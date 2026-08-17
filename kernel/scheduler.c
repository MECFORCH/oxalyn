#include "kernel.h"
#include "scheduler.h"
#include "gui_guard.h"

extern Process  process_table[MAX_PROCESSES];
extern int      current_pid;
extern uint32_t context_switches;

/* ------------------------------------------------------------------ */
/* INIT                                                                 */
/* ------------------------------------------------------------------ */
void scheduler_init(void)
{
    int i;
    for (i = 0; i < MAX_PROCESSES; i++) {
        process_table[i].state      = PROC_FREE;
        process_table[i].priority   = 4;
        process_table[i].stack_base = 0x4000u + (uint32_t)(i * 0x400);
        gui_guard_init(&process_table[i]);
    }
}

/* ------------------------------------------------------------------ */
/* PICK NEXT PROCESS                                                    */
/* ------------------------------------------------------------------ */
void scheduler(void)
{
    int i;
    int next_pid     = current_pid;
    int best_priority = -1;

    /* Find highest-priority READY process */
    for (i = 0; i < MAX_PROCESSES; i++) {
        if (process_table[i].state == PROC_READY) {
            if ((int)process_table[i].priority > best_priority) {
                best_priority = (int)process_table[i].priority;
                next_pid      = i;
            }
        }
    }

    /* No READY process — unblock first BLOCKED process */
    if (best_priority < 0) {
        for (i = 0; i < MAX_PROCESSES; i++) {
            if (process_table[i].state == PROC_BLOCKED) {
                process_table[i].state = PROC_READY;
                next_pid = i;
                break;
            }
        }
    }

    if (next_pid != current_pid) {
        context_switch(current_pid, next_pid);
    }
}

/* ------------------------------------------------------------------ */
/* CONTEXT SWITCH                                                       */
/* ------------------------------------------------------------------ */
void context_switch(int from_pid, int to_pid)
{
    if (from_pid >= 0 && from_pid < MAX_PROCESSES &&
        process_table[from_pid].state == PROC_RUNNING)
    {
        process_table[from_pid].state = PROC_READY;
    }

    process_table[to_pid].state = PROC_RUNNING;
    current_pid = to_pid;
    context_switches++;

    /* In real hardware the trap handler restores registers and
       jumps to process_table[to_pid].pc.  In the simulator the
       scheduler loop drives execution, so this is sufficient. */
}

/* ------------------------------------------------------------------ */
/* SCHEDULER LOOP (never returns)                                       */
/* ------------------------------------------------------------------ */
void scheduler_run(void)
{
    while (1) {
        scheduler();
    }
}

/* ------------------------------------------------------------------ */
/* PROCESS CREATE                                                       */
/* ------------------------------------------------------------------ */
int process_create(void (*entry)(void), int priority)
{
    int i, pid = -1;
    uint32_t stack_base;

    for (i = 0; i < MAX_PROCESSES; i++) {
        if (process_table[i].state == PROC_FREE) {
            pid = i;
            break;
        }
    }
    if (pid < 0) return -1;

    stack_base = 0x4000u + (uint32_t)(pid * 0x400);
    memset(&process_table[pid], 0, sizeof(Process));
    process_table[pid].state           = PROC_READY;
    process_table[pid].priority        = (uint32_t)priority;
    process_table[pid].stack_base      = stack_base;
    process_table[pid].pc              = (uint32_t)(uintptr_t)entry;
    process_table[pid].entry_fn        = entry;
    process_table[pid].regs[31]        = stack_base;
    process_table[pid].ticks_remaining = TIMER_QUANTUM;
    gui_guard_init(&process_table[pid]);

    return pid;
}

/* ------------------------------------------------------------------ */
/* HOST DEV-BUILD DISPATCH
 *
 * Honesty note: on real Oxalyn-64 hardware, scheduling is driven by the
 * timer IRQ + trap handler (trap.asm), which saves/restores R0-R31 and
 * jumps to process_table[pid].pc via ERET — scheduler_run()'s infinite
 * loop above is correct there because the *hardware* performs the jump.
 *
 * When this kernel is instead compiled with host gcc for local
 * development (OXALYN_SIMULATOR), there is no real timer interrupt and
 * no ERET, so nothing would ever call the process's code. process_run_now()
 * calls the entry function pointer directly. This makes dispatch
 * cooperative and run-to-completion on host — a documented
 * simplification for interactive testing, not a claim of real hardware
 * preemptive concurrency (that remains the Oxalyn CPU + trap.asm's job).
 * ------------------------------------------------------------------ */
void process_run_now(int pid)
{
    if (pid < 0 || pid >= MAX_PROCESSES) return;
    if (!process_table[pid].entry_fn)    return;

    process_table[pid].state = PROC_RUNNING;
    current_pid = pid;
    context_switches++;

    process_table[pid].entry_fn();   /* runs to completion, or sys_exit()s */

    if (process_table[pid].state != PROC_FREE)
        process_table[pid].state = PROC_FREE;
}

/* ------------------------------------------------------------------ */
/* PROCESS KILL                                                         */
/* ------------------------------------------------------------------ */
void process_kill(int pid)
{
    if (pid >= 0 && pid < MAX_PROCESSES) {
        process_table[pid].state = PROC_FREE;
    }
}

/* ------------------------------------------------------------------ */
/* GET CURRENT PID                                                      */
/* ------------------------------------------------------------------ */
int get_current_pid(void)
{
    return current_pid;
}
