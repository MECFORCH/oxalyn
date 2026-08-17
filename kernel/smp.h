#ifndef SMP_H
#define SMP_H

#include <stdint.h>

/*
 * SMP control plane.
 *
 * The current RTL/simulator executes one CPU instance by default. Building
 * with -DOXALYN_SMP_CORES=N enables N logical cores in the kernel scheduler
 * control plane; the public API is also usable by a future hardware backend.
 */
#ifndef OXALYN_SMP_CORES
#define OXALYN_SMP_CORES 1
#endif

#define SMP_MAX_CORES 32u
#define SMP_IPI_RESCHEDULE 1u
#define SMP_IPI_FLUSH_TLB  2u
#define SMP_IPI_HALT       3u

typedef struct {
    uint32_t id;
    uint32_t online;
    uint32_t current_pid;
    uint32_t load;
    uint32_t ipi_pending;
    uint32_t context_switches;
} SmpCoreInfo;

typedef struct {
    uint32_t configured_cores;
    uint32_t online_cores;
    uint32_t dispatches;
    uint32_t migrations;
    uint32_t ipis_sent;
    uint32_t ipis_handled;
} SmpStats;

void     smp_init(uint32_t requested_cores);
uint32_t smp_online_count(void);
uint32_t smp_online_mask(void);
int      smp_core_online(uint32_t core);
int      smp_current_core(void);
int      smp_set_current_core(uint32_t core);
int      smp_pick_core(uint32_t affinity_mask);
void     smp_dispatch(uint32_t core, uint32_t pid);
void     smp_account_tick(uint32_t core);
void     smp_send_ipi(uint32_t target_core, uint32_t type);
uint32_t smp_handle_ipi(uint32_t core);
int      smp_get_core_info(uint32_t core, SmpCoreInfo *out);
void     smp_get_stats(SmpStats *out);

#endif /* SMP_H */