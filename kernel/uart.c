#include "kernel.h"
#include "uart.h"
#include "platform.h"
#include <stdarg.h>

#define UART_TX_PORT   0x10
#define UART_RX_PORT   0x11
#define UART_CTRL_PORT 0x12
#define UART_STAT_PORT 0x13

/*
 * HOST TEST MODU (make host):
 *   Kernel mantığını PC'de test etmek için standart C kullanılır.
 *   Linux/Windows/macOS fark etmez — sadece putchar/getchar yeterli.
 *   Oxalyn-64'ün MMIO adresleri (0x10 vb.) burada geçerli değil,
 *   o yüzden standart terminal I/O simüle eder.
 *
 * OXALYN KERNEL MODU (make oxalyn):
 *   Tamamen bağımsız — sadece kendi MMIO registerlarını kullanır,
 *   hiçbir OS'a bağımlılık yok.
 */
#if defined(OXALYN_HOST_TEST)
/* Standart C — her platformda çalışır */
#include <stdio.h>

void uart_init(void) {}   /* terminal zaten hazır */

void uart_putchar(char c) { putchar((unsigned char)c); fflush(stdout); }

char uart_getchar(void)
{
    int c = getchar();
    return (c == EOF) ? 0 : (char)c;
}

#else /* Gerçek Oxalyn-64 donanım / CPU simülatör modu */

/* ------------------------------------------------------------------ */
void uart_init(void)
{
    MMIO_WRITE(UART_CTRL_PORT, 0x03);   /* Enable + 115200 baud */
}

/* ------------------------------------------------------------------ */
void uart_putchar(char c)
{
    MMIO_WRITE(UART_TX_PORT, (uint64_t)(unsigned char)c);
}

/* ------------------------------------------------------------------ */
char uart_getchar(void)
{
    return (char)(MMIO_READ(UART_RX_PORT) & 0xFF);
}

#endif

/* ------------------------------------------------------------------ */
void uart_puts(const char *s)
{
    while (*s)
        uart_putchar(*s++);
}

/* ------------------------------------------------------------------ */
/* Minimal printf: supports %d %u %x %s %c %% and \n -> \r\n          */
/* ------------------------------------------------------------------ */

static void print_uint(unsigned long long val, int base)
{
    static const char digits[] = "0123456789abcdef";
    char buf[64];
    int  i = 63;
    buf[i] = '\0';
    if (val == 0) { uart_putchar('0'); return; }
    while (val > 0 && i > 0) {
        buf[--i] = digits[val % (unsigned)base];
        val      /= (unsigned)base;
    }
    uart_puts(&buf[i]);
}

static void print_int(long long val)
{
    if (val < 0) { uart_putchar('-'); val = -val; }
    print_uint((unsigned long long)val, 10);
}

void kprintf(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            if (*fmt == '\n') uart_putchar('\r');
            uart_putchar(*fmt++);
            continue;
        }
        fmt++;   /* skip '%' */
        switch (*fmt) {
            case 'd': print_int((long long)va_arg(ap, int));              break;
            case 'u': print_uint((unsigned long long)va_arg(ap, unsigned int), 10); break;
            case 'x': print_uint((unsigned long long)va_arg(ap, unsigned int), 16); break;
            case 'X': print_uint((unsigned long long)va_arg(ap, unsigned int), 16); break;
            case 's': uart_puts(va_arg(ap, const char *));                break;
            case 'c': uart_putchar((char)va_arg(ap, int));                break;
            case 'l': {
                fmt++;
                if (*fmt == 'l') {
                    fmt++;
                    if (*fmt == 'd') print_int((long long)va_arg(ap, long long));
                    else             print_uint(va_arg(ap, unsigned long long), 16);
                } else if (*fmt == 'd') {
                    print_int((long long)va_arg(ap, long));
                } else {
                    print_uint(va_arg(ap, unsigned long), 16);
                }
                break;
            }
            case '%': uart_putchar('%'); break;
            default:  uart_putchar('%'); uart_putchar(*fmt); break;
        }
        fmt++;
    }
    va_end(ap);
}
