#include "kernel.h"
#include "gpu.h"
#include "gpu_hw.h"
#ifdef OXALYN_HOST_TEST
#include "hostio.h"
#endif

/* ── Framebuffer işaretçisi ─────────────────────────────────────────────────
 * OXALYN_SIMULATOR : sim.c'deki mem[0x8000] dizisine oxalyn_fb_ptr() üzerinden
 *                    bağlanır. Lazy init — ilk gpu_init() çağrısında kurulur.
 *                    Bu yöntem hem Linux hem Windows'ta çalışır.
 * OXALYN_HOST_TEST : Bağımsız host binary; GPU çıktısı görünmez, yerel tampon.
 * Gerçek donanım   : FB_ADDR doğrudan word-addressed MMIO.
 * ──────────────────────────────────────────────────────────────────────── */
#if defined(OXALYN_SIMULATOR)
static volatile uint32_t *framebuffer = (void *)0;
extern uint32_t *oxalyn_fb_ptr(void);   /* sim.c tarafından sağlanır */
static void ensure_fb(void)
{
    if (!framebuffer)
        framebuffer = (volatile uint32_t *)oxalyn_fb_ptr();
}
#elif defined(OXALYN_HOST_TEST)
static uint32_t _host_framebuffer[FB_WIDTH * FB_HEIGHT];
static volatile uint32_t *framebuffer = _host_framebuffer;
static void ensure_fb(void) { /* yerel tampon, görüntü yok */ }
#else
static volatile uint32_t *framebuffer = (volatile uint32_t *)(uintptr_t)FB_ADDR;
static void ensure_fb(void) { /* doğrudan MMIO, kurulum gerekmez */ }
#endif

static const int fb_w = FB_WIDTH;
static const int fb_h = FB_HEIGHT;

static int abs_i(int v) { return v < 0 ? -v : v; }

static void gpu_put_pixel_local(int x, int y, uint32_t color)
{
    if (x < 0 || x >= fb_w || y < 0 || y >= fb_h) return;
    framebuffer[y * fb_w + x] = color;
}

void gpu_save_frame_raw(const char *filename)
{
#ifdef OXALYN_HOST_TEST
    int fd;
    int y;
    const char *path = filename ? filename : "framebuffer.raw";
    fd = hostio_open(path, HOSTIO_O_WRONLY | HOSTIO_O_CREAT |
                          HOSTIO_O_TRUNC, 0644);
    if (fd < 0) return;

    /*
     * Export format: row-major RGBA8, 4 bytes per pixel, 800x600.
     * The kernel stores pixels as 0xAARRGGBB; the viewer consumes bytes.
     */
    for (y = 0; y < fb_h; y++) {
        int x;
        for (x = 0; x < fb_w; x++) {
            uint32_t pixel = framebuffer[y * fb_w + x];
            unsigned char rgba[4];
            rgba[0] = (unsigned char)(pixel >> 16);
            rgba[1] = (unsigned char)(pixel >> 8);
            rgba[2] = (unsigned char)pixel;
            rgba[3] = (unsigned char)(pixel >> 24);
            if (hostio_write(fd, rgba, sizeof(rgba)) != (long)sizeof(rgba)) {
                hostio_close(fd);
                return;
            }
        }
    }
    hostio_close(fd);
#else
    (void)filename;
#endif
}

volatile uint32_t *platform_framebuffer(void)
{
    ensure_fb();
    return framebuffer;
}

/* ------------------------------------------------------------------ */
void gpu_init(void)
{
    gpu_hw_init();
    ensure_fb();             /* Framebuffer bağlantısını kur */
    gpu_clear(0xFF001A33);   /* Dark blue */
}

/* ------------------------------------------------------------------ */
void gpu_clear(uint32_t color)
{
    int i;
    for (i = 0; i < fb_w * fb_h; i++)
        framebuffer[i] = color;
    gpu_hw_clear(color);
}

/* ------------------------------------------------------------------ */
void gpu_put_pixel(int x, int y, uint32_t color)
{
    gpu_put_pixel_local(x, y, color);
    gpu_hw_pixel(x, y, color);
}

