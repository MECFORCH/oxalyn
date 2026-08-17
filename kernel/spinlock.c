/*
 * HILAL_BIS — Spinlock Implementasyonu
 *
 * Tek çekirdek için basit (cooperative) uygulama.
 * Çok çekirdek hazırlığı: ATOMIC_CAS makrosu platform.h'dan gelir.
 * Gerçek donanımda LOCK XCHG / LR-SC çiftiyle değiştirilmeli.
 */

#include "spinlock.h"
#include "kernel.h"
#include "smp.h"

/* ------------------------------------------------------------------ */
void spin_lock(spinlock_t *lock)
{
    /* Çok çekirdek: CAS döngüsü ile bekle */
    while (!ATOMIC_CAS(lock, 0, 1)) {
        /* Tek çekirdekte bu döngü asla beklemez (lock zaten 0).
         * Çok çekirdekte diğer core lock'u bırakana kadar döner.
         * WFI / yield eklenebilir ama spinlock'ta pahalı. */
    }
    MEMORY_BARRIER();
}

/* ------------------------------------------------------------------ */
void spin_unlock(spinlock_t *lock)
{
    MEMORY_BARRIER();
    ATOMIC_STORE(lock, 0);
}

/* ------------------------------------------------------------------ */
int spin_trylock(spinlock_t *lock)
{
    return ATOMIC_CAS(lock, 0, 1);
}

/* ------------------------------------------------------------------ */
/* IPI — gelecekte Oxalyn MMIO veya özel CSR ile implemente edilecek.
 * Şimdilik sadece kütük (log) yazar.                                  */
void ipi_send(int target_core, int ipi_type)
{
    smp_send_ipi((uint32_t)target_core, (uint32_t)ipi_type);
}
