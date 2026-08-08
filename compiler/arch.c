/*
 * Oxalyn Compiler — portable file/header detection.
 *
 * Bu dosya yalnızca standart C kütüphanesini kullanır. ELF, PE/COFF,
 * Mach-O, WebAssembly ve kaynak uzantılarını tanır.
 */
#include "arch.h"

#include <stdio.h>
#include <string.h>
#include <ctype.h>

static const CompilerBackend BACKENDS[] = {
    { COMPILER_ARCH_OXALYN64, "oxalyn64",
      "Oxalyn-64 assembly kaynağı ve Oxalyn .bin üretimi", 1, 0 },
    { COMPILER_ARCH_X86_64, "x86-64",
      "x86-64 assembly/ELF/PE/Mach-O backend'i", 1, 0 },
    { COMPILER_ARCH_ARM64, "arm64",
      "AArch64 assembly/ELF/PE/Mach-O backend'i", 1, 0 },
    { COMPILER_ARCH_RISCV64, "riscv64",
      "RISC-V 64 assembly/ELF backend'i", 1, 0 },
    { COMPILER_ARCH_WASM, "wasm",
      "WebAssembly modül tanıma; decoder backend'i", 0, 0 }
};

static unsigned short read_u16(const unsigned char *p, int little)
{
    if (little)
        return (unsigned short)p[0] | ((unsigned short)p[1] << 8);
    return ((unsigned short)p[0] << 8) | (unsigned short)p[1];
}

static unsigned long read_u32(const unsigned char *p, int little)
{
    if (little)
        return (unsigned long)p[0] |
               ((unsigned long)p[1] << 8) |
               ((unsigned long)p[2] << 16) |
               ((unsigned long)p[3] << 24);
    return ((unsigned long)p[3]) |
           ((unsigned long)p[2] << 8) |
           ((unsigned long)p[1] << 16) |
           ((unsigned long)p[0] << 24);
}

static unsigned long read_macho_u32(const unsigned char *p, int swapped)
{
    return read_u32(p, swapped ? 0 : 1);
}

static int has_extension(const char *path, const char *extension)
{
    const char *dot;
    size_t i;

    if (!path || !extension)
        return 0;
    dot = strrchr(path, '.');
    if (!dot)
        return 0;
    for (i = 0; dot[i] && extension[i]; i++) {
        if (tolower((unsigned char)dot[i]) !=
            tolower((unsigned char)extension[i]))
            return 0;
    }
    return dot[i] == '\0' && extension[i] == '\0';
}

static int looks_like_oxalyn_source(const unsigned char *data, size_t size)
{
    static const char *tokens[] = {
        "HALT", "LI ", "ADD ", "SUB ", "LOAD ", "STORE ",
        "JMP ", "JZ ", "JNZ ", "OUT ", "IN ", "R31"
    };
    size_t i;
    size_t token;

    for (i = 0; i + 4 < size; i++) {
        for (token = 0; token < sizeof(tokens) / sizeof(tokens[0]); token++) {
            size_t length = strlen(tokens[token]);
            if (i + length <= size &&
                memcmp(data + i, tokens[token], length) == 0)
                return 1;
        }
    }
    return 0;
}

static int contains_text(const unsigned char *data, size_t size,
                         const char *needle)
{
    size_t needle_size = strlen(needle);
    size_t i;

    if (!needle_size || needle_size > size)
        return 0;
    for (i = 0; i + needle_size <= size; i++)
        if (memcmp(data + i, needle, needle_size) == 0)
            return 1;
    return 0;
}

static CompilerArchKind detect_assembly_arch(const unsigned char *data,
                                             size_t size)
{
    /*
     * .asm/.oxs Oxalyn'a ayrılmıştır. .s/.S taşınabilir assembly uzantısıdır;
     * burada yalnızca ayırt edici register/mnemonic izleri kullanılır.
     */
    if (contains_text(data, size, "%rax") ||
        contains_text(data, size, "%rsp") ||
        contains_text(data, size, "rax") ||
        contains_text(data, size, "syscall") ||
        contains_text(data, size, "movq"))
        return COMPILER_ARCH_X86_64;
    if (contains_text(data, size, "addi") ||
        contains_text(data, size, "ecall") ||
        contains_text(data, size, " a0") ||
        contains_text(data, size, "\na0") ||
        contains_text(data, size, "li a") ||
        contains_text(data, size, "jal"))
        return COMPILER_ARCH_RISCV64;
    if (contains_text(data, size, "mov x") ||
        contains_text(data, size, "xzr") ||
        contains_text(data, size, "w0") ||
        contains_text(data, size, "movz") ||
        contains_text(data, size, "stp ") ||
        contains_text(data, size, "adrp"))
        return COMPILER_ARCH_ARM64;
    /*
     * Sadece x0/x1 gibi ortak register isimleri görüldüğünde güvenilir
     * otomatik seçim yapılamaz. Kullanıcı --arch vermelidir.
     */
    return COMPILER_ARCH_UNKNOWN;
}

