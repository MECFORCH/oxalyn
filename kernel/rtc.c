/*
 * HILAL_BIS — RTC Sürücüsü
 * Oxalyn-64 bellek-eşlemeli I/O, portlar 0x60-0x67
 */

#include "rtc.h"
#include "kstring.h"
#include "mmio.h"   /* H3: Host modda düşük adres segfault'unu önler */
#include "platform.h"

static inline uint8_t rtc_port_read(uint32_t port)
{
    return (uint8_t)(mmio_read(port) & 0xFFu);
}

static inline void rtc_port_write(uint32_t port, uint8_t val)
{
    mmio_write(port, (uint64_t)val);
}

/* ================================================================ */
void rtc_init(void)
{
    /* Latch kaldır */
    rtc_port_write(RTC_PORT_CTRL, 0);
    KPRINT("[RTC] Basladi\n");
}

/* ================================================================ */
void rtc_read(DateTime *dt)
{
    /* Okuma sırasında değişimi kilitle */
    rtc_port_write(RTC_PORT_CTRL, RTC_CTRL_LATCH);

    dt->sec   = rtc_port_read(RTC_PORT_SEC);
    dt->min   = rtc_port_read(RTC_PORT_MIN);
    dt->hour  = rtc_port_read(RTC_PORT_HOUR);
    dt->wday  = rtc_port_read(RTC_PORT_WDAY);
    dt->mday  = rtc_port_read(RTC_PORT_MDAY);
    dt->month = rtc_port_read(RTC_PORT_MONTH);
    dt->year  = (uint16_t)(2000u + rtc_port_read(RTC_PORT_YEAR));

    /* Kilidi serbest bırak */
    rtc_port_write(RTC_PORT_CTRL, 0);

    /* Sınır koruması (simülatör garip değer dönebilir) */
    if (dt->sec   > 59)  dt->sec   = 0;
    if (dt->min   > 59)  dt->min   = 0;
    if (dt->hour  > 23)  dt->hour  = 0;
    if (dt->wday  > 6)   dt->wday  = 0;
    if (dt->mday  < 1 || dt->mday  > 31) dt->mday  = 1;
    if (dt->month < 1 || dt->month > 12) dt->month = 1;
    if (dt->year  < 2000u || dt->year > 2099u) dt->year = 2025u;
}

/* ================================================================ */
uint32_t rtc_timestamp(void)
{
    DateTime dt;
    uint32_t days;
    static const uint16_t days_in_month[13] = {
        0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    };
    uint16_t y;
    uint8_t  m;

    rtc_read(&dt);

    /* Yıldan gün sayısı (2000 tabanı, basit hesap) */
    y = dt.year - 2000u;
    days = (uint32_t)y * 365u + (uint32_t)(y / 4u);   /* artık yıl tahmini */

    for (m = 1; m < dt.month; m++)
        days += days_in_month[m];

    /* Artık yıl + Şubat düzeltmesi */
    if (dt.month > 2 && (dt.year % 4u == 0u))
        days++;

    days += (uint16_t)(dt.mday - 1u);

    return days * 86400u
         + (uint32_t)dt.hour * 3600u
         + (uint32_t)dt.min  * 60u
         + (uint32_t)dt.sec;
}

/* ================================================================ */
/* Çıktı: "2025-07-27 14:35:09" */
void rtc_format(const DateTime *dt, char *buf, int buflen)
{
    /* Elle yaz, snprintf yok */
    char tmp[24];
    int  pos = 0;

#define WDIGIT2(v) \
    do { tmp[pos++] = (char)('0' + ((v)/10) % 10); \
         tmp[pos++] = (char)('0' + (v) % 10); } while(0)
#define WCHAR(c) do { tmp[pos++] = (c); } while(0)

    /* yıl */
    tmp[pos++] = (char)('0' + (dt->year / 1000) % 10);
    tmp[pos++] = (char)('0' + (dt->year / 100)  % 10);
    tmp[pos++] = (char)('0' + (dt->year / 10)   % 10);
    tmp[pos++] = (char)('0' + (dt->year)         % 10);
    WCHAR('-'); WDIGIT2(dt->month);
    WCHAR('-'); WDIGIT2(dt->mday);
    WCHAR(' '); WDIGIT2(dt->hour);
    WCHAR(':'); WDIGIT2(dt->min);
    WCHAR(':'); WDIGIT2(dt->sec);
    tmp[pos] = '\0';

    kstrncpy(buf, tmp, buflen);
#undef WDIGIT2
#undef WCHAR
}
