/*
 * display.c — Oxalyn-64 Simülatörü Görsel Pencere Katmanı
 *
 * Backend seçimi (derleme zamanı):
 *   SDL2   : -DOXALYN_DISPLAY_SDL2  (Windows + Linux, tavsiye edilen)
 *   Win32  : -DOXALYN_DISPLAY_WIN32 (Windows, SDL2 yoksa)
 *   X11    : -DOXALYN_DISPLAY_X11   (Linux, SDL2 yoksa)
 *   stub   : hiçbiri → no-op, sessiz devre dışı
 */

#include "display.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ================================================================== */
/* ── A) SDL2 BACKEND (Windows + Linux + macOS)                        */
/* ================================================================== */
#if defined(OXALYN_DISPLAY_SDL2)

#include <SDL2/SDL.h>

static SDL_Window   *g_win  = NULL;
static SDL_Renderer *g_ren  = NULL;
static SDL_Texture  *g_tex  = NULL;
static int           g_w    = 0;
static int           g_h    = 0;

int display_open(int width, int height, const char *title)
{
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        fprintf(stderr, "[GUI/SDL2] SDL_Init: %s\n", SDL_GetError());
        return -1;
    }

    g_win = SDL_CreateWindow(
        title,
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        width, height,
        SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE
    );
    if (!g_win) {
        fprintf(stderr, "[GUI/SDL2] SDL_CreateWindow: %s\n", SDL_GetError());
        SDL_Quit();
        return -1;
    }

    g_ren = SDL_CreateRenderer(g_win, -1,
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!g_ren) {
        /* Hızlandırma yoksa yazılım renderer'a düş */
        g_ren = SDL_CreateRenderer(g_win, -1, SDL_RENDERER_SOFTWARE);
    }
    if (!g_ren) {
        fprintf(stderr, "[GUI/SDL2] SDL_CreateRenderer: %s\n", SDL_GetError());
        SDL_DestroyWindow(g_win);
        SDL_Quit();
        return -1;
    }

    /* Pencere boyutuna göre ölçeklendir, en-boy oranını koru */
    SDL_RenderSetLogicalSize(g_ren, width, height);

    g_tex = SDL_CreateTexture(
        g_ren,
        SDL_PIXELFORMAT_RGBA8888,
        SDL_TEXTUREACCESS_STREAMING,
        width, height
    );
    if (!g_tex) {
        fprintf(stderr, "[GUI/SDL2] SDL_CreateTexture: %s\n", SDL_GetError());
        SDL_DestroyRenderer(g_ren);
        SDL_DestroyWindow(g_win);
        SDL_Quit();
        return -1;
    }

    g_w = width;
    g_h = height;

    fprintf(stderr, "[GUI/SDL2] Pencere açıldı: %dx%d — %s\n",
            width, height, title);
    return 0;
}

int display_update(const uint8_t *pixels, int width, int height, int pitch)
{
    if (!g_tex || !pixels) return -1;

    SDL_UpdateTexture(g_tex, NULL, pixels, pitch);
    SDL_SetRenderDrawColor(g_ren, 0, 0, 0, 255);
    SDL_RenderClear(g_ren);
    SDL_RenderCopy(g_ren, g_tex, NULL, NULL);
    SDL_RenderPresent(g_ren);
    return 0;
}

int display_poll(void)
{
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT)
            return 0;
        if (e.type == SDL_KEYDOWN) {
            switch (e.key.keysym.sym) {
                case SDLK_ESCAPE: return 0;
                case SDLK_F11: {
                    /* F11 → tam ekran geçiş */
                    Uint32 flags = SDL_GetWindowFlags(g_win);
                    SDL_SetWindowFullscreen(g_win,
                        (flags & SDL_WINDOW_FULLSCREEN_DESKTOP)
                            ? 0
                            : SDL_WINDOW_FULLSCREEN_DESKTOP);
                    break;
                }
                default: break;
            }
        }
    }
    return 1;
}

void display_close(void)
{
    if (g_tex)  { SDL_DestroyTexture(g_tex);   g_tex  = NULL; }
    if (g_ren)  { SDL_DestroyRenderer(g_ren);  g_ren  = NULL; }
    if (g_win)  { SDL_DestroyWindow(g_win);    g_win  = NULL; }
    SDL_Quit();
    fprintf(stderr, "[GUI/SDL2] Pencere kapatıldı.\n");
}

