/*
 * Oxalyn Compiler
 *
 * Kullanım:
 *   build/compiler kaynak.asm -o build/program
 *   build/compiler --inspect uygulama.elf
 *   build/compiler --list-arch
 *
 * İlk gerçek backend Oxalyn assembly'dir. Diğer mimariler güvenli biçimde
 * tanınır; instruction decoder tamamlanmadan yanlış Oxalyn kodu üretmez.
 */
#include "arch.h"
#include "translator.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define PATH_LIMIT 1024

static void usage(const char *program)
{
    printf("Oxalyn Compiler — kaynak/makine mimarisi köprüsü\n\n");
    printf("Kullanım:\n");
    printf("  %s <girdi> -o <çıktı-ön eki> [--arch <mimari>]\n", program);
    printf("  %s --inspect <girdi>\n", program);
    printf("  %s --list-arch\n\n", program);
    printf("Çıktı: <ön ek>.asm ve <ön ek>.bin\n");
    printf("Mimari: auto, oxalyn64, x86-64, arm64, riscv64, wasm\n");
}

static int read_text(const char *path, char **out, size_t *out_size)
{
    FILE *file;
    long length;
    char *buffer;
    size_t read_size;

    file = fopen(path, "rb");
    if (!file)
        return -1;
    if (fseek(file, 0, SEEK_END) != 0) {
        fclose(file);
        return -1;
    }
    length = ftell(file);
    if (length < 0 || fseek(file, 0, SEEK_SET) != 0) {
        fclose(file);
        return -1;
    }
    buffer = (char *)malloc((size_t)length + 1);
    if (!buffer) {
        fclose(file);
        return -1;
    }
    read_size = fread(buffer, 1, (size_t)length, file);
    fclose(file);
    buffer[read_size] = '\0';
    *out = buffer;
    *out_size = read_size;
    return 0;
}

static int write_text(const char *path, const char *text, size_t size)
{
    FILE *file = fopen(path, "wb");
    if (size >= 3 && (unsigned char)text[0] == 0xEF &&
        (unsigned char)text[1] == 0xBB &&
        (unsigned char)text[2] == 0xBF) {
        text += 3;
        size -= 3;
    }
    if (!file)
        return -1;
    if (fwrite(text, 1, size, file) != size || fclose(file) != 0)
        return -1;
    return 0;
}

static int shell_quote(const char *input, char *output, size_t capacity)
{
    size_t used = 0;
    size_t i;
    if (!input || capacity < 3)
        return -1;
    output[used++] = '\'';
    for (i = 0; input[i]; i++) {
        if (used + 5 >= capacity)
            return -1;
        if (input[i] == '\'') {
            memcpy(output + used, "'\\''", 4);
            used += 4;
        } else {
            output[used++] = input[i];
        }
    }
    output[used++] = '\'';
    output[used] = '\0';
    return 0;
}

static int run_assembler(const char *assembler,
                         const char *assembly,
                         const char *binary)
{
    char q_assembler[PATH_LIMIT];
    char q_assembly[PATH_LIMIT];
    char q_binary[PATH_LIMIT];
    char command[PATH_LIMIT * 3 + 32];

    if (shell_quote(assembler, q_assembler, sizeof(q_assembler)) != 0 ||
        shell_quote(assembly, q_assembly, sizeof(q_assembly)) != 0 ||
        shell_quote(binary, q_binary, sizeof(q_binary)) != 0)
        return -1;
    snprintf(command, sizeof(command), "%s %s %s",
             q_assembler, q_assembly, q_binary);
    return system(command);
}

static void write_report(const char *path,
                         const CompilerDetection *detection,
                         const char *message)
{
    FILE *file = fopen(path, "wb");
    if (!file)
        return;
    fprintf(file, "Oxalyn Compiler raporu\n");
    fprintf(file, "Girdi türü : %s\n",
            compiler_input_kind_name(detection->input_kind));
    fprintf(file, "Mimari     : %s\n", compiler_arch_name(detection->arch));
    fprintf(file, "Ayrıntı    : %s\n", detection->detail);
    fprintf(file, "Sonuç      : %s\n", message);
    fclose(file);
}

static void print_detection(const CompilerDetection *detection)
{
    printf("Girdi türü : %s\n",
           compiler_input_kind_name(detection->input_kind));
    printf("Mimari     : %s\n", compiler_arch_name(detection->arch));
    printf("Bit genişliği: %d\n", detection->bits);
    printf("Endian     : %s\n",
           detection->little_endian ? "little-endian" : "big-endian");
    printf("Ayrıntı    : %s\n", detection->detail);
}