/* ------------------------------------------------------------------ */
void gpu_draw_line(int x1, int y1, int x2, int y2, uint32_t color)
{
    int ox1 = x1, oy1 = y1, ox2 = x2, oy2 = y2;
    /* Bresenham line algorithm */
    int dx  = abs_i(x2 - x1);
    int dy  = abs_i(y2 - y1);
    int sx  = (x1 < x2) ? 1 : -1;
    int sy  = (y1 < y2) ? 1 : -1;
    int err = dx - dy;

    while (1) {
        gpu_put_pixel_local(x1, y1, color);
        if (x1 == x2 && y1 == y2) break;

        int e2 = 2 * err;
        if (e2 > -dy) { err -= dy; x1 += sx; }
        if (e2 <  dx) { err += dx; y1 += sy; }
    }
    gpu_hw_line(ox1, oy1, ox2, oy2, color);
}

/* ------------------------------------------------------------------ */
void gpu_draw_rect(int x, int y, int w, int h, uint32_t color)
{
    int dy, dx;
    for (dy = 0; dy < h; dy++)
        for (dx = 0; dx < w; dx++)
            gpu_put_pixel_local(x + dx, y + dy, color);
    gpu_hw_rect(x, y, w, h, color);
}

/* ------------------------------------------------------------------ */
void gpu_draw_circle(int cx, int cy, int r, uint32_t color)
{
    /* Midpoint circle algorithm */
    int px = 0, py = r;
    int d  = 3 - 2 * r;

    while (px <= py) {
        gpu_put_pixel_local(cx + px, cy + py, color);
        gpu_put_pixel_local(cx - px, cy + py, color);
        gpu_put_pixel_local(cx + px, cy - py, color);
        gpu_put_pixel_local(cx - px, cy - py, color);
        gpu_put_pixel_local(cx + py, cy + px, color);
        gpu_put_pixel_local(cx - py, cy + px, color);
        gpu_put_pixel_local(cx + py, cy - px, color);
        gpu_put_pixel_local(cx - py, cy - px, color);

        if (d < 0)  d += 4 * px + 6;
        else       { d += 4 * (px - py) + 10; py--; }
        px++;
    }
    gpu_hw_circle(cx, cy, r, color);
}

/* ------------------------------------------------------------------ */
void gpu_fill_circle(int cx, int cy, int r, uint32_t color)
{
    int dy;
    for (dy = -r; dy <= r; dy++) {
        int dx = 0;
        /* Integer sqrt via simple search — r is always small (<=~150) */
        while (dx * dx + dy * dy <= r * r) dx++;
        dx--;
        {
            int x;
            for (x = cx - dx; x <= cx + dx; x++)
                gpu_put_pixel_local(x, cy + dy, color);
        }
    }
    gpu_hw_fill_circle(cx, cy, r, color);
}

/* ------------------------------------------------------------------ */
void gpu_present(void)
{
    MEMORY_BARRIER();
    gpu_hw_present();
#ifdef OXALYN_HOST_TEST
    gpu_save_frame_raw("framebuffer.raw");
#endif
}

/* ================================================================
 * GPU GENİŞLETMELERİ
 * ================================================================ */

/* ------------------------------------------------------------------ */
/* ALPHA BLEND: src üzerinden dst'e basit porter-duff "over"           */
/* color formatı: 0xAARRGGBB                                           */
/* ------------------------------------------------------------------ */
void gpu_put_pixel_alpha(int x, int y, uint32_t color)
{
    uint32_t a, sr, sg, sb, s, dr, dg, db, rr, rg, rb;
    if (x < 0 || x >= fb_w || y < 0 || y >= fb_h) return;

    a = (color >> 24) & 0xFFu;
    if (a == 0xFFu) { framebuffer[y * fb_w + x] = color; return; }
    if (a == 0x00u) return;

    /* Kaynak RGB */
    sr = (color >> 16) & 0xFFu;
    sg = (color >>  8) & 0xFFu;
    sb =  color        & 0xFFu;

    /* Hedef RGB */
    s  = framebuffer[y * fb_w + x];
    dr = (s >> 16) & 0xFFu;
    dg = (s >>  8) & 0xFFu;
    db =  s        & 0xFFu;

    /* Lineer blend: out = src*a + dst*(255-a) */
    rr = (sr * a + dr * (255u - a)) / 255u;
    rg = (sg * a + dg * (255u - a)) / 255u;
    rb = (sb * a + db * (255u - a)) / 255u;
    framebuffer[y * fb_w + x] = 0xFF000000u | (rr << 16u) | (rg << 8u) | rb;
}

