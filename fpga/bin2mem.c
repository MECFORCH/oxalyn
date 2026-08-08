/*
 * bin2mem.c — Oxalyn-64 binary -> Vivado-compatible .mem
 *
 * Input binaries contain consecutive big-endian 32-bit instructions.
 * Each instruction is written as one zero-extended 64-bit memory word by
 * default, matching the FPGA memory layout.
 *
 * Usage:
 *   bin2mem input.bin output.mem [--depth N] [--width 32|64]
 */

#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_DEPTH 65536u
#define DEFAULT_WIDTH 64u

static void usage(const char *program)
{
    fprintf(stderr,
            "Kullanım: %s input.bin output.mem [--depth N] [--width 32|64]\n",
            program);
}

static int parse_unsigned(const char *text, unsigned long *value)
{
    char *end = NULL;
    unsigned long parsed;

    errno = 0;
    parsed = strtoul(text, &end, 10);
    if (errno != 0 || end == text || *end != '\0') {
        return -1;
    }
    *value = parsed;
    return 0;
}

static uint32_t read_be32(const unsigned char bytes[4])
{
    return ((uint32_t)bytes[0] << 24) |
           ((uint32_t)bytes[1] << 16) |
           ((uint32_t)bytes[2] << 8) |
           (uint32_t)bytes[3];
}

int main(int argc, char **argv)
{
    const char *src_path;
    const char *dst_path;
    uint32_t *words;
    unsigned long depth = DEFAULT_DEPTH;
    unsigned long width = DEFAULT_WIDTH;
    size_t word_count = 0;
    FILE *src;
    FILE *dst;
    unsigned char bytes[4];
    size_t addr;

    if (argc < 3) {
        usage(argv[0]);
        return 2;
    }

    src_path = argv[1];
    dst_path = argv[2];

    for (int i = 3; i < argc; i++) {
        unsigned long parsed;

        if (strcmp(argv[i], "--depth") == 0 && i + 1 < argc) {
            if (parse_unsigned(argv[++i], &parsed) != 0 || parsed == 0) {
                fprintf(stderr, "HATA: geçersiz bellek derinliği: %s\n",
                        argv[i]);
                return 2;
            }
            depth = parsed;
        } else if (strcmp(argv[i], "--width") == 0 && i + 1 < argc) {
            if (parse_unsigned(argv[++i], &parsed) != 0 ||
                (parsed != 32 && parsed != 64)) {
                fprintf(stderr, "HATA: kelime genişliği 32 veya 64 olmalı: %s\n",
                        argv[i]);
                return 2;
            }
            width = parsed;
        } else {
            usage(argv[0]);
            return 2;
        }
    }

    if (depth > SIZE_MAX / sizeof(*words)) {
        fprintf(stderr, "HATA: bellek derinliği çok büyük\n");
        return 2;
    }

    words = calloc((size_t)depth, sizeof(*words));
    if (words == NULL) {
        fprintf(stderr, "HATA: %lu kelimelik bellek ayrılamadı\n", depth);
        return 1;
    }

    src = fopen(src_path, "rb");
    if (src == NULL) {
        fprintf(stderr, "HATA: '%s' açılamadı: %s\n",
                src_path, strerror(errno));
        free(words);
        return 1;
    }

    while (1) {
        size_t bytes_read = fread(bytes, 1, sizeof(bytes), src);

        if (bytes_read == 0) {
            if (ferror(src)) {
                fprintf(stderr, "HATA: '%s' okunamadı\n", src_path);
                fclose(src);
                free(words);
                return 1;
            }
            break;
        }
        if (bytes_read != sizeof(bytes)) {
            fprintf(stderr,
                    "UYARI: Binary boyutu 4'ün katı değil (%zu baytlık "
                    "kısmi kelime atlandı)\n", bytes_read);
            break;
        }
        if (word_count >= (size_t)depth) {
            fprintf(stderr,
                    "HATA: Binary çok büyük (%zu kelime > %lu kelime kapasitesi)\n",
                    word_count + 1, depth);
            fclose(src);
            free(words);
            return 1;
        }
        words[word_count++] = read_be32(bytes);
    }

    if (fclose(src) != 0) {
        fprintf(stderr, "HATA: '%s' kapatılamadı\n", src_path);
        free(words);
        return 1;
    }

    dst = fopen(dst_path, "w");
    if (dst == NULL) {
        fprintf(stderr, "HATA: '%s' oluşturulamadı: %s\n",
                dst_path, strerror(errno));
        free(words);
        return 1;
    }

    for (addr = 0; addr < (size_t)depth; addr++) {
        uint32_t value = (addr < word_count) ? words[addr] : 0;

        if (width == 64) {
            if (fprintf(dst, "%016" PRIX32 "\n", value) < 0) {
                fprintf(stderr, "HATA: '%s' yazılamadı\n", dst_path);
                fclose(dst);
                free(words);
                return 1;
            }
        } else if (fprintf(dst, "%08" PRIX32 "\n", value) < 0) {
            fprintf(stderr, "HATA: '%s' yazılamadı\n", dst_path);
            fclose(dst);
            free(words);
            return 1;
        }
    }

    if (fclose(dst) != 0) {
        fprintf(stderr, "HATA: '%s' kapatılamadı\n", dst_path);
        free(words);
        return 1;
    }

    printf("OK  %zu komut -> %s\n", word_count, dst_path);
    printf("    Bellek kullanımı: %zu/%lu kelime (%lu%%)\n",
           word_count, depth, (word_count * 100u) / depth);
    free(words);
    return 0;
}