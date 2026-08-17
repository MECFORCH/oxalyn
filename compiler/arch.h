/*
 * Oxalyn Compiler — mimari algılama ve backend eklenti arayüzü.
 *
 * Yeni mimari eklemek için:
 *   1. CompilerArchKind ve isim tablosuna ekle.
 *   2. detect_file() içinde dosya başlıklarını tanıt.
 *   3. backend tablosuna translate fonksiyonunu bağla.
 *
 * Backend bilinmeyen bir komutu sessizce çevirmemelidir; hata döndürmelidir.
 */
#ifndef OXALYN_COMPILER_ARCH_H
#define OXALYN_COMPILER_ARCH_H

#include <stddef.h>

typedef enum CompilerInputKind {
    COMPILER_INPUT_UNKNOWN = 0,
    COMPILER_INPUT_ASSEMBLY,
    COMPILER_INPUT_ELF,
    COMPILER_INPUT_PE,
    COMPILER_INPUT_MACHO,
    COMPILER_INPUT_WASM,
    COMPILER_INPUT_RAW_BINARY
} CompilerInputKind;

typedef enum CompilerArchKind {
    COMPILER_ARCH_UNKNOWN = 0,
    COMPILER_ARCH_OXALYN64,
    COMPILER_ARCH_X86_64,
    COMPILER_ARCH_ARM64,
    COMPILER_ARCH_RISCV64,
    COMPILER_ARCH_WASM
} CompilerArchKind;

typedef struct CompilerDetection {
    CompilerInputKind input_kind;
    CompilerArchKind arch;
    unsigned long machine;
    int bits;
    int little_endian;
    char detail[160];
} CompilerDetection;

typedef struct CompilerBackend {
    CompilerArchKind arch;
    const char *name;
    const char *description;
    int source_supported;
    int binary_input_supported;
} CompilerBackend;

const char *compiler_input_kind_name(CompilerInputKind kind);
const char *compiler_arch_name(CompilerArchKind arch);
CompilerArchKind compiler_arch_from_name(const char *name);
const CompilerBackend *compiler_backend_for(CompilerArchKind arch);
size_t compiler_backend_count(void);
const CompilerBackend *compiler_backend_at(size_t index);

int compiler_detect_file(const char *path, CompilerDetection *out);
int compiler_detect_bytes(const unsigned char *data, size_t size,
                          const char *path_hint, CompilerDetection *out);

#endif