/*
 * HILAL_BIS — TCP Katmanı
 *
 * Mevcut Ethernet/IP/UDP yığıtı üzerine hafif TCP implementasyonu.
 * RFC 793 temelinde; kayan pencere, yeniden iletim ve sıra dışı
 * paket tamponu bu sürümde yer almaz (eğitim amaçlı).
 */

#include "tcp.h"
#include "network.h"
#include "kstring.h"
#include "kernel.h"

/* ── Bağlantı tablosu ─────────────────────────────────────────────── */
static TcpConn conns[TCP_MAX_CONNECTIONS];

/* ── Basit sözde rastgele ISN üreteci ────────────────────────────── */
static uint32_t tcp_isn_seed = 0xABCD1234u;
static uint32_t tcp_next_isn(void)
{
    tcp_isn_seed ^= tcp_isn_seed << 13;
    tcp_isn_seed ^= tcp_isn_seed >> 17;
    tcp_isn_seed ^= tcp_isn_seed << 5;
    return tcp_isn_seed;
}

/* ── Yardımcılar ─────────────────────────────────────────────────── */

static TcpConn *alloc_conn(void)
{
    int i;
    for (i = 0; i < TCP_MAX_CONNECTIONS; i++)
        if (!conns[i].used) return &conns[i];
    return NULL;
}

static int conn_id(const TcpConn *c)
{
    return (int)(c - conns);
}

/* 16-bit internet sağlama toplamı — TCP sahte başlık dahil */
static uint16_t tcp_checksum(uint32_t src_ip, uint32_t dst_ip,
                              const uint8_t *seg, int seg_len)
{
    uint32_t sum = 0;
    int i;

    /* Sahte başlık: src_ip, dst_ip, sıfır, protokol(6), TCP uzunluğu */
    sum += (src_ip >> 16) & 0xFFFFu;
    sum += (src_ip)       & 0xFFFFu;
    sum += (dst_ip >> 16) & 0xFFFFu;
    sum += (dst_ip)       & 0xFFFFu;
    sum += IP_PROTO_TCP;
    sum += (uint32_t)seg_len;

    for (i = 0; i + 1 < seg_len; i += 2)
        sum += ((uint32_t)seg[i] << 8) | seg[i + 1];
    if (seg_len & 1) sum += (uint32_t)seg[seg_len - 1] << 8;

    while (sum >> 16) sum = (sum & 0xFFFFu) + (sum >> 16);
    return (uint16_t)(~sum);
}

/* ── Segment inşaatçısı ──────────────────────────────────────────── */
static int tcp_build_segment(TcpConn *c, uint8_t flags,
                              const uint8_t *data, int data_len,
                              uint8_t *out, int out_cap)
{
    int total = TCP_HEADER_SIZE + data_len;
    uint16_t csum;

    if (total > out_cap) return -1;

    /* Kaynak port */
    out[0]  = (uint8_t)(c->local_port  >> 8);
    out[1]  = (uint8_t)(c->local_port  & 0xFF);
    /* Hedef port */
    out[2]  = (uint8_t)(c->remote_port >> 8);
    out[3]  = (uint8_t)(c->remote_port & 0xFF);
    /* Sıra numarası */
    out[4]  = (uint8_t)(c->snd_nxt >> 24);
    out[5]  = (uint8_t)(c->snd_nxt >> 16);
    out[6]  = (uint8_t)(c->snd_nxt >>  8);
    out[7]  = (uint8_t)(c->snd_nxt);
    /* Onay numarası */
    out[8]  = (uint8_t)(c->rcv_nxt >> 24);
    out[9]  = (uint8_t)(c->rcv_nxt >> 16);
    out[10] = (uint8_t)(c->rcv_nxt >>  8);
    out[11] = (uint8_t)(c->rcv_nxt);
    /* Veri ofseti (5 kelime = 20 bayt) | sıfır */
    out[12] = (5 << 4);
    /* Bayraklar */
    out[13] = flags;
    /* Pencere boyutu */
    out[14] = (uint8_t)(c->rcv_wnd >> 8);
    out[15] = (uint8_t)(c->rcv_wnd & 0xFF);
    /* Sağlama toplamı (şimdilik sıfır) */
    out[16] = 0; out[17] = 0;
    /* Acil işaretçi */
    out[18] = 0; out[19] = 0;

    /* Veri */
    if (data && data_len > 0)
        kmemcpy(out + TCP_HEADER_SIZE, data, (size_t)data_len);

    /* Sağlama toplamı hesapla */
    csum = tcp_checksum(c->local_ip, c->remote_ip, out, total);
    out[16] = (uint8_t)(csum >> 8);
    out[17] = (uint8_t)(csum & 0xFF);

    return total;
}

