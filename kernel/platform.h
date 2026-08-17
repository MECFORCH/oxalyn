/*
 * HILAL_BIS — Platform Soyutlama Katmanı
 *
 * Tüm platform farkları burada toplanır. Sürücüler doğrudan
 * #ifdef OXALYN_HOST_TEST / OXALYN_KERNEL yazmak yerine bu
 * makroları çağırır.
 *
 * Desteklenen platformlar:
 *   OXALYN_HOST_TEST  — PC'de çalışan test binary'si (Linux/Windows/macOS)
 *   OXALYN_SIMULATOR  — Oxalyn-64 simülatörüyle birlikte derlenen kernel
 *   OXALYN_KERNEL     — Gerçek donanım (freestanding)
 */

#ifndef PLATFORM_H
#define PLATFORM_H

#include <stdint.h>
#include <stddef.h>
#include "mmio.h"        /* mmio_read() / mmio_write() — her platformda çalışır */

/* ── MMIO Erişim Makroları ───────────────────────────────────────────
 * Tüm sürücüler volatile pointer yerine bu makroları kullanmalı.     */
#define MMIO_READ(addr)      mmio_read((uint32_t)(addr))
#define MMIO_WRITE(addr, v)  mmio_write((uint32_t)(addr), (uint64_t)(v))

/* ── Çıktı / UART ────────────────────────────────────────────────── */
#ifdef OXALYN_HOST_TEST
#  include <stdio.h>
#  include "hostio.h"                /* oxalyn_printf bildirimi */
#  define KPRINT(...)   oxalyn_printf(__VA_ARGS__)
#  define KPUTCHAR(c)   do { putchar(c); fflush(stdout); } while(0)
#  define KGETCHAR()    getchar()
#else
   /* Gerçek kernel veya simülatör: kprintf / uart_* */
   void kprintf(const char *fmt, ...);
   void uart_putchar(char c);
   char uart_getchar(void);
#  define KPRINT(...)   kprintf(__VA_ARGS__)
#  define KPUTCHAR(c)   uart_putchar(c)
#  define KGETCHAR()    uart_getchar()
#endif

/* ── Framebuffer ─────────────────────────────────────────────────── */
/*
 * GPU modülü platforma uygun framebuffer'ı sağlar:
 *   simulator: sim.c framebuffer'ı
 *   host test: yerel tampon
 *   hardware: FB_ADDR MMIO alanı
 */
volatile uint32_t *platform_framebuffer(void);

/* ── Panik ───────────────────────────────────────────────────────── */
#ifdef OXALYN_HOST_TEST
#  include <stdlib.h>
#  define KPANIC(msg) \
      do { oxalyn_printf("\n[PANIC] %s\n[PANIC] System halted.\n", (msg)); \
           exit(1); } while(0)
#else
   void panic(const char *msg);
#  define KPANIC(msg)  panic(msg)
#endif

/* ── Bellek Bariyeri ─────────────────────────────────────────────── */
#if defined(OXALYN_HOST_TEST) || defined(OXALYN_WASM)
#  define MEMORY_BARRIER()  do { } while(0)  /* host'ta gerçek barrier yok */
#else
#  define MEMORY_BARRIER()  __asm__ volatile("fence" ::: "memory")
#endif

/* ── Atomik İşlemler (spinlock için) ─────────────────────────────── */
#ifdef OXALYN_HOST_TEST
#  ifdef __GNUC__
#    define ATOMIC_CAS(ptr, expected, desired) \
         __sync_bool_compare_and_swap((ptr), (expected), (desired))
#    define ATOMIC_STORE(ptr, val) \
         do { __sync_lock_release(ptr); (void)(val); *(ptr) = (val); } while(0)
#  else
#    define ATOMIC_CAS(ptr, expected, desired)  (*(ptr) == (expected) ? (*(ptr) = (desired), 1) : 0)
#    define ATOMIC_STORE(ptr, val)              do { *(ptr) = (val); } while(0)
#  endif
#else
   /* Gerçek donanım: LOCK XCHG benzeri atomik (ISA'ya eklenecek) */
#  define ATOMIC_CAS(ptr, expected, desired)  (*(ptr) == (expected) ? (*(ptr) = (desired), 1) : 0)
#  define ATOMIC_STORE(ptr, val)              do { *(ptr) = (val); } while(0)
#endif

/* ── Core ID (çok çekirdek hazırlığı) ───────────────────────────── */
#ifdef OXALYN_HOST_TEST
#  define PLATFORM_CORE_ID()  0   /* host'ta tek çekirdek */
#else
   /* Gerçek donanım: CSR[CORE_ID] okunacak (ISA genişlemesi) */
#  define PLATFORM_CORE_ID()  0
#endif

#endif /* PLATFORM_H */
