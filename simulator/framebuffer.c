/*
 * Oxalyn framebuffer çıkış katmanı — yalnızca C standard kütüphanesi.
 */
#include "framebuffer.h"

#include <stdio.h>

static void pixel_rgb(const uint8_t *pixel,
                      OxalynPixelFormat format,
                      uint8_t *red,
                      uint8_t *green,
                      uint8_t *blue)
{
    if (format == OXALYN_PIXEL_RGB565) {
        uint16_t value = (uint16_t)pixel[0] | ((uint16_t)pixel[1] << 8);
        *red = (uint8_t)(((value >> 11) & 0x1Fu) * 255u / 31u);
        *green = (uint8_t)(((value >> 5) & 0x3Fu) * 255u / 63u);
        *blue = (uint8_t)((value & 0x1Fu) * 255u / 31u);
    } else if (format == OXALYN_PIXEL_BGRA8) {
        *blue = pixel[0];
        *green = pixel[1];
        *red = pixel[2];
    } else {
        *red = pixel[0];
        *green = pixel[1];
        *blue = pixel[2];
    }
}

int oxalyn_frame_write_ppm(const char *path,
                           const uint8_t *pixels,
                           uint32_t width,
                           uint32_t height,
                           uint32_t pitch,
                           OxalynPixelFormat format)
{
    FILE *file;
    uint32_t x;
    uint32_t y;
    uint32_t bytes_per_pixel = format == OXALYN_PIXEL_RGB565 ? 2u : 4u;

    if (!path || !pixels || width == 0 || height == 0 ||
        pitch < width * bytes_per_pixel)
        return -1;

    file = fopen(path, "wb");
    if (!file)
        return -1;

    if (fprintf(file, "P6\n%u %u\n255\n", width, height) < 0) {
        fclose(file);
        return -1;
    }

    for (y = 0; y < height; y++) {
        const uint8_t *row = pixels + (size_t)y * pitch;
        for (x = 0; x < width; x++) {
            uint8_t rgb[3];
            pixel_rgb(row + x * bytes_per_pixel, format,
                      &rgb[0], &rgb[1], &rgb[2]);
            if (fwrite(rgb, 1, sizeof(rgb), file) != sizeof(rgb)) {
                fclose(file);
                return -1;
            }
        }
    }

    if (fclose(file) != 0)
        return -1;
    return 0;
}

void oxalyn_frame_print_ascii(const uint8_t *pixels,
                              uint32_t width,
                              uint32_t height,
                              uint32_t pitch,
                              OxalynPixelFormat format,
                              uint32_t max_width)
{
    static const char shades[] = " .:-=+*#%@";
    uint32_t output_width;
    uint32_t output_height;
    uint32_t x;
    uint32_t y;
    uint32_t bytes_per_pixel = format == OXALYN_PIXEL_RGB565 ? 2u : 4u;

    if (!pixels || width == 0 || height == 0 || max_width == 0)
        return;

    output_width = width < max_width ? width : max_width;
    output_height = (uint32_t)(((uint64_t)height * output_width) / width / 2u);
    if (output_height == 0)
        output_height = 1;

    for (y = 0; y < output_height; y++) {
        uint32_t source_y = (uint32_t)(((uint64_t)y * height) / output_height);
        const uint8_t *row = pixels + (size_t)source_y * pitch;
        for (x = 0; x < output_width; x++) {
            uint32_t source_x = (uint32_t)(((uint64_t)x * width) / output_width);
            uint8_t red;
            uint8_t green;
            uint8_t blue;
            unsigned brightness;
            unsigned shade;

            pixel_rgb(row + source_x * bytes_per_pixel, format,
                      &red, &green, &blue);
            brightness = (unsigned)red * 30u +
                         (unsigned)green * 59u +
                         (unsigned)blue * 11u;
            shade = (brightness * (sizeof(shades) - 2u)) / 25500u;
            putchar(shades[shade]);
        }
        putchar('\n');
    }
}