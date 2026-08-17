/*
 * HILAL_BIS — Spinlock (Çok Çekirdek Hazırlığı)
 *
 * Tek çekirdekte no-op gibi davranır; NUM_CORES > 1 olduğunda
 * gerçek atomik LOCK XCHG / LR-SC çiftine dönüşecek.
 */

#ifndef SPINLOCK_H
#define SPINLOCK_H

#include <stdint.h>
#include "platform.h"

typedef volatile int spinlock_t;

/* Kilidi başlat (serbest) */
static inline void spin_init(spinlock_t *lock)
{
    *lock = 0;
}

/* Kilidi al — serbest olana kadar döner */
void spin_lock(spinlock_t *lock);

/* Kilidi bırak */
void spin_unlock(spinlock_t *lock);

/* Kilidi almayı dene — başarılıysa 1, değilse 0 */
int  spin_trylock(spinlock_t *lock);

/* IPI (Inter-Processor Interrupt) — gelecek çok çekirdek için iskelet */
void ipi_send(int target_core, int ipi_type);

/* IPI türleri */
#define IPI_RESCHEDULE  1   /* Hedef çekirdeği yeniden zamanlat */
#define IPI_FLUSH_TLB   2   /* TLB temizle (sanal bellek) */
#define IPI_HALT        3   /* Hedef çekirdeği durdur */

#endif /* SPINLOCK_H */
