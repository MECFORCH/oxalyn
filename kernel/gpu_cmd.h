/*
 * HILAL_BIS — GPU Komut Kuyruğu & Sprite Motoru
 *
 * Gravityon GPU için DMA-tarzı komut listesi, sprite sistemi ve
 * 2D dönüşüm (ölçek, döndürme, çevirme) desteği ekler.
 *
 * Mimari:
 *   - Uygulama komutları bir tampon kuyruğa yazar.
 *   - gpu_cmd_flush() kuyruğu işler, her komutu gpu_* primitifine çevirir.
 *   - Sprite'lar 8×8..64×64 piksel, RLE sıkıştırma isteğe bağlı.
 *   - 8 sprite yuvası, 16 tile şeridi.
 */

#ifndef GPU_CMD_H
#define GPU_CMD_H

#include <stdint.h>

/* ── Sabitler ─────────────────────────────────────────── */
#define GPU_CMD_QUEUE_SIZE   256    /* maksimum komut sayısı */
#ifdef OXALYN_GUI_RENDER_BUILD
/*
 * The ASCII boot-render image does not load sprite/tile assets.  Keep the
 * simulator image below the Oxalyn RAM window while preserving the normal
 * capacities for regular kernel builds.
 */
#define GPU_MAX_SPRITES      1
#define GPU_MAX_TILES        1
#define GPU_TILE_MAX_COUNT   4
#define GPU_SPRITE_MAX_W     16
#define GPU_SPRITE_MAX_H     16
#else
#define GPU_MAX_SPRITES      8
#define GPU_MAX_TILES        16
#define GPU_TILE_MAX_COUNT   256
#define GPU_SPRITE_MAX_W     64
#define GPU_SPRITE_MAX_H     64
#endif
#define GPU_TILE_W           8
#define GPU_TILE_H           8

/* ── Komut türleri ────────────────────────────────────── */
typedef enum {
    GPU_CMD_NOP         = 0,
    GPU_CMD_CLEAR       = 1,   /* renk ile ekranı sil */
    GPU_CMD_PIXEL       = 2,   /* tek piksel */
    GPU_CMD_LINE        = 3,   /* çizgi */
    GPU_CMD_RECT        = 4,   /* dolu dikdörtgen */
    GPU_CMD_RECT_BORDER = 5,   /* kenarlıklı dikdörtgen */
    GPU_CMD_CIRCLE      = 6,   /* halka */
    GPU_CMD_FILL_CIRCLE = 7,   /* dolu daire */
    GPU_CMD_SPRITE      = 8,   /* sprite çiz */
    GPU_CMD_TILE        = 9,   /* tile çiz */
    GPU_CMD_STRING      = 10,  /* metin */
    GPU_CMD_BLIT        = 11,  /* ham piksel bloğu kopyala */
    GPU_CMD_SCROLL      = 12,  /* framebuffer'ı kaydır */
    GPU_CMD_FLIP        = 13,  /* yatay/dikey aynala */
    GPU_CMD_ALPHA_RECT  = 14,  /* alfa karışımlı dikdörtgen */
    GPU_CMD_PRESENT     = 15,  /* ekranı güncelle */
} GpuCmdType;

/* ── Komut yükü (en büyük alana göre boyutlandırılmış birleşim) ── */
typedef struct {
    GpuCmdType type;
    union {
        /* CLEAR */
        struct { uint32_t color; }                              clear;
        /* PIXEL */
        struct { int16_t x, y; uint32_t color; }               pixel;
        /* LINE */
        struct { int16_t x1,y1,x2,y2; uint32_t color; }       line;
        /* RECT / RECT_BORDER / ALPHA_RECT */
        struct { int16_t x,y,w,h; uint32_t color; uint8_t alpha; } rect;
        /* CIRCLE / FILL_CIRCLE */
        struct { int16_t cx,cy,r; uint32_t color; }            circle;
        /* SPRITE */
        struct {
            uint8_t  slot;
            int16_t  x, y;
            uint8_t  scale;      /* 1–4 */
            uint8_t  flip_h;     /* 0/1 */
            uint8_t  flip_v;     /* 0/1 */
            uint8_t  alpha;      /* 0=tam saydam, 255=opak */
        } sprite;
        /* TILE */
        struct {
            uint8_t  strip;      /* tile şerit indeksi */
            uint8_t  tile_idx;   /* şeritteki karo indeksi */
            int16_t  x, y;
            uint8_t  scale;
        } tile;
        /* STRING */
        struct {
            int16_t  x, y;
            uint32_t color;
            uint8_t  scale;
            char     text[64];
        } string;
        /* BLIT */
        struct {
            int16_t   dst_x, dst_y;
            int16_t   src_x, src_y;
            int16_t   w, h;
            int16_t   src_pitch;
            const uint32_t *pixels;
        } blit;
        /* SCROLL */
        struct { int16_t dx, dy; uint32_t fill_color; } scroll;
        /* FLIP */
        struct { uint8_t horiz; uint8_t vert; }         flip;
    };
} GpuCmd;

