/*
 * Oxalyn framebuffer çıkış katmanı.
 *
 * Harici pencere kütüphanesi kullanmaz. Aynı framebuffer'ı PPM olarak
 * kaydedebilir veya terminalde düşük çözünürlüklü bir önizleme gösterebilir.
 */
#ifndef OXALYN_FRAMEBUFFER_H
#define OXALYN_FRAMEBUFFER_H

#include <stdint.h>

typedef enum OxalynPixelFormat {
    OXALYN_PIXEL_RGBA8 = 0,
    OXALYN_PIXEL_BGRA8 = 1,
    OXALYN_PIXEL_RGB565 = 2
} OxalynPixelFormat;

int oxalyn_frame_write_ppm(const char *path,
                           const uint8_t *pixels,
                           uint32_t width,
                           uint32_t height,
                           uint32_t pitch,
                           OxalynPixelFormat format);

void oxalyn_frame_print_ascii(const uint8_t *pixels,
                              uint32_t width,
                              uint32_t height,
                              uint32_t pitch,
                              OxalynPixelFormat format,
                              uint32_t max_width);

#endif