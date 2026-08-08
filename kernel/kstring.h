#ifndef KSTRING_H
#define KSTRING_H

/* Freestanding string + memory yardımcıları
 * libc gerekmez — kernel içinde kullanılır.
 */

#include "types.h"
#include <stddef.h>

/* Memory */
void  *kmemset (void *dst, int c,   size_t n);
void  *kmemcpy (void *dst, const void *src, size_t n);
void  *kmemmove(void *dst, const void *src, size_t n);
int    kmemcmp (const void *a, const void *b, size_t n);

/* String */
size_t kstrlen (const char *s);
char  *kstrcpy (char *dst, const char *src);
char  *kstrncpy(char *dst, const char *src, size_t n);
int    kstrcmp (const char *a, const char *b);
int    kstrncmp(const char *a, const char *b, size_t n);
char  *kstrchr (const char *s, int c);

/* libc isimlerini yeniden yönlendir (kernel.c / shell.c / scheduler.c kullanımı için) */
#define memset   kmemset
#define memcpy   kmemcpy
#define memmove  kmemmove
#define memcmp   kmemcmp
#define strlen   kstrlen
#define strcpy   kstrcpy
#define strncpy  kstrncpy
#define strcmp   kstrcmp
#define strncmp  kstrncmp
#define strchr   kstrchr

#endif /* KSTRING_H */
