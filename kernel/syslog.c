/*
 * HILAL_BIS — Kernel Syslog (Ring Buffer)
 */

#include "syslog.h"
#include "kernel.h"
#include <stdarg.h>

extern uint32_t total_ticks;

static SyslogEntry slog_buf[SYSLOG_MAX_ENTRIES];
static int slog_head  = 0;   /* sonraki yazma konumu */
static int slog_total = 0;   /* toplam yazılan giriş */

static const char * const level_str[] = {
    "DBG", "INF", "WRN", "ERR", "PNK"
};

/* ── Küçük vsnprintf benzeri (sadece %s %d %x %c %u) ───────── */
static int slog_vformat(char *out, int size, const char *fmt, va_list ap)
{
    int pos = 0;
#define SPUT(c) do { if (pos < size-1) out[pos++] = (c); } while(0)

    while (*fmt && pos < size - 1) {
        if (*fmt != '%') { SPUT(*fmt++); continue; }
        fmt++;
        switch (*fmt++) {
        case 's': {
            const char *s = va_arg(ap, const char *);
            if (!s) s = "(null)";
            while (*s && pos < size-1) SPUT(*s++);
            break;
        }
        case 'd': case 'i': {
            int v = va_arg(ap, int);
            char tmp[16]; int ti = 0;
            if (v < 0) { SPUT('-'); v = -v; }
            if (v == 0) { SPUT('0'); break; }
            while (v) { tmp[ti++] = (char)('0' + v % 10); v /= 10; }
            while (ti--) SPUT(tmp[ti]);
            break;
        }
        case 'u': {
            unsigned v = va_arg(ap, unsigned);
            char tmp[16]; int ti = 0;
            if (v == 0) { SPUT('0'); break; }
            while (v) { tmp[ti++] = (char)('0' + v % 10); v /= 10; }
            while (ti--) SPUT(tmp[ti]);
            break;
        }
        case 'x': case 'X': {
            unsigned v = va_arg(ap, unsigned);
            char tmp[16]; int ti = 0;
            const char *hex = "0123456789abcdef";
            SPUT('0'); SPUT('x');
            if (v == 0) { SPUT('0'); break; }
            while (v) { tmp[ti++] = hex[v & 0xF]; v >>= 4; }
            while (ti--) SPUT(tmp[ti]);
            break;
        }
        case 'c':
            SPUT((char)va_arg(ap, int));
            break;
        case '%':
            SPUT('%');
            break;
        default:
            SPUT('?');
            break;
        }
    }
    out[pos] = '\0';
    return pos;
#undef SPUT
}

/* ── Kısa kstrncpy benzeri (kstring'e bağımlılıktan kaçın) ── */
static void slog_strncpy(char *dst, const char *src, int n)
{
    int i = 0;
    while (i < n - 1 && src[i]) { dst[i] = src[i]; i++; }
    dst[i] = '\0';
}

/* ================================================================ */
void syslog_init(void)
{
    slog_head  = 0;
    slog_total = 0;
    /* İlk giriş */
    klog(LOG_INFO, "SYSLOG", "Syslog tampon hazir (%d slot)", SYSLOG_MAX_ENTRIES);
}

/* ================================================================ */
void klog(uint8_t level, const char *tag, const char *fmt, ...)
{
    SyslogEntry *e;
    va_list ap;

    if (level > LOG_PANIC) level = LOG_PANIC;

    e = &slog_buf[slog_head];
    e->tick  = total_ticks;
    e->level = level;
    slog_strncpy(e->tag, tag ? tag : "??", sizeof(e->tag));

    va_start(ap, fmt);
    slog_vformat(e->msg, SYSLOG_MSG_LEN, fmt, ap);
    va_end(ap);

    slog_head = (slog_head + 1) % SYSLOG_MAX_ENTRIES;
    slog_total++;

    /* ERR ve PANIC seviyesi hemen UART'a da yaz */
    if (level >= LOG_ERROR) {
        KPRINT("[%s][%s] %s\n", level_str[level], e->tag, e->msg);
    }
}

/* ── Tek girişi UART'a yazar ──────────────────────────────── */
static void print_entry(const SyslogEntry *e)
{
    KPRINT("[T%05u][%s][%s] %s\n",
            (unsigned)e->tick,
            level_str[e->level < 5 ? e->level : 4],
            e->tag, e->msg);
}

/* ================================================================ */
void syslog_dump(void)
{
    int total = slog_total < SYSLOG_MAX_ENTRIES ? slog_total : SYSLOG_MAX_ENTRIES;
    int start;
    int i;

    KPRINT("=== SYSLOG (%d giri%c) ===\n", total, total == 1 ? 's' : 's');
    if (total == 0) return;

    /* En eski girişten başla */
    if (slog_total <= SYSLOG_MAX_ENTRIES)
        start = 0;
    else
        start = slog_head;   /* halka doldu, head = en eski */

    for (i = 0; i < total; i++) {
        int idx = (start + i) % SYSLOG_MAX_ENTRIES;
        print_entry(&slog_buf[idx]);
    }
    KPRINT("=== SYSLOG SONU ===\n");
}

/* ================================================================ */
void syslog_dump_last(int n)
{
    int total = slog_total < SYSLOG_MAX_ENTRIES ? slog_total : SYSLOG_MAX_ENTRIES;
    int start, i;

    if (n > total) n = total;
    if (n <= 0)    return;

    KPRINT("=== Son %d syslog girisi ===\n", n);
    start = ((slog_head - n) % SYSLOG_MAX_ENTRIES + SYSLOG_MAX_ENTRIES)
             % SYSLOG_MAX_ENTRIES;

    for (i = 0; i < n; i++) {
        int idx = (start + i) % SYSLOG_MAX_ENTRIES;
        print_entry(&slog_buf[idx]);
    }
}

/* ================================================================ */
void syslog_dump_level(uint8_t min_level)
{
    int total = slog_total < SYSLOG_MAX_ENTRIES ? slog_total : SYSLOG_MAX_ENTRIES;
    int start = (slog_total <= SYSLOG_MAX_ENTRIES) ? 0 : slog_head;
    int i;

    KPRINT("=== SYSLOG >= %s ===\n", level_str[min_level < 5 ? min_level : 4]);
    for (i = 0; i < total; i++) {
        int idx = (start + i) % SYSLOG_MAX_ENTRIES;
        if (slog_buf[idx].level >= min_level)
            print_entry(&slog_buf[idx]);
    }
}

/* ================================================================ */
int syslog_count(void)
{
    return slog_total < SYSLOG_MAX_ENTRIES ? slog_total : SYSLOG_MAX_ENTRIES;
}
