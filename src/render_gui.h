#ifndef OXALYN_RENDER_GUI_H
#define OXALYN_RENDER_GUI_H

#include <stdint.h>
#include "world.h"

/*
 * Kamera yapısı — voxel_gui.c ile paylaşılır.
 * Burada sadece forward-declare ediyoruz; asıl tanım voxel_gui.c'de.
 */
typedef struct Camera Camera;

/*
 * Gravityon software rasterizer kullanarak dünyayı render eder ve
 * sonucu BGRA8 formatında 'out_bgra' buffer'ına yazar.
 * 'out_bgra' boyutu: width * height * 4 byte.
 */
int render_to_bgra(World *world, const Camera *cam,
                   uint8_t *out_bgra, uint32_t width, uint32_t height);

#endif /* OXALYN_RENDER_GUI_H */
