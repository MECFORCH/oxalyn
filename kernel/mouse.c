#include "kernel.h"
#include "mouse.h"
#include "gpu.h"

Mouse mouse;

/* ------------------------------------------------------------------ */
void mouse_init(void)
{
    mouse.x       = FB_WIDTH  / 2;
    mouse.y       = FB_HEIGHT / 2;
    mouse.buttons = 0;
    mouse.moved   = 0;
    mouse.changed = 0;
}

/* ------------------------------------------------------------------ */
void mouse_move(int dx, int dy)
{
    mouse.x += dx;
    mouse.y += dy;
    if (mouse.x < 0) mouse.x = 0;
    if (mouse.x >= FB_WIDTH)  mouse.x = FB_WIDTH  - 1;
    if (mouse.y < 0) mouse.y = 0;
    if (mouse.y >= FB_HEIGHT) mouse.y = FB_HEIGHT - 1;
    mouse.moved = 1;
    mouse.changed = 1;
}

/* ------------------------------------------------------------------ */
void mouse_button(int button, int pressed)
{
    if (pressed) mouse.buttons |=  (1 << button);
    else         mouse.buttons &= ~(1 << button);
    mouse.changed = 1;
}

/* ------------------------------------------------------------------ */
void draw_cursor(void)
{
    gpu_draw_line(mouse.x, mouse.y, mouse.x + 10, mouse.y + 5,  0xFFFFFFFF);
    gpu_draw_line(mouse.x, mouse.y, mouse.x + 5,  mouse.y + 10, 0xFFFFFFFF);
    gpu_draw_line(mouse.x + 5, mouse.y + 10, mouse.x + 10, mouse.y + 5, 0xFFFFFFFF);
}
