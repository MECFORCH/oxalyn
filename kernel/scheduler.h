#ifndef SCHEDULER_H
#define SCHEDULER_H

#include "kernel.h"

void scheduler_init(void);
void scheduler(void);
void scheduler_run(void);
void context_switch(int from_pid, int to_pid);
int  process_create(void (*entry)(void), int priority);
void process_kill(int pid);
int  get_current_pid(void);
void process_run_now(int pid);

#endif /* SCHEDULER_H */
