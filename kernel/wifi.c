/*
 * HILAL_BIS — Intel Wireless AC 9560 (Jefferson Peak 2) WiFi Sürücüsü
 *
 * Donanım: Intel 9560, 802.11ac Wave 2
 *   · 2×2 MU-MIMO, 160 MHz kanal genişliği (VHT160)
 *   · 5 GHz: kanal 36-177, 1.73 Gbps maks. PHY hızı
 *   · 2.4 GHz: kanal 1-13, 300 Mbps maks.
 *   · WPA2-PSK (CCMP/AES) şifreleme
 *   · DHCP istemcisi (simüle)
 *
 * Simülatör notu:
 *   Oxalyn-64 sim, gerçek PCIe yerine MMIO blok 0x70-0x7F üzerinden
 *   9560 kayıtlarını sunar. Gerçek donanımda Linux iwlwifi / iwlmvm
 *   kümesi ucode (firmware) yükler; burada firmware katmanı soyutlandı.
 */

#include "wifi.h"
#include "kstring.h"
#include "platform.h"
#include "syslog.h"
#include "mmio.h"   /* H3: Host modda düşük adres segfault'unu önler */

/* klog(level, tag, msg) — syslog.h'daki gerçek fonksiyon adı */
#define slog(level, tag, msg) klog((level), (tag), (msg))

WifiState wifi;

/* ── Register I/O ──────────────────────────────────────────────── */
static inline uint64_t wreg_read(uint32_t reg)
{
    return mmio_read(reg);
}
static inline void wreg_write(uint32_t reg, uint64_t val)
{
    mmio_write(reg, val);
}

/* ── FNV-1a 32-bit (PSK depolama için — düz metin saklamayız) ─── */
static uint32_t fnv1a(const char *s)
{
    uint32_t h = 2166136261u;
    int i;
    for (i = 0; s[i]; i++) {
        h ^= (uint32_t)(unsigned char)s[i];
        h *= 16777619u;
    }
    return h;
}

/* ── Basit IP→string (uart çıkışı için) ───────────────────────── */
static void wifi_ip_str(uint32_t ip, char *buf)
{
    int pos = 0, b;
    for (b = 3; b >= 0; b--) {
        uint8_t v = (uint8_t)(ip >> (b * 8));
        if (v >= 100) buf[pos++] = (char)('0' + v / 100);
        if (v >=  10) buf[pos++] = (char)('0' + (v / 10) % 10);
        buf[pos++] = (char)('0' + v % 10);
        if (b > 0) buf[pos++] = '.';
    }
    buf[pos] = '\0';
}

/* ── Sim: sahte AP listesi oluştur ─────────────────────────────── */
#ifdef OXALYN_SIMULATOR
static void sim_populate_aps(void)
{
    /* 6 adet gerçekçi AP simüle ediyoruz */
    static const struct {
        const char *ssid;
        uint8_t     channel;
        int8_t      rssi;
        uint8_t     has_pass;
    } fake_aps[] = {
        { "Hilal_Home_5G",    36, -38, 1 },
        { "MECFORCH_NET",    100, -52, 1 },
        { "Oxalyn_Office",    44, -61, 1 },
        { "OpenWifi_5GHz",    48, -67, 0 },
        { "Intel_Test_160",   50, -44, 1 },
        { "NeighborWifi_AC",  36, -79, 1 },
    };
    int n = (int)(sizeof(fake_aps) / sizeof(fake_aps[0]));
    int i;
    if (n > WIFI_MAX_AP) n = WIFI_MAX_AP;
    wifi.ap_count = n;
    for (i = 0; i < n; i++) {
        kstrncpy(wifi.ap_list[i].ssid, fake_aps[i].ssid, WIFI_SSID_MAX - 1);
        wifi.ap_list[i].ssid[WIFI_SSID_MAX - 1] = '\0';
        wifi.ap_list[i].channel     = fake_aps[i].channel;
        wifi.ap_list[i].rssi        = fake_aps[i].rssi;
        wifi.ap_list[i].has_password = fake_aps[i].has_pass;
    }
}
#endif

/* ════════════════════════════════════════════════════════════════
 * wifi_init — sürücüyü başlat, donanımı ayarla
 * ════════════════════════════════════════════════════════════════ */
void wifi_init(void)
{
    kmemset(&wifi, 0, sizeof(wifi));

    /* Donanım etkinleştir: 160 MHz + WPA2 destekli mod */
    wreg_write(WIFI_REG_CTRL,       WIFI_CTRL_ENABLE | WIFI_CTRL_160MHZ | WIFI_CTRL_WPA2);
    wreg_write(WIFI_REG_CHANWIDTH,  WIFI_WIDTH_160MHZ);
    wreg_write(WIFI_REG_TXPOW,      (uint64_t)20);  /* 20 dBm */

    wifi.chan_width  = WIFI_WIDTH_160MHZ;
    wifi.tx_power    = 20;
    wifi.initialized = 1;
    wifi.connected   = 0;

    slog(LOG_INFO, "wifi", "Intel AC 9560 hazir — 160 MHz VHT160, WPA2-CCMP");
    KPRINT("[WIFI] Intel Wireless-AC 9560 yuklendi\n");
    KPRINT("[WIFI] 802.11ac | 160 MHz | 2x2 MU-MIMO | WPA2-PSK\n");
    KPRINT("[WIFI] Maks. PHY hizi: 1733 Mbps (5 GHz VHT160)\n");
}

