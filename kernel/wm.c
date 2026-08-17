#include "kernel.h"
#include "wm.h"
#include "gpu.h"
#include "mouse.h"
#include "ui.h"

static Window windows[MAX_WINDOWS];
static int    window_count  = 0;
static int    focused_win   = -1;
static int    current_theme = THEME_GREEN;

static uint32_t theme_accent(void)
{
    switch (current_theme) {
        case THEME_BLUE: return 0xFF2277FF;
        case THEME_DARK: return 0xFF444444;
        default:         return 0xFF00CC66; /* green */
    }
}

/* ------------------------------------------------------------------ */
void wm_init(void)
{
    int i;
    for (i = 0; i < MAX_WINDOWS; i++) windows[i].active = 0;
    window_count  = 0;
    focused_win   = -1;
    current_theme = THEME_GREEN;
    printf("[WM] Window manager ready (%d slots)\n", MAX_WINDOWS);
}

/* ------------------------------------------------------------------ */
/* FAZ 3 — desktop welcome screen shown once, right after boot          */
/* ------------------------------------------------------------------ */
void desktop_welcome_screen(void)
{
    gpu_clear(0xFF102040);
    ui_draw_crescent(400, 150, 60, theme_accent());
    gpu_draw_rect(150, 250, 500, 80, 0xFF203050);
    printf("\n");
    printf("+======================================+\n");
    printf("|     HILAL_BIS masaustune hosgeldiniz   |\n");
    printf("+======================================+\n");
    draw_taskbar();
    gpu_present();
}

/* ------------------------------------------------------------------ */
int wm_create_window(int x, int y, int w, int h, const char *title)
{
    int i;
    for (i = 0; i < MAX_WINDOWS; i++) {
        if (!windows[i].active) {
            windows[i].x     = x;
            windows[i].y     = y;
            windows[i].w     = w;
            windows[i].h     = h;
            windows[i].bg_color   = 0xFFEEEEEE;
            windows[i].title_color = theme_accent();
            kstrncpy(windows[i].title, title, sizeof(windows[i].title) - 1);
            windows[i].active    = 1;
            windows[i].minimized = 0;
            windows[i].focused   = 1;
            if (focused_win >= 0) windows[focused_win].focused = 0;
            focused_win = i;
            window_count++;
            return i;
        }
    }
    printf("Error: no free window slots (max %d)\n", MAX_WINDOWS);
    return -1;
}

/* ------------------------------------------------------------------ */
void draw_window_frame(Window *win)
{
    if (!win->active || win->minimized) return;

    /* title bar */
    gpu_draw_rect(win->x, win->y, win->w, 24, win->title_color);
    /* body */
    gpu_draw_rect(win->x, win->y + 24, win->w, win->h - 24, win->bg_color);
    /* border */
    gpu_draw_line(win->x, win->y, win->x + win->w, win->y, 0xFF000000);
    gpu_draw_line(win->x, win->y + win->h, win->x + win->w, win->y + win->h, 0xFF000000);
    gpu_draw_line(win->x, win->y, win->x, win->y + win->h, 0xFF000000);
    gpu_draw_line(win->x + win->w, win->y, win->x + win->w, win->y + win->h, 0xFF000000);
}

/* ------------------------------------------------------------------ */
void draw_taskbar(void)
{
    int i, tx = 10;
    gpu_draw_rect(0, FB_HEIGHT - 30, FB_WIDTH, 30, 0xFF111111);
    for (i = 0; i < MAX_WINDOWS; i++) {
        if (windows[i].active) {
            gpu_draw_rect(tx, FB_HEIGHT - 26, 100, 22,
                          windows[i].focused ? theme_accent() : 0xFF333333);
            tx += 110;
        }
    }
}

/* ------------------------------------------------------------------ */
void wm_render(void)
{
    int i;
    for (i = 0; i < MAX_WINDOWS; i++) draw_window_frame(&windows[i]);
    draw_taskbar();
    draw_cursor();
    gpu_present();
}

/* ------------------------------------------------------------------ */
/* Window manager event tick                                            */
/*
 * Timer interrupt/USB HID katmanı bu fonksiyonu çağırır. Host build'de
 * sonsuz bir döngü kurmamak için tek bir olay turu işler; gerçek donanımda
 * bu tick'ler scheduler tarafından sürekli üretilir.
 */
void wm_run(void)
{
    static int last_x = -1;
    static int last_y = -1;
    static int last_buttons = -1;

    if (!mouse.changed &&
        mouse.x == last_x && mouse.y == last_y &&
        mouse.buttons == last_buttons)
        return;

    wm_mouse_event(mouse.x, mouse.y, mouse.buttons);
    mouse.moved = 0;
    mouse.changed = 0;
    last_x = mouse.x;
    last_y = mouse.y;
    last_buttons = mouse.buttons;
    wm_render();
}

/* ------------------------------------------------------------------ */
int wm_click(int x, int y)
{
    int i;
    for (i = MAX_WINDOWS - 1; i >= 0; i--) {
        if (windows[i].active && !windows[i].minimized &&
            x >= windows[i].x && x <= windows[i].x + windows[i].w &&
            y >= windows[i].y && y <= windows[i].y + windows[i].h) {
            if (focused_win >= 0) windows[focused_win].focused = 0;
            windows[i].focused = 1;
            focused_win = i;
            return i;
        }
    }
    return -1;
}