/* ------------------------------------------------------------------ */
/* YUVARLAK KÖŞELİ DİKDÖRTGEN (fill)                                  */
/* ------------------------------------------------------------------ */
void gpu_draw_rounded_rect(int x, int y, int w, int h, int r, uint32_t color)
{
    int dx, dy, rr;
    /* Merkez gövde */
    gpu_draw_rect(x + r, y,     w - 2*r, h,     color);
    gpu_draw_rect(x,     y + r, r,       h-2*r, color);
    gpu_draw_rect(x+w-r, y + r, r,       h-2*r, color);

    /* 4 köşe çeyrek dairesi */
    for (dy = 0; dy <= r; dy++) {
        for (dx = 0; dx <= r; dx++) {
            rr = dx*dx + dy*dy;
            if (rr <= r*r) {
                gpu_put_pixel_local(x + r     - dx, y + r     - dy, color);
                gpu_put_pixel_local(x + w - r + dx, y + r     - dy, color);
                gpu_put_pixel_local(x + r     - dx, y + h - r + dy, color);
                gpu_put_pixel_local(x + w - r + dx, y + h - r + dy, color);
            }
        }
    }
}

/* ------------------------------------------------------------------ */
/* DOLU ÜÇGEN (rasterizasyon — tarama çizgisi)                        */
/* ------------------------------------------------------------------ */
static int gpu_min3(int a, int b, int c) { int m=a; if(b<m)m=b; if(c<m)m=c; return m; }
static int gpu_max3(int a, int b, int c) { int m=a; if(b>m)m=b; if(c>m)m=c; return m; }

void gpu_fill_triangle(int x0, int y0, int x1, int y1, int x2, int y2, uint32_t color)
{
    int xmin = gpu_min3(x0, x1, x2);
    int xmax = gpu_max3(x0, x1, x2);
    int ymin = gpu_min3(y0, y1, y2);
    int ymax = gpu_max3(y0, y1, y2);
    int px, py;

    /* Barisentrik koordinat ile rasterize */
    for (py = ymin; py <= ymax; py++) {
        for (px = xmin; px <= xmax; px++) {
            /* Kenar fonksiyonları */
            int w0 = (x1-x0)*(py-y0) - (y1-y0)*(px-x0);
            int w1 = (x2-x1)*(py-y1) - (y2-y1)*(px-x1);
            int w2 = (x0-x2)*(py-y2) - (y0-y2)*(px-x2);
            if ((w0 >= 0 && w1 >= 0 && w2 >= 0) ||
                (w0 <= 0 && w1 <= 0 && w2 <= 0))
                gpu_put_pixel_local(px, py, color);
        }
    }
}

/* ------------------------------------------------------------------ */
/* BİTMAP METİN RENDER — 8×8 IBM CP437 / ASCII subset                  */
/*                                                                      */
/* Her karakter 8 satır × 8 sütun bit olarak saklanır.                 */
/* Sadece yazdırılabilir ASCII (0x20–0x7E) desteklenir.                */
/* ------------------------------------------------------------------ */

