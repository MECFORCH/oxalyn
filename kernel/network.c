/*
 * HILAL_BIS — Ağ Sürücüsü
 * Oxalyn-64 NIC, bellek-eşlemeli I/O, portlar 0x50-0x58
 */

#include "network.h"
#include "tcp.h"
#include "kstring.h"
#include "platform.h"
#include "mmio.h"   /* H3: Host modda düşük adres segfault'unu önler */

NetworkConfig net;
ArpEntry      arp_table[ARP_TABLE_SIZE];

/* ── Port I/O ────────────────────────────────────────────── */
static inline uint64_t nic_read(uint32_t port)
{
    return mmio_read(port);
}

static inline void nic_write(uint32_t port, uint64_t val)
{
    mmio_write(port, val);
}

/* ── IP → bayt dönüşümleri ──────────────────────────────── */
static void ip_to_str(uint32_t ip, char *buf)
{
    /* "A.B.C.D" formatı — elle yaz, sprintf yok */
    int pos = 0, byte_i;
    for (byte_i = 3; byte_i >= 0; byte_i--) {
        uint8_t b = (uint8_t)(ip >> (byte_i * 8));
        if (b >= 100) buf[pos++] = (char)('0' + b / 100);
        if (b >= 10)  buf[pos++] = (char)('0' + (b / 10) % 10);
        buf[pos++] = (char)('0' + b % 10);
        if (byte_i > 0) buf[pos++] = '.';
    }
    buf[pos] = '\0';
}

/* ── 16-bit Internet checksum ───────────────────────────── */
static uint16_t inet_checksum(const uint8_t *data, int len)
{
    uint32_t sum = 0;
    int i;
    for (i = 0; i + 1 < len; i += 2)
        sum += ((uint32_t)data[i] << 8) | data[i + 1];
    if (len & 1) sum += (uint32_t)data[len - 1] << 8;
    while (sum >> 16) sum = (sum & 0xFFFFu) + (sum >> 16);
    return (uint16_t)(~sum);
}

/* ================================================================
 * INIT
 * ================================================================ */
void network_init(void)
{
    uint64_t status;
    int i;

    kmemset(&net, 0, sizeof(net));
    for (i = 0; i < ARP_TABLE_SIZE; i++) arp_table[i].valid = 0;

    /* Varsayılan IP/MAC */
    net.ip      = 0xC0A80064u;  /* 192.168.0.100 */
    net.gateway = 0xC0A80001u;  /* 192.168.0.1   */
    net.netmask = 0xFFFFFF00u;  /* 255.255.255.0 */

    net.mac[0] = 0x02; net.mac[1] = 0x48; net.mac[2] = 0x42;
    net.mac[3] = 0x0A; net.mac[4] = 0x00; net.mac[5] = 0x01;

    /* NIC'i etkinleştir */
    nic_write(NIC_PORT_CTRL, NIC_STATUS_READY);

    /* IP adresini NIC'e yaz (4 ayrı bayt) */
    nic_write(NIC_PORT_IP, (uint64_t)net.ip);

    status = nic_read(NIC_PORT_STATUS);
    net.connected = (int)((status & NIC_STATUS_LINK) ? 1 : 0);

    {
        char ipbuf[20];
        ip_to_str(net.ip, ipbuf);
        KPRINT("[NET] NIC hazir — IP: %s, link: %s\n",
                ipbuf, net.connected ? "yukari" : "asagi");
    }
}

/* ================================================================ */
int net_is_up(void)
{
    uint64_t s = nic_read(NIC_PORT_STATUS);
    return (int)((s & NIC_STATUS_LINK) != 0);
}

/* ================================================================ */
void net_status(void)
{
    char ipbuf[20], gwbuf[20];
    ip_to_str(net.ip,      ipbuf);
    ip_to_str(net.gateway, gwbuf);
    KPRINT("NIC Durumu:\n");
    KPRINT("  IP      : %s\n",  ipbuf);
    KPRINT("  Gateway : %s\n",  gwbuf);
    KPRINT("  Link    : %s\n",  net_is_up() ? "yukari" : "asagi");
    KPRINT("  TX: %u paket  RX: %u paket\n",
            (unsigned)net.tx_packets, (unsigned)net.rx_packets);
    KPRINT("  Hatalar TX: %u  RX: %u\n",
            (unsigned)net.tx_errors, (unsigned)net.rx_errors);
}

