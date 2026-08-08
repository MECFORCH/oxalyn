/*
 * gdb_stub.c — Oxalyn-64 GDB Remote Serial Protocol (RSP) Stub
 *
 * Derlemek için sim.c ile birlikte kullanılır:
 *   gcc -O2 -o sim sim.c gdb_stub.c
 *
 * Kullanım:
 *   ./sim program.bin --gdb 1234
 *   gdb-multiarch program.elf -ex "target remote :1234"
 *
 * Oxalyn-64 bellek modeli:
 *   - word-addressed: mem[0..65535], her giriş 64-bit
 *   - big-endian saklanır (MSB önce): .bin formatıyla tutarlı
 *   - GDB byte adresi → word index: waddr = byte_addr >> 3
 *   - Word içi byte: offset = byte_addr & 7  (0=MSB, 7=LSB)
 *
 * GDB register haritası (34 register, R0-R31 ve PC 64-bit, FLAGS 64-bit):
 *   0-31: R0-R31  (64-bit, 16 hex karakter her biri)
 *   32  : PC       (word adresi × 8 = byte adresi, 64-bit olarak gönderilir)
 *   33  : FLAGS    (64-bit)
 *   (Toplam 34 × 8 = 272 byte = 544 hex karakter)
 */

#include "gdb_stub.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#ifdef _WIN32
#  include <winsock2.h>
#  pragma comment(lib, "ws2_32.lib")
   typedef int socklen_t;
#  define CLOSESOCK closesocket
#else
#  include <sys/socket.h>
#  include <netinet/in.h>
#  include <arpa/inet.h>
#  include <unistd.h>
#  define CLOSESOCK close
#endif

/* ── Sabitler ───────────────────────────────────────────── */

#define RSP_BUF_SIZE   4096
#define MAX_BREAKPOINTS  64
#define NUM_REGS         34   /* R0-R31, PC, FLAGS */

/* ── Durum ──────────────────────────────────────────────── */

static int listen_fd = -1;
static int conn_fd   = -1;

/* Breakpoint tablosu: oxalyn_word_addr cinsinden */
static uint32_t bp_table[MAX_BREAKPOINTS];
static int      bp_count = 0;

/* ── Yardımcı: socket gönder/al ─────────────────────────── */

static int rsp_send_raw(const char *buf, int len)
{
    int sent = 0;
    while (sent < len) {
        int n = (int)send(conn_fd, buf + sent, (size_t)(len - sent), 0);
        if (n <= 0) return -1;
        sent += n;
    }
    return 0;
}

static int rsp_recv_byte(uint8_t *out)
{
    return (int)recv(conn_fd, (char *)out, 1, 0) == 1 ? 0 : -1;
}

/* ── RSP çerçeveleme ────────────────────────────────────── */

static uint8_t rsp_checksum(const char *data, int len)
{
    uint8_t cs = 0;
    int i;
    for (i = 0; i < len; i++) cs += (uint8_t)data[i];
    return cs;
}

/*
 * RSP paketi gönder: $data#cs
 */
static int rsp_send_packet(const char *data)
{
    char buf[RSP_BUF_SIZE + 8];
    int  dlen = (int)strlen(data);
    uint8_t cs = rsp_checksum(data, dlen);
    int  blen = snprintf(buf, sizeof(buf), "$%s#%02x", data, (unsigned)cs);
    return rsp_send_raw(buf, blen);
}

/*
 * RSP paketi al. Sonuç: data alanı out'a, uzunluğu *len'e yazılır.
 * + ACK gönderir, '-' gelirse tekrar bekler.
 * Dönüş: 0=OK, -1=bağlantı koptu.
 */
static int rsp_recv_packet(char *out, int *len)
{
    uint8_t b;
    int     i;

retry:
    /* '$' bekle */
    do {
        if (rsp_recv_byte(&b) < 0) return -1;
    } while (b != '$');

    /* Data oku */
    i = 0;
    for (;;) {
        if (rsp_recv_byte(&b) < 0) return -1;
        if (b == '#') break;
        if (i < RSP_BUF_SIZE - 1) out[i++] = (char)b;
    }
    out[i] = '\0';
    *len = i;

    /* Checksum al (2 hex karakter) */
    uint8_t cs_recv = 0;
    uint8_t c1, c2;
    if (rsp_recv_byte(&c1) < 0) return -1;
    if (rsp_recv_byte(&c2) < 0) return -1;
    {
        uint8_t h1 = (c1 >= 'a') ? (uint8_t)(c1 - 'a' + 10) :
                     (c1 >= 'A') ? (uint8_t)(c1 - 'A' + 10) : (uint8_t)(c1 - '0');
        uint8_t h2 = (c2 >= 'a') ? (uint8_t)(c2 - 'a' + 10) :
                     (c2 >= 'A') ? (uint8_t)(c2 - 'A' + 10) : (uint8_t)(c2 - '0');
        cs_recv = (uint8_t)((h1 << 4) | h2);
    }

    if (rsp_checksum(out, i) != cs_recv) {
        rsp_send_raw("-", 1);
        goto retry;
    }
    rsp_send_raw("+", 1);
    return 0;
}

