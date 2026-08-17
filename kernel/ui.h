#ifndef UI_H
#define UI_H

#include <stdint.h>

/* FAZ 1.2 / 2.2 — Splash screen + animated loading bar */
void ui_draw_crescent(int cx, int cy, int r, uint32_t color);
void ui_boot_splash(void);
void ui_loading_bar(const char *task, int percent);

#endif /* UI_H */