/* ------------------------------------------------------------------ */
void wm_set_theme(int theme)
{
    int i;
    if (theme < THEME_GREEN || theme > THEME_DARK) {
        printf("Error: theme must be 0 (green), 1 (blue) or 2 (dark)\n");
        return;
    }
    current_theme = theme;
    for (i = 0; i < MAX_WINDOWS; i++)
        if (windows[i].active) windows[i].title_color = theme_accent();
    printf("[OK] Theme applied\n");
}

/* ------------------------------------------------------------------ */
/* PENCERE SÜRÜKLEME + BOYUTLANDIRMA                                    */
/*                                                                      */
/* Durum makinesi:                                                      */
/*   drag_win   >= 0  → fare tutulmuş, pencere başlık çubuğundan       */
/*                       taşınıyor (offset fare + drag_offset ile)      */
/*   resize_win >= 0  → fare tutulmuş, sağ-alt köşe resize handle ile  */
/*                       boyut değiştiriliyor                           */
/*                                                                      */
/* Başlık çubuğu: y ∈ [win.y, win.y+24)                               */
/* Resize handle : sağ-alt 12×12 piksel köşe kutusu                    */
/* ------------------------------------------------------------------ */

#define TITLE_H      24    /* Başlık çubuğu yüksekliği (draw_window_frame ile eşleşmeli) */
#define RESIZE_GRIP  12    /* Resize handle boyutu (piksel)                               */
#define WIN_MIN_W    80    /* Minimum pencere genişliği                                   */
#define WIN_MIN_H    48    /* Minimum pencere yüksekliği                                  */

static int drag_win      = -1;   /* Sürüklenen pencerenin indisi, -1 = yok  */
static int drag_offset_x =  0;   /* Farenin pencere sol kenarından uzaklığı */
static int drag_offset_y =  0;   /* Farenin pencere üst kenarından uzaklığı */

static int resize_win    = -1;   /* Boyutlandırılan pencerenin indisi        */
static int prev_mx       =  0;   /* Önceki kare fare X                       */
static int prev_my       =  0;   /* Önceki kare fare Y                       */

void wm_mouse_event(int x, int y, int buttons)
{
    int btn_down  = buttons & 1;          /* sol tuş basılı mı?       */
    int i;

    /* ── BIRAKILMA: sol tuş çekildi ──────────────────────────────── */
    if (!btn_down) {
        drag_win   = -1;
        resize_win = -1;
        prev_mx    = x;
        prev_my    = y;
        return;
    }

    /* ── SÜRÜKLEME DEVAM ─────────────────────────────────────────── */
    if (drag_win >= 0) {
        int nx = x - drag_offset_x;
        int ny = y - drag_offset_y;
        /* Ekran sınırlarına kıstır */
        if (nx < 0) nx = 0;
        if (ny < 0) ny = 0;
        if (nx + windows[drag_win].w > FB_WIDTH)
            nx = FB_WIDTH - windows[drag_win].w;
        if (ny + windows[drag_win].h > FB_HEIGHT - 30) /* taskbar alanı */
            ny = FB_HEIGHT - 30 - windows[drag_win].h;
        windows[drag_win].x = nx;
        windows[drag_win].y = ny;
        prev_mx = x;
        prev_my = y;
        return;
    }

    /* ── BOYUTLANDIRMA DEVAM ─────────────────────────────────────── */
    if (resize_win >= 0) {
        int dx = x - prev_mx;
        int dy = y - prev_my;
        int nw = windows[resize_win].w + dx;
        int nh = windows[resize_win].h + dy;
        if (nw < WIN_MIN_W) nw = WIN_MIN_W;
        if (nh < WIN_MIN_H) nh = WIN_MIN_H;
        /* Ekran dışına taşmasın */
        if (windows[resize_win].x + nw > FB_WIDTH)
            nw = FB_WIDTH - windows[resize_win].x;
        if (windows[resize_win].y + nh > FB_HEIGHT - 30)
            nh = FB_HEIGHT - 30 - windows[resize_win].y;
        windows[resize_win].w = nw;
        windows[resize_win].h = nh;
        prev_mx = x;
        prev_my = y;
        return;
    }

    /* ── YENİ BASKI: hangi pencere/bölge üzerinde? ──────────────── */
    /* Üstten alta (önce odaklanmış pencereler) tara */
    for (i = MAX_WINDOWS - 1; i >= 0; i--) {
        Window *w = &windows[i];
        if (!w->active || w->minimized) continue;
        if (x < w->x || x > w->x + w->w) continue;
        if (y < w->y || y > w->y + w->h) continue;

        /* Odaklan */
        if (focused_win >= 0 && focused_win != i)
            windows[focused_win].focused = 0;
        w->focused = 1;
        focused_win = i;

        /* Resize handle: sağ-alt köşe */
        if (x >= w->x + w->w - RESIZE_GRIP &&
            y >= w->y + w->h - RESIZE_GRIP) {
            resize_win = i;
            prev_mx    = x;
            prev_my    = y;
            return;
        }

        /* Başlık çubuğu: sürükle */
        if (y < w->y + TITLE_H) {
            drag_win      = i;
            drag_offset_x = x - w->x;
            drag_offset_y = y - w->y;
            prev_mx       = x;
            prev_my       = y;
            return;
        }

        /* Pencere gövdesi — sadece odaklanma yaptık, başka iş yok */
        return;
    }

    prev_mx = x;
    prev_my = y;
}