/* ── Breakpoint yönetimi ────────────────────────────────── */

static int bp_add(uint32_t word_addr)
{
    int i;
    for (i = 0; i < bp_count; i++)
        if (bp_table[i] == word_addr) return 0; /* zaten var */
    if (bp_count >= MAX_BREAKPOINTS) return -1;
    bp_table[bp_count++] = word_addr;
    return 0;
}

static int bp_remove(uint32_t word_addr)
{
    int i;
    for (i = 0; i < bp_count; i++) {
        if (bp_table[i] == word_addr) {
            bp_table[i] = bp_table[--bp_count];
            return 0;
        }
    }
    return -1;
}

static int bp_hit(uint32_t word_addr)
{
    int i;
    for (i = 0; i < bp_count; i++)
        if (bp_table[i] == word_addr) return 1;
    return 0;
}

/* ── Watchpoint yönetimi ────────────────────────────────── */

#define MAX_WATCHPOINTS 32

typedef enum {
    WP_WRITE  = 2,  /* Z2: yazma izle */
    WP_READ   = 3,  /* Z3: okuma izle */
    WP_ACCESS = 4,  /* Z4: okuma+yazma izle */
} WpType;

typedef struct {
    uint32_t byte_addr;
    uint32_t byte_len;
    WpType   type;
    int      active;
} Watchpoint;

static Watchpoint wp_table[MAX_WATCHPOINTS];
static int        wp_count = 0;

/* Son tetiklenen watchpoint byte adresi (raporlama için) */
static uint32_t wp_hit_addr  = 0;
static int      wp_triggered = 0;

static int wp_add(uint32_t byte_addr, uint32_t byte_len, WpType type)
{
    int i;
    for (i = 0; i < wp_count; i++) {
        if (wp_table[i].active &&
            wp_table[i].byte_addr == byte_addr &&
            wp_table[i].byte_len  == byte_len  &&
            wp_table[i].type      == type)
            return 0; /* zaten var */
    }
    if (wp_count >= MAX_WATCHPOINTS) return -1;
    wp_table[wp_count].byte_addr = byte_addr;
    wp_table[wp_count].byte_len  = byte_len;
    wp_table[wp_count].type      = type;
    wp_table[wp_count].active    = 1;
    wp_count++;
    return 0;
}

static int wp_remove(uint32_t byte_addr, uint32_t byte_len, WpType type)
{
    int i;
    for (i = 0; i < wp_count; i++) {
        if (wp_table[i].active &&
            wp_table[i].byte_addr == byte_addr &&
            wp_table[i].byte_len  == byte_len  &&
            wp_table[i].type      == type) {
            wp_table[i].active = 0;
            return 0;
        }
    }
    return -1;
}

/*
 * Bellek erişim bildirimi — sim.c her okuma/yazma öncesi çağırır.
 * is_write: 1=yazma, 0=okuma
 * Dönüş: 1 → watchpoint tetiklendi (sim durmalı)
 */
int gdb_watchpoint_check(uint32_t byte_addr, uint32_t byte_len, int is_write)
{
    int i;
    for (i = 0; i < wp_count; i++) {
        Watchpoint *wp = &wp_table[i];
        if (!wp->active) continue;
        /* Adres aralığı çakışması: [wp_addr, wp_addr+wp_len) ∩ [byte_addr, byte_addr+byte_len) */
        if (byte_addr + byte_len <= wp->byte_addr) continue;
        if (byte_addr >= wp->byte_addr + wp->byte_len) continue;
        if (wp->type == WP_ACCESS) { wp_hit_addr = byte_addr; wp_triggered = 1; return 1; }
        if (wp->type == WP_WRITE && is_write) { wp_hit_addr = byte_addr; wp_triggered = 1; return 1; }
        if (wp->type == WP_READ  && !is_write) { wp_hit_addr = byte_addr; wp_triggered = 1; return 1; }
    }
    return 0;
}