static void reset_detection(CompilerDetection *out)
{
    memset(out, 0, sizeof(*out));
    out->input_kind = COMPILER_INPUT_UNKNOWN;
    out->arch = COMPILER_ARCH_UNKNOWN;
    out->bits = 0;
    out->little_endian = 1;
}

static void set_detail(CompilerDetection *out, const char *text)
{
    snprintf(out->detail, sizeof(out->detail), "%s", text);
}

int compiler_detect_bytes(const unsigned char *data, size_t size,
                          const char *path_hint, CompilerDetection *out)
{
    int little;

    if (!out)
        return -1;
    reset_detection(out);

    if (size >= 4 && data[0] == 0x00 && data[1] == 'a' &&
        data[2] == 's' && data[3] == 'm') {
        out->input_kind = COMPILER_INPUT_WASM;
        out->arch = COMPILER_ARCH_WASM;
        out->bits = 32;
        set_detail(out, "WebAssembly binary module");
        return 0;
    }

    if (size >= 20 && data[0] == 0x7f && data[1] == 'E' &&
        data[2] == 'L' && data[3] == 'F') {
        out->input_kind = COMPILER_INPUT_ELF;
        out->bits = data[4] == 2 ? 64 : data[4] == 1 ? 32 : 0;
        little = data[5] == 1;
        out->little_endian = little;
        out->machine = read_u16(data + 18, little);
        switch (out->machine) {
        case 62:  out->arch = COMPILER_ARCH_X86_64; break;
        case 183: out->arch = COMPILER_ARCH_ARM64; break;
        case 243: out->arch = COMPILER_ARCH_RISCV64; break;
        default:  out->arch = COMPILER_ARCH_UNKNOWN; break;
        }
        snprintf(out->detail, sizeof(out->detail),
                 "ELF%d %s, e_machine=%lu",
                 out->bits, little ? "little-endian" : "big-endian",
                 out->machine);
        return 0;
    }

    if (size >= 64 && data[0] == 'M' && data[1] == 'Z') {
        unsigned long pe_offset = read_u32(data + 0x3c, 1);
        if (pe_offset + 6 <= size &&
            data[pe_offset] == 'P' && data[pe_offset + 1] == 'E' &&
            data[pe_offset + 2] == 0 && data[pe_offset + 3] == 0) {
            unsigned short machine = read_u16(data + pe_offset + 4, 1);
            out->input_kind = COMPILER_INPUT_PE;
            out->machine = machine;
            out->little_endian = 1;
            out->bits = machine == 0x8664 || machine == 0xAA64 ? 64 : 32;
            if (machine == 0x8664)
                out->arch = COMPILER_ARCH_X86_64;
            else if (machine == 0xAA64)
                out->arch = COMPILER_ARCH_ARM64;
            snprintf(out->detail, sizeof(out->detail),
                     "PE/COFF, machine=0x%04X", machine);
            return 0;
        }
    }

    if (size >= 8) {
        unsigned long magic = read_u32(data, 0);
        int swapped = 0;
        if (magic == 0xFEEDFACF || magic == 0xFEEDFACE)
            swapped = 0;
        else if (magic == 0xCFFAEDFE || magic == 0xCEFAEDFE)
            swapped = 1;
        else
            magic = 0;

        if (magic) {
            unsigned long cpu = read_macho_u32(data + 4, swapped);
            out->input_kind = COMPILER_INPUT_MACHO;
            out->machine = cpu;
            out->little_endian = !swapped;
            out->bits = (magic == 0xFEEDFACF || magic == 0xCFFAEDFE) ? 64 : 32;
            if (cpu == 0x01000007)
                out->arch = COMPILER_ARCH_X86_64;
            else if (cpu == 0x0100000C)
                out->arch = COMPILER_ARCH_ARM64;
            snprintf(out->detail, sizeof(out->detail),
                     "Mach-O%d, cputype=0x%08lX", out->bits, cpu);
            return 0;
        }
    }

    if (has_extension(path_hint, ".asm") ||
        has_extension(path_hint, ".oxs") ||
        has_extension(path_hint, ".s") ||
        has_extension(path_hint, ".S") ||
        looks_like_oxalyn_source(data, size)) {
        out->input_kind = COMPILER_INPUT_ASSEMBLY;
        /*
         * .asm/.oxs bu compiler'ın yerel Oxalyn assembly girişidir.
         * İçerik kısa veya yalnızca yorumlardan oluşsa bile uzantı yeterli
         * kanıttır; farklı assembly sözdizimleri --arch/backend ile eklenir.
         */
        if (has_extension(path_hint, ".asm") ||
            has_extension(path_hint, ".oxs") ||
            looks_like_oxalyn_source(data, size))
            out->arch = COMPILER_ARCH_OXALYN64;
        else
        out->arch = detect_assembly_arch(data, size);
        out->bits = 64;
        if (out->arch == COMPILER_ARCH_OXALYN64)
            set_detail(out, "Oxalyn assembly source");
        else if (out->arch == COMPILER_ARCH_UNKNOWN)
            set_detail(out, "assembly source; architecture not identified");
        else
            snprintf(out->detail, sizeof(out->detail),
                     "assembly source; heuristic architecture=%s",
                     compiler_arch_name(out->arch));
        return 0;
    }

    if (has_extension(path_hint, ".bin") ||
        has_extension(path_hint, ".raw")) {
        out->input_kind = COMPILER_INPUT_RAW_BINARY;
        set_detail(out, "raw binary; architecture header bulunamadı");
        return 0;
    }

    set_detail(out, "dosya biçimi veya mimari tanınamadı");
    return 0;
}

