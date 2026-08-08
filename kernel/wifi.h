#ifndef WIFI_H
#define WIFI_H

#include <stdint.h>

/* ════════════════════════════════════════════════════════════════
 * Intel Wireless AC 9560 (Jefferson Peak 2) — Oxalyn-64 sürücüsü
 *
 * Gerçek donanım: PCIe x1, 802.11a/b/g/n/ac (Wave 2)
 *   · 2×2 MU-MIMO, 160 MHz kanal genişliği, 1.73 Gbps maks.
 *   · Bluetooth 5.1 combo (bu sürücüde yalnızca WiFi)
 *
 * Simülatör modeli:
 *   Donanım kayıtlarına MMIO portu 0x70-0x7F üzerinden erişilir.
 *   Gerçek PCIe konfigürasyon alanı (BDF 00:14.3) bu katmanda
 *   soyutlanmıştır; simülatör tek register bloğu olarak sunar.
 * ════════════════════════════════════════════════════════════════ */

/* ── MMIO register adresleri (Oxalyn sim base = 0x70) ─────────── */
#define WIFI_REG_BASE       0x70u
#define WIFI_REG_CTRL       (WIFI_REG_BASE + 0x00u)  /* kontrol     */
#define WIFI_REG_STATUS     (WIFI_REG_BASE + 0x01u)  /* durum       */
#define WIFI_REG_CHAN       (WIFI_REG_BASE + 0x02u)  /* kanal no    */
#define WIFI_REG_CHANWIDTH  (WIFI_REG_BASE + 0x03u)  /* kanal genişliği */
#define WIFI_REG_TXPOW     (WIFI_REG_BASE + 0x04u)  /* TX güç (dBm) */
#define WIFI_REG_SSID      (WIFI_REG_BASE + 0x05u)  /* SSID ptr    */
#define WIFI_REG_PSK       (WIFI_REG_BASE + 0x06u)  /* PSK ptr     */
#define WIFI_REG_RSSI      (WIFI_REG_BASE + 0x07u)  /* RSSI (-dBm) */
#define WIFI_REG_SCAN_TRIG (WIFI_REG_BASE + 0x08u)  /* tarama koy  */
#define WIFI_REG_SCAN_CNT  (WIFI_REG_BASE + 0x09u)  /* AP sayısı   */
#define WIFI_REG_SCAN_IDX  (WIFI_REG_BASE + 0x0Au)  /* okunacak AP */
#define WIFI_REG_SCAN_SSID (WIFI_REG_BASE + 0x0Bu)  /* AP SSID ptr */
#define WIFI_REG_SCAN_CHAN (WIFI_REG_BASE + 0x0Cu)  /* AP kanalı   */
#define WIFI_REG_SCAN_RSSI (WIFI_REG_BASE + 0x0Du)  /* AP RSSI     */
#define WIFI_REG_IP        (WIFI_REG_BASE + 0x0Eu)  /* DHCP IP     */
#define WIFI_REG_GW        (WIFI_REG_BASE + 0x0Fu)  /* gateway     */

/* ── CTRL bit maskeleri ────────────────────────────────────────── */
#define WIFI_CTRL_ENABLE    (1u << 0)  /* sürücüyü aç/kapat    */
#define WIFI_CTRL_CONNECT   (1u << 1)  /* bağlanma isteği      */
#define WIFI_CTRL_DISCONNECT (1u << 2) /* bağlantıyı kes       */
#define WIFI_CTRL_SCAN      (1u << 3)  /* tarama başlat        */
#define WIFI_CTRL_160MHZ    (1u << 4)  /* 160 MHz kanal genişliği */
#define WIFI_CTRL_WPA2      (1u << 5)  /* WPA2-PSK şifreleme   */

/* ── STATUS bit maskeleri ─────────────────────────────────────── */
#define WIFI_STATUS_UP      (1u << 0)  /* bağlı              */
#define WIFI_STATUS_SCANNING (1u << 1) /* tarama devam ediyor */
#define WIFI_STATUS_AUTH    (1u << 2)  /* kimlik doğrulandı  */
#define WIFI_STATUS_DHCP    (1u << 3)  /* IP alındı          */
#define WIFI_STATUS_ERROR   (1u << 4)  /* hata durumu        */

/* ── Kanal genişliği sabitleri ─────────────────────────────────── */
#define WIFI_WIDTH_20MHZ   20u
#define WIFI_WIDTH_40MHZ   40u
#define WIFI_WIDTH_80MHZ   80u
#define WIFI_WIDTH_160MHZ  160u   /* 9560'ın ayırt edici özelliği */

/* ── Maksimumlar ──────────────────────────────────────────────── */
#define WIFI_SSID_MAX       33    /* 32 karakter + NUL             */
#define WIFI_PSK_MAX        65    /* 64 karakter + NUL             */
#define WIFI_MAX_AP         16    /* tarama listesi kapasitesi     */

/* ── Taranan AP kaydı ─────────────────────────────────────────── */
typedef struct {
    char     ssid[WIFI_SSID_MAX];
    uint8_t  channel;           /* 1-14 (2.4GHz) veya 36-177 (5GHz) */
    int8_t   rssi;              /* dBm, tipik: -30 (güçlü) … -90 (zayıf) */
    uint8_t  has_password;      /* 0 = açık, 1 = şifreli             */
} WifiAP;

/* ── Sürücü durumu ────────────────────────────────────────────── */
typedef struct {
    char     ssid[WIFI_SSID_MAX];    /* bağlı ağın SSID'si       */
    char     psk[WIFI_PSK_MAX];      /* WPA2 parolası (hash'li)   */
    uint8_t  channel;                /* aktif kanal               */
    uint16_t chan_width;             /* MHz: 20/40/80/160         */
    int8_t   rssi;                   /* anlık sinyal gücü (dBm)   */
    int8_t   tx_power;               /* TX gücü (dBm, 0-22)       */
    int      connected;              /* 1 = bağlı                 */
    int      initialized;            /* wifi_init çağrıldı mı?    */
    uint32_t ip;                     /* DHCP'den alınan IP        */
    uint32_t gateway;                /* varsayılan ağ geçidi      */
    int      ap_count;               /* son taramadaki AP sayısı  */
    WifiAP   ap_list[WIFI_MAX_AP];   /* AP listesi                */
} WifiState;

extern WifiState wifi;

/* ── API ──────────────────────────────────────────────────────── */
void wifi_init(void);                            /* sürücüyü başlat   */
int  wifi_scan(void);                            /* AP'leri tara      */
void wifi_print_scan(void);                      /* tarama sonuçlarını yaz */
int  wifi_connect(const char *ssid, const char *psk); /* ağa bağlan  */
void wifi_disconnect(void);                      /* bağlantıyı kes    */
void wifi_status(void);                          /* durumu yazdır     */
int  wifi_is_up(void);                           /* bağlı mı?         */
int8_t wifi_rssi(void);                          /* anlık RSSI        */

#endif /* WIFI_H */
