/*
 * HILAL_BIS — GPU Komut Kuyruğu & Sprite/Tile Motoru
 *
 * DMA-tarzı komut listesi: uygulama komutları tampon kuyruğa yazar,
 * gpu_cmd_flush() hepsini işler. Sprite ve tile sistemi de burada.
 */

#include "gpu_cmd.h"
#include "gpu.h"
#include "kstring.h"
#include "platform.h"

/* ── Kuyruk ───────────────────────────────────────────────────────── */
static GpuCmd     cmd_queue[GPU_CMD_QUEUE_SIZE];
static int        cmd_head = 0;   /* bir sonraki yazma pozisyonu */

/* ── Sprite ve tile deposi ───────────────────────────────────────── */
static GpuSprite    sprites[GPU_MAX_SPRITES];
static GpuTileStrip tile_strips[GPU_MAX_TILES];

/* ── Yardımcılar ─────────────────────────────────────────────────── */
static int abs_i(int v) { (void)v; return 0; } /* reserved for future use */

/* ── gpu_cmd_init ─────────────────────────────────────────────────── */
void gpu_cmd_init(void)
{
    int i;
    cmd_head = 0;
    for (i = 0; i < GPU_MAX_SPRITES;   i++) sprites[i].used     = 0;
    for (i = 0; i < GPU_MAX_TILES;     i++) tile_strips[i].used  = 0;
        KPRINT("[GPU_CMD] Komut kuyruğu hazır (%d yuva)\n", GPU_CMD_QUEUE_SIZE);
}

/* ── gpu_cmd_push ─────────────────────────────────────────────────── */
int gpu_cmd_push(const GpuCmd *cmd)
{
    if (cmd_head >= GPU_CMD_QUEUE_SIZE) {
        KPRINT("[GPU_CMD] Kuyruk dolu — otomatik flush\n");
        gpu_cmd_flush();
    }
    kmemcpy(&cmd_queue[cmd_head++], cmd, sizeof(GpuCmd));
    return 0;
}

/* ── gpu_cmd_reset ────────────────────────────────────────────────── */
void gpu_cmd_reset(void) { cmd_head = 0; }

/* ── gpu_cmd_pending ──────────────────────────────────────────────── */
int gpu_cmd_pending(void) { return cmd_head; }

/* ── Dahili: sprite pikselini framebuffer'a yaz (alfa + renk anahtarı) ─ */
static void blit_sprite_pixel(int sx, int sy, uint32_t px, uint8_t alpha)
{
    uint32_t a;
    if (alpha == 0) return;
    /* Alfa < 255 → basit karışım (gpu_put_pixel_alpha zaten var) */
    a = (px >> 24) & 0xFFu;
    /* Komuttan gelen genel alfa ile sprite'ın kendi alfasını çarp */
    a = (a * alpha) >> 8;
    px = (px & 0x00FFFFFFu) | (a << 24);
    gpu_put_pixel_alpha(sx, sy, px);
}

/* ── Dahili: tek karo çiz ─────────────────────────────────────────── */
static void draw_tile(uint8_t strip_id, uint8_t tile_idx,
                      int dx, int dy, uint8_t scale)
{
    GpuTileStrip *strip;
    const uint32_t *src;
    int row, col, sy, sx;

    if (strip_id >= GPU_MAX_TILES) return;
    strip = &tile_strips[strip_id];
    if (!strip->used || tile_idx >= strip->tile_count) return;

    src = strip->pixels + (int)tile_idx * GPU_TILE_W * GPU_TILE_H;
    for (row = 0; row < GPU_TILE_H; row++) {
        for (col = 0; col < GPU_TILE_W; col++) {
            uint32_t px = src[row * GPU_TILE_W + col];
            int s;
            for (sy = 0; sy < scale; sy++)
                for (s = 0, sx = 0; sx < scale; sx++, s++)
                    gpu_put_pixel_alpha(dx + col*scale + sx,
                                       dy + row*scale + sy, px);
        }
    }
}