int compiler_detect_file(const char *path, CompilerDetection *out)
{
    FILE *file;
    unsigned char buffer[8192];
    size_t size;

    if (!path || !out)
        return -1;
    file = fopen(path, "rb");
    if (!file)
        return -1;
    size = fread(buffer, 1, sizeof(buffer), file);
    fclose(file);
    return compiler_detect_bytes(buffer, size, path, out);
}

const char *compiler_input_kind_name(CompilerInputKind kind)
{
    switch (kind) {
    case COMPILER_INPUT_ASSEMBLY: return "assembly";
    case COMPILER_INPUT_ELF: return "ELF";
    case COMPILER_INPUT_PE: return "PE/COFF";
    case COMPILER_INPUT_MACHO: return "Mach-O";
    case COMPILER_INPUT_WASM: return "WebAssembly";
    case COMPILER_INPUT_RAW_BINARY: return "raw binary";
    default: return "unknown";
    }
}

const char *compiler_arch_name(CompilerArchKind arch)
{
    size_t i;
    for (i = 0; i < sizeof(BACKENDS) / sizeof(BACKENDS[0]); i++)
        if (BACKENDS[i].arch == arch)
            return BACKENDS[i].name;
    return "unknown";
}

CompilerArchKind compiler_arch_from_name(const char *name)
{
    size_t i;
    if (!name)
        return COMPILER_ARCH_UNKNOWN;
    for (i = 0; i < sizeof(BACKENDS) / sizeof(BACKENDS[0]); i++)
        if (strcmp(name, BACKENDS[i].name) == 0)
            return BACKENDS[i].arch;
    if (strcmp(name, "amd64") == 0 || strcmp(name, "x86_64") == 0)
        return COMPILER_ARCH_X86_64;
    if (strcmp(name, "arm64") == 0 || strcmp(name, "aarch64") == 0)
        return COMPILER_ARCH_ARM64;
    if (strcmp(name, "rv64") == 0 || strcmp(name, "riscv") == 0)
        return COMPILER_ARCH_RISCV64;
    if (strcmp(name, "wasm32") == 0)
        return COMPILER_ARCH_WASM;
    return COMPILER_ARCH_UNKNOWN;
}

const CompilerBackend *compiler_backend_for(CompilerArchKind arch)
{
    size_t i;
    for (i = 0; i < sizeof(BACKENDS) / sizeof(BACKENDS[0]); i++)
        if (BACKENDS[i].arch == arch)
            return &BACKENDS[i];
    return NULL;
}

size_t compiler_backend_count(void)
{
    return sizeof(BACKENDS) / sizeof(BACKENDS[0]);
}

const CompilerBackend *compiler_backend_at(size_t index)
{
    return index < compiler_backend_count() ? &BACKENDS[index] : NULL;
}