/* ── Register paketleme (64-bit) ───────────────────────── */

/*
 * 64-bit değeri 16 hex karaktere dönüştür (big-endian byte sırası).
 * Oxalyn-64 big-endian: MSB önce gönderilir.
 * GDB'de "set endian big" kullanılmalı.
 */
static void u64_to_hex_be(uint64_t v, char *out)
{
    snprintf(out, 17, "%016llx", (unsigned long long)v);
}

static uint64_t hex_to_u64_be(const char *s)
{
    uint64_t v = 0;
    int i;
    for (i = 0; i < 16 && s[i]; i++) {
        v <<= 4;
        char c = s[i];
        if (c >= '0' && c <= '9')      v |= (uint64_t)(c - '0');
        else if (c >= 'a' && c <= 'f') v |= (uint64_t)(c - 'a' + 10);
        else if (c >= 'A' && c <= 'F') v |= (uint64_t)(c - 'A' + 10);
    }
    return v;
}

/* ── RSP komut işleyiciler ──────────────────────────────── */

/* '?' — halt sebebi */
static void handle_halt_reason(void)
{
    rsp_send_packet("S05"); /* SIGTRAP */
}

/* 'g' — tüm register'ları oku */
static void handle_read_regs(void)
{
    /* NUM_REGS × 16 hex karakter + NUL */
    char buf[NUM_REGS * 16 + 1];
    char tmp[17];
    int i;
    buf[0] = '\0';

    /* R0-R31: 64-bit registerlar */
    for (i = 0; i < 32; i++) {
        u64_to_hex_be(oxalyn_reg_get(i), tmp);
        strcat(buf, tmp);
    }
    /* PC: byte adresi olarak gönder (word_addr × 8) */
    u64_to_hex_be((uint64_t)oxalyn_pc_get() * 8ull, tmp);
    strcat(buf, tmp);
    /* FLAGS: 64-bit */
    u64_to_hex_be(oxalyn_flags_get(), tmp);
    strcat(buf, tmp);

    rsp_send_packet(buf);
}

/* 'G' — tüm register'ları yaz */
static void handle_write_regs(const char *data)
{
    int i;
    const char *p = data + 1; /* 'G' atla */

    for (i = 0; i < 32; i++, p += 16) {
        if (*p == '\0') break;
        oxalyn_reg_set(i, hex_to_u64_be(p));
    }
    if (p[0]) {
        /* PC: byte adresi → word indeksi (÷8) */
        oxalyn_pc_set((uint32_t)(hex_to_u64_be(p) / 8ull));
        p += 16;
    }
    if (p[0]) {
        oxalyn_flags_set(hex_to_u64_be(p));
    }
    rsp_send_packet("OK");
}

/* 'm addr,len' — bellek oku (byte-addressed) */
static void handle_read_mem(const char *data)
{
    uint32_t addr = 0, len = 0;
    const char *p = data + 1;
    char out[RSP_BUF_SIZE];
    uint32_t i;
    int oi = 0;

    while (*p && *p != ',') {
        addr = (addr << 4) | (uint32_t)((*p >= 'a') ? (*p-'a'+10) :
               (*p >= 'A') ? (*p-'A'+10) : (*p - '0'));
        p++;
    }
    if (*p == ',') p++;
    while (*p) {
        len = (len << 4) | (uint32_t)((*p >= 'a') ? (*p-'a'+10) :
              (*p >= 'A') ? (*p-'A'+10) : (*p - '0'));
        p++;
    }

    if (addr + len > oxalyn_mem_size_bytes()) {
        rsp_send_packet("E01");
        return;
    }

    for (i = 0; i < len && oi + 2 < (int)sizeof(out); i++) {
        uint8_t b = oxalyn_mem_read_byte(addr + i);
        snprintf(out + oi, 3, "%02x", (unsigned)b);
        oi += 2;
    }
    out[oi] = '\0';
    rsp_send_packet(out);
}