/* ── Segment gönder ──────────────────────────────────────────────── */
static int tcp_send_segment(TcpConn *c, uint8_t flags,
                             const uint8_t *data, int data_len)
{
    uint8_t seg[NET_MTU];
    int len = tcp_build_segment(c, flags, data, data_len, seg, (int)sizeof(seg));
    if (len < 0) return -1;
    return ip_send(c->remote_ip, IP_PROTO_TCP, seg, len);
}

/* ── tcp_init ─────────────────────────────────────────────────────── */
void tcp_init(void)
{
    int i;
    for (i = 0; i < TCP_MAX_CONNECTIONS; i++) {
        kmemset(&conns[i], 0, sizeof(TcpConn));
        conns[i].state = TCP_STATE_CLOSED;
    }
    KPRINT("[TCP] Baslatildi (%d yuva)\n", TCP_MAX_CONNECTIONS);
}

/* ── tcp_connect ─────────────────────────────────────────────────── */
int tcp_connect(uint32_t dst_ip, uint16_t dst_port, uint16_t src_port)
{
    TcpConn *c = alloc_conn();
    if (!c) { KPRINT("[TCP] Yuva dolu\n"); return -1; }

    c->used        = 1;
    c->state       = TCP_STATE_SYN_SENT;
    c->local_ip    = net.ip;
    c->remote_ip   = dst_ip;
    c->local_port  = src_port;
    c->remote_port = dst_port;
    c->snd_nxt     = tcp_next_isn();
    c->snd_una     = c->snd_nxt;
    c->rcv_nxt     = 0;
    c->rcv_wnd     = TCP_BUFFER_SIZE;
    c->snd_len     = 0;
    c->rcv_len     = 0;

    /* SYN gönder */
    if (tcp_send_segment(c, TCP_FLAG_SYN, NULL, 0) < 0) {
        c->used = 0;
        return -1;
    }
    c->snd_nxt++;   /* SYN sıra numarası tüketir */
    KPRINT("[TCP] SYN gonderildi -> %u.%u.%u.%u:%u\n",
            (dst_ip >> 24) & 0xFF, (dst_ip >> 16) & 0xFF,
            (dst_ip >>  8) & 0xFF,  dst_ip         & 0xFF,
            dst_port);
    return conn_id(c);
}

/* ── tcp_listen ──────────────────────────────────────────────────── */
int tcp_listen(uint16_t port)
{
    TcpConn *c = alloc_conn();
    if (!c) return -1;
    kmemset(c, 0, sizeof(*c));
    c->used       = 1;
    c->state      = TCP_STATE_SYN_RECV;   /* dinleme işareti */
    c->local_ip   = net.ip;
    c->local_port = port;
    c->rcv_wnd    = TCP_BUFFER_SIZE;
    KPRINT("[TCP] Dinleniyor: port %u\n", port);
    return conn_id(c);
}

/* ── tcp_accept ──────────────────────────────────────────────────── */
int tcp_accept(int listen_id)
{
    /* Basit implementasyon: dinleme yuvasının kendisini döndür
       (yeni bağlantı poll sırasında kurulur). */
    TcpConn *c = tcp_get_conn(listen_id);
    if (!c) return -1;
    if (c->state == TCP_STATE_ESTABLISHED) return listen_id;
    return -1;
}

/* ── tcp_send ─────────────────────────────────────────────────────── */
int tcp_send(int conn_id_val, const uint8_t *data, int len)
{
    TcpConn *c = tcp_get_conn(conn_id_val);
    int sent = 0;

    if (!c || c->state != TCP_STATE_ESTABLISHED) return -1;

    while (sent < len) {
        int chunk = len - sent;
        int seg_data_max = NET_MTU - TCP_HEADER_SIZE - 20 /* IP */;
        if (chunk > seg_data_max) chunk = seg_data_max;

        if (tcp_send_segment(c, TCP_FLAG_ACK | TCP_FLAG_PSH,
                             data + sent, chunk) < 0)
            break;
        c->snd_nxt += (uint32_t)chunk;
        sent       += chunk;
    }
    return sent;
}