/* ── gpu_cmd_flush ────────────────────────────────────────────────── */
void gpu_cmd_flush(void)
{
    int i;
    for (i = 0; i < cmd_head; i++) {
        GpuCmd *c = &cmd_queue[i];
        switch (c->type) {

        case GPU_CMD_NOP:
            break;

        case GPU_CMD_CLEAR:
            gpu_clear(c->clear.color);
            break;

        case GPU_CMD_PIXEL:
            gpu_put_pixel(c->pixel.x, c->pixel.y, c->pixel.color);
            break;

        case GPU_CMD_LINE:
            gpu_draw_line(c->line.x1, c->line.y1,
                          c->line.x2, c->line.y2, c->line.color);
            break;

        case GPU_CMD_RECT:
        case GPU_CMD_ALPHA_RECT:
            if (c->type == GPU_CMD_ALPHA_RECT && c->rect.alpha < 255) {
                /* Alfa karışımlı dolgu: her piksel ayrı */
                int rx, ry;
                uint32_t col = (c->rect.color & 0x00FFFFFFu) |
                               ((uint32_t)c->rect.alpha << 24);
                for (ry = c->rect.y; ry < c->rect.y + c->rect.h; ry++)
                    for (rx = c->rect.x; rx < c->rect.x + c->rect.w; rx++)
                        gpu_put_pixel_alpha(rx, ry, col);
            } else {
                gpu_draw_rect(c->rect.x, c->rect.y,
                              c->rect.w, c->rect.h, c->rect.color);
            }
            break;

        case GPU_CMD_RECT_BORDER: {
            int x = c->rect.x, y = c->rect.y,
                w = c->rect.w, h = c->rect.h;
            uint32_t col = c->rect.color;
            /* Dört kenar */
            gpu_draw_line(x,     y,     x+w-1, y,     col);
            gpu_draw_line(x,     y+h-1, x+w-1, y+h-1, col);
            gpu_draw_line(x,     y,     x,     y+h-1, col);
            gpu_draw_line(x+w-1, y,     x+w-1, y+h-1, col);
            break;
        }

        case GPU_CMD_CIRCLE:
            gpu_draw_circle(c->circle.cx, c->circle.cy,
                            c->circle.r,  c->circle.color);
            break;

        case GPU_CMD_FILL_CIRCLE:
            gpu_fill_circle(c->circle.cx, c->circle.cy,
                            c->circle.r,  c->circle.color);
            break;

        case GPU_CMD_STRING:
            gpu_draw_string(c->string.x, c->string.y, c->string.text,
                            c->string.color, c->string.scale);
            break;

        case GPU_CMD_SPRITE: {
            GpuSprite *spr;
            int row, col, drow, dcol;
            if (c->sprite.slot >= GPU_MAX_SPRITES) break;
            spr = &sprites[c->sprite.slot];
            if (!spr->used) break;

            for (row = 0; row < spr->h; row++) {
                for (col = 0; col < spr->w; col++) {
                    int src_col = c->sprite.flip_h ? (spr->w - 1 - col) : col;
                    int src_row = c->sprite.flip_v ? (spr->h - 1 - row) : row;
                    uint32_t px = spr->pixels[src_row * spr->w + src_col];

                    /* Renk anahtarı kontrolü */
                    if (spr->color_key_en &&
                        (px & 0x00FFFFFFu) == (spr->color_key & 0x00FFFFFFu))
                        continue;

                    /* Ölçekli çiz */
                    for (drow = 0; drow < c->sprite.scale; drow++)
                        for (dcol = 0; dcol < c->sprite.scale; dcol++)
                            blit_sprite_pixel(
                                c->sprite.x + col * c->sprite.scale + dcol,
                                c->sprite.y + row * c->sprite.scale + drow,
                                px, c->sprite.alpha);
                }
            }
            break;
        }

        case GPU_CMD_TILE:
            draw_tile(c->tile.strip, c->tile.tile_idx,
                      c->tile.x, c->tile.y, c->tile.scale);
            break;

        case GPU_CMD_BLIT: {
            int brow, bcol;
            for (brow = 0; brow < c->blit.h; brow++)
                for (bcol = 0; bcol < c->blit.w; bcol++) {
                    uint32_t px = c->blit.pixels[
                        (c->blit.src_y + brow) * (c->blit.src_pitch / 4) +
                         c->blit.src_x + bcol];
                    gpu_put_pixel(c->blit.dst_x + bcol,
                                  c->blit.dst_y + brow, px);
                }
            break;
        }

        case GPU_CMD_SCROLL: {
            /* Kayan pencere: tüm framebuffer'ı dx,dy kaydır.
               Boşalan alanı fill_color ile doldur.
               Basit implementasyon: satır/sütun döngüsü. */
        
            /* Simülatörde framebuffer'a doğrudan erişim yok;
               gpu_draw_rect ile boşluğu doldur, mevcut içeriği
               kaydıramayız. Kayan işlemi yaklaşık uygula:
               fill + kayan bölgeyi çiz  */
            (void)c;
            /* TODO: gerçek framebuffer erişiminde memmove kullan */
            KPRINT("[GPU_CMD] SCROLL: dx=%d dy=%d (simulated)\n",
                    c->scroll.dx, c->scroll.dy);
            break;
        }

        case GPU_CMD_FLIP:
            /* Simülatörde tam aynalama için framebuffer erişimi gerekir.
               Donanımda GPU_CTRL registerına FLIP_H/FLIP_V biti yaz. */
            KPRINT("[GPU_CMD] FLIP: h=%d v=%d (hw mode only)\n",
                    c->flip.horiz, c->flip.vert);
            break;

        case GPU_CMD_PRESENT:
            gpu_present();
            break;

        default:
            KPRINT("[GPU_CMD] Bilinmeyen komut: %d\n", (int)c->type);
            break;
        }
    }
    cmd_head = 0;   /* kuyruk temizle */
}