/* ================================================================== */
/* ── B) WIN32 GDI BACKEND (Windows, SDL2 olmadan)                     */
/* ================================================================== */
#elif defined(OXALYN_DISPLAY_WIN32) && defined(_WIN32)

#ifndef WIN32_LEAN_AND_MEAN
#  define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>

static HWND   g_hwnd    = NULL;
static HDC    g_memdc   = NULL;
static HBITMAP g_bmp    = NULL;
static void  *g_bits    = NULL;
static int    g_w       = 0;
static int    g_h       = 0;
static int    g_quit    = 0;
static uint8_t *g_conv  = NULL;   /* BGRA dönüşüm tamponu */

static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg,
                                 WPARAM wp, LPARAM lp)
{
    switch (msg) {
        case WM_CLOSE:
        case WM_DESTROY:
            g_quit = 1;
            PostQuitMessage(0);
            return 0;
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC dc = BeginPaint(hwnd, &ps);
            BitBlt(dc, 0, 0, g_w, g_h, g_memdc, 0, 0, SRCCOPY);
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_KEYDOWN:
            if (wp == VK_ESCAPE) { g_quit = 1; return 0; }
            if (wp == VK_F11) {
                /* Basit tam ekran: pencere stilini değiştir */
                static WINDOWPLACEMENT s_prev = { sizeof(s_prev) };
                DWORD style = (DWORD)GetWindowLong(hwnd, GWL_STYLE);
                if (style & WS_OVERLAPPEDWINDOW) {
                    MONITORINFO mi = { sizeof(mi) };
                    GetWindowPlacement(hwnd, &s_prev);
                    GetMonitorInfo(MonitorFromWindow(hwnd,
                        MONITOR_DEFAULTTOPRIMARY), &mi);
                    SetWindowLong(hwnd, GWL_STYLE,
                        style & ~WS_OVERLAPPEDWINDOW);
                    SetWindowPos(hwnd, HWND_TOP,
                        mi.rcMonitor.left, mi.rcMonitor.top,
                        mi.rcMonitor.right  - mi.rcMonitor.left,
                        mi.rcMonitor.bottom - mi.rcMonitor.top,
                        SWP_NOOWNERZORDER | SWP_FRAMECHANGED);
                } else {
                    SetWindowLong(hwnd, GWL_STYLE,
                        style | WS_OVERLAPPEDWINDOW);
                    SetWindowPlacement(hwnd, &s_prev);
                    SetWindowPos(hwnd, NULL, 0, 0, 0, 0,
                        SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER |
                        SWP_NOOWNERZORDER | SWP_FRAMECHANGED);
                }
            }
            return 0;
        default:
            return DefWindowProc(hwnd, msg, wp, lp);
    }
}

int display_open(int width, int height, const char *title)
{
    WNDCLASSA wc  = {0};
    BITMAPINFO bmi = {0};
    HDC dc;
    RECT r = { 0, 0, width, height };
    DWORD style = WS_OVERLAPPEDWINDOW;

    wc.lpfnWndProc   = WndProc;
    wc.hInstance     = GetModuleHandle(NULL);
    wc.lpszClassName = "OxalynSim";
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    RegisterClassA(&wc);

    AdjustWindowRect(&r, style, FALSE);
    g_hwnd = CreateWindowA("OxalynSim", title, style,
        CW_USEDEFAULT, CW_USEDEFAULT,
        r.right - r.left, r.bottom - r.top,
        NULL, NULL, GetModuleHandle(NULL), NULL);
    if (!g_hwnd) return -1;

    dc     = GetDC(g_hwnd);
    g_memdc = CreateCompatibleDC(dc);

    bmi.bmiHeader.biSize        = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth       = width;
    bmi.bmiHeader.biHeight      = -height;  /* top-down */
    bmi.bmiHeader.biPlanes      = 1;
    bmi.bmiHeader.biBitCount    = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    g_bmp = CreateDIBSection(dc, &bmi, DIB_RGB_COLORS, &g_bits, NULL, 0);
    ReleaseDC(g_hwnd, dc);

    if (!g_bmp) { DestroyWindow(g_hwnd); g_hwnd = NULL; return -1; }
    SelectObject(g_memdc, g_bmp);

    g_conv = (uint8_t *)malloc((size_t)(width * height * 4));
    if (!g_conv) { DestroyWindow(g_hwnd); g_hwnd = NULL; return -1; }

    g_w    = width;
    g_h    = height;
    g_quit = 0;

    ShowWindow(g_hwnd, SW_SHOW);
    UpdateWindow(g_hwnd);

    fprintf(stderr, "[GUI/Win32] Pencere açıldı: %dx%d — %s\n",
            width, height, title);
    return 0;
}

