/*
 * HILAL_BIS — Ham Linux Sistem Çağrısı Dosya G/Ç
 *
 * Kernel nostdlib ile derleniyor, bu yüzden fopen/fread/fclose yok.
 * Bu başlık, simülatör (host gcc) modunda doğrudan syscall ile
 * minimal dosya G/Ç sağlar. Donanım modunda tüm fonksiyonlar no-op döner.
 */

#ifndef HOSTIO_H
#define HOSTIO_H

#include <stdint.h>
#include <stddef.h>

#if defined(OXALYN_HOST_TEST)
#define HOSTIO_AVAILABLE 1
#else
#define HOSTIO_AVAILABLE 0
#endif

/* H4: Stdout'u her printf sonrası flush eden sarıcı.
 * Pipe/dosyaya yönlendirilmiş stdout fully-buffered olur; bu wrapper
 * her çağrıda fflush(stdout) yaparak çıktının kaybolmamasını sağlar. */
#if defined(OXALYN_HOST_TEST)
#include <stdarg.h>
int oxalyn_printf(const char *fmt, ...);
#endif

/* ── Modlar ── */
#define HOSTIO_O_RDONLY  0
#define HOSTIO_O_WRONLY  1
#define HOSTIO_O_RDWR    2
#define HOSTIO_O_CREAT   0100   /* octal */
#define HOSTIO_O_TRUNC   01000
#define HOSTIO_O_APPEND  02000

/* ── API ── */
int    hostio_open (const char *path, int flags, int mode);
void   hostio_close(int fd);
long   hostio_read (int fd, void *buf, size_t n);
long   hostio_write(int fd, const void *buf, size_t n);
long   hostio_lseek(int fd, long offset, int whence);

#endif /* HOSTIO_H */
