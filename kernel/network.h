#ifndef NETWORK_H
#define NETWORK_H

/*
 * HILAL_BIS — Ağ Sürücüsü
 * Oxalyn-64 NIC Port Haritası: 0x50-0x5F
 *
 *  0x50  NIC_STATUS  (R)  bit0=hazır, bit1=link yukarı, bit2=rx_avail, bit3=tx_meşgul
 *  0x51  NIC_CTRL    (W)  bit0=etkinleştir, bit1=sıfırla, bit2=çift yönlü
 *  0x52  NIC_TX_LEN  (W)  gönderilecek paket boyutu (byte)
 *  0x53  NIC_TX_DATA (W)  tek byte yaz (FIFO)
 *  0x54  NIC_TX_SEND (W)  herhangi değer → gönderimi tetikle
 *  0x55  NIC_RX_LEN  (R)  alınan paket boyutu (0 = paket yok)
 *  0x56  NIC_RX_DATA (R)  tek byte oku (FIFO)
 *  0x57  NIC_RX_ACK  (W)  herhangi değer → paketi onayla/at
 *  0x58  NIC_IP      (W)  IP adresi (4 byte, büyük endian)
 */

#include <stdint.h>

/* ── Port Adresleri ─────────────────────────────────────── */
#define NIC_PORT_STATUS  0x50u
#define NIC_PORT_CTRL    0x51u
#define NIC_PORT_TX_LEN  0x52u
#define NIC_PORT_TX_DATA 0x53u
#define NIC_PORT_TX_SEND 0x54u
#define NIC_PORT_RX_LEN  0x55u
#define NIC_PORT_RX_DATA 0x56u
#define NIC_PORT_RX_ACK  0x57u
#define NIC_PORT_IP      0x58u

/* ── Durum Bitleri ──────────────────────────────────────── */
#define NIC_STATUS_READY    (1u << 0)
#define NIC_STATUS_LINK     (1u << 1)
#define NIC_STATUS_RX_AVAIL (1u << 2)
#define NIC_STATUS_TX_BUSY  (1u << 3)

/* ── Paket sabitleri ────────────────────────────────────── */
#define NET_MTU          1518
#define NET_HDR_ETH      14
#define NET_HDR_IP       20
#define NET_HDR_ICMP      8
#define NET_HDR_UDP       8

#define ETHERTYPE_IP     0x0800u
#define ETHERTYPE_ARP    0x0806u
#define IP_PROTO_ICMP    0x01u
#define IP_PROTO_UDP     0x11u

/* ── ARP tablosu ────────────────────────────────────────── */
#define ARP_TABLE_SIZE   8

typedef struct {
    uint32_t ip;
    uint8_t  mac[6];
    int      valid;
} ArpEntry;

/* ── Ağ yapılandırması ──────────────────────────────────── */
typedef struct {
    uint32_t ip;
    uint32_t gateway;
    uint32_t netmask;
    uint8_t  mac[6];
    int      connected;
    uint64_t tx_packets;
    uint64_t rx_packets;
    uint64_t tx_errors;
    uint64_t rx_errors;
} NetworkConfig;

extern NetworkConfig net;
extern ArpEntry      arp_table[ARP_TABLE_SIZE];

/* ── API ────────────────────────────────────────────────── */
void network_init(void);
int  net_is_up(void);
void net_status(void);           /* UART'a durum yazar */

/* Ham Ethernet paketi gönder */
int  eth_send(const uint8_t *dst_mac, uint16_t ethertype,
              const uint8_t *payload, int payload_len);

/* Bekleyen paketi al (non-blocking; boyut döner, 0=yok) */
int  eth_recv(uint8_t *buf, int buflen);

/* ARP */
int     arp_lookup(uint32_t ip, uint8_t *mac_out);
void    arp_learn(uint32_t ip, const uint8_t *mac);

/* IP katmanı */
int  ip_send(uint32_t dst_ip, uint8_t proto,
             const uint8_t *data, int data_len);

/* ICMP ping (bloklamayan; -1=hata/zaman aşımı, 0=başarı) */
int  ping(uint32_t target_ip);

/* UDP */
int  udp_send(uint32_t dst_ip, uint16_t src_port, uint16_t dst_port,
              const uint8_t *data, int data_len);

/* ── DNS çözümleme ──────────────────────────────────────── */
/* Hostname → IPv4 adres çözümler (UDP DNS sorgusu, port 53).
 * Başarıda: 0 ve *out_ip doldurulur.  Hata: -1               */
int  dns_resolve(const char *hostname, uint32_t *out_ip);

/* ── HTTP/1.0 ────────────────────────────────────────────── */
/* URL'den sayfa indir, yanıtı buf'a yazar. Başarıda byte sayısı,
 * hata durumunda -1.  URL formatı: http://host[:port]/path    */
int  http_get(const char *url, char *buf, int buflen);

/* Geriye uyumluluk shim (buf/buflen olmadan çağrılar için)    */
int  http_get_print(const char *url);

#endif /* NETWORK_H */
