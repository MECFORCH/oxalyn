/*
 * HILAL_BIS — Platform-Agnostik Host Dosya G/Ç
 *
 * HOST TEST MODU (OXALYN_HOST_TEST):
 *   Standart C stdio kullanır — Linux, Windows, macOS hepsinde çalışır.
 *
 * OXALYN KERNEL MODU:
 *   Gerçek donanımda EEPROM MMIO kullanılır, bu fonksiyonlar çağrılmaz.
 */

#include "hostio.h"

#if defined(OXALYN_HOST_TEST)
#include <stdio.h>
#include <stdarg.h>

/* H4: Her printf çağrısından sonra stdout'u flush et.
 * Stdout pipe'a yönlendirildiğinde fully-buffered olur; process bitmeden
 * hiçbir çıktı görünmez. Bu wrapper fflush(stdout) ile bunu önler. */
int oxalyn_printf(const char *fmt, ...)
{
    va_list ap;
    int r;
    va_start(ap, fmt);
    r = vprintf(fmt, ap);
    va_end(ap);
    fflush(stdout);
    return r;
}


/* ── FILE* handle tablosu (0-2 stdin/out/err için ayrılmış) ── */
static FILE *handle_table[8];

static int hostio_register(FILE *f)
{
    int i;
    for (i = 0; i < 8; i++) {
        if (!handle_table[i]) { handle_table[i] = f; return i + 3; }
    }
    fclose(f);
    return -1;
}

static FILE *get_file(int fd)
{
    int idx = fd - 3;
    if (idx < 0 || idx >= 8) return NULL;
    return handle_table[idx];
}

/* ── Genel API ── */

int hostio_open(const char *path, int flags, int mode)
{
    const char *fmode;
    FILE *f;
    (void)mode;

    if (flags & HOSTIO_O_WRONLY)
        fmode = (flags & HOSTIO_O_APPEND) ? "ab" : "wb";
    else if (flags & HOSTIO_O_RDWR)
        fmode = "r+b";
    else
        fmode = "rb";

    f = fopen(path, fmode);
    if (!f && (flags & HOSTIO_O_CREAT)) {
        /* dosya yoksa oluştur */
        f = fopen(path, "wb");
        if (f) { fclose(f); f = fopen(path, "r+b"); }
    }
    if (!f) return -1;
    return hostio_register(f);
}

void hostio_close(int fd)
{
    FILE *f = get_file(fd);
    if (!f) return;
    fclose(f);
    handle_table[fd - 3] = NULL;
}

long hostio_read(int fd, void *buf, size_t n)
{
    FILE *f = get_file(fd);
    if (!f) return -1;
    return (long)fread(buf, 1, n, f);
}

long hostio_write(int fd, const void *buf, size_t n)
{
    FILE *f = get_file(fd);
    if (!f) return -1;
    return (long)fwrite(buf, 1, n, f);
}

long hostio_lseek(int fd, long offset, int whence)
{
    FILE *f = get_file(fd);
    if (!f) return -1;
    if (fseek(f, offset, whence) != 0) return -1;
    return ftell(f);
}

#else /* ── Oxalyn kernel modu — MMIO, bu stub'lar çağrılmaz ── */

int  hostio_open (const char *p, int f, int m) { (void)p;(void)f;(void)m; return -1; }
void hostio_close(int fd)                       { (void)fd; }
long hostio_read (int fd, void *b, size_t n)    { (void)fd;(void)b;(void)n; return -1; }
long hostio_write(int fd,const void*b,size_t n) { (void)fd;(void)b;(void)n; return -1; }
long hostio_lseek(int fd, long o, int w)        { (void)fd;(void)o;(void)w; return -1; }

#endif
