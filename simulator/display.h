/*
 * display.h — Oxalyn-64 Simülatörü Görsel Pencere Katmanı
 *
 * Desteklenen backend'ler (derleme bayrağı ile seç):
 *   -DOXALYN_DISPLAY_SDL2   : SDL2 — Windows + Linux + macOS (tavsiye edilen)
 *   -DOXALYN_DISPLAY_WIN32  : Windows API (GDI) — SDL2 olmadan Windows
 *   -DOXALYN_DISPLAY_X11    : X11/Xlib — SDL2 olmadan Linux
 *   (hiçbiri yok)           : no-op stub, pencere açılmaz
 *
 * Kullanım:
 *   display_open(800, 600, "HILAL_BIS — Oxalyn-64");
 *   while (cpu_running) {
 *       cpu_step_batch();
 *       display_update(pixels, 800, 600, 800*4);
 *       if (!display_poll()) break;   // pencere kapatıldıysa dur
 *   }
 *   display_close();
 */

#ifndef OXALYN_DISPLAY_H
#define OXALYN_DISPLAY_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * display_open — pencere aç.
 * width / height : piksel boyutu.
 * title          : pencere başlık çubuğu metni.
 * Döndürür       : 0 başarı, -1 hata.
 */
int display_open(int width, int height, const char *title);

/*
 * display_update — framebuffer'ı pencereye çiz.
 * pixels : RGBA8 veya BGRA8 bayt dizisi (sıra-ardışık).
 * width  : görüntü genişliği (piksel).
 * height : görüntü yüksekliği (piksel).
 * pitch  : satır başına bayt sayısı (genellikle width * 4).
 * Döndürür: 0 başarı, -1 hata.
 */
int display_update(const uint8_t *pixels, int width, int height, int pitch);

/*
 * display_poll — olay kuyruğunu boşalt.
 * Döndürür: 1 devam et, 0 pencere kapatıldı / ESC basıldı.
 */
int display_poll(void);

/*
 * display_close — pencereyi ve tüm kaynakları serbest bırak.
 */
void display_close(void);

#ifdef __cplusplus
}
#endif

#endif /* OXALYN_DISPLAY_H */