/* ================================================================
 * ARP
 * ================================================================ */
void arp_learn(uint32_t ip, const uint8_t *mac)
{
    int i, oldest = 0;
    for (i = 0; i < ARP_TABLE_SIZE; i++) {
        if (!arp_table[i].valid) { oldest = i; break; }
        if (arp_table[i].ip == ip) { oldest = i; break; }
    }
    arp_table[oldest].ip    = ip;
    arp_table[oldest].valid = 1;
    kmemcpy(arp_table[oldest].mac, mac, 6);
}

int arp_lookup(uint32_t ip, uint8_t *mac_out)
{
    int i;
    for (i = 0; i < ARP_TABLE_SIZE; i++) {
        if (arp_table[i].valid && arp_table[i].ip == ip) {
            kmemcpy(mac_out, arp_table[i].mac, 6);
            return 0;
        }
    }
    /* Bulunamazsa broadcast MAC kullan */
    kmemset(mac_out, 0xFF, 6);
    return -1;
}

/* ================================================================
 * ETH GÖNDER
 * ================================================================ */
int eth_send(const uint8_t *dst_mac, uint16_t ethertype,
             const uint8_t *payload, int payload_len)
{
    uint8_t frame[NET_MTU];
    int     total, i;
    uint64_t status;

    if (payload_len < 0 || payload_len > NET_MTU - NET_HDR_ETH)
        return -1;

    /* NIC hazır mı? */
    status = nic_read(NIC_PORT_STATUS);
    if (!(status & NIC_STATUS_READY)) { net.tx_errors++; return -1; }
    if (  status & NIC_STATUS_TX_BUSY) { net.tx_errors++; return -1; }

    /* Ethernet başlığı */
    kmemcpy(frame,     dst_mac,   6);              /* dst MAC */
    kmemcpy(frame + 6, net.mac,   6);              /* src MAC */
    frame[12] = (uint8_t)(ethertype >> 8);
    frame[13] = (uint8_t)(ethertype & 0xFF);
    kmemcpy(frame + NET_HDR_ETH, payload, payload_len);
    total = NET_HDR_ETH + payload_len;

    /* Boyutu yaz, ardından tek tek bayt FIFO'ya */
    nic_write(NIC_PORT_TX_LEN, (uint64_t)total);
    for (i = 0; i < total; i++)
        nic_write(NIC_PORT_TX_DATA, (uint64_t)frame[i]);
    nic_write(NIC_PORT_TX_SEND, 1u);

    net.tx_packets++;
    return total;
}

/* ================================================================
 * ETH AL
 * ================================================================ */
int eth_recv(uint8_t *buf, int buflen)
{
    uint64_t status, pkt_len;
    int      i, n;

    status = nic_read(NIC_PORT_STATUS);
    if (!(status & NIC_STATUS_RX_AVAIL)) return 0;

    pkt_len = nic_read(NIC_PORT_RX_LEN);
    n = (int)pkt_len;
    if (n <= 0 || n > buflen) {
        nic_write(NIC_PORT_RX_ACK, 1u);
        net.rx_errors++;
        return 0;
    }
    for (i = 0; i < n; i++)
        buf[i] = (uint8_t)(nic_read(NIC_PORT_RX_DATA) & 0xFFu);

    nic_write(NIC_PORT_RX_ACK, 1u);
    net.rx_packets++;
    return n;
}

/* ================================================================
 * IP GÖNDER
 * ================================================================ */
