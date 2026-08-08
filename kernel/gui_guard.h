#ifndef GUI_GUARD_H
#define GUI_GUARD_H

#include <stddef.h>
#include <stdint.h>
#include "gpu.h"

/*
 * GUI, kernel'in devam edebilmesi için güvenilmeyen bir istemci gibi ele
 * edilir. Geçersiz veya aşırı pahalı istekler GUI'yi karantinaya alır;
 * kernel panic yapmaz.
 */
#define GUI_FAULT_LIMIT          3u
#define GUI_MAX_OPS              4096u
#define GUI_MAX_PIXELS           ((uint64_t)FB_WIDTH * (uint64_t)FB_HEIGHT * 4u)
#define GUI_FAULT_DISABLED       (-1)
#define GUI_FAULT_INVALID        (-2)
#define GUI_FAULT_BUDGET         (-3)

struct Process;

int  gui_user_buffer_valid(const void *buffer, size_t size);
void gui_guard_init(struct Process *process);
int  gui_guard_admit(struct Process *process,
                     const GpuDrawRequest *request,
                     uint64_t *estimated_pixels);
int  gui_guard_admit_pixels(struct Process *process, uint64_t pixels);
void gui_guard_record_fault(struct Process *process, const char *reason);
void gui_guard_reset(struct Process *process);
int  gui_guard_enabled(const struct Process *process);

#endif /* GUI_GUARD_H */