static int compile_oxalyn_source(const char *input,
                                 const char *prefix,
                                 const char *assembler,
                                 const CompilerDetection *detection)
{
    char assembly_path[PATH_LIMIT];
    char binary_path[PATH_LIMIT];
    char report_path[PATH_LIMIT];
    char *source;
    size_t source_size;
    int result;

    snprintf(assembly_path, sizeof(assembly_path), "%s.asm", prefix);
    snprintf(binary_path, sizeof(binary_path), "%s.bin", prefix);
    snprintf(report_path, sizeof(report_path), "%s.report.txt", prefix);

    if (read_text(input, &source, &source_size) != 0) {
        fprintf(stderr, "[HATA] Kaynak okunamadı: %s\n", input);
        return 1;
    }
    if (write_text(assembly_path, source, source_size) != 0) {
        fprintf(stderr, "[HATA] Assembly çıktısı yazılamadı: %s\n",
                assembly_path);
        free(source);
        return 1;
    }
    free(source);

    result = run_assembler(assembler, assembly_path, binary_path);
    if (result != 0) {
        fprintf(stderr, "[HATA] Oxalyn assembler başarısız oldu.\n");
        return 1;
    }
    write_report(report_path, &(CompilerDetection){
        detection->input_kind, detection->arch, detection->machine,
        detection->bits, detection->little_endian, "Oxalyn assembly source"
    }, "başarılı: .asm ve .bin üretildi");
    printf("[OK] %s\n", assembly_path);
    printf("[OK] %s\n", binary_path);
    printf("[OK] %s\n", report_path);
    return 0;
}

static int compile_generic_source(const char *input,
                                  const char *prefix,
                                  CompilerArchKind arch,
                                  const char *assembler,
                                  const CompilerDetection *detection)
{
    char assembly_path[PATH_LIMIT];
    char binary_path[PATH_LIMIT];
    char report_path[PATH_LIMIT];
    char error[256];
    int result;

    snprintf(assembly_path, sizeof(assembly_path), "%s.asm", prefix);
    snprintf(binary_path, sizeof(binary_path), "%s.bin", prefix);
    snprintf(report_path, sizeof(report_path), "%s.report.txt", prefix);

    result = compiler_translate_source(arch, input, assembly_path,
                                       error, sizeof(error));
    if (result != 0) {
        write_report(report_path, detection, error);
        fprintf(stderr, "[HATA] %s\n", error);
        return 2;
    }
    result = run_assembler(assembler, assembly_path, binary_path);
    if (result != 0) {
        write_report(report_path, detection,
                     "çeviri başarılı fakat Oxalyn assembler başarısız oldu");
        fprintf(stderr, "[HATA] Üretilen Oxalyn assembly derlenemedi.\n");
        return 1;
    }
    write_report(report_path, detection,
                 "başarılı: kaynak assembly Oxalyn assembly/.bin'e çevrildi");
    printf("[OK] %s\n", assembly_path);
    printf("[OK] %s\n", binary_path);
    printf("[OK] %s\n", report_path);
    return 0;
}