int ip_send(uint32_t dst_ip, uint8_t proto,
            const uint8_t *data, int data_len)
{
    uint8_t  pkt[NET_MTU];
    uint8_t  dst_mac[6];
    uint16_t total_len, csum;
    int      ip_offset = 0;

    if (data_len < 0 || data_len > NET_MTU - NET_HDR_ETH - NET_HDR_IP)
        return -1;

    total_len = (uint16_t)(NET_HDR_IP + data_len);

    /* IPv4 başlığı */
    pkt[ip_offset++] = 0x45;                         /* ver=4, IHL=5 */
    pkt[ip_offset++] = 0x00;                         /* DSCP/ECN */
    pkt[ip_offset++] = (uint8_t)(total_len >> 8);
    pkt[ip_offset++] = (uint8_t)(total_len & 0xFF);
    pkt[ip_offset++] = 0x00; pkt[ip_offset++] = 0x01; /* ID */
    pkt[ip_offset++] = 0x40; pkt[ip_offset++] = 0x00; /* Flags: DF */
    pkt[ip_offset++] = 64;                            /* TTL */
    pkt[ip_offset++] = proto;
    pkt[ip_offset++] = 0x00; pkt[ip_offset++] = 0x00; /* checksum (sonra) */
    pkt[ip_offset++] = (uint8_t)(net.ip >> 24);
    pkt[ip_offset++] = (uint8_t)(net.ip >> 16);
    pkt[ip_offset++] = (uint8_t)(net.ip >> 8);
    pkt[ip_offset++] = (uint8_t)(net.ip);
    pkt[ip_offset++] = (uint8_t)(dst_ip >> 24);
    pkt[ip_offset++] = (uint8_t)(dst_ip >> 16);
    pkt[ip_offset++] = (uint8_t)(dst_ip >> 8);
    pkt[ip_offset++] = (uint8_t)(dst_ip);

    /* IP checksum */
    csum = inet_checksum(pkt, NET_HDR_IP);
    pkt[10] = (uint8_t)(csum >> 8);
    pkt[11] = (uint8_t)(csum & 0xFF);

    kmemcpy(pkt + NET_HDR_IP, data, data_len);

    arp_lookup(dst_ip, dst_mac);
    return eth_send(dst_mac, ETHERTYPE_IP, pkt, NET_HDR_IP + data_len);
}

/* ================================================================
 * ICMP PING
 * ================================================================ */
int ping(uint32_t target_ip)
{
    uint8_t  icmp[NET_HDR_ICMP + 4];
    uint8_t  reply[NET_MTU];
    uint16_t csum;
    int      i, len;
    char     ipbuf[20];

    ip_to_str(target_ip, ipbuf);

    if (!net_is_up()) {
        KPRINT("ping: link asagi\n");
        return -1;
    }

    /* ICMP Echo Request */
    icmp[0] = 8;    /* type: echo request */
    icmp[1] = 0;    /* code */
    icmp[2] = 0; icmp[3] = 0;    /* checksum (sonra) */
    icmp[4] = 0; icmp[5] = 1;    /* identifier */
    icmp[6] = 0; icmp[7] = 1;    /* sequence */
    icmp[8] = 'H'; icmp[9] = 'I'; icmp[10] = 'L'; icmp[11] = 'A';

    csum = inet_checksum(icmp, sizeof(icmp));
    icmp[2] = (uint8_t)(csum >> 8);
    icmp[3] = (uint8_t)(csum & 0xFF);

    KPRINT("PING %s ...\n", ipbuf);
    ip_send(target_ip, IP_PROTO_ICMP, icmp, sizeof(icmp));

    /* Yanıt bekle (busy-wait, max ~10000 iterasyon) */
    for (i = 0; i < 10000; i++) {
        len = eth_recv(reply, NET_MTU);
        if (len >= NET_HDR_ETH + NET_HDR_IP + NET_HDR_ICMP) {
            /* Ethernet çerçevesi atla, IP başlığı atla, ICMP bak */
            uint8_t *ip_hdr   = reply + NET_HDR_ETH;
            uint8_t *icmp_hdr = ip_hdr + NET_HDR_IP;
            if (icmp_hdr[0] == 0) {   /* type 0 = echo reply */
                KPRINT("Yanit alindi: %s\n", ipbuf);
                return 0;
            }
        }
    }
    KPRINT("ping: zaman asimi (%s)\n", ipbuf);
    return -1;
}

/* ================================================================
 * UDP GÖNDER
 * ================================================================ */