/* ── Sprite tanımı ────────────────────────────────────── */
typedef struct {
    uint32_t pixels[GPU_SPRITE_MAX_W * GPU_SPRITE_MAX_H]; /* RGBA8 */
    uint8_t  w, h;
    uint8_t  color_key_en;   /* 1=saydam renk etkin */
    uint32_t color_key;      /* bu renk saydam sayılır */
    int      used;
} GpuSprite;

/* ── Tile şeridi ──────────────────────────────────────── */
typedef struct {
    uint32_t pixels[GPU_TILE_W * GPU_TILE_H * GPU_TILE_MAX_COUNT];
    /* maks GPU_TILE_MAX_COUNT karo */
    uint8_t  tile_count;
    int      used;
} GpuTileStrip;

/* ── API ───────────────────────────────────────────────── */

/* Sistemi başlat */
void gpu_cmd_init(void);

/* Kuyruğa komut ekle (kopyalanır) */
int  gpu_cmd_push(const GpuCmd *cmd);

/* Kuyruğu hemen işle ve temizle */
void gpu_cmd_flush(void);

/* Kuyruğu yalnızca temizle (çizme yapma) */
void gpu_cmd_reset(void);

/* Kaç komut bekliyor? */
int  gpu_cmd_pending(void);

/* Kolaylık sarıcılar — doğrudan kuyruğa ekler */
void gcmd_clear(uint32_t color);
void gcmd_pixel(int x, int y, uint32_t color);
void gcmd_line(int x1, int y1, int x2, int y2, uint32_t color);
void gcmd_rect(int x, int y, int w, int h, uint32_t color);
void gcmd_rect_border(int x, int y, int w, int h, uint32_t color);
void gcmd_circle(int cx, int cy, int r, uint32_t color);
void gcmd_fill_circle(int cx, int cy, int r, uint32_t color);
void gcmd_string(int x, int y, const char *text, uint32_t color, int scale);
void gcmd_sprite(uint8_t slot, int x, int y, uint8_t scale,
                 uint8_t flip_h, uint8_t flip_v, uint8_t alpha);
void gcmd_tile(uint8_t strip, uint8_t tile_idx, int x, int y, uint8_t scale);
void gcmd_scroll(int dx, int dy, uint32_t fill);
void gcmd_flip(uint8_t horiz, uint8_t vert);
void gcmd_present(void);

/* ── Sprite yönetimi ──────────────────────────────────── */

/* Sprite yükle (ham piksel dizisi, RGBA8) */
int  gpu_sprite_load(uint8_t slot, const uint32_t *pixels,
                     uint8_t w, uint8_t h);

/* Saydam renk anahtarı ayarla */
void gpu_sprite_set_color_key(uint8_t slot, uint32_t color);

/* Sprite'ı boşalt */
void gpu_sprite_free(uint8_t slot);

/* ── Tile yönetimi ────────────────────────────────────── */

/* Tile şeridini yükle (her karo 8×8, RGBA8) */
int  gpu_tile_load_strip(uint8_t strip_id, const uint32_t *pixels,
                         uint8_t tile_count);

/* 2D harita çiz */
void gpu_tile_draw_map(uint8_t strip_id, const uint8_t *map,
                       int map_w, int map_h,
                       int screen_x, int screen_y, uint8_t scale);

#endif /* GPU_CMD_H */
