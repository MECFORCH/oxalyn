#include "kstring.h"

/* ── Memory ──────────────────────────────────────────────── */

void *kmemset(void *dst, int c, size_t n)
{
    unsigned char *p = (unsigned char *)dst;
    while (n--) *p++ = (unsigned char)c;
    return dst;
}

void *kmemcpy(void *dst, const void *src, size_t n)
{
    unsigned char       *d = (unsigned char *)dst;
    const unsigned char *s = (const unsigned char *)src;
    while (n--) *d++ = *s++;
    return dst;
}

int kmemcmp(const void *a, const void *b, size_t n)
{
    const unsigned char *pa = (const unsigned char *)a;
    const unsigned char *pb = (const unsigned char *)b;
    while (n--) {
        if (*pa != *pb) return (int)*pa - (int)*pb;
        pa++; pb++;
    }
    return 0;
}

/* ── String ──────────────────────────────────────────────── */

size_t kstrlen(const char *s)
{
    size_t n = 0;
    while (*s++) n++;
    return n;
}

char *kstrcpy(char *dst, const char *src)
{
    char *d = dst;
    while ((*d++ = *src++));
    return dst;
}

char *kstrncpy(char *dst, const char *src, size_t n)
{
    char *d = dst;
    while (n && (*d++ = *src++)) n--;
    while (n--) *d++ = '\0';   /* geri kalanı sıfırla */
    return dst;
}

int kstrcmp(const char *a, const char *b)
{
    while (*a && (*a == *b)) { a++; b++; }
    return (unsigned char)*a - (unsigned char)*b;
}

int kstrncmp(const char *a, const char *b, size_t n)
{
    size_t i;
    for (i = 0; i < n; i++) {
        if (a[i] != b[i] || a[i] == '\0')
            return (unsigned char)a[i] - (unsigned char)b[i];
    }
    return 0;
}

void *kmemmove(void *dst, const void *src, size_t n)
{
    unsigned char       *d = (unsigned char *)dst;
    const unsigned char *s = (const unsigned char *)src;
    if (d < s) {
        while (n--) *d++ = *s++;
    } else {
        d += n; s += n;
        while (n--) *--d = *--s;
    }
    return dst;
}

char *kstrchr(const char *s, int c)
{
    for (; *s; s++)
        if ((unsigned char)*s == (unsigned char)c) return (char *)s;
    return (*s == (unsigned char)c) ? (char *)s : NULL;
}