/* 8×8 bitmap font: 96 karakter × 8 bayt (0x20'den başlayarak) */
static const uint8_t font8x8[96][8] = {
    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}, /* ' ' */
    {0x18,0x3C,0x3C,0x18,0x18,0x00,0x18,0x00}, /* '!' */
    {0x36,0x36,0x00,0x00,0x00,0x00,0x00,0x00}, /* '"' */
    {0x36,0x36,0x7F,0x36,0x7F,0x36,0x36,0x00}, /* '#' */
    {0x0C,0x3E,0x03,0x1E,0x30,0x1F,0x0C,0x00}, /* '$' */
    {0x00,0x63,0x33,0x18,0x0C,0x66,0x63,0x00}, /* '%' */
    {0x1C,0x36,0x1C,0x6E,0x3B,0x33,0x6E,0x00}, /* '&' */
    {0x06,0x06,0x03,0x00,0x00,0x00,0x00,0x00}, /* '\'' */
    {0x18,0x0C,0x06,0x06,0x06,0x0C,0x18,0x00}, /* '(' */
    {0x06,0x0C,0x18,0x18,0x18,0x0C,0x06,0x00}, /* ')' */
    {0x00,0x66,0x3C,0xFF,0x3C,0x66,0x00,0x00}, /* '*' */
    {0x00,0x0C,0x0C,0x3F,0x0C,0x0C,0x00,0x00}, /* '+' */
    {0x00,0x00,0x00,0x00,0x00,0x0C,0x0C,0x06}, /* ',' */
    {0x00,0x00,0x00,0x3F,0x00,0x00,0x00,0x00}, /* '-' */
    {0x00,0x00,0x00,0x00,0x00,0x0C,0x0C,0x00}, /* '.' */
    {0x60,0x30,0x18,0x0C,0x06,0x03,0x01,0x00}, /* '/' */
    {0x3E,0x63,0x73,0x7B,0x6F,0x67,0x3E,0x00}, /* '0' */
    {0x0C,0x0E,0x0C,0x0C,0x0C,0x0C,0x3F,0x00}, /* '1' */
    {0x1E,0x33,0x30,0x1C,0x06,0x33,0x3F,0x00}, /* '2' */
    {0x1E,0x33,0x30,0x1C,0x30,0x33,0x1E,0x00}, /* '3' */
    {0x38,0x3C,0x36,0x33,0x7F,0x30,0x78,0x00}, /* '4' */
    {0x3F,0x03,0x1F,0x30,0x30,0x33,0x1E,0x00}, /* '5' */
    {0x1C,0x06,0x03,0x1F,0x33,0x33,0x1E,0x00}, /* '6' */
    {0x3F,0x33,0x30,0x18,0x0C,0x0C,0x0C,0x00}, /* '7' */
    {0x1E,0x33,0x33,0x1E,0x33,0x33,0x1E,0x00}, /* '8' */
    {0x1E,0x33,0x33,0x3E,0x30,0x18,0x0E,0x00}, /* '9' */
    {0x00,0x0C,0x0C,0x00,0x00,0x0C,0x0C,0x00}, /* ':' */
    {0x00,0x0C,0x0C,0x00,0x00,0x0C,0x0C,0x06}, /* ';' */
    {0x18,0x0C,0x06,0x03,0x06,0x0C,0x18,0x00}, /* '<' */
    {0x00,0x00,0x3F,0x00,0x00,0x3F,0x00,0x00}, /* '=' */
    {0x06,0x0C,0x18,0x30,0x18,0x0C,0x06,0x00}, /* '>' */
    {0x1E,0x33,0x30,0x18,0x0C,0x00,0x0C,0x00}, /* '?' */
    {0x3E,0x63,0x7B,0x7B,0x7B,0x03,0x1E,0x00}, /* '@' */
    {0x0C,0x1E,0x33,0x33,0x3F,0x33,0x33,0x00}, /* 'A' */
    {0x3F,0x66,0x66,0x3E,0x66,0x66,0x3F,0x00}, /* 'B' */
    {0x3C,0x66,0x03,0x03,0x03,0x66,0x3C,0x00}, /* 'C' */
    {0x1F,0x36,0x66,0x66,0x66,0x36,0x1F,0x00}, /* 'D' */
    {0x7F,0x46,0x16,0x1E,0x16,0x46,0x7F,0x00}, /* 'E' */
    {0x7F,0x46,0x16,0x1E,0x16,0x06,0x0F,0x00}, /* 'F' */
    {0x3C,0x66,0x03,0x03,0x73,0x66,0x7C,0x00}, /* 'G' */
    {0x33,0x33,0x33,0x3F,0x33,0x33,0x33,0x00}, /* 'H' */
    {0x1E,0x0C,0x0C,0x0C,0x0C,0x0C,0x1E,0x00}, /* 'I' */
    {0x78,0x30,0x30,0x30,0x33,0x33,0x1E,0x00}, /* 'J' */
    {0x67,0x66,0x36,0x1E,0x36,0x66,0x67,0x00}, /* 'K' */
    {0x0F,0x06,0x06,0x06,0x46,0x66,0x7F,0x00}, /* 'L' */
    {0x63,0x77,0x7F,0x7F,0x6B,0x63,0x63,0x00}, /* 'M' */
    {0x63,0x67,0x6F,0x7B,0x73,0x63,0x63,0x00}, /* 'N' */
    {0x1C,0x36,0x63,0x63,0x63,0x36,0x1C,0x00}, /* 'O' */
    {0x3F,0x66,0x66,0x3E,0x06,0x06,0x0F,0x00}, /* 'P' */
    {0x1E,0x33,0x33,0x33,0x3B,0x1E,0x38,0x00}, /* 'Q' */
    {0x3F,0x66,0x66,0x3E,0x36,0x66,0x67,0x00}, /* 'R' */
    {0x1E,0x33,0x07,0x0E,0x38,0x33,0x1E,0x00}, /* 'S' */
    {0x3F,0x2D,0x0C,0x0C,0x0C,0x0C,0x1E,0x00}, /* 'T' */
    {0x33,0x33,0x33,0x33,0x33,0x33,0x3F,0x00}, /* 'U' */
    {0x33,0x33,0x33,0x33,0x33,0x1E,0x0C,0x00}, /* 'V' */
    {0x63,0x63,0x63,0x6B,0x7F,0x77,0x63,0x00}, /* 'W' */
    {0x63,0x63,0x36,0x1C,0x1C,0x36,0x63,0x00}, /* 'X' */
    {0x33,0x33,0x33,0x1E,0x0C,0x0C,0x1E,0x00}, /* 'Y' */
    {0x7F,0x63,0x31,0x18,0x4C,0x66,0x7F,0x00}, /* 'Z' */
    {0x1E,0x06,0x06,0x06,0x06,0x06,0x1E,0x00}, /* '[' */
    {0x03,0x06,0x0C,0x18,0x30,0x60,0x40,0x00}, /* '\\' */
    {0x1E,0x18,0x18,0x18,0x18,0x18,0x1E,0x00}, /* ']' */
    {0x08,0x1C,0x36,0x63,0x00,0x00,0x00,0x00}, /* '^' */
    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF}, /* '_' */
    {0x0C,0x0C,0x18,0x00,0x00,0x00,0x00,0x00}, /* '`' */
    {0x00,0x00,0x1E,0x30,0x3E,0x33,0x6E,0x00}, /* 'a' */
    {0x07,0x06,0x06,0x3E,0x66,0x66,0x3B,0x00}, /* 'b' */
    {0x00,0x00,0x1E,0x33,0x03,0x33,0x1E,0x00}, /* 'c' */
    {0x38,0x30,0x30,0x3e,0x33,0x33,0x6E,0x00}, /* 'd' */
    {0x00,0x00,0x1E,0x33,0x3f,0x03,0x1E,0x00}, /* 'e' */
    {0x1C,0x36,0x06,0x0f,0x06,0x06,0x0F,0x00}, /* 'f' */
    {0x00,0x00,0x6E,0x33,0x33,0x3E,0x30,0x1F}, /* 'g' */
    {0x07,0x06,0x36,0x6E,0x66,0x66,0x67,0x00}, /* 'h' */
    {0x0C,0x00,0x0E,0x0C,0x0C,0x0C,0x1E,0x00}, /* 'i' */
    {0x30,0x00,0x30,0x30,0x30,0x33,0x33,0x1E}, /* 'j' */
    {0x07,0x06,0x66,0x36,0x1E,0x36,0x67,0x00}, /* 'k' */
    {0x0E,0x0C,0x0C,0x0C,0x0C,0x0C,0x1E,0x00}, /* 'l' */
    {0x00,0x00,0x33,0x7F,0x7F,0x6B,0x63,0x00}, /* 'm' */
    {0x00,0x00,0x1F,0x33,0x33,0x33,0x33,0x00}, /* 'n' */
    {0x00,0x00,0x1E,0x33,0x33,0x33,0x1E,0x00}, /* 'o' */
    {0x00,0x00,0x3B,0x66,0x66,0x3E,0x06,0x0F}, /* 'p' */
    {0x00,0x00,0x6E,0x33,0x33,0x3E,0x30,0x78}, /* 'q' */
    {0x00,0x00,0x3B,0x6E,0x66,0x06,0x0F,0x00}, /* 'r' */
    {0x00,0x00,0x3E,0x03,0x1E,0x30,0x1F,0x00}, /* 's' */
    {0x08,0x0C,0x3E,0x0C,0x0C,0x2C,0x18,0x00}, /* 't' */
    {0x00,0x00,0x33,0x33,0x33,0x33,0x6E,0x00}, /* 'u' */
    {0x00,0x00,0x33,0x33,0x33,0x1E,0x0C,0x00}, /* 'v' */
    {0x00,0x00,0x63,0x6B,0x7F,0x7F,0x36,0x00}, /* 'w' */
    {0x00,0x00,0x63,0x36,0x1C,0x36,0x63,0x00}, /* 'x' */
    {0x00,0x00,0x33,0x33,0x33,0x3E,0x30,0x1F}, /* 'y' */
    {0x00,0x00,0x3F,0x19,0x0C,0x26,0x3F,0x00}, /* 'z' */
    {0x38,0x0C,0x0C,0x07,0x0C,0x0C,0x38,0x00}, /* '{' */
    {0x18,0x18,0x18,0x00,0x18,0x18,0x18,0x00}, /* '|' */
    {0x07,0x0C,0x0C,0x38,0x0C,0x0C,0x07,0x00}, /* '}' */
    {0x6E,0x3B,0x00,0x00,0x00,0x00,0x00,0x00}, /* '~' */
};