int udp_send(uint32_t dst_ip, uint16_t src_port, uint16_t dst_port,
             const uint8_t *data, int data_len)
{
    uint8_t  udp[NET_HDR_UDP + 512];
    uint16_t total;

    if (data_len > 512) return -1;
    total = (uint16_t)(NET_HDR_UDP + data_len);

    udp[0] = (uint8_t)(src_port >> 8);  udp[1] = (uint8_t)(src_port & 0xFF);
    udp[2] = (uint8_t)(dst_port >> 8);  udp[3] = (uint8_t)(dst_port & 0xFF);
    udp[4] = (uint8_t)(total >> 8);     udp[5] = (uint8_t)(total & 0xFF);
    udp[6] = 0; udp[7] = 0;   /* checksum (opsiyonel UDP'de) */
    kmemcpy(udp + NET_HDR_UDP, data, data_len);

    return ip_send(dst_ip, IP_PROTO_UDP, udp, (int)total);
}

/* ================================================================
 * DNS ÇÖZÜMLEMESİ  (UDP, port 53)
 *
 * RFC 1035 uyumlu minimal A kaydı sorgusu.
 * DNS sunucusu olarak ağ geçidi kullanılır (veya 8.8.8.8).
 * ================================================================ */

/* DNS başlık alanları */
#define DNS_PORT        53u
#define DNS_SRC_PORT  5300u
#define DNS_TYPE_A    0x0001u
#define DNS_CLASS_IN  0x0001u

/* Hostname'i DNS wire formatına çevirir: "foo.bar" → \3foo\3bar\0 */
static int dns_encode_name(const char *name, uint8_t *out, int outlen)
{
    int i = 0, label_start = 0, total = 0;
    uint8_t *p = out;
    const char *s = name;

    if (total + 1 >= outlen) return -1;

    while (1) {
        if (*s == '.' || *s == '\0') {
            int len = (int)(s - name) - label_start;
            if (len <= 0 || len > 63) { if (*s == '\0') break; s++; label_start = (int)(s - name); continue; }
            if (total + 1 + len >= outlen) return -1;
            *p++ = (uint8_t)len;
            for (i = 0; i < len; i++) *p++ = (uint8_t)name[label_start + i];
            total += 1 + len;
            label_start = (int)(s - name) + 1;
            if (*s == '\0') break;
        }
        s++;
    }
    if (total + 1 >= outlen) return -1;
    *p++ = 0;   /* kök etiketi */
    total++;
    return total;
}