/* 'M addr,len:data' — bellek yaz */
static void handle_write_mem(const char *data)
{
    uint32_t addr = 0, len = 0;
    const char *p = data + 1;
    uint32_t i;

    while (*p && *p != ',') {
        addr = (addr << 4) | (uint32_t)((*p >= 'a') ? (*p-'a'+10) :
               (*p >= 'A') ? (*p-'A'+10) : (*p - '0'));
        p++;
    }
    if (*p == ',') p++;
    while (*p && *p != ':') {
        len = (len << 4) | (uint32_t)((*p >= 'a') ? (*p-'a'+10) :
              (*p >= 'A') ? (*p-'A'+10) : (*p - '0'));
        p++;
    }
    if (*p == ':') p++;

    if (addr + len > oxalyn_mem_size_bytes()) {
        rsp_send_packet("E01");
        return;
    }

    for (i = 0; i < len && p[0] && p[1]; i++, p += 2) {
        uint8_t hi = (uint8_t)((*p >= 'a') ? (*p-'a'+10) :
                     (*p >= 'A') ? (*p-'A'+10) : (*p - '0'));
        uint8_t lo = (uint8_t)((p[1] >= 'a') ? (p[1]-'a'+10) :
                     (p[1] >= 'A') ? (p[1]-'A'+10) : (p[1] - '0'));
        oxalyn_mem_write_byte(addr + i, (uint8_t)((hi << 4) | lo));
    }
    rsp_send_packet("OK");
}

/* 's' — tek adım */
static void handle_step(void)
{
    wp_triggered = 0;
    if (!oxalyn_halted_get())
        oxalyn_step();
    if (wp_triggered) {
        char reply[64];
        snprintf(reply, sizeof(reply), "T05watch:%08x;", (unsigned)wp_hit_addr);
        rsp_send_packet(reply);
    } else {
        rsp_send_packet("S05");
    }
}

/* 'c' — devam et (breakpoint, watchpoint veya halt'a kadar) */
static void handle_continue(void)
{
    wp_triggered = 0;
    while (!oxalyn_halted_get()) {
        oxalyn_step();
        if (bp_hit(oxalyn_pc_get())) break;
        if (wp_triggered) break;
    }
    if (wp_triggered) {
        char reply[64];
        snprintf(reply, sizeof(reply), "T05watch:%08x;", (unsigned)wp_hit_addr);
        rsp_send_packet(reply);
    } else {
        rsp_send_packet("S05");
    }
}

/* Adres ve uzunluğu RSP 'Z'/'z' paketinden ayrıştır:
 * Format: "Ztype,addr,kind"  veya  "ztype,addr,kind" */
static void parse_zpacket(const char *p,
                           int *bp_type, uint32_t *addr, uint32_t *bp_len)
{
    *bp_type = 0; *addr = 0; *bp_len = 1;
    if (*p >= '0' && *p <= '4') { *bp_type = (int)(*p - '0'); p++; }
    if (*p == ',') p++;
    while (*p && *p != ',') {
        *addr = (*addr << 4) | (uint32_t)((*p>='a')?(*p-'a'+10):(*p>='A')?(*p-'A'+10):(*p-'0'));
        p++;
    }
    if (*p == ',') p++;
    while (*p) {
        *bp_len = (*bp_len << 4) | (uint32_t)((*p>='a')?(*p-'a'+10):(*p>='A')?(*p-'A'+10):(*p-'0'));
        p++;
    }
}

/* 'Z/z' — breakpoint veya watchpoint ekle/kaldır */
static void handle_breakpoint(const char *data)
{
    char      cmd  = data[0];   /* 'Z' ekle, 'z' kaldır */
    int       bptype;
    uint32_t  addr, blen;

    parse_zpacket(data + 1, &bptype, &addr, &blen);

    if (bptype == 0) {
        /* Yazılım breakpoint — word adresi (Oxalyn-64: her kelime 8 byte) */
        uint32_t waddr = addr / 8u;
        rsp_send_packet(cmd == 'Z' ? (bp_add(waddr) == 0 ? "OK" : "E01")
                                   : (bp_remove(waddr) == 0 ? "OK" : "E01"));
    } else if (bptype == 2) {
        /* Z2/z2: yazma watchpoint */
        rsp_send_packet(cmd == 'Z' ? (wp_add(addr, blen, WP_WRITE) == 0 ? "OK" : "E01")
                                   : (wp_remove(addr, blen, WP_WRITE) == 0 ? "OK" : "E01"));
    } else if (bptype == 3) {
        /* Z3/z3: okuma watchpoint */
        rsp_send_packet(cmd == 'Z' ? (wp_add(addr, blen, WP_READ) == 0 ? "OK" : "E01")
                                   : (wp_remove(addr, blen, WP_READ) == 0 ? "OK" : "E01"));
    } else if (bptype == 4) {
        /* Z4/z4: erişim (okuma+yazma) watchpoint */
        rsp_send_packet(cmd == 'Z' ? (wp_add(addr, blen, WP_ACCESS) == 0 ? "OK" : "E01")
                                   : (wp_remove(addr, blen, WP_ACCESS) == 0 ? "OK" : "E01"));
    } else {
        rsp_send_packet(""); /* desteklenmeyen tip */
    }
}

