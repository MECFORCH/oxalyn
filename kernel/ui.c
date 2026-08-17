#include "kernel.h"
#include "ui.h"
#include "gpu.h"

/* ------------------------------------------------------------------ */
/* FAZ 1.2 — Hilal (crescent) logo.
 *
 * The original roadmap sketch used sin()/cos() to rotate a crescent.
 * This kernel is freestanding (-nostdlib, no libm), so trig functions
 * are not available. Instead we draw the crescent the way real pixel
 * art does it: a filled circle with a second, offset filled circle
 * "cut out" of it using the background colour. No floating point or
 * libm dependency required.
 * ------------------------------------------------------------------ */
void ui_draw_crescent(int cx, int cy, int r, uint32_t color)
{
    int offset = r / 3;     /* shift of the cutout circle -> crescent shape  */
    int cut_r  = (r * 85) / 100;

    gpu_fill_circle(cx, cy, r, color);
    gpu_fill_circle(cx + offset, cy - (r / 10), cut_r, 0xFF001A33 /* bg */);
}

/* ------------------------------------------------------------------ */
/* FAZ 1.2 — Splash screen                                              */
/* ------------------------------------------------------------------ */
void ui_boot_splash(void)
{
    gpu_clear(0xFF001A33);                      /* dark blue background   */
    ui_draw_crescent(400, 220, 90, 0xFF00FF00); /* green hilal, tilted look */

    printf("\n");
    printf("+======================================+\n");
    printf("|        HILAL_BIS v1.0  (Oxalyn-64)    |\n");
    printf("+======================================+\n");
    printf("[*] Initializing kernel subsystems...\n");
    gpu_present();
}

/* ------------------------------------------------------------------ */
/* FAZ 2.2 — Animated loading bar (UART text bar + GPU bar)             */
/* ------------------------------------------------------------------ */
void ui_loading_bar(const char *task, int percent)
{
    int bars = (percent * 30) / 100;
    int i;

    if (percent > 100) percent = 100;
    if (percent < 0)   percent = 0;

    printf("\r[");
    for (i = 0; i < 30; i++) {
        if (i < bars) printf("#");
        else          printf(".");
    }
    printf("] %d%% %s\n", percent, task);

    /* GPU: green progress bar under the crescent */
    gpu_draw_rect(200, 340, 400, 20, 0xFF222233);            /* track */
    gpu_draw_rect(200, 340, (percent * 400) / 100, 20, 0xFF00FF00); /* fill */
    gpu_present();
}
