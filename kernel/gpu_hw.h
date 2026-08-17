/*
 * HILAL_BIS — Gravityon GPU ring-buffer backend
 *
 * The kernel's local 2D command API deliberately does not share the
 * userspace/kernel GpuCmd layout with Gravityon's wire protocol.  This
 * module is the explicit adapter between the two.
 */
#ifndef KERNEL_GPU_HW_H
#define KERNEL_GPU_HW_H

#include <stdint.h>

void gpu_hw_init(void);
int  gpu_hw_available(void);
void gpu_hw_set_owner(uint32_t pid);

void gpu_hw_clear(uint32_t color);
void gpu_hw_pixel(int x, int y, uint32_t color);
void gpu_hw_line(int x1, int y1, int x2, int y2, uint32_t color);
void gpu_hw_rect(int x, int y, int w, int h, uint32_t color);
void gpu_hw_circle(int cx, int cy, int r, uint32_t color);
void gpu_hw_fill_circle(int cx, int cy, int r, uint32_t color);
void gpu_hw_present(void);

#endif /* KERNEL_GPU_HW_H */