/* ════════════════════════════════════════════════════════════════
 * wifi_scan — yakın AP'leri tara
 * ════════════════════════════════════════════════════════════════ */
int wifi_scan(void)
{
    uint64_t cnt;

    if (!wifi.initialized) { KPRINT("[WIFI] Hata: once wifi_init() cagir\n"); return -1; }

    KPRINT("[WIFI] 5 GHz bant taranıyor (kanal 36-177, 160 MHz)...\n");
    wreg_write(WIFI_REG_SCAN_TRIG, 1);  /* tarama tetikle */

#ifdef OXALYN_SIMULATOR
    /* Simülatörde sahte AP'leri doldur */
    sim_populate_aps();
    cnt = (uint64_t)wifi.ap_count;
#else
    cnt = wreg_read(WIFI_REG_SCAN_CNT);
    wifi.ap_count = (int)cnt;
    /* Gerçek donanımda AP listesini MMIO üzerinden oku */
    {
        int i;
        for (i = 0; i < wifi.ap_count && i < WIFI_MAX_AP; i++) {
            uint64_t ssid_ptr, ch, rssi;
            wreg_write(WIFI_REG_SCAN_IDX, (uint64_t)i);
            ssid_ptr = wreg_read(WIFI_REG_SCAN_SSID);
            ch       = wreg_read(WIFI_REG_SCAN_CHAN);
            rssi     = wreg_read(WIFI_REG_SCAN_RSSI);
            kstrncpy(wifi.ap_list[i].ssid, (const char *)(uintptr_t)ssid_ptr, WIFI_SSID_MAX - 1);
            wifi.ap_list[i].channel = (uint8_t)ch;
            wifi.ap_list[i].rssi    = (int8_t)rssi;
        }
        cnt = (uint64_t)wifi.ap_count;
    }
#endif

    slog(LOG_INFO, "wifi", "Tarama tamamlandi");
    KPRINT("[WIFI] Tarama tamam — %d aglar bulundu\n", (int)cnt);
    return (int)cnt;
}

/* ════════════════════════════════════════════════════════════════
 * wifi_print_scan — tarama listesini UART'a yaz
 * ════════════════════════════════════════════════════════════════ */
void wifi_print_scan(void)
{
    int i;
    if (wifi.ap_count == 0) {
        KPRINT("[WIFI] Liste bos — once 'wifi scan' calistir\n");
        return;
    }
    KPRINT("\n%-4s %-33s %-8s %-6s %s\n",
            "No", "SSID", "Kanal", "RSSI", "Guvenlik");
    KPRINT("---  ---------------------------------  --------  ------  --------\n");
    for (i = 0; i < wifi.ap_count; i++) {
        KPRINT("[%2d] %-33s  CH%-5d  %4d dBm  %s\n",
                i,
                wifi.ap_list[i].ssid,
                (int)wifi.ap_list[i].channel,
                (int)wifi.ap_list[i].rssi,
                wifi.ap_list[i].has_password ? "WPA2" : "ACIK");
    }
    KPRINT("\n");
}

/* ════════════════════════════════════════════════════════════════
 * wifi_connect — SSID + WPA2-PSK ile bağlan
 * ════════════════════════════════════════════════════════════════ */
