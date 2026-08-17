#ifndef SYSLOG_H
#define SYSLOG_H

/*
 * HILAL_BIS — Kernel Syslog (Ring Buffer)
 * Seviyeli log, damgalı zaman, döngüsel tampon.
 */

#include <stdint.h>

/* Log seviyeleri */
#define LOG_DEBUG   0
#define LOG_INFO    1
#define LOG_WARN    2
#define LOG_ERROR   3
#define LOG_PANIC   4

#define SYSLOG_MAX_ENTRIES  128
#define SYSLOG_MSG_LEN       80

typedef struct {
    uint32_t tick;          /* Oluşturulduğu kernel tick */
    uint8_t  level;         /* LOG_* */
    char     tag[12];       /* Kısa modül adı, ör: "USB", "FS" */
    char     msg[SYSLOG_MSG_LEN];
} SyslogEntry;

void syslog_init(void);

/* Seviyeli kayıt — kprintf formatına benzer */
void klog(uint8_t level, const char *tag, const char *fmt, ...);

/* Tüm tamponu UART'a döker */
void syslog_dump(void);

/* Son N girişi döker */
void syslog_dump_last(int n);

/* Belirli seviye ve üstünü filtrele */
void syslog_dump_level(uint8_t min_level);

/* Kaç giriş birikti */
int  syslog_count(void);

#endif /* SYSLOG_H */