int dns_resolve(const char *hostname, uint32_t *out_ip)
{
    uint8_t  query[512];
    uint8_t  reply[512];
    int      qlen = 0, name_len, i, n;
    uint32_t dns_server;

    if (!hostname || !out_ip) return -1;

    /* Zaten IP ise doğrudan döndür (A.B.C.D) */
    {
        int a, b, c, d;
        const char *p = hostname;
        a = b = c = d = -1;
        a = 0; while (*p >= '0' && *p <= '9') a = a*10 + (*p++ - '0');
        if (*p++ == '.') { b = 0; while (*p >= '0' && *p <= '9') b = b*10 + (*p++ - '0'); }
        if (b >= 0 && *p++ == '.') { c = 0; while (*p >= '0' && *p <= '9') c = c*10 + (*p++ - '0'); }
        if (c >= 0 && *p++ == '.') { d = 0; while (*p >= '0' && *p <= '9') d = d*10 + (*p++ - '0'); }
        if (d >= 0 && *p == '\0' && a>=0&&a<=255&&b>=0&&b<=255&&c>=0&&c<=255&&d>=0&&d<=255) {
            *out_ip = ((uint32_t)a<<24)|((uint32_t)b<<16)|((uint32_t)c<<8)|(uint32_t)d;
            return 0;
        }
    }

    if (!net.connected) { KPRINT("[DNS] Ag bagli degil\n"); return -1; }

    /* DNS sunucusu: gateway veya Google DNS */
    dns_server = net.gateway ? net.gateway
                             : (uint32_t)((8u<<24)|(8u<<16)|(8u<<8)|8u);

    /* ── DNS sorgu paketi ── */
    /* Header: ID=0xABCD, RD=1, QDCOUNT=1 */
    query[qlen++] = 0xAB; query[qlen++] = 0xCD;  /* ID      */
    query[qlen++] = 0x01; query[qlen++] = 0x00;  /* flags RD*/
    query[qlen++] = 0x00; query[qlen++] = 0x01;  /* QDCOUNT */
    query[qlen++] = 0x00; query[qlen++] = 0x00;  /* ANCOUNT */
    query[qlen++] = 0x00; query[qlen++] = 0x00;  /* NSCOUNT */
    query[qlen++] = 0x00; query[qlen++] = 0x00;  /* ARCOUNT */

    /* QNAME */
    name_len = dns_encode_name(hostname, query + qlen, 512 - qlen - 4);
    if (name_len < 0) return -1;
    qlen += name_len;

    /* QTYPE=A, QCLASS=IN */
    query[qlen++] = 0x00; query[qlen++] = 0x01;
    query[qlen++] = 0x00; query[qlen++] = 0x01;

    /* Gönder */
    if (udp_send(dns_server, DNS_SRC_PORT, DNS_PORT, query, qlen) < 0) {
        KPRINT("[DNS] Gonderilemedi\n");
        return -1;
    }

    /* Yanıt bekle — basit polling (en fazla 512 çevrim) */
    for (i = 0; i < 512; i++) {
        n = eth_recv(reply, (int)sizeof(reply));
        if (n <= 0) continue;

        /* UDP + DNS yanıtı mı? (basit kontrol: src port 53, ID eşleşiyor) */
        if (n < NET_HDR_ETH + NET_HDR_IP + NET_HDR_UDP + 12) continue;
        {
            uint8_t  *udp  = reply + NET_HDR_ETH + NET_HDR_IP;
            uint8_t  *dns  = udp + NET_HDR_UDP;
            uint16_t  sport = (uint16_t)((udp[0]<<8)|udp[1]);
            uint16_t  id    = (uint16_t)((dns[0]<<8)|dns[1]);
            uint16_t  ancount;
            int       off;

            if (sport != DNS_PORT) continue;
            if (id    != 0xABCDu)  continue;

            ancount = (uint16_t)((dns[6]<<8)|dns[7]);
            if (ancount == 0) { KPRINT("[DNS] Kayit yok\n"); return -1; }

            /* Soruyu atla */
            off = 12;
            while (off < n - (NET_HDR_ETH+NET_HDR_IP+NET_HDR_UDP) && dns[off] != 0) {
                if ((dns[off] & 0xC0) == 0xC0) { off += 2; goto skip_q; } /* pointer */
                off += dns[off] + 1;
            }
            off++;   /* kök etiketi */
            off += 4; /* QTYPE + QCLASS */
skip_q:
            /* İlk A kaydını bul */
            while (off + 10 < n - (NET_HDR_ETH+NET_HDR_IP+NET_HDR_UDP)) {
                uint16_t rtype, rdlen;
                if ((dns[off] & 0xC0) == 0xC0) off += 2; else { while(dns[off]) off += dns[off]+1; off++; }
                rtype = (uint16_t)((dns[off]<<8)|dns[off+1]); off += 2;
                off += 2; /* class */
                off += 4; /* TTL */
                rdlen = (uint16_t)((dns[off]<<8)|dns[off+1]); off += 2;
                if (rtype == DNS_TYPE_A && rdlen == 4) {
                    *out_ip = ((uint32_t)dns[off]<<24)|((uint32_t)dns[off+1]<<16)
                             |((uint32_t)dns[off+2]<<8)|(uint32_t)dns[off+3];
                    KPRINT("[DNS] %s -> %u.%u.%u.%u\n", hostname,
                            (unsigned)dns[off], (unsigned)dns[off+1],
                            (unsigned)dns[off+2], (unsigned)dns[off+3]);
                    return 0;
                }
                off += rdlen;
            }
        }
    }
    KPRINT("[DNS] Zaman asimi\n");
    return -1;
}

/* ================================================================
 * HTTP/1.0 GET  (TCP üzerinden)
 * ================================================================ */