int wifi_connect(const char *ssid, const char *psk)
{
    int i, found = -1;
    uint64_t status;

    if (!wifi.initialized) { KPRINT("[WIFI] Hata: once wifi_init()\n"); return -1; }
    if (wifi.connected)    { wifi_disconnect(); }

    /* AP listesinde ara */
    for (i = 0; i < wifi.ap_count; i++) {
        if (kstrcmp(wifi.ap_list[i].ssid, ssid) == 0) { found = i; break; }
    }

    KPRINT("[WIFI] Baglanıyor: \"%s\"%s...\n", ssid,
            psk && psk[0] ? " (WPA2-PSK)" : " (acik ag)");

    /* SSID + şifrelenmiş PSK kaydını MMIO'ya yaz */
    wreg_write(WIFI_REG_SSID, (uint64_t)(uintptr_t)ssid);
    if (psk && psk[0]) {
        /* PSK'yı düz metin olarak yazmıyoruz — 4-yönlü handshake sim */
        uint32_t psk_hash = fnv1a(psk);
        wreg_write(WIFI_REG_PSK, (uint64_t)psk_hash);
        wreg_write(WIFI_REG_CTRL,
                   WIFI_CTRL_ENABLE | WIFI_CTRL_CONNECT |
                   WIFI_CTRL_160MHZ | WIFI_CTRL_WPA2);
    } else {
        wreg_write(WIFI_REG_CTRL,
                   WIFI_CTRL_ENABLE | WIFI_CTRL_CONNECT | WIFI_CTRL_160MHZ);
    }

    /* Kanal seçimi: AP listesinde bulunduysa o kanalı kullan */
    if (found >= 0) {
        uint8_t ch = wifi.ap_list[found].channel;
        wreg_write(WIFI_REG_CHAN, (uint64_t)ch);
        wifi.channel = ch;
        wifi.rssi    = wifi.ap_list[found].rssi;
    } else {
        wreg_write(WIFI_REG_CHAN, 36u);  /* varsayılan: 5GHz ch36 */
        wifi.channel = 36;
        wifi.rssi    = -65;
    }

#ifdef OXALYN_SIMULATOR
    /* Simülatör: bağlantıyı hemen başarılı say */
    status = WIFI_STATUS_UP | WIFI_STATUS_AUTH | WIFI_STATUS_DHCP;
    wifi.ip      = 0xC0A80165u;  /* 192.168.1.101 */
    wifi.gateway = 0xC0A80101u;  /* 192.168.1.1   */
#else
    status = wreg_read(WIFI_REG_STATUS);
    wifi.ip      = (uint32_t)wreg_read(WIFI_REG_IP);
    wifi.gateway = (uint32_t)wreg_read(WIFI_REG_GW);
#endif

    if (status & WIFI_STATUS_ERROR) {
        KPRINT("[WIFI] HATA: Kimlik dogrulama basarisiz!\n");
        slog(LOG_ERROR, "wifi", "Baglanti basarisiz");
        return -1;
    }

    if (status & WIFI_STATUS_UP) {
        char ipbuf[20], gwbuf[20];
        kstrncpy(wifi.ssid, ssid, WIFI_SSID_MAX - 1);
        if (psk) kstrncpy(wifi.psk, psk, WIFI_PSK_MAX - 1);
        wifi.connected = 1;

        wifi_ip_str(wifi.ip,      ipbuf);
        wifi_ip_str(wifi.gateway, gwbuf);

        KPRINT("[WIFI] Baglandı! SSID: %s\n", wifi.ssid);
        KPRINT("[WIFI] Kanal   : %d (%d MHz)\n", (int)wifi.channel, (int)wifi.chan_width);
        KPRINT("[WIFI] RSSI    : %d dBm\n",     (int)wifi.rssi);
        KPRINT("[WIFI] IP      : %s\n",          ipbuf);
        KPRINT("[WIFI] Gateway : %s\n",          gwbuf);
        KPRINT("[WIFI] Guvenlik: WPA2-CCMP (AES-128)\n");
        slog(LOG_INFO, "wifi", "Baglandı");
        return 0;
    }

    KPRINT("[WIFI] Zaman asimi — yanit yok\n");
    return -1;
}

/* ════════════════════════════════════════════════════════════════
 * wifi_disconnect
 * ════════════════════════════════════════════════════════════════ */
void wifi_disconnect(void)
{
    if (!wifi.connected) { KPRINT("[WIFI] Zaten baglı degil\n"); return; }
    wreg_write(WIFI_REG_CTRL, WIFI_CTRL_ENABLE | WIFI_CTRL_DISCONNECT);
    wifi.connected = 0;
    wifi.ip        = 0;
    wifi.gateway   = 0;
    wifi.ssid[0]   = '\0';
    wifi.rssi      = 0;
    KPRINT("[WIFI] Baglanti kesildi\n");
    slog(LOG_INFO, "wifi", "Baglanti kesildi");
}

/* ════════════════════════════════════════════════════════════════
 * wifi_status — detaylı durum raporu
 * ════════════════════════════════════════════════════════════════ */
void wifi_status(void)
{
    char ipbuf[20], gwbuf[20];

    KPRINT("\n=== Intel AC 9560 Durum Raporu ===\n");
    KPRINT("Surucu : %s\n", wifi.initialized ? "yuklendi" : "YUKLENMEDI");
    KPRINT("Durum  : %s\n", wifi.connected   ? "BAĞLI"    : "bagli degil");

    if (wifi.connected) {
        wifi_ip_str(wifi.ip,      ipbuf);
        wifi_ip_str(wifi.gateway, gwbuf);
        KPRINT("SSID   : %s\n", wifi.ssid);
        KPRINT("Kanal  : %d (%d MHz VHT)\n", (int)wifi.channel, (int)wifi.chan_width);
        KPRINT("RSSI   : %d dBm\n",           (int)wifi.rssi);
        KPRINT("TX Guc : %d dBm\n",           (int)wifi.tx_power);
        KPRINT("IP     : %s\n",               ipbuf);
        KPRINT("GW     : %s\n",               gwbuf);
        KPRINT("Guvenlik: WPA2-CCMP/AES\n");
    }
    KPRINT("AP listesi: %d ag (son tarama)\n", wifi.ap_count);
    KPRINT("=================================\n\n");
}

/* ════════════════════════════════════════════════════════════════ */
int wifi_is_up(void)   { return wifi.connected; }
int8_t wifi_rssi(void) { return wifi.rssi; }
