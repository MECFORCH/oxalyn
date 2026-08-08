#ifndef RTC_H
#define RTC_H

/*
 * HILAL_BIS — RTC Sürücüsü (Real-Time Clock)
 * Oxalyn-64 Port Haritası: 0x60-0x67
 *
 *  0x60  RTC_SEC    (R)  saniye  (0-59)
 *  0x61  RTC_MIN    (R)  dakika  (0-59)
 *  0x62  RTC_HOUR   (R)  saat    (0-23)
 *  0x63  RTC_WDAY   (R)  haftanın günü (0=Pazar)
 *  0x64  RTC_MDAY   (R)  ayın günü   (1-31)
 *  0x65  RTC_MONTH  (R)  ay          (1-12)
 *  0x66  RTC_YEAR   (R)  yıl (2000'den fark, ör: 25 = 2025)
 *  0x67  RTC_CTRL   (W)  bit0=latch (okuma esnasında değişimi durdur)
 */

#include <stdint.h>

#define RTC_PORT_SEC    0x60u
#define RTC_PORT_MIN    0x61u
#define RTC_PORT_HOUR   0x62u
#define RTC_PORT_WDAY   0x63u
#define RTC_PORT_MDAY   0x64u
#define RTC_PORT_MONTH  0x65u
#define RTC_PORT_YEAR   0x66u
#define RTC_PORT_CTRL   0x67u

#define RTC_CTRL_LATCH  (1u << 0)

static const char * const RTC_DAY_NAMES[7] = {
    "Paz", "Pzt", "Sal", "Car", "Per", "Cum", "Cmt"
};

static const char * const RTC_MONTH_NAMES[13] = {
    "", "Oca", "Sub", "Mar", "Nis", "May", "Haz",
    "Tem", "Agu", "Eyl", "Eki", "Kas", "Ara"
};

typedef struct {
    uint8_t  sec;
    uint8_t  min;
    uint8_t  hour;
    uint8_t  wday;   /* 0=Pazar */
    uint8_t  mday;
    uint8_t  month;
    uint16_t year;   /* tam yıl, ör: 2025 */
} DateTime;

void     rtc_init(void);
void     rtc_read(DateTime *dt);
uint32_t rtc_timestamp(void);          /* saniye cinsinden basit damga */
void     rtc_format(const DateTime *dt, char *buf, int buflen);
                                        /* ör: "2025-07-27 14:35:09" */

#endif /* RTC_H */
