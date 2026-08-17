/*
 * HILAL_BIS — TCP Katmanı
 *
 * Mevcut Ethernet/IP/UDP yığıtının üzerine hafif bir TCP implementasyonu.
 * Desteklenen özellikler:
 *   - 3-yönlü el sıkışma (SYN, SYN-ACK, ACK)
 *   - Güvenilir veri aktarımı (sıra numaraları, onay numaraları)
 *   - Bağlantı kapatma (FIN-ACK)
 *   - 8 eş zamanlı bağlantı
 *   - Gönderme/alma tamponları (her bağlantı için 1KB)
 */

#ifndef TCP_H
#define TCP_H

#include <stdint.h>
#include "network.h"

/* ── Sabitler ─────────────────────────────────────────── */
#define TCP_MAX_CONNECTIONS  8
#define TCP_BUFFER_SIZE      1024
#define TCP_HEADER_SIZE      20
#define IP_PROTO_TCP         0x06u

/* ── TCP bayrakları ───────────────────────────────────── */
#define TCP_FLAG_FIN  (1u << 0)
#define TCP_FLAG_SYN  (1u << 1)
#define TCP_FLAG_RST  (1u << 2)
#define TCP_FLAG_PSH  (1u << 3)
#define TCP_FLAG_ACK  (1u << 4)
#define TCP_FLAG_URG  (1u << 5)

/* ── Bağlantı durumları ───────────────────────────────── */
typedef enum {
    TCP_STATE_CLOSED      = 0,
    TCP_STATE_SYN_SENT    = 1,
    TCP_STATE_SYN_RECV    = 2,
    TCP_STATE_ESTABLISHED = 3,
    TCP_STATE_FIN_WAIT1   = 4,
    TCP_STATE_FIN_WAIT2   = 5,
    TCP_STATE_CLOSE_WAIT  = 6,
    TCP_STATE_LAST_ACK    = 7,
    TCP_STATE_TIME_WAIT   = 8
} TcpState;

/* ── TCP bağlantı bloğu (TCB) ─────────────────────────── */
typedef struct {
    TcpState  state;
    uint32_t  local_ip;
    uint32_t  remote_ip;
    uint16_t  local_port;
    uint16_t  remote_port;

    /* Sıra / onay numaraları */
    uint32_t  snd_nxt;     /* sonraki gönderilecek bayt */
    uint32_t  snd_una;     /* onaylanmamış en eski bayt */
    uint32_t  rcv_nxt;     /* beklenen sonraki bayt     */
    uint32_t  rcv_wnd;     /* alıcı penceresi           */

    /* Tamponlar */
    uint8_t   snd_buf[TCP_BUFFER_SIZE];
    int       snd_len;
    uint8_t   rcv_buf[TCP_BUFFER_SIZE];
    int       rcv_len;

    int       used;
} TcpConn;

/* ── API ───────────────────────────────────────────────── */

/* Katmanı başlat */
void tcp_init(void);

/*
 * tcp_connect — aktif bağlantı aç (istemci tarafı).
 * Döndürür: bağlantı tanımlayıcısı (≥0) veya -1=hata
 */
int  tcp_connect(uint32_t dst_ip, uint16_t dst_port, uint16_t src_port);

/*
 * tcp_send — bağlantı üzerinden veri gönder.
 * Döndürür: gönderilen bayt sayısı veya -1=hata
 */
int  tcp_send(int conn_id, const uint8_t *data, int len);

/*
 * tcp_recv — gelen veriyi al (non-blocking).
 * Döndürür: alınan bayt sayısı (0=veri yok, -1=hata)
 */
int  tcp_recv(int conn_id, uint8_t *buf, int maxlen);

/*
 * tcp_close — bağlantıyı kapat (FIN gönder).
 */
void tcp_close(int conn_id);

/*
 * tcp_poll — gelen paketleri işle (ana döngüde çağrılmalı).
 */
void tcp_poll(void);

/*
 * tcp_status — UART'a bağlantı durumu yazar.
 */
void tcp_status(void);

/*
 * tcp_listen — pasif dinleme yuvası aç (sunucu tarafı).
 * Döndürür: bağlantı tanımlayıcısı veya -1=hata
 */
int  tcp_listen(uint16_t port);

/*
 * tcp_accept — dinleme yuvasında yeni bağlantıyı kabul et.
 * Döndürür: yeni bağlantı tanımlayıcısı veya -1=yok
 */
int  tcp_accept(int listen_id);

/* Bağlantı nesnesi erişimi (dahili / hata ayıklama) */
TcpConn *tcp_get_conn(int conn_id);

#endif /* TCP_H */