/* ── RSP ana döngüsü ────────────────────────────────────── */

static void rsp_loop(void)
{
    char pkt[RSP_BUF_SIZE];
    int  plen;

    printf("[GDB] Bağlantı kuruldu. RSP döngüsü başlıyor...\n");
    printf("[GDB] PC=0x%04X (byte 0x%016llX)\n",
           (unsigned)oxalyn_pc_get(),
           (unsigned long long)((uint64_t)oxalyn_pc_get() * 8ull));

    for (;;) {
        if (rsp_recv_packet(pkt, &plen) < 0) {
            printf("[GDB] Bağlantı kesildi.\n");
            break;
        }
        if (plen == 0) { rsp_send_packet(""); continue; }

        switch (pkt[0]) {
        case '?':
            handle_halt_reason();
            break;
        case 'g':
            handle_read_regs();
            break;
        case 'G':
            handle_write_regs(pkt);
            break;
        case 'm':
            handle_read_mem(pkt);
            break;
        case 'M':
            handle_write_mem(pkt);
            break;
        case 's':
            handle_step();
            break;
        case 'c':
            handle_continue();
            break;
        case 'Z':
        case 'z':
            handle_breakpoint(pkt);
            break;
        case 'k':
            printf("[GDB] Kill komutu alındı, çıkılıyor.\n");
            oxalyn_halted_set(1);
            rsp_send_raw("+", 1);
            return;
        case 'q':
            if (strncmp(pkt, "qSupported", 10) == 0) {
                /* Watchpoint türleri de destekleniyor */
                rsp_send_packet("PacketSize=3fff;hwbreak+;swbreak+;");
            } else if (strncmp(pkt, "qAttached", 9) == 0) {
                rsp_send_packet("1");
            } else {
                rsp_send_packet("");
            }
            break;
        case 'v':
            if (strncmp(pkt, "vCont?", 6) == 0) {
                rsp_send_packet("vCont;c;s");
            } else if (strncmp(pkt, "vCont;c", 7) == 0) {
                handle_continue();
            } else if (strncmp(pkt, "vCont;s", 7) == 0) {
                handle_step();
            } else {
                rsp_send_packet("");
            }
            break;
        case 'H':
            /* Thread seçimi — yok say, OK */
            rsp_send_packet("OK");
            break;
        default:
            rsp_send_packet(""); /* desteklenmeyen komut */
            break;
        }
    }
}

/* ── Genel API ──────────────────────────────────────────── */

int gdb_stub_init(int tcp_port)
{
    struct sockaddr_in addr;
    int optval = 1;

#ifdef _WIN32
    WSADATA wsa;
    WSAStartup(MAKEWORD(2,2), &wsa);
#endif

    listen_fd = (int)socket(AF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0) {
        perror("[GDB] socket");
        return -1;
    }
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR,
               (const char *)&optval, sizeof(optval));

    memset(&addr, 0, sizeof(addr));
    addr.sin_family      = AF_INET;
    addr.sin_port        = htons((uint16_t)tcp_port);
    addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(listen_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("[GDB] bind");
        CLOSESOCK(listen_fd);
        listen_fd = -1;
        return -1;
    }
    if (listen(listen_fd, 1) < 0) {
        perror("[GDB] listen");
        CLOSESOCK(listen_fd);
        listen_fd = -1;
        return -1;
    }
    printf("[GDB] RSP stub dinliyor: localhost:%d\n", tcp_port);
    printf("[GDB] GDB bağlantısı bekleniyor...\n");
    fflush(stdout);
    return 0;
}

void gdb_stub_run(void)
{
    struct sockaddr_in client;
    socklen_t clen = sizeof(client);

    if (listen_fd < 0) return;

    /* GDB bağlanana kadar bekle */
    conn_fd = (int)accept(listen_fd, (struct sockaddr *)&client, &clen);
    if (conn_fd < 0) {
        perror("[GDB] accept");
        return;
    }
    printf("[GDB] %s bağlandı.\n", inet_ntoa(client.sin_addr));
    fflush(stdout);

    bp_count = 0;
    rsp_loop();

    CLOSESOCK(conn_fd);
    conn_fd = -1;
    CLOSESOCK(listen_fd);
    listen_fd = -1;
}