int display_update(const uint8_t *pixels, int width, int height, int pitch)
{
    int x, y;
    if (!g_hwnd || !pixels || !g_bits) return -1;

    /* RGBA8 → BGRA8 (GDI için) */
    for (y = 0; y < height; y++) {
        const uint8_t *src = pixels + (size_t)y * (size_t)pitch;
        uint8_t       *dst = (uint8_t *)g_bits + (size_t)y * (size_t)(width * 4);
        for (x = 0; x < width; x++) {
            dst[0] = src[2];   /* B */
            dst[1] = src[1];   /* G */
            dst[2] = src[0];   /* R */
            dst[3] = src[3];   /* A */
            src += 4;
            dst += 4;
        }
    }

    InvalidateRect(g_hwnd, NULL, FALSE);
    UpdateWindow(g_hwnd);
    return 0;
}

int display_poll(void)
{
    MSG msg;
    while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return g_quit ? 0 : 1;
}

void display_close(void)
{
    free(g_conv); g_conv = NULL;
    if (g_memdc) { DeleteDC(g_memdc);     g_memdc = NULL; }
    if (g_bmp)   { DeleteObject(g_bmp);   g_bmp   = NULL; }
    if (g_hwnd)  { DestroyWindow(g_hwnd); g_hwnd  = NULL; }
    fprintf(stderr, "[GUI/Win32] Pencere kapatıldı.\n");
}

/* ================================================================== */
/* ── C) X11/XLIB BACKEND (Linux/BSD, SDL2 olmadan)                   */
/* ================================================================== */
#elif defined(OXALYN_DISPLAY_X11) && defined(__linux__)

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>

static Display  *g_dpy   = NULL;
static Window    g_win   = 0;
static GC        g_gc    = 0;
static XImage   *g_img   = NULL;
static char     *g_imgbuf = NULL;
static int       g_w     = 0;
static int       g_h     = 0;
static Atom      g_wmdel = 0;
static int       g_quit  = 0;

int display_open(int width, int height, const char *title)
{
    XSetWindowAttributes attr = {0};
    Visual    *visual;
    int        depth;
    int        screen;
    size_t     bufsz;

    g_dpy = XOpenDisplay(NULL);
    if (!g_dpy) {
        fprintf(stderr, "[GUI/X11] Ekran açılamadı (DISPLAY=%s)\n",
                getenv("DISPLAY") ? getenv("DISPLAY") : "(ayarsız)");
        return -1;
    }

    screen = DefaultScreen(g_dpy);
    visual = DefaultVisual(g_dpy, screen);
    depth  = DefaultDepth(g_dpy, screen);

    attr.background_pixel = BlackPixel(g_dpy, screen);
    attr.event_mask       = KeyPressMask | ExposureMask | StructureNotifyMask;

    g_win = XCreateWindow(g_dpy, RootWindow(g_dpy, screen),
        0, 0, (unsigned)width, (unsigned)height, 0,
        depth, InputOutput, visual,
        CWBackPixel | CWEventMask, &attr);

    XStoreName(g_dpy, g_win, title);

    /* WM_DELETE_WINDOW protokolü (pencere × düğmesi) */
    g_wmdel = XInternAtom(g_dpy, "WM_DELETE_WINDOW", False);
    XSetWMProtocols(g_dpy, g_win, &g_wmdel, 1);

    g_gc = XCreateGC(g_dpy, g_win, 0, NULL);

    /* Piksel tamponu (XImage için) — 32 bpp */
    bufsz = (size_t)(width * height * 4);
    g_imgbuf = (char *)malloc(bufsz);
    if (!g_imgbuf) { XDestroyWindow(g_dpy, g_win); XCloseDisplay(g_dpy); return -1; }
    memset(g_imgbuf, 0, bufsz);

    g_img = XCreateImage(g_dpy, visual, (unsigned)depth, ZPixmap, 0,
                         g_imgbuf, (unsigned)width, (unsigned)height,
                         32, width * 4);
    if (!g_img) {
        free(g_imgbuf); g_imgbuf = NULL;
        XDestroyWindow(g_dpy, g_win);
        XCloseDisplay(g_dpy);
        return -1;
    }

    XMapWindow(g_dpy, g_win);
    XFlush(g_dpy);

    g_w    = width;
    g_h    = height;
    g_quit = 0;

    fprintf(stderr, "[GUI/X11] Pencere açıldı: %dx%d — %s\n",
            width, height, title);
    return 0;
}