static int compile_input(const char *input,
                         const char *prefix,
                         CompilerArchKind forced_arch,
                         const char *assembler)
{
    CompilerDetection detection;
    const CompilerBackend *backend;
    char report_path[PATH_LIMIT];

    if (compiler_detect_file(input, &detection) != 0) {
        fprintf(stderr, "[HATA] Girdi açılamadı veya okunamadı: %s\n", input);
        return 1;
    }
    if (forced_arch != COMPILER_ARCH_UNKNOWN)
        detection.arch = forced_arch;
    if (forced_arch != COMPILER_ARCH_UNKNOWN)
        snprintf(detection.detail, sizeof(detection.detail),
                 "assembly source; --arch ile %s seçildi",
                 compiler_arch_name(forced_arch));

    print_detection(&detection);
    backend = compiler_backend_for(detection.arch);
    snprintf(report_path, sizeof(report_path), "%s.report.txt", prefix);

    if (!backend) {
        write_report(report_path, &detection, "başarısız: mimari bulunamadı");
        fprintf(stderr, "[HATA] Mimari tanınmadı. --arch ile belirtin.\n");
        return 1;
    }
    if (detection.arch == COMPILER_ARCH_OXALYN64 &&
        detection.input_kind == COMPILER_INPUT_ASSEMBLY)
        return compile_oxalyn_source(input, prefix, assembler, &detection);

    if (detection.input_kind == COMPILER_INPUT_ASSEMBLY &&
        (detection.arch == COMPILER_ARCH_X86_64 ||
         detection.arch == COMPILER_ARCH_ARM64 ||
         detection.arch == COMPILER_ARCH_RISCV64))
        return compile_generic_source(input, prefix, detection.arch,
                                       assembler, &detection);

    /* WASM binary → Oxalyn-64 assembly çevirisi */
    if (detection.input_kind == COMPILER_INPUT_WASM ||
        detection.arch        == COMPILER_ARCH_WASM) {
        char error[256];
        char assembly_path[PATH_LIMIT];
        snprintf(assembly_path, sizeof(assembly_path), "%s.asm", prefix);
        if (wasm_translate_module(input, assembly_path, error, sizeof(error)) != 0) {
            write_report(report_path, &detection, error);
            fprintf(stderr, "[HATA] WASM çevirisi başarısız: %s\n", error);
            return 2;
        }
        printf("[OK] WASM → Oxalyn-64 assembly: %s\n", assembly_path);
        /* Assembler varsa binary'ye de derle */
        {
            char binary_path[PATH_LIMIT];
            snprintf(binary_path, sizeof(binary_path), "%s.bin", prefix);
            if (run_assembler(assembler, assembly_path, binary_path) != 0) {
                remove(assembly_path);
                remove(binary_path);
                write_report(report_path, &detection,
                             "başarısız: Oxalyn assembler çıktıyı reddetti");
                fprintf(stderr,
                        "[HATA] Oxalyn assembler başarısız oldu; kısmi "
                        "assembly/.bin silindi.\n");
                fprintf(stderr, "       Rapor: %s\n", report_path);
                return 2;
            }
            printf("[OK] %s\n", binary_path);
        }
        write_report(report_path, &detection,
                     "başarılı: WASM modülü Oxalyn-64 assembly'ye çevrildi");
        return 0;
    }

    write_report(report_path, &detection,
                 "başarısız: bu mimari için güvenli decoder/backend hazır değil");
    fprintf(stderr,
            "[HATA] %s tanındı fakat henüz güvenli Oxalyn çeviricisi yok.\n"
            "       Sahte .bin üretilmedi; ayrıntı: %s\n",
            compiler_arch_name(detection.arch), detection.detail);
    fprintf(stderr, "       Rapor: %s\n", report_path);
    return 2;
}

int main(int argc, char **argv)
{
    const char *input = NULL;
    const char *prefix = NULL;
    const char *assembler = "build/asm";
    CompilerArchKind forced_arch = COMPILER_ARCH_UNKNOWN;
    int i;

    if (argc < 2) {
        usage(argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "--list-arch") == 0) {
        size_t index;
        for (index = 0; index < compiler_backend_count(); index++) {
            const CompilerBackend *backend = compiler_backend_at(index);
            printf("%-9s source=%s binary=%s — %s\n",
                   backend->name,
                   backend->source_supported ? "yes" : "no",
                   backend->binary_input_supported ? "yes" : "no",
                   backend->description);
        }
        return 0;
    }
    if (strcmp(argv[1], "--inspect") == 0) {
        CompilerDetection detection;
        if (argc < 3 || compiler_detect_file(argv[2], &detection) != 0) {
            fprintf(stderr, "[HATA] İncelenecek dosya açılamadı.\n");
            return 1;
        }
        print_detection(&detection);
        return 0;
    }

    input = argv[1];
    for (i = 2; i < argc; i++) {
        if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            prefix = argv[++i];
        } else if (strcmp(argv[i], "--arch") == 0 && i + 1 < argc) {
            const char *name = argv[++i];
            if (strcmp(name, "auto") != 0)
                forced_arch = compiler_arch_from_name(name);
            if (strcmp(name, "auto") != 0 &&
                forced_arch == COMPILER_ARCH_UNKNOWN) {
                fprintf(stderr, "[HATA] Bilinmeyen mimari: %s\n", name);
                return 1;
            }
        } else if (strcmp(argv[i], "--assembler") == 0 && i + 1 < argc) {
            assembler = argv[++i];
        } else if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else {
            fprintf(stderr, "[HATA] Bilinmeyen seçenek: %s\n", argv[i]);
            return 1;
        }
    }

    if (!prefix) {
        fprintf(stderr, "[HATA] -o <çıktı-ön eki> zorunludur.\n");
        return 1;
    }
    return compile_input(input, prefix, forced_arch, assembler);
}