/* ── tcp_recv ─────────────────────────────────────────────────────── */
int tcp_recv(int conn_id_val, uint8_t *buf, int maxlen)
{
    TcpConn *c = tcp_get_conn(conn_id_val);
    int copy;
    if (!c || c->rcv_len == 0) return 0;

    copy = (maxlen < c->rcv_len) ? maxlen : c->rcv_len;
    kmemcpy(buf, c->rcv_buf, (size_t)copy);
    /* Kalan veriyi öne kaydır */
    c->rcv_len -= copy;
    if (c->rcv_len > 0)
        kmemmove(c->rcv_buf, c->rcv_buf + copy, (size_t)c->rcv_len);
    return copy;
}

/* ── tcp_close ────────────────────────────────────────────────────── */
void tcp_close(int conn_id_val)
{
    TcpConn *c = tcp_get_conn(conn_id_val);
    if (!c) return;

    if (c->state == TCP_STATE_ESTABLISHED) {
        tcp_send_segment(c, TCP_FLAG_FIN | TCP_FLAG_ACK, NULL, 0);
        c->snd_nxt++;
        c->state = TCP_STATE_FIN_WAIT1;
        KPRINT("[TCP] FIN gonderildi (conn %d)\n", conn_id_val);
    } else {
        c->state = TCP_STATE_CLOSED;
        c->used  = 0;
    }
}

