#include "smp.h"
#include "platform.h"

#if OXALYN_SMP_CORES < 1
#error "OXALYN_SMP_CORES must be at least 1"
#endif

#if OXALYN_SMP_CORES > SMP_MAX_CORES
#error "OXALYN_SMP_CORES exceeds SMP_MAX_CORES"
#endif

static SmpCoreInfo cores[SMP_MAX_CORES];
static SmpStats stats;
static uint32_t active_cores;

#ifdef OXALYN_HOST_TEST
static int active_core;
#else
static int active_core;
#endif

static uint32_t valid_mask(void)
{
    if (active_cores >= 32u) return 0xFFFFFFFFu;
    return active_cores == 0u ? 0u : ((1u << active_cores) - 1u);
}

void smp_init(uint32_t requested_cores)
{
    uint32_t i;

    active_cores = requested_cores;
    if (active_cores == 0u) active_cores = 1u;
    if (active_cores > OXALYN_SMP_CORES)
        active_cores = OXALYN_SMP_CORES;
    if (active_cores > SMP_MAX_CORES)
        active_cores = SMP_MAX_CORES;

    stats.configured_cores = OXALYN_SMP_CORES;
    stats.online_cores = active_cores;
    stats.dispatches = 0;
    stats.migrations = 0;
    stats.ipis_sent = 0;
    stats.ipis_handled = 0;
    active_core = 0;

    for (i = 0; i < SMP_MAX_CORES; i++) {
        cores[i].id = i;
        cores[i].online = i < active_cores ? 1u : 0u;
        cores[i].current_pid = 0u;
        cores[i].load = 0u;
        cores[i].ipi_pending = 0u;
        cores[i].context_switches = 0u;
    }
}

uint32_t smp_online_count(void)
{
    return active_cores;
}

uint32_t smp_online_mask(void)
{
    return valid_mask();
}

int smp_core_online(uint32_t core)
{
    return core < active_cores && cores[core].online != 0u;
}

int smp_current_core(void)
{
    return active_core;
}

int smp_set_current_core(uint32_t core)
{
    if (!smp_core_online(core)) return -1;
    active_core = (int)core;
    return 0;
}

int smp_pick_core(uint32_t affinity_mask)
{
    uint32_t i;
    uint32_t mask = affinity_mask & valid_mask();
    uint32_t best = SMP_MAX_CORES;
    uint32_t best_load = 0xFFFFFFFFu;

    if (mask == 0u) return -1;
    for (i = 0; i < active_cores; i++) {
        if ((mask & (1u << i)) == 0u) continue;
        if (cores[i].load < best_load) {
            best = i;
            best_load = cores[i].load;
        }
    }
    return best == SMP_MAX_CORES ? -1 : (int)best;
}

void smp_dispatch(uint32_t core, uint32_t pid)
{
    if (!smp_core_online(core)) return;
    if (cores[core].current_pid != pid)
        stats.migrations++;
    cores[core].current_pid = pid;
    cores[core].context_switches++;
    cores[core].load++;
    stats.dispatches++;
}

void smp_account_tick(uint32_t core)
{
    if (!smp_core_online(core)) return;
    if (cores[core].load > 0u) cores[core].load--;
}

void smp_send_ipi(uint32_t target_core, uint32_t type)
{
    if (!smp_core_online(target_core) || type == 0u || type > 31u)
        return;
    cores[target_core].ipi_pending |= 1u << (type - 1u);
    stats.ipis_sent++;
}

uint32_t smp_handle_ipi(uint32_t core)
{
    uint32_t pending;
    if (!smp_core_online(core)) return 0u;
    pending = cores[core].ipi_pending;
    cores[core].ipi_pending = 0u;
    if (pending != 0u) stats.ipis_handled++;
    return pending;
}

int smp_get_core_info(uint32_t core, SmpCoreInfo *out)
{
    if (!out || !smp_core_online(core)) return -1;
    *out = cores[core];
    return 0;
}

void smp_get_stats(SmpStats *out)
{
    if (!out) return;
    *out = stats;
}