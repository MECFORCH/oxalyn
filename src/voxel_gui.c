/*
 * voxel_gui.c — Oxalyn Voxel Demo (Win32 GUI modu)
 *
 * Gravityon software rasterizer ile voxel dünyayı render eder,
 * Win32 GDI aracılığıyla pencereye basar.
 * Harici bağımlılık yok — sadece gdi32, user32, kernel32.
 *
 * Kontroller:
 *   W/A/S/D        — ileri/sol/geri/sağ
 *   Space / C      — yukarı/aşağı
 *   Sağ fare       — basılı tut + sürükle → kamera döndür
 *   ESC            — çıkış
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "world.h"
#include "mesher.h"
#include "render_gui.h"

/* ── Pencere sabitleri ───────────────────────────────────────────── */
#define WIN_W  800
#define WIN_H  600
#define TITLE  "Oxalyn Voxel World"
#define TARGET_FPS 30

/* ── Kamera ──────────────────────────────────────────────────────── */
typedef struct Camera {
    float x, y, z;      /* pozisyon */
    float yaw;           /* yatay açı (radyan) */
    float pitch;         /* dikey  açı (radyan) */
} Camera;

static Camera g_cam = { 20.0f, 14.0f, 20.0f, -2.35f, -0.45f };
static int    g_keys[256];
static int    g_mouse_down;
static int    g_mouse_last_x, g_mouse_last_y;

/* ── Dünya ───────────────────────────────────────────────────────── */
static World g_world;

static int build_demo_world(World *world)
{
    int x, y, z;
    for (x = 0; x < CHUNK_X; ++x)
        for (z = 0; z < CHUNK_Z; ++z)
            for (y = 0; y < 3; ++y)
                if (world_set_block(world, x, y, z, (Block)(y == 2 ? 2 : 1)) != 0)
                    return -1;

    for (x = 3; x < 7; ++x)
        for (z = 3; z < 7; ++z)
            if (world_set_block(world, x, 3, z, (Block)3) != 0)
                return -1;
    return 0;
}

/* ── Kamera güncelleme ───────────────────────────────────────────── */
static void camera_update(Camera *cam, float dt)
{
    float speed  = 8.0f * dt;
    float cy     = cosf(cam->yaw);
    float sy     = sinf(cam->yaw);

    /* WASD */
    if (g_keys['W']) { cam->x += cy * speed; cam->z += sy * speed; }
    if (g_keys['S']) { cam->x -= cy * speed; cam->z -= sy * speed; }
    if (g_keys['A']) { cam->x -= -sy * speed; cam->z -= cy * speed; }
    if (g_keys['D']) { cam->x +=  -sy * speed; cam->z += cy * speed; }
    /* Yukarı/Aşağı */
    if (g_keys[VK_SPACE])    cam->y += speed;
    if (g_keys['C'])         cam->y -= speed;
    /* Pitch sınırı */
    if (cam->pitch >  1.4f) cam->pitch =  1.4f;
    if (cam->pitch < -1.4f) cam->pitch = -1.4f;
}

/* ── Win32 pencere prosedürü ─────────────────────────────────────── */
static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg) {
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    case WM_KEYDOWN:
        if (wp < 256) g_keys[wp] = 1;
        if (wp == VK_ESCAPE) PostQuitMessage(0);
        return 0;
    case WM_KEYUP:
        if (wp < 256) g_keys[wp] = 0;
        return 0;
    case WM_RBUTTONDOWN:
        g_mouse_down   = 1;
        g_mouse_last_x = LOWORD(lp);
        g_mouse_last_y = HIWORD(lp);
        SetCapture(hwnd);
        return 0;
    case WM_RBUTTONUP:
        g_mouse_down = 0;
        ReleaseCapture();
        return 0;
    case WM_MOUSEMOVE:
        if (g_mouse_down) {
            int mx = LOWORD(lp), my = HIWORD(lp);
            float dx = (float)(mx - g_mouse_last_x);
            float dy = (float)(my - g_mouse_last_y);
            g_cam.yaw   += dx * 0.004f;
            g_cam.pitch -= dy * 0.004f;
            g_mouse_last_x = mx;
            g_mouse_last_y = my;
        }
        return 0;
    }
    return DefWindowProcA(hwnd, msg, wp, lp);
}