/* ── Kolaylık sarıcılar ───────────────────────────────────────────── */
#define PUSH(cmd) gpu_cmd_push(&(GpuCmd)(cmd))

void gcmd_clear(uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_CLEAR; c.clear.color=color; gpu_cmd_push(&c); }

void gcmd_pixel(int x, int y, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_PIXEL; c.pixel.x=(int16_t)x; c.pixel.y=(int16_t)y; c.pixel.color=color; gpu_cmd_push(&c); }

void gcmd_line(int x1, int y1, int x2, int y2, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_LINE; c.line.x1=(int16_t)x1; c.line.y1=(int16_t)y1; c.line.x2=(int16_t)x2; c.line.y2=(int16_t)y2; c.line.color=color; gpu_cmd_push(&c); }

void gcmd_rect(int x, int y, int w, int h, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_RECT; c.rect.x=(int16_t)x; c.rect.y=(int16_t)y; c.rect.w=(int16_t)w; c.rect.h=(int16_t)h; c.rect.color=color; c.rect.alpha=255; gpu_cmd_push(&c); }

void gcmd_rect_border(int x, int y, int w, int h, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_RECT_BORDER; c.rect.x=(int16_t)x; c.rect.y=(int16_t)y; c.rect.w=(int16_t)w; c.rect.h=(int16_t)h; c.rect.color=color; c.rect.alpha=255; gpu_cmd_push(&c); }

void gcmd_circle(int cx, int cy, int r, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_CIRCLE; c.circle.cx=(int16_t)cx; c.circle.cy=(int16_t)cy; c.circle.r=(int16_t)r; c.circle.color=color; gpu_cmd_push(&c); }

void gcmd_fill_circle(int cx, int cy, int r, uint32_t color)
{ GpuCmd c; c.type=GPU_CMD_FILL_CIRCLE; c.circle.cx=(int16_t)cx; c.circle.cy=(int16_t)cy; c.circle.r=(int16_t)r; c.circle.color=color; gpu_cmd_push(&c); }

void gcmd_string(int x, int y, const char *text, uint32_t color, int scale)
{
    GpuCmd c;
    c.type = GPU_CMD_STRING;
    c.string.x=(int16_t)x; c.string.y=(int16_t)y;
    c.string.color=color; c.string.scale=(uint8_t)scale;
    kstrncpy(c.string.text, text, 63); c.string.text[63]='\0';
    gpu_cmd_push(&c);
}

