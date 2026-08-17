/*
 * HILAL_BIS — Platform-Agnostik MMIO Erişim Katmanı
 *
 * OXALYN_HOST_TEST modunda düşük adresler (0x00-0xFF) host process'inde
 * eşleşmemiş bellektir → segfault/access violation.
 * Bu başlık, tüm MMIO erişimlerini sahte bir dizi üzerinden yapar.
 *
 * Kullanım: MMIO kullanan her sürücü bu başlığı include eder ve
 * doğrudan volatile pointer yerine mmio_read() / mmio_write() çağırır.
 */

#ifndef MMIO_H
#define MMIO_H

#include <stdint.h>

#ifdef OXALYN_HOST_TEST

/* Her çeviri biriminde bağımsız sahte register alanı (file-local) */
static uint64_t _host_mmio_regs[256];

static inline uint64_t mmio_read(uint32_t addr)
{
    return _host_mmio_regs[addr & 0xFFu];
}

static inline void mmio_write(uint32_t addr, uint64_t v)
{
    _host_mmio_regs[addr & 0xFFu] = v;
}

#elif defined(OXALYN_WASM)

/*
 * WASM linear memory is byte-addressed, while the Oxalyn kernel ABI exposes
 * 64-bit MMIO registers at port numbers.  Keep the two address spaces
 * separate so an i64 store to port N cannot become eight unrelated RAM
 * writes (or overlap the kernel's linear-memory data).
 */
#define OXALYN_WASM_MMIO_BASE 0x10000u

static inline uint64_t mmio_read(uint32_t addr)
{
    return *(volatile uint64_t *)(uintptr_t)
        (OXALYN_WASM_MMIO_BASE + (addr & 0xFFu) * 8u);
}

static inline void mmio_write(uint32_t addr, uint64_t v)
{
    *(volatile uint64_t *)(uintptr_t)
        (OXALYN_WASM_MMIO_BASE + (addr & 0xFFu) * 8u) = v;
}

#else /* Gerçek Oxalyn donanımı / simülatör — doğrudan MMIO */

static inline uint64_t mmio_read(uint32_t addr)
{
    return *(volatile uint64_t *)(uintptr_t)addr;
}

static inline void mmio_write(uint32_t addr, uint64_t v)
{
    *(volatile uint64_t *)(uintptr_t)addr = v;
}

#endif /* OXALYN_HOST_TEST */

#endif /* MMIO_H */