/* ------------------------------------------------------------------ */
/* gpu_draw_char — tek karakter (scale=1: 8x8, scale=2: 16x16 vb.)    */
/* ------------------------------------------------------------------ */
void gpu_draw_char(int x, int y, char c, uint32_t color, int scale)
{
    int row, col, sx, sy;
    const uint8_t *glyph;
    int idx = (int)(unsigned char)c - 0x20;

    if (idx < 0 || idx >= 96) return;
    glyph = font8x8[idx];

    for (row = 0; row < 8; row++) {
        uint8_t bits = glyph[row];
        for (col = 0; col < 8; col++) {
            if (bits & (0x80u >> col)) {
                for (sy = 0; sy < scale; sy++)
                    for (sx = 0; sx < scale; sx++)
                        gpu_put_pixel_local(x + col*scale + sx,
                                            y + row*scale + sy, color);
            }
        }
    }
}

/* ------------------------------------------------------------------ */
/* gpu_draw_string — null-sonlandırmalı ASCII dize                     */
/* ------------------------------------------------------------------ */
void gpu_draw_string(int x, int y, const char *str, uint32_t color, int scale)
{
    int cx = x;
    int glyph_w = 8 * scale + scale; /* karakter genişliği + 1px boşluk */
    while (*str) {
        if (*str == '\n') {
            cx = x;
            y += 8 * scale + 2;
        } else {
            gpu_draw_char(cx, y, *str, color, scale);
            cx += glyph_w;
        }
        str++;
    }
}