void gcmd_sprite(uint8_t slot, int x, int y, uint8_t scale,
                 uint8_t flip_h, uint8_t flip_v, uint8_t alpha)
{
    GpuCmd c;
    c.type=GPU_CMD_SPRITE;
    c.sprite.slot=slot; c.sprite.x=(int16_t)x; c.sprite.y=(int16_t)y;
    c.sprite.scale=scale; c.sprite.flip_h=flip_h; c.sprite.flip_v=flip_v;
    c.sprite.alpha=alpha;
    gpu_cmd_push(&c);
}

void gcmd_tile(uint8_t strip, uint8_t tile_idx, int x, int y, uint8_t scale)
{
    GpuCmd c;
    c.type=GPU_CMD_TILE;
    c.tile.strip=strip; c.tile.tile_idx=tile_idx;
    c.tile.x=(int16_t)x; c.tile.y=(int16_t)y; c.tile.scale=scale;
    gpu_cmd_push(&c);
}

void gcmd_scroll(int dx, int dy, uint32_t fill)
{
    GpuCmd c;
    c.type=GPU_CMD_SCROLL;
    c.scroll.dx=(int16_t)dx; c.scroll.dy=(int16_t)dy; c.scroll.fill_color=fill;
    gpu_cmd_push(&c);
}

void gcmd_flip(uint8_t horiz, uint8_t vert)
{ GpuCmd c; c.type=GPU_CMD_FLIP; c.flip.horiz=horiz; c.flip.vert=vert; gpu_cmd_push(&c); }

void gcmd_present(void)
{ GpuCmd c; c.type=GPU_CMD_PRESENT; gpu_cmd_push(&c); }

/* ── Sprite yönetimi ─────────────────────────────────────────────── */
int gpu_sprite_load(uint8_t slot, const uint32_t *pixels, uint8_t w, uint8_t h)
{
    GpuSprite *spr;
    int total;
    if (slot >= GPU_MAX_SPRITES) return -1;
    spr = &sprites[slot];
    total = (int)w * (int)h;
    if (total > GPU_SPRITE_MAX_W * GPU_SPRITE_MAX_H) return -1;

    kmemcpy(spr->pixels, pixels, (size_t)(total * 4));
    spr->w            = w;
    spr->h            = h;
    spr->color_key_en = 0;
    spr->color_key    = 0;
    spr->used         = 1;
    KPRINT("[GPU_CMD] Sprite %d yuklendi (%dx%d)\n", slot, w, h);
    return 0;
}

void gpu_sprite_set_color_key(uint8_t slot, uint32_t color)
{
    if (slot >= GPU_MAX_SPRITES || !sprites[slot].used) return;
    sprites[slot].color_key_en = 1;
    sprites[slot].color_key    = color;
}

void gpu_sprite_free(uint8_t slot)
{
    if (slot >= GPU_MAX_SPRITES) return;
    sprites[slot].used = 0;
}

/* ── Tile yönetimi ────────────────────────────────────────────────── */
int gpu_tile_load_strip(uint8_t strip_id, const uint32_t *pixels,
                        uint8_t tile_count)
{
    GpuTileStrip *strip;
    int total;
    if (strip_id >= GPU_MAX_TILES) return -1;
    strip = &tile_strips[strip_id];
    total = (int)tile_count * GPU_TILE_W * GPU_TILE_H;

    kmemcpy(strip->pixels, pixels, (size_t)(total * 4));
    strip->tile_count = tile_count;
    strip->used       = 1;
    KPRINT("[GPU_CMD] Tile serit %d yuklendi (%d karo)\n", strip_id, tile_count);
    return 0;
}

void gpu_tile_draw_map(uint8_t strip_id, const uint8_t *map,
                       int map_w, int map_h,
                       int screen_x, int screen_y, uint8_t scale)
{
    int row, col;
    int tile_size = GPU_TILE_W * scale;
    for (row = 0; row < map_h; row++)
        for (col = 0; col < map_w; col++)
            draw_tile(strip_id, map[row * map_w + col],
                      screen_x + col * tile_size,
                      screen_y + row * tile_size, scale);
}