int display_update(const uint8_t *pixels, int width, int height, int pitch)
{
    int x, y;
    if (!g_img || !pixels) return -1;

    /* RGBA8 → BGRX (X11 32-bpp, little-endian varsayım) */
    for (y = 0; y < height; y++) {
        const uint8_t *src = pixels + (size_t)y * (size_t)pitch;
        uint8_t       *dst = (uint8_t *)g_imgbuf + (size_t)y * (size_t)(width * 4);
        for (x = 0; x < width; x++) {
            dst[0] = src[2];   /* B */
            dst[1] = src[1];   /* G */
            dst[2] = src[0];   /* R */
            dst[3] = 0xFF;
            src += 4;
            dst += 4;
        }
    }

    XPutImage(g_dpy, g_win, g_gc, g_img, 0, 0, 0, 0,
              (unsigned)width, (unsigned)height);
    XFlush(g_dpy);
    return 0;
}

int display_poll(void)
{
    XEvent e;
    while (XPending(g_dpy)) {
        XNextEvent(g_dpy, &e);
        switch (e.type) {
            case ClientMessage:
                if ((Atom)e.xclient.data.l[0] == g_wmdel) g_quit = 1;
                break;
            case KeyPress: {
                KeySym ks = XLookupKeysym(&e.xkey, 0);
                if (ks == XK_Escape) g_quit = 1;
                if (ks == XK_F11) {
                    /* X11 tam ekran (EWMH) */
                    Atom wm_state = XInternAtom(g_dpy, "_NET_WM_STATE", False);
                    Atom fullscr  = XInternAtom(g_dpy, "_NET_WM_STATE_FULLSCREEN", False);
                    XEvent ev     = {0};
                    ev.type                 = ClientMessage;
                    ev.xclient.window       = g_win;
                    ev.xclient.message_type = wm_state;
                    ev.xclient.format       = 32;
                    ev.xclient.data.l[0]    = 2;  /* _NET_WM_STATE_TOGGLE */
                    ev.xclient.data.l[1]    = (long)fullscr;
                    XSendEvent(g_dpy,
                        DefaultRootWindow(g_dpy), False,
                        SubstructureRedirectMask | SubstructureNotifyMask, &ev);
                }
                break;
            }
            case Expose:
                if (g_img)
                    XPutImage(g_dpy, g_win, g_gc, g_img, 0, 0, 0, 0,
                              (unsigned)g_w, (unsigned)g_h);
                break;
            default: break;
        }
    }
    return g_quit ? 0 : 1;
}

void display_close(void)
{
    if (g_img) {
        g_img->data = NULL;   /* imgbuf'u ayrıca free edeceğiz */
        XDestroyImage(g_img);
        g_img = NULL;
    }
    free(g_imgbuf); g_imgbuf = NULL;
    if (g_gc)  { XFreeGC(g_dpy, g_gc);        g_gc  = 0; }
    if (g_win) { XDestroyWindow(g_dpy, g_win); g_win = 0; }
    if (g_dpy) { XCloseDisplay(g_dpy);         g_dpy = NULL; }
    fprintf(stderr, "[GUI/X11] Pencere kapatıldı.\n");
}

/* ================================================================== */
/* ── D) NO-OP STUB (backend seçilmedi)                                */
/* ================================================================== */
#else

int  display_open(int w, int h, const char *t)
{
    (void)w; (void)h; (void)t;
    fprintf(stderr,
        "[GUI] Pencere desteği devre dışı. "
        "-DOXALYN_DISPLAY_SDL2, -DOXALYN_DISPLAY_WIN32 "
        "veya -DOXALYN_DISPLAY_X11 ile derleyin.\n");
    return -1;
}
int  display_update(const uint8_t *p, int w, int h, int pitch)
{ (void)p;(void)w;(void)h;(void)pitch; return -1; }
int  display_poll(void) { return 1; }
void display_close(void) {}

#endif /* backend seçimi */