/* ── tcp_poll ─────────────────────────────────────────────────────── */
void tcp_poll(void)
{
    uint8_t pkt[NET_MTU];
    int     pkt_len;
    int     i;

    /* Tüm bekleyen paketleri işle */
    while ((pkt_len = eth_recv(pkt, NET_MTU)) > 0) {
        uint8_t *ip_hdr, *tcp_hdr;
        uint32_t src_ip;
        uint16_t src_port, dst_port;
        uint32_t seq, ack_num;
        uint8_t  flags;
        int      data_off, data_len;

        if (pkt_len < (int)(14 + 20 + TCP_HEADER_SIZE)) continue;

        ip_hdr = pkt + 14;          /* Ethernet başlığını atla */
        if (ip_hdr[9] != IP_PROTO_TCP) continue;   /* TCP değilse atla */

        src_ip   = ((uint32_t)ip_hdr[12] << 24) | ((uint32_t)ip_hdr[13] << 16) |
                   ((uint32_t)ip_hdr[14] <<  8) |  (uint32_t)ip_hdr[15];
        tcp_hdr  = ip_hdr + 20;    /* IP başlığını atla */

        src_port = ((uint16_t)tcp_hdr[0] << 8) | tcp_hdr[1];
        dst_port = ((uint16_t)tcp_hdr[2] << 8) | tcp_hdr[3];
        seq      = ((uint32_t)tcp_hdr[4] << 24) | ((uint32_t)tcp_hdr[5] << 16) |
                   ((uint32_t)tcp_hdr[6] <<  8) | (uint32_t)tcp_hdr[7];
        ack_num  = ((uint32_t)tcp_hdr[8] << 24) | ((uint32_t)tcp_hdr[9] << 16) |
                   ((uint32_t)tcp_hdr[10]<<  8) | (uint32_t)tcp_hdr[11];
        flags    = tcp_hdr[13];
        data_off = (tcp_hdr[12] >> 4) * 4;
        data_len = pkt_len - 14 - 20 - data_off;
        if (data_len < 0) data_len = 0;

        /* İlgili bağlantıyı bul */
        for (i = 0; i < TCP_MAX_CONNECTIONS; i++) {
            TcpConn *c = &conns[i];
            if (!c->used) continue;

            /* ── SYN_SENT: SYN-ACK bekliyoruz ── */
            if (c->state == TCP_STATE_SYN_SENT &&
                c->remote_ip == src_ip &&
                c->remote_port == src_port &&
                c->local_port  == dst_port &&
                (flags & (TCP_FLAG_SYN | TCP_FLAG_ACK)) == (TCP_FLAG_SYN | TCP_FLAG_ACK)) {
                c->rcv_nxt = seq + 1;
                c->snd_una = ack_num;
                c->state   = TCP_STATE_ESTABLISHED;
                /* ACK gönder */
                tcp_send_segment(c, TCP_FLAG_ACK, NULL, 0);
                KPRINT("[TCP] KURULDU (conn %d)\n", i);
                break;
            }

            /* ── SYN_RECV (dinleme): SYN geldi ── */
            if (c->state == TCP_STATE_SYN_RECV &&
                c->local_port == dst_port &&
                (flags & TCP_FLAG_SYN) && !(flags & TCP_FLAG_ACK)) {
                c->remote_ip   = src_ip;
                c->remote_port = src_port;
                c->rcv_nxt     = seq + 1;
                c->snd_nxt     = tcp_next_isn();
                c->snd_una     = c->snd_nxt;
                /* SYN-ACK gönder */
                tcp_send_segment(c, TCP_FLAG_SYN | TCP_FLAG_ACK, NULL, 0);
                c->snd_nxt++;
                c->state = TCP_STATE_ESTABLISHED;
                KPRINT("[TCP] KABUL EDILDI (conn %d, port %u)\n", i, dst_port);
                break;
            }

            /* ── ESTABLISHED: veri veya FIN ── */
            if (c->state == TCP_STATE_ESTABLISHED &&
                c->remote_ip   == src_ip &&
                c->remote_port == src_port &&
                c->local_port  == dst_port) {

                if ((flags & TCP_FLAG_ACK) && ack_num > c->snd_una)
                    c->snd_una = ack_num;

                /* Veri al */
                if (data_len > 0 && seq == c->rcv_nxt) {
                    int space = TCP_BUFFER_SIZE - c->rcv_len;
                    int copy  = (data_len < space) ? data_len : space;
                    if (copy > 0) {
                        kmemcpy(c->rcv_buf + c->rcv_len,
                                tcp_hdr + data_off, (size_t)copy);
                        c->rcv_len += copy;
                        c->rcv_nxt += (uint32_t)copy;
                    }
                    /* ACK */
                    tcp_send_segment(c, TCP_FLAG_ACK, NULL, 0);
                }

                /* FIN geldi */
                if (flags & TCP_FLAG_FIN) {
                    c->rcv_nxt++;
                    tcp_send_segment(c, TCP_FLAG_ACK, NULL, 0);
                    c->state = TCP_STATE_CLOSE_WAIT;
                    /* Hemen LAST_ACK'e geç */
                    tcp_send_segment(c, TCP_FLAG_FIN | TCP_FLAG_ACK, NULL, 0);
                    c->snd_nxt++;
                    c->state = TCP_STATE_LAST_ACK;
                }
                break;
            }

            /* ── LAST_ACK: son ACK bekleniyor ── */
            if (c->state == TCP_STATE_LAST_ACK &&
                c->remote_ip == src_ip &&
                (flags & TCP_FLAG_ACK)) {
                c->state = TCP_STATE_CLOSED;
                c->used  = 0;
                KPRINT("[TCP] Baglanti kapatildi (conn %d)\n", i);
                break;
            }

            /* ── FIN_WAIT1: FIN-ACK bekleniyor ── */
            if (c->state == TCP_STATE_FIN_WAIT1 &&
                c->remote_ip == src_ip &&
                (flags & TCP_FLAG_ACK)) {
                c->state = TCP_STATE_FIN_WAIT2;
                if (flags & TCP_FLAG_FIN) {
                    c->rcv_nxt++;
                    tcp_send_segment(c, TCP_FLAG_ACK, NULL, 0);
                    c->state = TCP_STATE_CLOSED;
                    c->used  = 0;
                }
                break;
            }
        }
    }
}

/* ── tcp_status ──────────────────────────────────────────────────── */
void tcp_status(void)
{
    int i, active = 0;
    static const char * const state_names[] = {
        "KAPALI", "SYN_GOND", "SYN_ALIND", "KURULDU",
        "FIN_BK1", "FIN_BK2", "KAP_BEKL", "SON_ACK", "ZMN_BKL"
    };
    KPRINT("TCP Baglantilari:\n");
    for (i = 0; i < TCP_MAX_CONNECTIONS; i++) {
        TcpConn *c = &conns[i];
        if (!c->used) continue;
        active++;
        KPRINT("  [%d] port=%u->%u  durum=%s  rx=%d  tx_nxt=%u\n",
                i, c->local_port, c->remote_port,
                state_names[c->state <= TCP_STATE_TIME_WAIT ? c->state : 0],
                c->rcv_len, c->snd_nxt);
    }
    if (!active) KPRINT("  (aktif baglanti yok)\n");
}

/* ── tcp_get_conn ────────────────────────────────────────────────── */
TcpConn *tcp_get_conn(int id)
{
    if (id < 0 || id >= TCP_MAX_CONNECTIONS) return NULL;
    return conns[id].used ? &conns[id] : NULL;
}
