#ifndef UART_H
#define UART_H

void uart_init(void);
void uart_putchar(char c);
char uart_getchar(void);
void uart_puts(const char *s);
void kprintf(const char *fmt, ...);

#endif /* UART_H */
