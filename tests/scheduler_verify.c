#include "../kernel/kernel.h"
#include "../kernel/scheduler.h"
#include <stdio.h>
#include <stdlib.h>

Process process_table[MAX_PROCESSES];
int current_pid = 0;
uint32_t context_switches = 0;

static void task_a(void) {}
static void task_b(void) {}

static void check(int condition, const char *message)
{
    if (!condition) {
        fprintf(stderr, "FAIL: %s\n", message);
        exit(1);
    }
}

int main(void)
{
    int a;
    int b;

    scheduler_init();
    a = process_create(task_a, 2);
    b = process_create(task_b, 7);
    check(a >= 0 && b >= 0, "process creation");
    check(process_table[a].state == PROC_READY, "task A ready");
    check(process_table[b].state == PROC_READY, "task B ready");
    check(process_table[a].regs[31] == 0x4000u + (uint32_t)(a * 0x400),
          "task A stack context initialized");
    check(process_table[b].regs[31] == 0x4000u + (uint32_t)(b * 0x400),
          "task B stack context initialized");

    process_table[a].regs[4] = 0xA4A4u;
    process_table[b].regs[4] = 0xB4B4u;
    current_pid = a;
    process_table[a].state = PROC_RUNNING;
    scheduler();
    check(current_pid == b, "highest-priority task selected");
    check(process_table[a].regs[4] == 0xA4A4u &&
          process_table[b].regs[4] == 0xB4B4u,
          "register context preserved after switch");
    check(process_table[a].state == PROC_READY &&
          process_table[b].state == PROC_RUNNING,
          "process states switched");

    context_switch(b, a);
    check(current_pid == a && process_table[a].state == PROC_RUNNING &&
          process_table[b].state == PROC_READY,
          "reverse context switch");
    printf("PASS: scheduler priority, state and context preserve\n");
    return 0;
}