#ifndef WM_H
#define WM_H

#include <stdint.h>
#include "kernel.h"

#define THEME_GREEN 0
#define THEME_BLUE  1
#define THEME_DARK  2

void wm_init(void);
void desktop_welcome_screen(void);
int  wm_create_window(int x, int y, int w, int h, const char *title);
void wm_close_window(int idx);
void wm_minimize_window(int idx);
void wm_render(void);
/* Bir zamanlayıcı/HID tick'inde input'u WM'e aktar ve gerekiyorsa çiz. */
void wm_run(void);
void draw_window_frame(Window *win);
void draw_taskbar(void);
int  wm_click(int x, int y);
void wm_set_theme(int theme);

/* Mouse olaylarını WM'e ilet (sürükleme + boyutlandırma) */
void wm_mouse_event(int x, int y, int buttons);

#endif /* WM_H */
