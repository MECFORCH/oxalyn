#ifndef GPU_H
#define GPU_H

#include <stdint.h>

typedef struct GpuDrawRequest {
    int cmd, x, y, w, h;
    uint32_t color;
} GpuDrawRequest;

/* ── Temel primitifler ──────────────────────────────────────────── */
void gpu_init(void);
void gpu_clear(uint32_t color);
void gpu_put_pixel(int x, int y, uint32_t color);
void gpu_put_pixel_alpha(int x, int y, uint32_t color);   /* RGBA alpha-blend */
void gpu_draw_line(int x1, int y1, int x2, int y2, uint32_t color);
void gpu_draw_rect(int x, int y, int w, int h, uint32_t color);
void gpu_draw_circle(int cx, int cy, int r, uint32_t color);
void gpu_fill_circle(int cx, int cy, int r, uint32_t color);
void gpu_present(void);
void gpu_save_frame_raw(const char *filename);

/* ── Genişletilmiş primitifler ──────────────────────────────────── */
void gpu_draw_rounded_rect(int x, int y, int w, int h, int r, uint32_t color);
void gpu_fill_triangle(int x0, int y0, int x1, int y1, int x2, int y2, uint32_t color);

/* ── Bitmap metin (8×8 font, scale=1..4) ───────────────────────── */
void gpu_draw_char(int x, int y, char c, uint32_t color, int scale);
void gpu_draw_string(int x, int y, const char *str, uint32_t color, int scale);

#endif /* GPU_H */