/* URL ayrıştır: http://host[:port]/path */
static int parse_url(const char *url, char *host, int hostlen,
                     uint16_t *port, char *path, int pathlen)
{
    const char *p = url;
    int i;

    *port = 80;

    /* scheme */
    if (p[0]=='h'&&p[1]=='t'&&p[2]=='t'&&p[3]=='p'&&p[4]==':'&&p[5]=='/'&&p[6]=='/') p += 7;
    else if (p[0]=='h'&&p[1]=='t'&&p[2]=='t'&&p[3]=='p'&&p[4]=='s'&&p[5]==':'&&p[6]=='/'&&p[7]=='/') {
        *port = 443; p += 8;
    }

    /* host */
    for (i = 0; i < hostlen - 1 && *p && *p != '/' && *p != ':'; i++)
        host[i] = *p++;
    host[i] = '\0';

    /* port */
    if (*p == ':') {
        p++;
        *port = 0;
        while (*p >= '0' && *p <= '9') { *port = (uint16_t)(*port * 10 + (*p++ - '0')); }
    }

    /* path */
    if (*p == '/') {
        for (i = 0; i < pathlen - 1 && *p; i++) path[i] = *p++;
        path[i] = '\0';
    } else {
        path[0] = '/'; path[1] = '\0';
    }

    return (host[0] != '\0') ? 0 : -1;
}

int http_get(const char *url, char *buf, int buflen)
{
    char     host[128];
    char     path[256];
    char     req[512];
    uint16_t port;
    uint32_t ip;
    int      conn, req_len, total, n, i;

    if (!url || !buf || buflen <= 0) return -1;
    if (!net.connected) { KPRINT("[HTTP] Ag bagli degil\n"); return -1; }

    /* URL ayrıştır */
    if (parse_url(url, host, (int)sizeof(host), &port, path, (int)sizeof(path)) < 0) {
        KPRINT("[HTTP] Gecersiz URL: %s\n", url);
        return -1;
    }

    /* DNS çöz */
    if (dns_resolve(host, &ip) < 0) {
        KPRINT("[HTTP] DNS basarisiz: %s\n", host);
        return -1;
    }

    /* TCP bağlantısı */
    conn = tcp_connect(ip, port, 10080u);
    if (conn < 0) { KPRINT("[HTTP] TCP baglanti basarisiz\n"); return -1; }

    /* HTTP/1.0 GET isteği */
    req_len = 0;
    {
        const char *method = "GET ";
        const char *ver    = " HTTP/1.0\r\nHost: ";
        const char *end    = "\r\nConnection: close\r\n\r\n";
        const char *s;
        for (s = method; *s; s++) req[req_len++] = *s;
        for (s = path;   *s; s++) req[req_len++] = *s;
        for (s = ver;    *s; s++) req[req_len++] = *s;
        for (s = host;   *s; s++) req[req_len++] = *s;
        for (s = end;    *s; s++) req[req_len++] = *s;
        req[req_len] = '\0';
    }

    if (tcp_send(conn, (const uint8_t *)req, req_len) < 0) {
        KPRINT("[HTTP] Istek gonderilemedi\n");
        tcp_close(conn);
        return -1;
    }

    /* Yanıtı topla */
    total = 0;
    for (i = 0; i < 2000 && total < buflen - 1; i++) {
        n = tcp_recv(conn, (uint8_t *)buf + total, buflen - 1 - total);
        if (n < 0) break;
        if (n > 0) { total += n; i = 0; } /* veri geldi, sayacı sıfırla */
    }
    buf[total] = '\0';
    tcp_close(conn);

    KPRINT("[HTTP] %s -> %d byte alindi\n", url, total);
    return total;
}

int http_get_print(const char *url)
{
    char buf[2048];
    int n = http_get(url, buf, (int)sizeof(buf));
    if (n < 0) return -1;
    /* HTTP başlığını atla, gövdeyi yazdır */
    {
        char *body = buf;
        char *p;
        for (p = buf; p < buf + n - 3; p++) {
            if (p[0]=='\r'&&p[1]=='\n'&&p[2]=='\r'&&p[3]=='\n') {
                body = p + 4; break;
            }
        }
        KPRINT("%s\n", body);
    }
    return n;
}
