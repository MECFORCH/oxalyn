#ifndef OXALYN_COMPILER_TRANSLATOR_H
#define OXALYN_COMPILER_TRANSLATOR_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "arch.h"

/*
 * Kaynak assembly'yi Oxalyn assembly'ye çevirir.
 *
 * Başarıda 0, çevrilemeyen veya desteklenmeyen satırda -1 döner.
 * error_buffer kullanıcıya gösterilebilir kısa bir hata içerir.
 */
int compiler_translate_source(CompilerArchKind arch,
                              const char *input_path,
                              const char *output_path,
                              char *error_buffer,
                              size_t error_capacity);

/*
 * WASM binary modülü Oxalyn-64 assembly'ye çevirir.
 * Başarıda 0, hata durumunda -1 döner.
 * error_buffer: NULL geçilebilir; sığarsa hata metni yazılır.
 */
int wasm_translate_module(const char *input_path,
                          const char *output_path,
                          char *error_buffer,
                          size_t error_capacity);

/*
 * Tek WASM fonksiyon gövdesini açık FILE*'a çevirir (birim test için).
 */
int wasm_translate_function(FILE *output,
                             const unsigned char *body,
                             size_t body_size,
                             unsigned func_index);

#endif