/* ── Ana giriş noktası ───────────────────────────────────────────── */
int main(void)
{
    /* Dünya kur */
    world_init(&g_world);
    if (build_demo_world(&g_world) != 0) {
        MessageBoxA(NULL, "Dünya oluşturulamadı!", "Hata", MB_ICONERROR);
        return 1;
    }
    world_get_or_create_chunk(&g_world, 0, 0, 0);

    /* Pencere sınıfı kaydet */
    WNDCLASSEXA wc = {0};
    wc.cbSize        = sizeof(wc);
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = WndProc;
    wc.hInstance     = GetModuleHandleA(NULL);
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
    wc.lpszClassName = "OxalynVoxel";
    RegisterClassExA(&wc);

    /* Pencere boyutunu istemci alanına göre ayarla */
    RECT rc = {0, 0, WIN_W, WIN_H};
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);
    HWND hwnd = CreateWindowExA(0, "OxalynVoxel", TITLE,
                    WS_OVERLAPPEDWINDOW,
                    CW_USEDEFAULT, CW_USEDEFAULT,
                    rc.right - rc.left, rc.bottom - rc.top,
                    NULL, NULL, wc.hInstance, NULL);
    if (!hwnd) {
        MessageBoxA(NULL, "Pencere açılamadı!", "Hata", MB_ICONERROR);
        return 1;
    }
    ShowWindow(hwnd, SW_SHOW);
    UpdateWindow(hwnd);

    /* DIB (Device Independent Bitmap) hazırla — piksel buffer'ı */
    BITMAPINFO bmi = {0};
    bmi.bmiHeader.biSize        = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth       = WIN_W;
    bmi.bmiHeader.biHeight      = -WIN_H;   /* negatif = yukarıdan aşağı */
    bmi.bmiHeader.biPlanes      = 1;
    bmi.bmiHeader.biBitCount    = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    /* BGRA8 piksel buffer'ı (GDI BI_RGB = BGRA sıralaması) */
    uint8_t *dib_pixels = (uint8_t *)malloc((size_t)WIN_W * WIN_H * 4);
    if (!dib_pixels) {
        MessageBoxA(NULL, "Bellek yetersiz!", "Hata", MB_ICONERROR);
        return 1;
    }

    HDC hdc = GetDC(hwnd);

    LARGE_INTEGER freq, t0, t1;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&t0);
    double frame_ms = 1000.0 / TARGET_FPS;

    MSG msg = {0};
    int running = 1;

    while (running) {
        /* Mesaj kuyruğunu boşalt */
        while (PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE)) {
            if (msg.message == WM_QUIT) { running = 0; break; }
            TranslateMessage(&msg);
            DispatchMessageA(&msg);
        }
        if (!running) break;

        /* Delta time */
        QueryPerformanceCounter(&t1);
        double dt = (double)(t1.QuadPart - t0.QuadPart) / (double)freq.QuadPart;
        t0 = t1;
        if (dt > 0.1) dt = 0.1;   /* çok uzun frame'leri kırp */

        /* Kamera güncelle */
        camera_update(&g_cam, (float)dt);

        /* Gravityon ile render et — piksel verisi al */
        render_to_bgra(&g_world, &g_cam, dib_pixels, WIN_W, WIN_H);

        /* GDI ile pencereye blit */
        StretchDIBits(hdc,
                      0, 0, WIN_W, WIN_H,
                      0, 0, WIN_W, WIN_H,
                      dib_pixels, &bmi,
                      DIB_RGB_COLORS, SRCCOPY);

        /* Hedef FPS için kalan süreyi bekle */
        QueryPerformanceCounter(&t1);
        double elapsed_ms = (double)(t1.QuadPart - t0.QuadPart) /
                            (double)freq.QuadPart * 1000.0;
        if (elapsed_ms < frame_ms)
            Sleep((DWORD)(frame_ms - elapsed_ms));
    }

    ReleaseDC(hwnd, hdc);
    free(dib_pixels);
    world_free(&g_world);
    return 0;
}
