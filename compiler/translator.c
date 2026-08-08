/*
 * Compiler'ın ilk kaynak backend'leri.
 *
 * Bilinçli olarak küçük ve denetlenebilir bir komut alt kümesi desteklenir.
 * Özellikle flags, ABI, bellek adresleme ve SIMD komutları yanlış çevrilmesin
 * diye açıkça reddedilir.
 */
#include "translator.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define LINE_CAP 512
#define TOKEN_CAP 8
#define TOKEN_LEN 96

static void set_error(char *buffer, size_t capacity,
                      unsigned line, const char *message)
{
    if (buffer && capacity)
        snprintf(buffer, capacity, "satır %u: %s", line, message);
}

static void trim(char *text)
{
    char *start = text;
    size_t length;

    while (*start && isspace((unsigned char)*start))
        start++;
    if (start != text)
        memmove(text, start, strlen(start) + 1);
    length = strlen(text);
    while (length && isspace((unsigned char)text[length - 1]))
        text[--length] = '\0';
}

static void lower(char *text)
{
    while (*text) {
        *text = (char)tolower((unsigned char)*text);
        text++;
    }
}

static void remove_comment(char *text, CompilerArchKind arch)
{
    char *semicolon = strchr(text, ';');
    char *slash = strstr(text, "//");
    char *hash = (arch == COMPILER_ARCH_X86_64 ||
                  arch == COMPILER_ARCH_RISCV64)
               ? strchr(text, '#') : NULL;
    char *cut = semicolon;

    if (slash && (!cut || slash < cut))
        cut = slash;
    if (hash && (!cut || hash < cut))
        cut = hash;
    if (cut)
        *cut = '\0';
    trim(text);
}

static int tokenize(char *line, char tokens[TOKEN_CAP][TOKEN_LEN])
{
    char *cursor = line;
    int count = 0;

    while (*cursor && count < TOKEN_CAP) {
        char *start;
        size_t length;
        while (*cursor == ' ' || *cursor == '\t' || *cursor == ',')
            cursor++;
        if (!*cursor)
            break;
        start = cursor;
        while (*cursor && *cursor != ' ' && *cursor != '\t' &&
               *cursor != ',')
            cursor++;
        length = (size_t)(cursor - start);
        if (length >= TOKEN_LEN)
            length = TOKEN_LEN - 1;
        memcpy(tokens[count], start, length);
        tokens[count][length] = '\0';
        count++;
    }
    return count;
}

static void normalize_operand(char *operand)
{
    size_t length = strlen(operand);
    if (length && (operand[0] == '%' || operand[0] == '$' ||
                   operand[0] == '#'))
        memmove(operand, operand + 1, length);
    length = strlen(operand);
    if (length >= 2 && operand[0] == '[' && operand[length - 1] == ']') {
        operand[length - 1] = '\0';
        memmove(operand, operand + 1, length - 1);
    }
}

static int parse_number(const char *text, long *value)
{
    char *end;
    long parsed = strtol(text, &end, 0);
    if (end == text || *end != '\0')
        return 0;
    *value = parsed;
    return 1;
}

static int x86_register(const char *name)
{
    static const char *names[] = {
        "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "r8", "r9",
        "r10", "r11", "r12", "r13", "r14", "r15", "rbp", "rsp",
        "eax", "ebx", "ecx", "edx", "esi", "edi", "ax", "bx",
        "cx", "dx"
    };
    size_t i;

    for (i = 0; i < sizeof(names) / sizeof(names[0]); i++)
        if (strcmp(name, names[i]) == 0)
            return (int)(i % 16) + 1;
    return -1;
}

static int arm_register(const char *name)
{
    char *end;
    long value;

    if (strcmp(name, "sp") == 0)
        return 31;
    if (name[0] != 'x')
        return -1;
    value = strtol(name + 1, &end, 10);
    if (end == name + 1 || *end != '\0' || value < 0 || value > 30)
        return -1;
    return value == 30 ? 30 : (int)value + 1;
}

static int riscv_register(const char *name)
{
    static const char *aliases[] = {
        "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
        "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
        "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
        "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
    };
    char *end;
    long value;
    size_t i;

    if (name[0] == 'x') {
        value = strtol(name + 1, &end, 10);
        if (end != name + 1 && *end == '\0' && value >= 0 && value <= 31)
            return (int)value;
    }
    for (i = 0; i < sizeof(aliases) / sizeof(aliases[0]); i++)
        if (strcmp(name, aliases[i]) == 0)
            return (int)i;
    return -1;
}

static int source_register(CompilerArchKind arch, char *operand)
{
    normalize_operand(operand);
    if (arch == COMPILER_ARCH_X86_64)
        return x86_register(operand);
    if (arch == COMPILER_ARCH_ARM64)
        return arm_register(operand);
    if (arch == COMPILER_ARCH_RISCV64)
        return riscv_register(operand);
    return -1;
}

static int is_directive(const char *token)
{
    return token[0] == '.' ||
           strcmp(token, "section") == 0 ||
           strcmp(token, "global") == 0 ||
           strcmp(token, "globl") == 0 ||
           strcmp(token, "type") == 0 ||
           strcmp(token, "size") == 0 ||
           strcmp(token, "text") == 0 ||
           strcmp(token, "syntax") == 0 ||
           strcmp(token, "cfi_startproc") == 0 ||
           strcmp(token, "cfi_endproc") == 0 ||
           strcmp(token, "cfi_def_cfa_offset") == 0 ||
           strcmp(token, "cfi_offset") == 0;
}

static int emit_three_register(FILE *output, const char *op,
                               int rd, int rs1, int rs2)
{
    return fprintf(output, "%s R%d, R%d, R%d\n", op, rd, rs1, rs2) < 0
         ? -1 : 0;
}

static int emit_two_register(FILE *output, const char *op,
                             int rd, int rs)
{
    return fprintf(output, "%s R%d, R%d\n", op, rd, rs) < 0 ? -1 : 0;
}

static void strip_x86_width_suffix(char *op)
{
    size_t length = strlen(op);

    if (length < 2)
        return;
    if (strcmp(op, "movb") == 0 || strcmp(op, "movw") == 0 ||
        strcmp(op, "movl") == 0 || strcmp(op, "movq") == 0 ||
        strcmp(op, "addb") == 0 || strcmp(op, "addw") == 0 ||
        strcmp(op, "addl") == 0 || strcmp(op, "addq") == 0 ||
        strcmp(op, "subb") == 0 || strcmp(op, "subw") == 0 ||
        strcmp(op, "subl") == 0 || strcmp(op, "subq") == 0 ||
        strcmp(op, "andb") == 0 || strcmp(op, "andw") == 0 ||
        strcmp(op, "andl") == 0 || strcmp(op, "andq") == 0 ||
        strcmp(op, "orb") == 0 || strcmp(op, "orw") == 0 ||
        strcmp(op, "orl") == 0 || strcmp(op, "orq") == 0 ||
        strcmp(op, "xorb") == 0 || strcmp(op, "xorw") == 0 ||
        strcmp(op, "xorl") == 0 || strcmp(op, "xorq") == 0)
        op[length - 1] = '\0';
}

static int translate_x86(FILE *output, char tokens[TOKEN_CAP][TOKEN_LEN],
                         int count, int att, unsigned line,
                         char *error, size_t error_capacity)
{
    char *op;
    char *first;
    char *second;
    int dst;
    int src;
    long immediate;

    op = tokens[0];
    strip_x86_width_suffix(op);
    if (strcmp(op, "nop") == 0)
        return fprintf(output, "NOP\n") < 0 ? -1 : 0;
    if (strcmp(op, "ret") == 0)
        return fprintf(output, "RET\n") < 0 ? -1 : 0;
    if (strcmp(op, "push") == 0 || strcmp(op, "pop") == 0) {
        if (count != 2 || (dst = source_register(COMPILER_ARCH_X86_64,
                                                  tokens[1])) < 0) {
            set_error(error, error_capacity, line, "x86 stack operandı");
            return -1;
        }
        return fprintf(output, "%s R%d\n",
                       strcmp(op, "push") == 0 ? "PUSH" : "POP", dst) < 0
             ? -1 : 0;
    }
    if (strcmp(op, "jmp") == 0 || strcmp(op, "call") == 0) {
        if (count != 2) {
            set_error(error, error_capacity, line, "x86 branch hedefi");
            return -1;
        }
        normalize_operand(tokens[1]);
        return fprintf(output, "%s %s\n",
                       strcmp(op, "jmp") == 0 ? "JMP" : "CALL",
                       tokens[1]) < 0 ? -1 : 0;
    }
    if (strcmp(op, "mov") == 0 || strcmp(op, "add") == 0 ||
        strcmp(op, "sub") == 0 || strcmp(op, "and") == 0 ||
        strcmp(op, "or") == 0 || strcmp(op, "xor") == 0) {
        if (count != 3) {
            set_error(error, error_capacity, line, "x86 iki operand bekleniyor");
            return -1;
        }
        first = tokens[1];
        second = tokens[2];
        if (att) {
            char *swap = first;
            first = second;
            second = swap;
        }
        dst = source_register(COMPILER_ARCH_X86_64, first);
        if (dst < 0) {
            set_error(error, error_capacity, line, "x86 hedef register'ı");
            return -1;
        }
        normalize_operand(second);
        src = source_register(COMPILER_ARCH_X86_64, second);
        if (src >= 0) {
            if (strcmp(op, "mov") == 0)
                return emit_two_register(output, "MOV", dst, src);
            {
                const char *mapped = strcmp(op, "add") == 0 ? "ADD" :
                                     strcmp(op, "sub") == 0 ? "SUB" :
                                     strcmp(op, "and") == 0 ? "AND" :
                                     strcmp(op, "or") == 0 ? "OR" : "XOR";
                return emit_three_register(output, mapped, dst, dst, src);
            }
        }
        if (!parse_number(second, &immediate) ||
            immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line,
                      "x86 immediate veya register desteklenmiyor");
            return -1;
        }
        if (strcmp(op, "mov") == 0)
            return fprintf(output, "LI R%d, %ld\n", dst, immediate) < 0
                 ? -1 : 0;
        if (fprintf(output, "LI R30, %ld\n", immediate) < 0)
            return -1;
        {
            const char *mapped = strcmp(op, "add") == 0 ? "ADD" :
                                 strcmp(op, "sub") == 0 ? "SUB" :
                                 strcmp(op, "and") == 0 ? "AND" :
                                 strcmp(op, "or") == 0 ? "OR" : "XOR";
            return emit_three_register(output, mapped, dst, dst, 30);
        }
    }
    /* ── Karşılaştırma ── */
    if (strcmp(op, "cmp") == 0 || strcmp(op, "test") == 0) {
        if (count != 3) {
            set_error(error, error_capacity, line, "x86 cmp: iki operand gerekli");
            return -1;
        }
        first = tokens[1]; second = tokens[2];
        if (att) { char *sw = first; first = second; second = sw; }
        dst = source_register(COMPILER_ARCH_X86_64, first);
        if (dst < 0) { set_error(error, error_capacity, line, "x86 cmp dst"); return -1; }
        normalize_operand(second);
        src = source_register(COMPILER_ARCH_X86_64, second);
        if (src >= 0)
            return emit_three_register(output, "SUB", 0 /* R0=discard */, dst, src);
        if (!parse_number(second, &immediate) || immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line, "x86 cmp immediate");
            return -1;
        }
        if (fprintf(output, "LI R30, %ld\n", immediate) < 0) return -1;
        return emit_three_register(output, "SUB", 0, dst, 30);
    }
    /* ── Bit kaydırma ── */
    if (strcmp(op, "shl") == 0 || strcmp(op, "sal") == 0 ||
        strcmp(op, "shr") == 0 || strcmp(op, "sar") == 0) {
        if (count != 3) {
            set_error(error, error_capacity, line, "x86 shift: iki operand gerekli");
            return -1;
        }
        first = tokens[1]; second = tokens[2];
        if (att) { char *sw = first; first = second; second = sw; }
        dst = source_register(COMPILER_ARCH_X86_64, first);
        if (dst < 0) { set_error(error, error_capacity, line, "x86 shift dst"); return -1; }
        normalize_operand(second);
        if (!parse_number(second, &immediate) || immediate < 0 || immediate > 63) {
            /* cl register → R0 ile sola/sağa kaydır */
            src = source_register(COMPILER_ARCH_X86_64, second);
            if (src < 0) { set_error(error, error_capacity, line, "x86 shift amt"); return -1; }
            return emit_three_register(output,
                (strcmp(op,"shr")==0||strcmp(op,"sar")==0) ? "SHR" : "SHL",
                dst, dst, src);
        }
        return fprintf(output, "%s R%d, R%d, %ld\n",
                       (strcmp(op,"shr")==0||strcmp(op,"sar")==0) ? "SHR" : "SHL",
                       dst, dst, immediate) < 0 ? -1 : 0;
    }
    /* ── Koşullu dallar ── */
    if (strcmp(op, "je")  == 0 || strcmp(op, "jz")  == 0 ||
        strcmp(op, "jne") == 0 || strcmp(op, "jnz") == 0 ||
        strcmp(op, "jl")  == 0 || strcmp(op, "jge") == 0 ||
        strcmp(op, "jle") == 0 || strcmp(op, "jg")  == 0) {
        if (count != 2) { set_error(error, error_capacity, line, "x86 jcc hedef"); return -1; }
        {
            const char *oxop =
                (strcmp(op,"je") ==0||strcmp(op,"jz") ==0) ? "BEQ" :
                (strcmp(op,"jne")==0||strcmp(op,"jnz")==0) ? "BNE" :
                (strcmp(op,"jl") ==0)                      ? "BLT" :
                (strcmp(op,"jge")==0)                      ? "BGE" :
                (strcmp(op,"jle")==0)                      ? "BLE" : "BGT";
            return fprintf(output, "%s R0, R0, %s\n", oxop, tokens[1]) < 0 ? -1 : 0;
        }
    }
    /* ── NOT / NEG ── */
    if (strcmp(op, "not") == 0) {
        if (count != 2 || (dst=source_register(COMPILER_ARCH_X86_64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"x86 not operandı"); return -1;
        }
        return emit_two_register(output, "NOT", dst, dst);
    }
    if (strcmp(op, "neg") == 0) {
        if (count != 2 || (dst=source_register(COMPILER_ARCH_X86_64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"x86 neg operandı"); return -1;
        }
        if (fprintf(output, "LI R30, 0\n") < 0) return -1;
        return emit_three_register(output, "SUB", dst, 30, dst);
    }
    /* ── MUL / IMUL ── */
    if (strcmp(op, "imul") == 0 || strcmp(op, "mul") == 0) {
        if (count == 2) {
            /* imul reg — rax × reg (hedef rax = R1 olarak eşleşti) */
            src = source_register(COMPILER_ARCH_X86_64, tokens[1]);
            if (src < 0) { set_error(error,error_capacity,line,"x86 mul src"); return -1; }
            return emit_three_register(output, "MUL", 1, 1, src);
        }
        if (count == 3) {
            /* imul dst, src */
            dst = source_register(COMPILER_ARCH_X86_64, tokens[1]);
            normalize_operand(tokens[2]);
            src = source_register(COMPILER_ARCH_X86_64, tokens[2]);
            if (dst<0||src<0) { set_error(error,error_capacity,line,"x86 imul op"); return -1; }
            return emit_three_register(output, "MUL", dst, dst, src);
        }
        set_error(error,error_capacity,line,"x86 imul format desteklenmiyor");
        return -1;
    }
    /* ── DIV / IDIV ── */
    if (strcmp(op, "div") == 0 || strcmp(op, "idiv") == 0) {
        if (count != 2 || (src=source_register(COMPILER_ARCH_X86_64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"x86 div src"); return -1;
        }
        return emit_three_register(output, "DIV", 1, 1, src);
    }
    /* ── INC / DEC ── */
    if (strcmp(op, "inc") == 0 || strcmp(op, "dec") == 0) {
        if (count != 2 || (dst=source_register(COMPILER_ARCH_X86_64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"x86 inc/dec"); return -1;
        }
        if (fprintf(output, "LI R30, %d\n", strcmp(op,"inc")==0?1:-1) < 0) return -1;
        return emit_three_register(output, "ADD", dst, dst, 30);
    }
    /* ── XCHG ── */
    if (strcmp(op, "xchg") == 0) {
        if (count != 3) { set_error(error,error_capacity,line,"x86 xchg operandı"); return -1; }
        dst = source_register(COMPILER_ARCH_X86_64, tokens[1]);
        src = source_register(COMPILER_ARCH_X86_64, tokens[2]);
        if (dst<0||src<0) { set_error(error,error_capacity,line,"x86 xchg register"); return -1; }
        /* tmp=dst; dst=src; src=tmp  (R1 geçici) */
        if (emit_two_register(output,"MOV",1,dst)<0) return -1;
        if (emit_two_register(output,"MOV",dst,src)<0) return -1;
        return emit_two_register(output,"MOV",src,1);
    }
    /* ── LEA (basit sabit ofset) ── */
    if (strcmp(op, "lea") == 0) {
        if (count < 3) { set_error(error,error_capacity,line,"x86 lea operandı"); return -1; }
        dst = source_register(COMPILER_ARCH_X86_64, tokens[1]);
        if (dst < 0) { set_error(error,error_capacity,line,"x86 lea dst"); return -1; }
        /* Basit: lea rax, [rbx + imm] → ADDI rax, rbx, imm */
        normalize_operand(tokens[2]);
        src = source_register(COMPILER_ARCH_X86_64, tokens[2]);
        if (src >= 0)
            return emit_two_register(output, "MOV", dst, src);
        if (parse_number(tokens[2], &immediate) && immediate>=-1024 && immediate<=1023)
            return fprintf(output, "LI R%d, %ld\n", dst, immediate) < 0 ? -1 : 0;
        set_error(error,error_capacity,line,"x86 lea: sadece basit register/immediate");
        return -1;
    }
    /* ── NOP geniş ── */
    if (strcmp(op, "syscall") == 0 || strcmp(op, "int") == 0)
        return fprintf(output, "ECALL\n") < 0 ? -1 : 0;
    if (strcmp(op, "hlt") == 0 || strcmp(op, "ud2") == 0)
        return fprintf(output, "HALT\n") < 0 ? -1 : 0;
    set_error(error, error_capacity, line, "x86 komutu desteklenmiyor");
    return -1;
}

static int translate_arm(FILE *output, char tokens[TOKEN_CAP][TOKEN_LEN],
                         int count, unsigned line,
                         char *error, size_t error_capacity)
{
    const char *op = tokens[0];
    int rd;
    int rs1;
    int rs2;
    long immediate;

    if (strcmp(op, "nop") == 0)
        return fprintf(output, "NOP\n") < 0 ? -1 : 0;
    if (strcmp(op, "ret") == 0)
        return fprintf(output, "RET\n") < 0 ? -1 : 0;
    if (strcmp(op, "b") == 0 || strcmp(op, "bl") == 0) {
        if (count != 2) {
            set_error(error, error_capacity, line, "ARM branch hedefi");
            return -1;
        }
        return fprintf(output, "%s %s\n",
                       strcmp(op, "b") == 0 ? "JMP" : "CALL",
                       tokens[1]) < 0 ? -1 : 0;
    }
    if (strcmp(op, "mov") == 0 || strcmp(op, "movz") == 0) {
        if (count != 3 ||
            (rd = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "ARM mov operandı");
            return -1;
        }
        normalize_operand(tokens[2]);
        if (parse_number(tokens[2], &immediate)) {
            if (immediate < -1024 || immediate > 1023) {
                set_error(error, error_capacity, line,
                          "ARM immediate aralık dışında");
                return -1;
            }
            return fprintf(output, "LI R%d, %ld\n", rd, immediate) < 0
                 ? -1 : 0;
        }
        if ((rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0) {
            set_error(error, error_capacity, line, "ARM kaynak register'ı");
            return -1;
        }
        return emit_two_register(output, "MOV", rd, rs1);
    }
    if (strcmp(op, "add") == 0 || strcmp(op, "sub") == 0 ||
        strcmp(op, "and") == 0 || strcmp(op, "orr") == 0 ||
        strcmp(op, "eor") == 0) {
        if (count != 4 ||
            (rd = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0) {
            set_error(error, error_capacity, line, "ARM arithmetic operandı");
            return -1;
        }
        normalize_operand(tokens[3]);
        rs2 = source_register(COMPILER_ARCH_ARM64, tokens[3]);
        if (rs2 < 0 && parse_number(tokens[3], &immediate) &&
            immediate >= -1024 && immediate <= 1023) {
            if (fprintf(output, "LI R30, %ld\n", immediate) < 0)
                return -1;
            rs2 = 30;
        }
        if (rs2 < 0) {
            set_error(error, error_capacity, line,
                      "ARM üçüncü operandı desteklenmiyor");
            return -1;
        }
        {
            const char *mapped = strcmp(op, "add") == 0 ? "ADD" :
                                 strcmp(op, "sub") == 0 ? "SUB" :
                                 strcmp(op, "and") == 0 ? "AND" :
                                 strcmp(op, "orr") == 0 ? "OR" : "XOR";
            return emit_three_register(output, mapped, rd, rs1, rs2);
        }
    }
    /* ── Bit kaydırma ── */
    if (strcmp(op, "lsl") == 0 || strcmp(op, "lsr") == 0 ||
        strcmp(op, "asr") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0) {
            set_error(error, error_capacity, line, "ARM shift operandı");
            return -1;
        }
        normalize_operand(tokens[3]);
        rs2 = source_register(COMPILER_ARCH_ARM64, tokens[3]);
        if (rs2 < 0) {
            if (!parse_number(tokens[3], &immediate) || immediate < 0 || immediate > 63) {
                set_error(error,error_capacity,line,"ARM shift immediate"); return -1;
            }
            return fprintf(output, "%s R%d, R%d, %ld\n",
                           strcmp(op,"lsl")==0?"SHL":"SHR", rd, rs1, immediate) < 0 ? -1 : 0;
        }
        return emit_three_register(output, strcmp(op,"lsl")==0?"SHL":"SHR", rd, rs1, rs2);
    }
    /* ── Karşılaştırma ── */
    if (strcmp(op, "cmp") == 0 || strcmp(op, "cmn") == 0) {
        if (count != 3 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0) {
            set_error(error,error_capacity,line,"ARM cmp operandı"); return -1;
        }
        normalize_operand(tokens[2]);
        rs2 = source_register(COMPILER_ARCH_ARM64, tokens[2]);
        if (rs2 < 0) {
            if (!parse_number(tokens[2],&immediate)||immediate<-1024||immediate>1023) {
                set_error(error,error_capacity,line,"ARM cmp immediate"); return -1;
            }
            if (fprintf(output,"LI R30, %ld\n",immediate)<0) return -1;
            rs2 = 30;
        }
        return emit_three_register(output, "SUB", 0, rs1, rs2);
    }
    /* ── MUL / UDIV / SDIV ── */
    if (strcmp(op, "mul") == 0 || strcmp(op, "udiv") == 0 || strcmp(op, "sdiv") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_ARM64, tokens[3])) < 0) {
            set_error(error,error_capacity,line,"ARM mul/div operandı"); return -1;
        }
        return emit_three_register(output,
            strcmp(op,"mul")==0?"MUL":"DIV", rd, rs1, rs2);
    }
    /* ── NEG / MVN ── */
    if (strcmp(op, "neg") == 0) {
        if (count != 3 ||
            (rd  = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0) {
            set_error(error,error_capacity,line,"ARM neg operandı"); return -1;
        }
        if (fprintf(output,"LI R30, 0\n")<0) return -1;
        return emit_three_register(output,"SUB",rd,30,rs1);
    }
    if (strcmp(op, "mvn") == 0) {
        if (count != 3 ||
            (rd  = source_register(COMPILER_ARCH_ARM64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2])) < 0) {
            set_error(error,error_capacity,line,"ARM mvn operandı"); return -1;
        }
        return emit_two_register(output, "NOT", rd, rs1);
    }
    /* ── Koşullu dallar ── */
    if (strcmp(op, "beq") == 0 || strcmp(op, "bne") == 0 ||
        strcmp(op, "blt") == 0 || strcmp(op, "bge") == 0 ||
        strcmp(op, "ble") == 0 || strcmp(op, "bgt") == 0) {
        if (count != 2) { set_error(error,error_capacity,line,"ARM bcc hedef"); return -1; }
        {
            const char *oxop =
                strcmp(op,"beq")==0?"BEQ":strcmp(op,"bne")==0?"BNE":
                strcmp(op,"blt")==0?"BLT":strcmp(op,"bge")==0?"BGE":
                strcmp(op,"ble")==0?"BLE":"BGT";
            return fprintf(output,"%s R0, R0, %s\n",oxop,tokens[1])<0?-1:0;
        }
    }
    /* ── CBZ / CBNZ ── */
    if (strcmp(op, "cbz") == 0 || strcmp(op, "cbnz") == 0) {
        if (count != 3 || (rs1=source_register(COMPILER_ARCH_ARM64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"ARM cbz/cbnz operandı"); return -1;
        }
        return fprintf(output,"%s R%d, R0, %s\n",
                       strcmp(op,"cbz")==0?"BEQ":"BNE",rs1,tokens[2])<0?-1:0;
    }
    /* ── PUSH / POP (ARM64'te stp/ldp x29,x30,[sp,#-16]! biçiminde gelir,
          basit tek-register pop/push pseudo olarak destekle) ── */
    if (strcmp(op, "str") == 0 || strcmp(op, "ldr") == 0) {
        int is_store = strcmp(op,"str")==0;
        if (count < 3) { set_error(error,error_capacity,line,"ARM str/ldr operandı"); return -1; }
        rd = source_register(COMPILER_ARCH_ARM64, tokens[1]);
        if (rd < 0) { set_error(error,error_capacity,line,"ARM str/ldr reg"); return -1; }
        /* Basit: str/ldr reg, [base] → STORE/LOAD */
        normalize_operand(tokens[2]);
        rs1 = source_register(COMPILER_ARCH_ARM64, tokens[2]);
        if (rs1 < 0) { set_error(error,error_capacity,line,"ARM str/ldr base"); return -1; }
        return fprintf(output,"%s R%d, R%d, 0\n",is_store?"STORE":"LOAD",rd,rs1)<0?-1:0;
    }
    /* ── PUSH / POP gerçek pseudo ── */
    if (strcmp(op, "push") == 0 || strcmp(op, "pop") == 0) {
        if (count != 2 || (rd=source_register(COMPILER_ARCH_ARM64,tokens[1]))<0) {
            set_error(error,error_capacity,line,"ARM push/pop operandı"); return -1;
        }
        return fprintf(output,"%s R%d\n",strcmp(op,"push")==0?"PUSH":"POP",rd)<0?-1:0;
    }
    /* ── SVC (sistem çağrısı) ── */
    if (strcmp(op, "svc") == 0)
        return fprintf(output,"ECALL\n")<0?-1:0;
    /* ── BRK / WFI ── */
    if (strcmp(op, "brk") == 0 || strcmp(op, "wfi") == 0 || strcmp(op, "wfe") == 0)
        return fprintf(output,"NOP\n")<0?-1:0;
    /* ── MSR / MRS → CSRW / CSRR ── */
    if (strcmp(op, "msr") == 0 || strcmp(op, "mrs") == 0) {
        /* Basit: hedef register varsa CSRW/CSRR olarak eşle */
        return fprintf(output,"NOP  ; %s unsupported msr/mrs\n",op)<0?-1:0;
    }
    set_error(error, error_capacity, line, "ARM komutu desteklenmiyor");
    return -1;
}

static int translate_riscv(FILE *output,
                           char tokens[TOKEN_CAP][TOKEN_LEN], int count,
                           unsigned line, char *error, size_t error_capacity)
{
    const char *op = tokens[0];
    int rd;
    int rs1;
    int rs2;
    long immediate;

    if (strcmp(op, "nop") == 0)
        return fprintf(output, "NOP\n") < 0 ? -1 : 0;
    if (strcmp(op, "ret") == 0 ||
        (strcmp(op, "jalr") == 0 && count == 2 &&
         strcmp(tokens[1], "ra") == 0))
        return fprintf(output, "RET\n") < 0 ? -1 : 0;
    if (strcmp(op, "j") == 0 || strcmp(op, "call") == 0 ||
        strcmp(op, "jal") == 0) {
        const char *target = count == 2 ? tokens[1] : count == 3 ? tokens[2] : NULL;
        if (!target) {
            set_error(error, error_capacity, line, "RISC-V branch hedefi");
            return -1;
        }
        return fprintf(output, "%s %s\n",
                       strcmp(op, "j") == 0 ? "JMP" : "CALL", target) < 0
             ? -1 : 0;
    }
    if (strcmp(op, "li") == 0 || strcmp(op, "mv") == 0) {
        if (count != 3 ||
            (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "RISC-V pseudo operandı");
            return -1;
        }
        normalize_operand(tokens[2]);
        if (strcmp(op, "li") == 0) {
            if (!parse_number(tokens[2], &immediate) ||
                immediate < -1024 || immediate > 1023) {
                set_error(error, error_capacity, line,
                          "RISC-V immediate aralık dışında");
                return -1;
            }
            return fprintf(output, "LI R%d, %ld\n", rd, immediate) < 0
                 ? -1 : 0;
        }
        rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2]);
        if (rs1 < 0) {
            set_error(error, error_capacity, line, "RISC-V kaynak register'ı");
            return -1;
        }
        return emit_two_register(output, "MOV", rd, rs1);
    }
    if (strcmp(op, "add") == 0 || strcmp(op, "sub") == 0 ||
        strcmp(op, "and") == 0 || strcmp(op, "or") == 0 ||
        strcmp(op, "xor") == 0) {
        if (count != 4 ||
            (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V arithmetic operandı");
            return -1;
        }
        {
            const char *mapped = strcmp(op, "add") == 0 ? "ADD" :
                                 strcmp(op, "sub") == 0 ? "SUB" :
                                 strcmp(op, "and") == 0 ? "AND" :
                                 strcmp(op, "or") == 0 ? "OR" : "XOR";
            return emit_three_register(output, mapped, rd, rs1, rs2);
        }
    }
    if (strcmp(op, "addi") == 0) {
        if (count != 4 ||
            (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            !parse_number(tokens[3], &immediate) ||
            immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line, "RISC-V addi operandı");
            return -1;
        }
        if (fprintf(output, "LI R30, %ld\n", immediate) < 0)
            return -1;
        return emit_three_register(output, "ADD", rd, rs1, 30);
    }
    if (strcmp(op, "beq") == 0 || strcmp(op, "bne") == 0 ||
        strcmp(op, "blt") == 0 || strcmp(op, "bge") == 0 ||
        strcmp(op, "bltu") == 0 || strcmp(op, "bgeu") == 0) {
        const char *compare = strcmp(op, "beq") == 0 ? "CMPEQ" :
                              strcmp(op, "bne") == 0 ? "CMPNE" :
                              (strcmp(op, "blt") == 0 || strcmp(op, "bltu") == 0) ? "CMPLT" : "CMPLE";
        if (count != 4 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0) {
            set_error(error, error_capacity, line, "RISC-V branch operandı");
            return -1;
        }
        if (fprintf(output, "%s R30, R%d, R%d\nJNZ R30, %s\n",
                    compare, rs1, rs2, tokens[3]) < 0)
            return -1;
        return 0;
    }
    /* ── Immediate logic/shift ── */
    if (strcmp(op, "andi") == 0 || strcmp(op, "ori") == 0 || strcmp(op, "xori") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            !parse_number(tokens[3], &immediate) ||
            immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line, "RISC-V andi/ori/xori operandı");
            return -1;
        }
        {
            const char *mapped = strcmp(op,"andi")==0?"AND":strcmp(op,"ori")==0?"OR":"XOR";
            if (fprintf(output, "LI R30, %ld\n", immediate) < 0) return -1;
            return emit_three_register(output, mapped, rd, rs1, 30);
        }
    }
    if (strcmp(op, "slli") == 0 || strcmp(op, "srli") == 0 || strcmp(op, "srai") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            !parse_number(tokens[3], &immediate) || immediate < 0 || immediate > 63) {
            set_error(error, error_capacity, line, "RISC-V slli/srli/srai operandı");
            return -1;
        }
        return fprintf(output, "%s R%d, R%d, %ld\n",
                       strcmp(op,"slli")==0?"SHL":"SHR", rd, rs1, immediate) < 0 ? -1 : 0;
    }
    if (strcmp(op, "sll") == 0 || strcmp(op, "srl") == 0 || strcmp(op, "sra") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V sll/srl operandı");
            return -1;
        }
        return emit_three_register(output, strcmp(op,"sll")==0?"SHL":"SHR", rd, rs1, rs2);
    }
    /* ── M-extension: mul / div / rem ── */
    if (strcmp(op, "mul") == 0 || strcmp(op, "mulw") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V mul operandı"); return -1;
        }
        return emit_three_register(output, "MUL", rd, rs1, rs2);
    }
    if (strcmp(op, "div") == 0 || strcmp(op, "divu") == 0 ||
        strcmp(op, "divw") == 0 || strcmp(op, "divuw") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V div operandı"); return -1;
        }
        return emit_three_register(output, "DIV", rd, rs1, rs2);
    }
    if (strcmp(op, "rem") == 0 || strcmp(op, "remu") == 0 ||
        strcmp(op, "remw") == 0 || strcmp(op, "remuw") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V rem operandı"); return -1;
        }
        /* Oxalyn-64: rem = rs1 - (rs1/rs2)*rs2  using scratch R29 */
        if (emit_three_register(output, "DIV", 29, rs1, rs2) < 0) return -1;
        if (emit_three_register(output, "MUL", 29, 29,  rs2) < 0) return -1;
        return emit_three_register(output, "SUB", rd,  rs1, 29);
    }
    /* ── Load/store (basit ofset 0) ── */
    if (strcmp(op, "lw") == 0 || strcmp(op, "ld") == 0 ||
        strcmp(op, "lh") == 0 || strcmp(op, "lb") == 0 ||
        strcmp(op, "lbu") == 0 || strcmp(op, "lhu") == 0 ||
        strcmp(op, "lwu") == 0) {
        /* RISC-V: lw rd, imm(rs1) */
        if (count < 3 || (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "RISC-V load operandı"); return -1;
        }
        normalize_operand(tokens[2]);
        rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2]);
        if (rs1 >= 0)
            return fprintf(output, "LOAD R%d, R%d, 0\n", rd, rs1) < 0 ? -1 : 0;
        /* imm(base) form: parse the base register inside parens */
        {
            char *paren = strchr(tokens[2], '(');
            if (paren) {
                char base_tok[TOKEN_LEN];
                long offset = 0;
                *paren = '\0';
                parse_number(tokens[2], &offset);
                snprintf(base_tok, sizeof(base_tok), "%s", paren + 1);
                { char *rp = strchr(base_tok, ')'); if (rp) *rp = '\0'; }
                normalize_operand(base_tok);
                rs1 = source_register(COMPILER_ARCH_RISCV64, base_tok);
                if (rs1 < 0) { set_error(error, error_capacity, line, "RISC-V load base reg"); return -1; }
                if (offset != 0) {
                    if (fprintf(output, "LI R29, %ld\nADD R29, R%d, R29\nLOAD R%d, R29, 0\n",
                                offset, rs1, rd) < 0) return -1;
                    return 0;
                }
                return fprintf(output, "LOAD R%d, R%d, 0\n", rd, rs1) < 0 ? -1 : 0;
            }
        }
        set_error(error, error_capacity, line, "RISC-V load format desteklenmiyor");
        return -1;
    }
    if (strcmp(op, "sw") == 0 || strcmp(op, "sd") == 0 ||
        strcmp(op, "sh") == 0 || strcmp(op, "sb") == 0) {
        /* RISC-V: sw rs2, imm(rs1) */
        if (count < 3 || (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "RISC-V store src"); return -1;
        }
        normalize_operand(tokens[2]);
        {
            char *paren = strchr(tokens[2], '(');
            long offset = 0;
            if (paren) {
                char base_tok[TOKEN_LEN];
                *paren = '\0';
                parse_number(tokens[2], &offset);
                snprintf(base_tok, sizeof(base_tok), "%s", paren + 1);
                { char *rp = strchr(base_tok, ')'); if (rp) *rp = '\0'; }
                normalize_operand(base_tok);
                rs1 = source_register(COMPILER_ARCH_RISCV64, base_tok);
            } else {
                rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2]);
                offset = 0;
            }
            if (rs1 < 0) { set_error(error, error_capacity, line, "RISC-V store base"); return -1; }
            if (offset != 0) {
                if (fprintf(output, "LI R29, %ld\nADD R29, R%d, R29\nSTORE R%d, R29, 0\n",
                            offset, rs1, rs2) < 0) return -1;
                return 0;
            }
            return fprintf(output, "STORE R%d, R%d, 0\n", rs2, rs1) < 0 ? -1 : 0;
        }
    }
    /* ── LUI / AUIPC ── */
    if (strcmp(op, "lui") == 0) {
        if (count != 3 || (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            !parse_number(tokens[2], &immediate)) {
            set_error(error, error_capacity, line, "RISC-V lui operandı"); return -1;
        }
        /* LUI loads 20-bit upper immediate; approximate with LI on Oxalyn-64 */
        return fprintf(output, "LI R%d, %ld\n", rd, immediate << 12) < 0 ? -1 : 0;
    }
    if (strcmp(op, "auipc") == 0) {
        /* PC-relative upper immediate: not directly expressible; emit NOP comment */
        return fprintf(output, "NOP  ; auipc R%s (PC-relative, not supported)\n", tokens[1]) < 0 ? -1 : 0;
    }
    /* ── ABI stack prologue / epilogue helpers ── */
    /* RISC-V calling convention: ra=x1, sp=x2, a0-a7=x10-x17, s0-s11=x8-x9,x18-x27 */
    if (strcmp(op, "push") == 0) {
        /* Non-standard pseudo added by some assemblers */
        if (count != 2 || (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "RISC-V push operandı"); return -1;
        }
        return fprintf(output, "PUSH R%d\n", rd) < 0 ? -1 : 0;
    }
    if (strcmp(op, "pop") == 0) {
        if (count != 2 || (rd = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0) {
            set_error(error, error_capacity, line, "RISC-V pop operandı"); return -1;
        }
        return fprintf(output, "POP R%d\n", rd) < 0 ? -1 : 0;
    }
    /* ── System calls ── */
    if (strcmp(op, "ecall") == 0 || strcmp(op, "ebreak") == 0)
        return fprintf(output, "ECALL\n") < 0 ? -1 : 0;
    if (strcmp(op, "fence") == 0 || strcmp(op, "fence.i") == 0 ||
        strcmp(op, "wfi") == 0)
        return fprintf(output, "NOP\n") < 0 ? -1 : 0;
    /* ── CSR instructions ── */
    if (strncmp(op, "csr", 3) == 0)
        return fprintf(output, "NOP  ; %s (CSR stub)\n", op) < 0 ? -1 : 0;
    /* ── SLT / SLTU / SLTI ── */
    if (strcmp(op, "slt") == 0 || strcmp(op, "sltu") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V slt operandı"); return -1;
        }
        /* rd = (rs1 < rs2) ? 1 : 0  →  CMPLT + conditional set */
        if (fprintf(output, "CMPLT R%d, R%d, R%d\n", rd, rs1, rs2) < 0) return -1;
        return 0;
    }
    if (strcmp(op, "slti") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            !parse_number(tokens[3], &immediate) || immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line, "RISC-V slti operandı"); return -1;
        }
        if (fprintf(output, "LI R30, %ld\nCMPLT R%d, R%d, R30\n", immediate, rd, rs1) < 0) return -1;
        return 0;
    }
    /* ── addiw / addw / subw (RV64 32-bit variants, map to full-width) ── */
    if (strcmp(op, "addw") == 0 || strcmp(op, "subw") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            (rs2 = source_register(COMPILER_ARCH_RISCV64, tokens[3])) < 0) {
            set_error(error, error_capacity, line, "RISC-V addw/subw operandı"); return -1;
        }
        return emit_three_register(output, strcmp(op,"addw")==0?"ADD":"SUB", rd, rs1, rs2);
    }
    if (strcmp(op, "addiw") == 0) {
        if (count != 4 ||
            (rd  = source_register(COMPILER_ARCH_RISCV64, tokens[1])) < 0 ||
            (rs1 = source_register(COMPILER_ARCH_RISCV64, tokens[2])) < 0 ||
            !parse_number(tokens[3], &immediate) || immediate < -1024 || immediate > 1023) {
            set_error(error, error_capacity, line, "RISC-V addiw operandı"); return -1;
        }
        if (fprintf(output, "LI R30, %ld\n", immediate) < 0) return -1;
        return emit_three_register(output, "ADD", rd, rs1, 30);
    }
    set_error(error, error_capacity, line, "RISC-V komutu desteklenmiyor");
    return -1;
}

/* ================================================================
 * WASM TRANSLATOR
 * WebAssembly binary → Oxalyn-64 assembly dönüştürücü.
 * Sadece mvp subset: i32/i64 aritmetik ve kontrol akışı.
 * ================================================================ */

/* WASM opcode değerleri (MVP subset) */
#define WASM_UNREACHABLE     0x00
#define WASM_NOP             0x01
#define WASM_BLOCK           0x02
#define WASM_LOOP            0x03
#define WASM_IF              0x04
#define WASM_ELSE            0x05
#define WASM_END             0x0B
#define WASM_BR              0x0C
#define WASM_BR_IF           0x0D
#define WASM_BR_TABLE        0x0E
#define WASM_RETURN          0x0F
#define WASM_CALL            0x10
#define WASM_CALL_INDIRECT   0x11
#define WASM_SELECT           0x1B
#define WASM_DROP            0x1A
#define WASM_LOCAL_GET       0x20
#define WASM_LOCAL_SET       0x21
#define WASM_LOCAL_TEE       0x22
#define WASM_GLOBAL_GET      0x23
#define WASM_GLOBAL_SET      0x24
#define WASM_I32_LOAD        0x28
#define WASM_I64_LOAD        0x29
#define WASM_I32_LOAD8_S     0x2C
#define WASM_I32_LOAD8_U     0x2D
#define WASM_I32_LOAD16_S    0x2E
#define WASM_I32_LOAD16_U    0x2F
#define WASM_I64_LOAD8_S     0x30
#define WASM_I64_LOAD8_U     0x31
#define WASM_I64_LOAD16_S    0x32
#define WASM_I64_LOAD16_U    0x33
#define WASM_I64_LOAD32_S    0x34
#define WASM_I64_LOAD32_U    0x35
#define WASM_I32_STORE       0x36
#define WASM_I64_STORE       0x37
#define WASM_I32_STORE8      0x3A
#define WASM_I32_STORE16     0x3B
#define WASM_I64_STORE8      0x3C
#define WASM_I64_STORE16     0x3D
#define WASM_I64_STORE32     0x3E
#define WASM_I32_CONST       0x41
#define WASM_I64_CONST       0x42
#define WASM_I32_EQZ        0x45
#define WASM_I32_EQ         0x46
#define WASM_I32_NE         0x47
#define WASM_I32_LT_S       0x48
#define WASM_I32_LT_U       0x49
#define WASM_I32_GT_S       0x4A
#define WASM_I32_GT_U       0x4B
#define WASM_I32_LE_S       0x4C
#define WASM_I32_LE_U       0x4D
#define WASM_I32_GE_S       0x4E
#define WASM_I32_GE_U       0x4F
#define WASM_I64_EQZ        0x50
#define WASM_I64_EQ         0x51
#define WASM_I64_NE         0x52
#define WASM_I64_LT_S       0x53
#define WASM_I64_LT_U       0x54
#define WASM_I64_GT_S       0x55
#define WASM_I64_GT_U       0x56
#define WASM_I64_LE_S       0x57
#define WASM_I64_LE_U       0x58
#define WASM_I64_GE_S       0x59
#define WASM_I64_GE_U       0x5A
#define WASM_I32_ADD        0x6A
#define WASM_I32_SUB        0x6B
#define WASM_I32_MUL        0x6C
#define WASM_I32_DIV_S      0x6D
#define WASM_I32_DIV_U      0x6E
#define WASM_I32_REM_S      0x6F
#define WASM_I32_REM_U      0x70
#define WASM_I32_AND        0x71
#define WASM_I32_OR         0x72
#define WASM_I32_XOR        0x73
#define WASM_I32_SHL        0x74
#define WASM_I32_SHR_S      0x75
#define WASM_I32_SHR_U      0x76
#define WASM_I32_ROTL       0x77
#define WASM_I32_ROTR       0x78
#define WASM_I64_ADD        0x7C
#define WASM_I64_SUB        0x7D
#define WASM_I64_MUL        0x7E
#define WASM_I64_DIV_S      0x7F
#define WASM_I64_DIV_U      0x80
#define WASM_I64_REM_S      0x81
#define WASM_I64_REM_U      0x82
#define WASM_I64_AND        0x83
#define WASM_I64_OR         0x84
#define WASM_I64_XOR        0x85
#define WASM_I64_SHL        0x86
#define WASM_I64_SHR_S      0x87
#define WASM_I64_SHR_U      0x88
#define WASM_I64_ROTL       0x89
#define WASM_I64_ROTR       0x8A
#define WASM_I32_WRAP_I64   0xA7
#define WASM_I64_EXTEND_I32_S 0xAC
#define WASM_I64_EXTEND_I32_U 0xAD
#define WASM_I32_EXTEND8_S  0xC0
#define WASM_I32_EXTEND16_S 0xC1
#define WASM_I64_EXTEND8_S  0xC2
#define WASM_I64_EXTEND16_S 0xC3
#define WASM_I64_EXTEND32_S 0xC4

/* LEB128 işaretsiz okuyucu */
static uint64_t read_uleb128(const unsigned char *buf, size_t size,
                              size_t *pos)
{
    uint64_t result = 0;
    int shift = 0;
    while (*pos < size) {
        uint8_t byte = buf[(*pos)++];
        result |= (uint64_t)(byte & 0x7F) << shift;
        if (!(byte & 0x80)) break;
        shift += 7;
    }
    return result;
}

/* LEB128 işaretli okuyucu (i32/i64.const için) */
static int64_t read_sleb128(const unsigned char *buf, size_t size,
                             size_t *pos)
{
    int64_t result = 0;
    int shift = 0;
    uint8_t byte = 0;
    while (*pos < size) {
        byte = buf[(*pos)++];
        result |= (int64_t)(byte & 0x7F) << shift;
        shift += 7;
        if (!(byte & 0x80)) break;
    }
    /* İşaret uzatma */
    if (shift < 64 && (byte & 0x40))
        result |= -(INT64_C(1) << shift);
    return result;
}

/*
 * Function indices in WASM include imported functions, while the code
 * section contains only defined functions. Keep module metadata separate
 * from the instruction decoder so calls and exports use the actual index
 * space.
 */
#define WASM_MAX_GLOBALS 256
#define WASM_MAX_TYPES 512
#define WASM_MAX_FUNCTIONS 4096
#define WASM_MAX_PARAMS 16
#define WASM_MAX_TABLE_ENTRIES 1024
#define WASM_FRAME_WORDS 1024
#define WASM_FRAME_SCRATCH_BASE 768
#define WASM_FRAME_OUTGOING_BASE 896

typedef struct {
    int64_t value;
    unsigned value_type;
    unsigned mutable_;
} WasmGlobalInfo;

typedef struct {
    unsigned param_count;
    unsigned result_count;
} WasmFuncType;

typedef struct {
    unsigned imported_functions;
    unsigned defined_functions;
    unsigned type_count;
    unsigned total_functions;
    unsigned entry_function;
    unsigned global_count;
    WasmGlobalInfo globals[WASM_MAX_GLOBALS];
    WasmFuncType types[WASM_MAX_TYPES];
    unsigned function_type_indices[WASM_MAX_FUNCTIONS];
    unsigned table_entries[WASM_MAX_TABLE_ENTRIES];
    unsigned table_entry_count;
    unsigned table_offset;
    unsigned table_index;
    unsigned memory_min_pages;
    int has_entry;
    int has_memory;
} WasmModuleInfo;

static const WasmModuleInfo *active_wasm_module;

/* Reserved Oxalyn word addresses for lowered WASM globals. */
#define WASM_GLOBAL_WORD_BASE 0xF000u

static const WasmFuncType *wasm_function_type(unsigned func_index)
{
    unsigned type_index;

    if (!active_wasm_module ||
        func_index >= active_wasm_module->total_functions)
        return NULL;
    type_index = active_wasm_module->function_type_indices[func_index];
    if (type_index >= active_wasm_module->type_count)
        return NULL;
    return &active_wasm_module->types[type_index];
}

typedef struct {
    unsigned id;
    unsigned kind; /* 0=function, 1=block, 2=loop, 3=if */
    char start_label[48];
    char else_label[48];
    char end_label[48];
    int saw_else;
} WasmControlFrame;

static void wasm_emit_variable_shift(FILE *output, unsigned dst,
                                      unsigned value_reg, unsigned count_reg,
                                      unsigned width, int mode, unsigned serial,
                                      unsigned func_index)
{
    char loop_label[64];
    char no_fill_label[64];
    char end_label[64];

    snprintf(loop_label, sizeof(loop_label), "wasm_shift_%u_%u_loop",
             func_index, serial);
    snprintf(no_fill_label, sizeof(no_fill_label), "wasm_shift_%u_%u_nofill",
             func_index, serial);
    snprintf(end_label, sizeof(end_label), "wasm_shift_%u_%u_end",
             func_index, serial);

    /* R26=count, R27=value, R25=temporary predicate, R28=scratch. */
    fprintf(output, "    MOV R26, R%u\n", count_reg);
    fprintf(output, "    MOV R27, R%u\n", value_reg);
    fprintf(output, "    LI R28, %u\n", width - 1);
    fprintf(output, "    AND R26, R26, R28\n");
    if (width == 32) {
        fprintf(output, "    LI R28, -1\n");
        fprintf(output, "    SHR R28, R28, 32\n");
        fprintf(output, "    AND R27, R27, R28\n");
    }
    if (mode == 2) {
        fprintf(output, "    BTEST R25, R27, 31\n");
    }
    fprintf(output, "%s:\n", loop_label);
    fprintf(output, "    CMPEQ R28, R26, R0\n");
    fprintf(output, "    JNZ R28, %s\n", end_label);
    if (mode == 3 || mode == 4) {
        fprintf(output, "    BTEST R25, R27, %u\n",
                mode == 3 ? width - 1 : 0);
        if (mode == 3)
            fprintf(output, "    SHL R27, R27, 1\n");
        else
            fprintf(output, "    SHR R27, R27, 1\n");
        fprintf(output, "    JZ R25, %s\n", no_fill_label);
        fprintf(output, "    BSET R27, R27, %u\n",
                mode == 3 ? 0 : width - 1);
        fprintf(output, "%s:\n", no_fill_label);
    } else if (mode == 0) {
        fprintf(output, "    SHL R27, R27, 1\n");
    } else if (mode == 2) {
        fprintf(output, "    SHR R27, R27, 1\n");
        fprintf(output, "    JZ R25, %s\n", no_fill_label);
        fprintf(output, "    BSET R27, R27, %u\n", width - 1);
        fprintf(output, "%s:\n", no_fill_label);
    } else {
        fprintf(output, "    SHR R27, R27, 1\n");
    }
    fprintf(output, "    DEC R26\n");
    fprintf(output, "    JMP %s\n", loop_label);
    fprintf(output, "%s:\n", end_label);
    if (width == 32) {
        fprintf(output, "    LI R28, -1\n");
        fprintf(output, "    SHR R28, R28, 32\n");
        fprintf(output, "    AND R27, R27, R28\n");
    }
    fprintf(output, "    MOV R%u, R27\n", dst);
}

static void wasm_emit_narrow_sign_extend(FILE *output, unsigned value_reg,
                                         unsigned bits, unsigned serial,
                                         unsigned func_index)
{
    char sign_label[64];
    char done_label[64];

    snprintf(sign_label, sizeof(sign_label), "wasm_sign_%u_%u",
             func_index, serial);
    snprintf(done_label, sizeof(done_label), "wasm_sign_done_%u_%u",
             func_index, serial);
    /* The source value may be a full-width stack value (unlike a narrow
     * load), so truncate it before inspecting the sign bit. */
    fprintf(output, "    LI R28, -1\n");
    fprintf(output, "    SHR R28, R28, %u\n", 64 - bits);
    fprintf(output, "    AND R%u, R%u, R28\n", value_reg, value_reg);
    fprintf(output, "    BTEST R27, R%u, %u\n", value_reg, bits - 1);
    fprintf(output, "    JNZ R27, %s\n", sign_label);
    fprintf(output, "    JMP %s\n", done_label);
    fprintf(output, "%s:\n", sign_label);
    fprintf(output, "    LI R28, -1\n");
    fprintf(output, "    LI R26, -1\n");
    fprintf(output, "    SHR R26, R26, %u\n", 64 - bits);
    fprintf(output, "    XOR R28, R28, R26\n");
    fprintf(output, "    OR R%u, R%u, R28\n", value_reg, value_reg);
    fprintf(output, "%s:\n", done_label);
}

static void wasm_emit_load_bytes(FILE *output, unsigned dst,
                                 unsigned address_reg, unsigned width_bytes,
                                 int signed_value, unsigned serial,
                                 unsigned func_index)
{
    unsigned i;
    unsigned temp_reg = 25;
    unsigned base_reg = 28;

    /*
     * Preserve the byte address while accumulating a little-endian WASM
     * value. LOADB itself performs the Oxalyn word-address to byte extraction.
     */
    fprintf(output, "    MOV R%u, R%u\n", base_reg, address_reg);
    fprintf(output, "    CLR R%u\n", dst);
    for (i = 0; i < width_bytes; i++) {
        fprintf(output, "    LOADB R%u, R%u, %u\n",
                temp_reg, base_reg, i);
        if (i != 0)
            fprintf(output, "    SHL R%u, R%u, %u\n",
                    temp_reg, temp_reg, i * 8);
        fprintf(output, "    OR R%u, R%u, R%u\n",
                dst, dst, temp_reg);
    }
    if (signed_value)
        wasm_emit_narrow_sign_extend(output, dst, width_bytes * 8, serial,
                                     func_index);
}

static void wasm_emit_store_bytes(FILE *output, unsigned address_reg,
                                  unsigned value_reg, unsigned width_bytes)
{
    unsigned i;

    /*
     * A byte store only consumes the low byte. Shift the value into the
     * corresponding little-endian byte position before STOREB.
     */
    fprintf(output, "    MOV R28, R%u\n", address_reg);
    fprintf(output, "    MOV R27, R%u\n", value_reg);
    for (i = 0; i < width_bytes; i++) {
        fprintf(output, "    STOREB R27, R28, %u\n", i);
        if (i + 1 < width_bytes)
            fprintf(output, "    SHR R27, R27, 8\n");
    }
}

static void wasm_emit_memory_copy(FILE *output, unsigned dst_reg,
                                  unsigned src_reg, unsigned length_reg,
                                  unsigned serial, unsigned func_index)
{
    char loop_label[64];
    char done_label[64];

    snprintf(loop_label, sizeof(loop_label), "wasm_memcpy_%u_%u_loop",
             func_index, serial);
    snprintf(done_label, sizeof(done_label), "wasm_memcpy_%u_%u_done",
             func_index, serial);
    fprintf(output, "    MOV R25, R%u\n", dst_reg);
    fprintf(output, "    MOV R26, R%u\n", src_reg);
    fprintf(output, "    MOV R27, R%u\n", length_reg);
    fprintf(output, "%s:\n", loop_label);
    fprintf(output, "    JZ R27, %s\n", done_label);
    fprintf(output, "    LOADB R28, R26, 0\n");
    fprintf(output, "    STOREB R28, R25, 0\n");
    fprintf(output, "    INC R25\n");
    fprintf(output, "    INC R26\n");
    fprintf(output, "    DEC R27\n");
    fprintf(output, "    JMP %s\n", loop_label);
    fprintf(output, "%s:\n", done_label);
}

static void wasm_emit_frame_load(FILE *output, unsigned dst, unsigned base,
                                 unsigned offset)
{
    if (offset <= 1023) {
        fprintf(output, "    LOAD R%u, R%u, %u\n", dst, base, offset);
    } else {
        fprintf(output, "    MOVI R28, %u\n", offset);
        fprintf(output, "    ADD R28, R%u, R28\n", base);
        fprintf(output, "    LOAD R%u, R28, 0\n", dst);
    }
}

static void wasm_emit_frame_store(FILE *output, unsigned src, unsigned base,
                                  unsigned offset)
{
    if (offset <= 1023) {
        fprintf(output, "    STORE R%u, R%u, %u\n", src, base, offset);
    } else {
        fprintf(output, "    MOVI R28, %u\n", offset);
        fprintf(output, "    ADD R28, R%u, R28\n", base);
        fprintf(output, "    STORE R%u, R28, 0\n", src);
    }
}

static int wasm_read_name(const unsigned char *buf, size_t size, size_t *pos,
                          char *out, size_t capacity)
{
    uint64_t length = read_uleb128(buf, size, pos);

    if (length >= capacity || *pos > size || length > size - *pos)
        return -1;
    memcpy(out, buf + *pos, (size_t)length);
    out[length] = '\0';
    *pos += (size_t)length;
    return 0;
}

static int wasm_skip_limits(const unsigned char *buf, size_t size,
                            size_t *pos, unsigned *minimum)
{
    uint64_t flags;

    if (*pos >= size)
        return -1;
    flags = read_uleb128(buf, size, pos);
    if (flags & 1)
        (void)read_uleb128(buf, size, pos);
    if (minimum)
        *minimum = (unsigned)read_uleb128(buf, size, pos);
    return *pos <= size ? 0 : -1;
}

static int wasm_skip_const_expr(const unsigned char *buf, size_t size,
                                size_t *pos, int64_t *value,
                                unsigned *value_type)
{
    uint8_t op;

    if (*pos >= size)
        return -1;
    op = buf[(*pos)++];
    if (op == WASM_I32_CONST || op == WASM_I64_CONST) {
        if (value)
            *value = read_sleb128(buf, size, pos);
        if (value_type)
            *value_type = op == WASM_I32_CONST ? 0x7f : 0x7e;
    } else {
        /* Runtime-dependent initializers require a real init relocation. */
        return -1;
    }
    if (*pos >= size || buf[(*pos)++] != WASM_END)
        return -1;
    return 0;
}

static int wasm_parse_module(const unsigned char *buf, size_t size,
                             WasmModuleInfo *info,
                             size_t *code_start, size_t *code_size)
{
    static const unsigned char magic[4] = {0x00, 0x61, 0x73, 0x6d};
    static const unsigned char version[4] = {0x01, 0x00, 0x00, 0x00};
    size_t pos = 8;

    memset(info, 0, sizeof(*info));
    if (size < 8 || memcmp(buf, magic, 4) != 0 ||
        memcmp(buf + 4, version, 4) != 0)
        return -1;

    while (pos < size) {
        uint8_t section_id = buf[pos++];
        uint64_t section_len = read_uleb128(buf, size, &pos);
        size_t section_end;
        size_t p;

        if (section_len > size - pos)
            return -1;
        section_end = pos + (size_t)section_len;
        p = pos;

        if (section_id == 2) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            uint64_t i;
            for (i = 0; i < count; i++) {
                char module_name[128];
                char field_name[128];
                uint8_t kind;

                if (wasm_read_name(buf, section_end, &p, module_name,
                                   sizeof(module_name)) != 0 ||
                    wasm_read_name(buf, section_end, &p, field_name,
                                   sizeof(field_name)) != 0 ||
                    p >= section_end)
                    return -1;
                kind = buf[p++];
                if (kind == 0) {
                    uint64_t type_index = read_uleb128(buf, section_end, &p);
                    if (info->total_functions >= WASM_MAX_FUNCTIONS) {
                        return -1;
                    }
                    info->function_type_indices[info->total_functions++] =
                        (unsigned)type_index;
                    info->imported_functions++;
                } else if (kind == 1) {
                    if (p >= section_end)
                        return -1;
                    p++; /* element type */
                    if (wasm_skip_limits(buf, section_end, &p, NULL) != 0)
                        return -1;
                } else if (kind == 2) {
                    info->has_memory = 1;
                    if (wasm_skip_limits(buf, section_end, &p,
                                         &info->memory_min_pages) != 0)
                        return -1;
                } else if (kind == 3) {
                    if (p + 2 > section_end)
                        return -1;
                    p += 2; /* global type + mutability */
                } else {
                    return -1;
                }
            }
        } else if (section_id == 1) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            uint64_t i;
            if (count > WASM_MAX_TYPES)
                return -1;
            info->type_count = (unsigned)count;
            for (i = 0; i < count; i++) {
                uint64_t param_count;
                uint64_t result_count;
                uint64_t j;

                if (p >= section_end || buf[p++] != 0x60)
                    return -1;
                param_count = read_uleb128(buf, section_end, &p);
                if (param_count > WASM_MAX_PARAMS)
                    return -1;
                info->types[i].param_count = (unsigned)param_count;
                for (j = 0; j < param_count; j++) {
                    if (p >= section_end)
                        return -1;
                    p++; /* value type */
                }
                result_count = read_uleb128(buf, section_end, &p);
                if (result_count > 1)
                    return -1;
                info->types[i].result_count = (unsigned)result_count;
                for (j = 0; j < result_count; j++) {
                    if (p >= section_end)
                        return -1;
                    p++; /* value type */
                }
            }
        } else if (section_id == 3) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            uint64_t i;
            if (count > WASM_MAX_FUNCTIONS - info->total_functions)
                return -1;
            info->defined_functions = (unsigned)count;
            for (i = 0; i < count; i++) {
                uint64_t type_index = read_uleb128(buf, section_end, &p);
                if (info->total_functions >= WASM_MAX_FUNCTIONS)
                    return -1;
                info->function_type_indices[info->total_functions++] =
                    (unsigned)type_index;
            }
        } else if (section_id == 5) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            if (count > 0) {
                info->has_memory = 1;
                if (wasm_skip_limits(buf, section_end, &p,
                                     &info->memory_min_pages) != 0)
                    return -1;
            }
        } else if (section_id == 6) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            uint64_t i;
            if (count > WASM_MAX_GLOBALS)
                return -1;
            info->global_count = (unsigned)count;
            for (i = 0; i < count; i++) {
                if (p + 2 > section_end)
                    return -1;
                info->globals[i].value_type = buf[p++];
                info->globals[i].mutable_ = buf[p++];
                if (wasm_skip_const_expr(buf, section_end, &p,
                                          &info->globals[i].value,
                                          &info->globals[i].value_type) != 0)
                    return -1;
            }
        } else if (section_id == 7) {
            uint64_t count = read_uleb128(buf, section_end, &p);
            uint64_t i;
            for (i = 0; i < count; i++) {
                char name[128];
                uint8_t kind;
                uint64_t index;

                if (wasm_read_name(buf, section_end, &p, name, sizeof(name)) != 0 ||
                    p >= section_end)
                    return -1;
                kind = buf[p++];
                index = read_uleb128(buf, section_end, &p);
                if (kind == 0 && strcmp(name, "kernel_main") == 0) {
                    info->entry_function = (unsigned)index;
                    info->has_entry = 1;
                }
            }
        } else if (section_id == 9) {
            uint64_t segment_count = read_uleb128(buf, section_end, &p);
            uint64_t segment;

            for (segment = 0; segment < segment_count; segment++) {
                uint64_t flags = read_uleb128(buf, section_end, &p);
                int64_t offset = 0;
                uint64_t element_count;
                uint64_t i;

                if (flags == 0) {
                    info->table_index = 0;
                } else if (flags == 2) {
                    info->table_index =
                        (unsigned)read_uleb128(buf, section_end, &p);
                } else {
                    /* Passive/declarative tables need runtime support. */
                    return -1;
                }
                if (wasm_skip_const_expr(buf, section_end, &p,
                                         &offset, NULL) != 0 ||
                    offset < 0 || offset > WASM_MAX_TABLE_ENTRIES) {
                    return -1;
                }
                if (flags == 2) {
                    if (p >= section_end)
                        return -1;
                    p++; /* elemkind */
                }
                element_count = read_uleb128(buf, section_end, &p);
                if (element_count > WASM_MAX_TABLE_ENTRIES ||
                    (unsigned)offset + (unsigned)element_count >
                        WASM_MAX_TABLE_ENTRIES) {
                    return -1;
                }
                for (i = 0; i < element_count; i++) {
                    unsigned table_slot = (unsigned)offset + (unsigned)i;
                    unsigned function_index =
                        (unsigned)read_uleb128(buf, section_end, &p);
                    if (table_slot >= WASM_MAX_TABLE_ENTRIES)
                        return -1;
                    info->table_entries[table_slot] = function_index;
                    if (table_slot + 1 > info->table_entry_count)
                        info->table_entry_count = table_slot + 1;
                }
            }
        } else if (section_id == 10) {
            *code_start = pos;
            *code_size = (size_t)section_len;
        }
        pos = section_end;
    }

    if (!*code_start || !*code_size || !info->defined_functions ||
        info->total_functions != info->imported_functions +
                                  info->defined_functions)
        return -1;
    {
        unsigned i;
        for (i = 0; i < info->total_functions; i++) {
            if (info->function_type_indices[i] >= info->type_count)
                return -1;
        }
    }
    return 0;
}

/* WASM modül başlığını doğrula ve ilk code section'ı bul.
 * Dönüş: code section başlangıç ofseti, -1 = geçersiz modül */
static int wasm_find_code_section(const unsigned char *buf, size_t size,
                                  size_t *code_start, size_t *code_size)
{
    const unsigned char MAGIC[4]   = {0x00, 0x61, 0x73, 0x6D};
    const unsigned char VERSION[4] = {0x01, 0x00, 0x00, 0x00};
    size_t pos = 0;

    if (size < 8) return -1;
    if (memcmp(buf, MAGIC, 4) != 0 || memcmp(buf + 4, VERSION, 4) != 0) return -1;
    pos = 8;

    while (pos < size) {
        uint8_t section_id;
        uint64_t section_len;
        if (pos >= size) break;
        section_id  = buf[pos++];
        section_len = read_uleb128(buf, size, &pos);
        if (section_id == 10) {   /* Code section */
            *code_start = pos;
            *code_size  = (size_t)section_len;
            return 0;
        }
        pos += (size_t)section_len;
    }
    return -1;
}

/* Tek WASM fonksiyon gövdesini Oxalyn-64 assembly'ye çevirir.
 * Sanal yığın için R4-R24 kullanılır (R25-R31 rezerve). */
int wasm_translate_function(FILE *output, const unsigned char *body,
                             size_t body_size, unsigned func_index)
{
    /*
     * Sanal yığın: SP olarak bir yazmaç sayacı kullanılır.
     * Yığın değerleri R4, R5, ..., R24'e eşlenir (derinlik 0-20).
     * depth = mevcut yığın derinliği; yeni push → R(4+depth).
     */
    int depth = 0;
    size_t pos = 0;
    unsigned label_cnt = 0;
    unsigned local_count = 0;
    unsigned shift_serial = 0;
    unsigned control_depth = 1;
    WasmControlFrame controls[256];
    const WasmFuncType *func_type = wasm_function_type(func_index);

    /* Yerel değişken sayısı (LEB128) */
    uint64_t local_decl_count = read_uleb128(body, body_size, &pos);
    {
        uint64_t i;
        for (i = 0; i < local_decl_count; i++) {
            uint64_t count = read_uleb128(body, body_size, &pos);
            if (count > WASM_FRAME_WORDS ||
                local_count > WASM_FRAME_WORDS - (unsigned)count) {
                fprintf(stderr, "WASM function %u: local frame is too large\n",
                        func_index);
                return -1;
            }
            local_count += (unsigned)count;
            pos++;                                /* type  */
        }
    }

    fprintf(output, "; WASM function %u\n", func_index);
    fprintf(output, "wasm_func_%u:\n", func_index);
    fprintf(output, "    LI R28, -%u\n", WASM_FRAME_WORDS);
    fprintf(output, "    ADD R31, R31, R28\n");
    fprintf(output, "    STORE R30, R31, 0\n");
    fprintf(output, "    STORE R29, R31, 1\n");
    fprintf(output, "    MOV R29, R31\n");
    if (func_type && func_type->param_count > WASM_MAX_PARAMS) {
        fprintf(stderr, "WASM function %u: too many parameters\n", func_index);
        return -1;
    }
    if (func_type) {
        unsigned i;
        for (i = 0; i < func_type->param_count; i++) {
            if (i < 4) {
                fprintf(output, "    STORE R%u, R29, %u\n", i + 1, 2 + i);
            } else {
                wasm_emit_frame_load(output, 28, 31,
                                     WASM_FRAME_WORDS +
                                     WASM_FRAME_OUTGOING_BASE + i);
                wasm_emit_frame_store(output, 28, 29, 2 + i);
            }
        }
    }
    memset(controls, 0, sizeof(controls));
    controls[0].id = label_cnt++;
    controls[0].kind = 0;
    snprintf(controls[0].end_label, sizeof(controls[0].end_label),
             "wasm_return_%u", func_index);

    while (pos < body_size) {
        uint8_t op = body[pos++];

        /* Yığın taşma/düşme koruması */
        if (depth > 20) {
            fprintf(stderr, "WASM function %u: value stack overflow at byte %zu\n",
                    func_index, pos - 1);
            return -1;
        }
        if (depth < 0) {
            fprintf(stderr, "WASM function %u: value stack underflow at byte %zu\n",
                    func_index, pos - 1);
            return -1;
        }

#define TOP     (3 + depth)         /* mevcut TOS register indeksi */
#define PUSH(r) do { depth++; } while(0)
#define POP()   do { if (depth>0) depth--; } while(0)

        switch (op) {
        case WASM_NOP:
            fprintf(output, "    NOP\n");
            break;
        case WASM_UNREACHABLE:
            fprintf(output, "    HALT  ; unreachable\n");
            break;
        case WASM_RETURN:
            if (func_type && func_type->result_count > 0) {
                if (depth <= 0) {
                    fprintf(stderr, "WASM function %u: return stack underflow\n",
                            func_index);
                    return -1;
                }
                fprintf(output, "    MOV R7, R%d\n", TOP);
            }
            fprintf(output, "    JMP wasm_return_%u\n", func_index);
            depth = 0;
            break;
        case WASM_DROP:
            if (depth <= 0) {
                fprintf(stderr, "WASM function %u: drop stack underflow\n",
                        func_index);
                return -1;
            }
            POP();
            break;
        case WASM_SELECT: {
            char false_label[64];
            char done_label[64];

            if (depth < 3) {
                fprintf(stderr, "WASM function %u: select stack underflow\n",
                        func_index);
                return -1;
            }
            snprintf(false_label, sizeof(false_label),
                     "wasm_select_false_%u_%u", func_index, label_cnt);
            snprintf(done_label, sizeof(done_label),
                     "wasm_select_done_%u_%u", func_index, label_cnt++);
            fprintf(output, "    JZ R%d, %s\n", TOP, false_label);
            fprintf(output, "    JMP %s\n", done_label);
            fprintf(output, "%s:\n", false_label);
            fprintf(output, "    MOV R%d, R%d\n", TOP - 2, TOP - 1);
            fprintf(output, "%s:\n", done_label);
            POP();
            POP();
            break;
        }
        case WASM_LOCAL_GET: {
            uint64_t idx = read_uleb128(body, body_size, &pos);
            unsigned param_count = func_type ? func_type->param_count : 0;
            if (idx >= (uint64_t)param_count + local_count) {
                fprintf(stderr, "WASM function %u: local.get index %llu is unsupported\n",
                        func_index, (unsigned long long)idx);
                return -1;
            }
            depth++;
            fprintf(output, "    LOAD R%d, R29, %llu  ; local.get %llu\n",
                    TOP, (unsigned long long)(2 + idx),
                    (unsigned long long)idx);
            break;
        }
        case WASM_LOCAL_SET: {
            uint64_t idx = read_uleb128(body, body_size, &pos);
            unsigned param_count = func_type ? func_type->param_count : 0;
            if (idx >= (uint64_t)param_count + local_count || depth <= 0) {
                fprintf(stderr, "WASM function %u: invalid local.set %llu\n",
                        func_index, (unsigned long long)idx);
                return -1;
            }
            fprintf(output, "    STORE R%d, R29, %llu  ; local.set %llu\n",
                    TOP, (unsigned long long)(2 + idx),
                    (unsigned long long)idx);
            POP();
            break;
        }
        case WASM_LOCAL_TEE: {
            uint64_t idx = read_uleb128(body, body_size, &pos);
            unsigned param_count = func_type ? func_type->param_count : 0;
            if (idx >= (uint64_t)param_count + local_count || depth <= 0) {
                fprintf(stderr, "WASM function %u: invalid local.tee %llu\n",
                        func_index, (unsigned long long)idx);
                return -1;
            }
            fprintf(output, "    STORE R%d, R29, %llu  ; local.tee %llu\n",
                    TOP, (unsigned long long)(2 + idx),
                    (unsigned long long)idx);
            break;
        }
        case WASM_GLOBAL_GET: {
            uint64_t idx = read_uleb128(body, body_size, &pos);
            if (!active_wasm_module ||
                idx >= active_wasm_module->global_count) {
                fprintf(stderr,
                        "WASM function %u: invalid global.get %llu "
                        "(global_count=%u imported=%u)\n",
                        func_index, (unsigned long long)idx,
                        active_wasm_module ? active_wasm_module->global_count : 0,
                        active_wasm_module ? active_wasm_module->imported_functions : 0);
                return -1;
            }
            depth++;
            fprintf(output, "    MOVI R28, %u\n    LOAD R%d, R28, 0  ; global.get %llu\n",
                    WASM_GLOBAL_WORD_BASE + (unsigned)idx, TOP,
                    (unsigned long long)idx);
            break;
        }
        case WASM_GLOBAL_SET: {
            uint64_t idx = read_uleb128(body, body_size, &pos);
            if (!active_wasm_module ||
                idx >= active_wasm_module->global_count ||
                !active_wasm_module->globals[idx].mutable_) {
                fprintf(stderr, "WASM function %u: invalid global.set %llu\n",
                        func_index, (unsigned long long)idx);
                return -1;
            }
            if (depth <= 0)
                return -1;
            fprintf(output, "    MOVI R28, %u\n    STORE R%d, R28, 0  ; global.set %llu\n",
                    WASM_GLOBAL_WORD_BASE + (unsigned)idx, TOP,
                    (unsigned long long)idx);
            POP();
            break;
        }
        case WASM_I32_CONST: {
            int64_t val = read_sleb128(body, body_size, &pos);
            depth++;
            if (val >= -1024 && val <= 1023)
                fprintf(output, "    LI R%d, %lld  ; i32.const\n",
                        TOP, (long long)val);
            else
                fprintf(output, "    MOVI R%d, %lld  ; i32.const\n",
                        TOP, (long long)val);
            break;
        }
        case WASM_I64_CONST: {
            int64_t val = read_sleb128(body, body_size, &pos);
            depth++;
            if (val >= -1024 && val <= 1023)
                fprintf(output, "    LI R%d, %lld  ; i64.const\n",
                        TOP, (long long)val);
            else
                fprintf(output, "    MOVI R%d, %lld  ; i64.const\n",
                        TOP, (long long)val);
            break;
        }
        case WASM_I32_ADD: case WASM_I64_ADD:
            fprintf(output, "    ADD R%d, R%d, R%d  ; i32/64.add\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_SUB: case WASM_I64_SUB:
            fprintf(output, "    SUB R%d, R%d, R%d  ; i32/64.sub\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_MUL: case WASM_I64_MUL:
            fprintf(output, "    MUL R%d, R%d, R%d  ; i32/64.mul\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_DIV_S: case WASM_I64_DIV_S:
            fprintf(output, "    DIV R%d, R%d, R%d  ; i32/64.div_s\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_DIV_U:
        case WASM_I64_DIV_U:
            fprintf(output, "    DIVU R%d, R%d, R%d  ; i32/64.div_u\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_REM_S:
        case WASM_I64_REM_S:
            fprintf(output, "    REM R%d, R%d, R%d  ; i32/64.rem_s\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_REM_U:
        case WASM_I64_REM_U:
            fprintf(output, "    REMU R%d, R%d, R%d  ; i32/64.rem_u\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_AND: case WASM_I64_AND:
            fprintf(output, "    AND R%d, R%d, R%d  ; i32/64.and\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_OR: case WASM_I64_OR:
            fprintf(output, "    OR  R%d, R%d, R%d  ; i32/64.or\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_XOR: case WASM_I64_XOR:
            fprintf(output, "    XOR R%d, R%d, R%d  ; i32/64.xor\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_SHL:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     32, 0, shift_serial++, func_index);
            POP(); break;
        case WASM_I32_SHR_S:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     32, 2, shift_serial++, func_index);
            POP(); break;
        case WASM_I32_SHR_U:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     32, 1, shift_serial++, func_index);
            POP(); break;
        case WASM_I32_ROTL:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     32, 3, shift_serial++, func_index);
            POP(); break;
        case WASM_I32_ROTR:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     32, 4, shift_serial++, func_index);
            POP(); break;
        case WASM_I64_SHL:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     64, 0, shift_serial++, func_index);
            POP(); break;
        case WASM_I64_SHR_S:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     64, 2, shift_serial++, func_index);
            POP(); break;
        case WASM_I64_SHR_U:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     64, 1, shift_serial++, func_index);
            POP(); break;
        case WASM_I64_ROTL:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     64, 3, shift_serial++, func_index);
            POP(); break;
        case WASM_I64_ROTR:
            wasm_emit_variable_shift(output, (unsigned)(TOP - 1),
                                     (unsigned)(TOP - 1), (unsigned)TOP,
                                     64, 4, shift_serial++, func_index);
            POP(); break;
        case WASM_I32_EQZ:
            fprintf(output, "    CMPEQ R%d, R%d, R0  ; i32.eqz\n", TOP, TOP);
            break;
        case WASM_I64_EQZ:
            fprintf(output, "    CMPEQ R%d, R%d, R0  ; i64.eqz\n", TOP, TOP);
            break;
        case WASM_I32_EQ:
        case WASM_I64_EQ:
            fprintf(output, "    CMPEQ R%d, R%d, R%d  ; i32.eq\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_NE:
        case WASM_I64_NE:
            fprintf(output, "    CMPNE R%d, R%d, R%d  ; i32.ne\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_LT_S:
        case WASM_I64_LT_S:
            fprintf(output, "    CMPLT R%d, R%d, R%d  ; i32.lt_s\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_LT_U:
        case WASM_I64_LT_U:
            fprintf(output, "    CMPLTU R%d, R%d, R%d  ; i32.lt_u\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_GT_S:
        case WASM_I64_GT_S:
            fprintf(output, "    CMPLT R%d, R%d, R%d  ; i32.gt_s\n",
                    TOP-1, TOP, TOP-1);
            POP(); break;
        case WASM_I32_GT_U:
        case WASM_I64_GT_U:
            fprintf(output, "    CMPLTU R%d, R%d, R%d  ; i32.gt_u\n",
                    TOP-1, TOP, TOP-1);
            POP(); break;
        case WASM_I32_LE_S:
        case WASM_I64_LE_S:
            fprintf(output, "    CMPLE R%d, R%d, R%d  ; i32.le_s\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_LE_U:
        case WASM_I64_LE_U:
            fprintf(output, "    CMPLEU R%d, R%d, R%d  ; i32.le_u\n",
                    TOP-1, TOP-1, TOP);
            POP(); break;
        case WASM_I32_GE_S:
        case WASM_I64_GE_S:
            fprintf(output, "    CMPLE R%d, R%d, R%d  ; i32.ge_s\n",
                    TOP-1, TOP, TOP-1);
            POP(); break;
        case WASM_I32_GE_U:
        case WASM_I64_GE_U:
            fprintf(output, "    CMPLEU R%d, R%d, R%d  ; i32.ge_u\n",
                    TOP-1, TOP, TOP-1);
            POP(); break;
        case WASM_I32_WRAP_I64:
            /*
             * Oxalyn registers are 64-bit while WASM i32 values wrap at
             * 32 bits. Build 0x00000000FFFFFFFF without relying on a
             * non-existent large immediate and mask the value explicitly.
             */
            fprintf(output, "    LI R28, -1\n");
            fprintf(output, "    SHR R28, R28, 32\n");
            fprintf(output, "    AND R%d, R%d, R28  ; i32.wrap_i64\n",
                    TOP, TOP);
            break;
        case WASM_I64_EXTEND_I32_U:
            fprintf(output, "    LI R28, -1\n");
            fprintf(output, "    SHR R28, R28, 32\n");
            fprintf(output, "    AND R%d, R%d, R28  ; i64.extend_i32_u\n",
                    TOP, TOP);
            break;
        case WASM_I64_EXTEND_I32_S: {
            unsigned serial = shift_serial++;
            char sign_label[64];
            char done_label[64];
            snprintf(sign_label, sizeof(sign_label),
                     "wasm_extend_%u_%u_sign", func_index, serial);
            snprintf(done_label, sizeof(done_label),
                     "wasm_extend_%u_%u_done", func_index, serial);
            fprintf(output, "    LI R28, -1\n");
            fprintf(output, "    SHR R28, R28, 32\n");
            fprintf(output, "    AND R%d, R%d, R28\n", TOP, TOP);
            fprintf(output, "    BTEST R25, R%d, 31\n", TOP);
            fprintf(output, "    JNZ R25, %s\n", sign_label);
            fprintf(output, "    JMP %s\n", done_label);
            fprintf(output, "%s:\n", sign_label);
            fprintf(output, "    LI R28, -1\n");
            fprintf(output, "    SHL R28, R28, 32\n");
            fprintf(output, "    OR R%d, R%d, R28\n", TOP, TOP);
            fprintf(output, "%s:\n", done_label);
            break;
        }
        case WASM_I32_EXTEND8_S:
        case WASM_I64_EXTEND8_S:
            wasm_emit_narrow_sign_extend(output, (unsigned)TOP, 8,
                                         shift_serial++, func_index);
            break;
        case WASM_I32_EXTEND16_S:
        case WASM_I64_EXTEND16_S:
            wasm_emit_narrow_sign_extend(output, (unsigned)TOP, 16,
                                         shift_serial++, func_index);
            break;
        case WASM_I64_EXTEND32_S:
            wasm_emit_narrow_sign_extend(output, (unsigned)TOP, 32,
                                         shift_serial++, func_index);
            break;
        case WASM_I32_LOAD:
        case WASM_I64_LOAD:
        case WASM_I32_LOAD8_S:
        case WASM_I32_LOAD8_U:
        case WASM_I32_LOAD16_S:
        case WASM_I32_LOAD16_U:
        case WASM_I64_LOAD8_S:
        case WASM_I64_LOAD8_U:
        case WASM_I64_LOAD16_S:
        case WASM_I64_LOAD16_U:
        case WASM_I64_LOAD32_S:
        case WASM_I64_LOAD32_U: {
            unsigned width_bytes;
            int signed_value = 0;
            read_uleb128(body, body_size, &pos);  /* alignment */
            {
                uint64_t offset = read_uleb128(body, body_size, &pos);
                fprintf(output, "    MOVI R28, %llu\n    ADD R28, R%d, R28\n",
                        (unsigned long long)offset, TOP);
            }
            if (op == WASM_I32_LOAD || op == WASM_I64_LOAD)
                width_bytes = op == WASM_I32_LOAD ? 4 : 8;
            else if (op == WASM_I32_LOAD8_S || op == WASM_I32_LOAD8_U ||
                     op == WASM_I64_LOAD8_S || op == WASM_I64_LOAD8_U)
                width_bytes = 1;
            else if (op == WASM_I32_LOAD16_S || op == WASM_I32_LOAD16_U ||
                     op == WASM_I64_LOAD16_S || op == WASM_I64_LOAD16_U)
                width_bytes = 2;
            else
                width_bytes = 4;
            signed_value = op == WASM_I32_LOAD8_S ||
                           op == WASM_I32_LOAD16_S ||
                           op == WASM_I64_LOAD8_S ||
                           op == WASM_I64_LOAD16_S ||
                           op == WASM_I64_LOAD32_S;
            wasm_emit_load_bytes(output, (unsigned)TOP, 28,
                                 width_bytes, signed_value, shift_serial++,
                                 func_index);
            break;
        }
        case WASM_I32_STORE:
        case WASM_I64_STORE:
        case WASM_I32_STORE8:
        case WASM_I32_STORE16:
        case WASM_I64_STORE8:
        case WASM_I64_STORE16:
        case WASM_I64_STORE32: {
            unsigned width_bytes;
            read_uleb128(body, body_size, &pos);  /* alignment */
            {
                uint64_t offset = read_uleb128(body, body_size, &pos);
                fprintf(output, "    MOVI R28, %llu\n    ADD R28, R%d, R28\n",
                        (unsigned long long)offset, TOP - 1);
            }
            if (op == WASM_I32_STORE || op == WASM_I64_STORE)
                width_bytes = op == WASM_I32_STORE ? 4 : 8;
            else if (op == WASM_I32_STORE8 || op == WASM_I64_STORE8)
                width_bytes = 1;
            else if (op == WASM_I32_STORE16 || op == WASM_I64_STORE16)
                width_bytes = 2;
            else
                width_bytes = 4;
            wasm_emit_store_bytes(output, 28, (unsigned)TOP, width_bytes);
            POP(); POP();
            break;
        }
        case WASM_CALL: {
            uint64_t fidx = read_uleb128(body, body_size, &pos);
            const WasmFuncType *callee_type = wasm_function_type((unsigned)fidx);
            int new_depth;
            unsigned i;

            if (active_wasm_module &&
                fidx < active_wasm_module->imported_functions) {
                fprintf(stderr,
                        "WASM function %u: imported call %llu has no Oxalyn ABI binding\n",
                        func_index, (unsigned long long)fidx);
                return -1;
            }
            if (!callee_type) {
                fprintf(stderr, "WASM function %u: call target %llu has no type\n",
                        func_index, (unsigned long long)fidx);
                return -1;
            }
            if (callee_type->param_count > WASM_FRAME_WORDS -
                                           WASM_FRAME_OUTGOING_BASE ||
                depth < (int)callee_type->param_count) {
                fprintf(stderr,
                        "WASM function %u: call %llu has invalid argument stack "
                        "(depth=%d params=%u)\n",
                        func_index, (unsigned long long)fidx, depth,
                        callee_type->param_count);
                return -1;
            }

            /*
             * R4-R24 are the virtual value stack. A callee may overwrite
             * them, so preserve the complete live stack in this frame before
             * moving arguments into the ABI registers/outgoing area.
             */
            for (i = 0; i < (unsigned)depth; i++)
                fprintf(output, "    STORE R%u, R29, %u\n",
                        4 + i, WASM_FRAME_SCRATCH_BASE + i);
            for (i = 0; i < callee_type->param_count; i++) {
                unsigned source = WASM_FRAME_SCRATCH_BASE +
                                  (unsigned)depth -
                                  callee_type->param_count + i;
                if (i < 4) {
                    fprintf(output, "    LOAD R%u, R29, %u\n",
                            i + 1, source);
                } else {
                    fprintf(output, "    LOAD R28, R29, %u\n", source);
                    fprintf(output, "    STORE R28, R29, %u\n",
                            WASM_FRAME_OUTGOING_BASE + i);
                }
            }
            fprintf(output, "    MOVI R28, wasm_func_%llu\n",
                    (unsigned long long)fidx);
            fprintf(output, "    JALR R30, R28, 0\n");
            for (i = 0; i < (unsigned)depth; i++)
                fprintf(output, "    LOAD R%u, R29, %u\n",
                        4 + i, WASM_FRAME_SCRATCH_BASE + i);

            new_depth = depth - (int)callee_type->param_count +
                        (int)callee_type->result_count;
            if (callee_type->result_count > 0)
                fprintf(output, "    MOV R%d, R7\n", 3 + new_depth);
            depth = new_depth;
            break;
        }
        case WASM_CALL_INDIRECT: {
            uint64_t type_index = read_uleb128(body, body_size, &pos);
            uint64_t table_index = read_uleb128(body, body_size, &pos);
            const WasmFuncType *callee_type;
            unsigned selector_slot;
            unsigned i;
            int new_depth;
            char dispatch_done[64];

            if (!active_wasm_module ||
                table_index != active_wasm_module->table_index ||
                type_index >= active_wasm_module->type_count) {
                fprintf(stderr,
                        "WASM function %u: unsupported call_indirect table/type\n",
                        func_index);
                return -1;
            }
            callee_type = &active_wasm_module->types[type_index];
            if (depth < (int)callee_type->param_count + 1) {
                fprintf(stderr,
                        "WASM function %u: call_indirect argument stack underflow\n",
                        func_index);
                return -1;
            }
            selector_slot = (unsigned)depth - 1;
            for (i = 0; i < active_wasm_module->table_entry_count; i++) {
                unsigned target_index = active_wasm_module->table_entries[i];
                const WasmFuncType *target_type =
                    wasm_function_type(target_index);
                if (!target_type ||
                    target_type->param_count != callee_type->param_count ||
                    target_type->result_count != callee_type->result_count) {
                    fprintf(stderr,
                            "WASM function %u: call_indirect table entry %u "
                            "has incompatible signature\n",
                            func_index, i);
                    return -1;
                }
            }

            for (i = 0; i < (unsigned)depth; i++)
                fprintf(output, "    STORE R%u, R29, %u\n",
                        4 + i, WASM_FRAME_SCRATCH_BASE + i);
            for (i = 0; i < callee_type->param_count; i++) {
                unsigned source = WASM_FRAME_SCRATCH_BASE +
                                  selector_slot - callee_type->param_count + i;
                if (i < 4) {
                    fprintf(output, "    LOAD R%u, R29, %u\n",
                            i + 1, source);
                } else {
                    fprintf(output, "    LOAD R28, R29, %u\n", source);
                    fprintf(output, "    STORE R28, R29, %u\n",
                            WASM_FRAME_OUTGOING_BASE + i);
                }
            }
            fprintf(output, "    LOAD R26, R29, %u\n",
                    WASM_FRAME_SCRATCH_BASE + selector_slot);
            snprintf(dispatch_done, sizeof(dispatch_done),
                     "wasm_indirect_done_%u_%u", func_index, label_cnt++);
            for (i = 0; i < active_wasm_module->table_entry_count; i++) {
                unsigned target_index = active_wasm_module->table_entries[i];
                char next_label[64];
                snprintf(next_label, sizeof(next_label),
                         "wasm_indirect_next_%u_%u_%u",
                         func_index, label_cnt, i);
                fprintf(output, "    LI R25, %u\n", i);
                fprintf(output, "    CMPEQ R25, R26, R25\n");
                fprintf(output, "    JZ R25, %s\n", next_label);
                fprintf(output, "    MOVI R28, wasm_func_%u\n", target_index);
                fprintf(output, "    JALR R30, R28, 0\n");
                fprintf(output, "    JMP %s\n", dispatch_done);
                fprintf(output, "%s:\n", next_label);
            }
            fprintf(output, "    HALT  ; invalid call_indirect selector\n");
            fprintf(output, "%s:\n", dispatch_done);
            for (i = 0; i < (unsigned)depth; i++)
                fprintf(output, "    LOAD R%u, R29, %u\n",
                        4 + i, WASM_FRAME_SCRATCH_BASE + i);
            new_depth = depth - (int)callee_type->param_count - 1 +
                        (int)callee_type->result_count;
            if (callee_type->result_count > 0)
                fprintf(output, "    MOV R%d, R7\n", 3 + new_depth);
            depth = new_depth;
            break;
        }
        case 0xFC: {
            uint64_t subopcode = read_uleb128(body, body_size, &pos);

            if (subopcode == 10) { /* memory.copy: dst, src, length */
                uint64_t memory_index_dst = read_uleb128(body, body_size, &pos);
                uint64_t memory_index_src = read_uleb128(body, body_size, &pos);
                if (memory_index_dst != 0 || memory_index_src != 0 ||
                    depth < 3) {
                    fprintf(stderr,
                            "WASM function %u: unsupported memory.copy memory "
                            "index or stack underflow\n",
                            func_index);
                    return -1;
                }
                wasm_emit_memory_copy(output, (unsigned)(TOP - 2),
                                      (unsigned)(TOP - 1), (unsigned)TOP,
                                      label_cnt++, func_index);
                POP();
                POP();
                POP();
            } else {
                fprintf(stderr,
                        "WASM function %u: unsupported 0xFC subopcode %llu\n",
                        func_index, (unsigned long long)subopcode);
                return -1;
            }
            break;
        }
        case WASM_BLOCK: case WASM_LOOP: {
            WasmControlFrame *frame;
            if (control_depth >= sizeof(controls) / sizeof(controls[0]) ||
                pos >= body_size) {
                fprintf(stderr, "WASM function %u: control stack overflow\n",
                        func_index);
                return -1;
            }
            /* MVP blocktype is one byte for the kernel's generated WASM. */
            pos++;
            frame = &controls[control_depth++];
            memset(frame, 0, sizeof(*frame));
            frame->id = label_cnt++;
            frame->kind = op == WASM_LOOP ? 2 : 1;
            snprintf(frame->start_label, sizeof(frame->start_label),
                     "wasm_start_%u_%u", func_index, frame->id);
            snprintf(frame->end_label, sizeof(frame->end_label),
                     "wasm_end_%u_%u", func_index, frame->id);
            if (frame->kind == 2)
                fprintf(output, "%s:  ; loop\n", frame->start_label);
            break;
        }
        case WASM_IF: {
            WasmControlFrame *frame;
            if (depth <= 0 ||
                control_depth >= sizeof(controls) / sizeof(controls[0]) ||
                pos >= body_size) {
                fprintf(stderr, "WASM function %u: invalid if control frame\n",
                        func_index);
                return -1;
            }
            frame = &controls[control_depth++];
            memset(frame, 0, sizeof(*frame));
            frame->id = label_cnt++;
            frame->kind = 3;
            snprintf(frame->else_label, sizeof(frame->else_label),
                     "wasm_else_%u_%u", func_index, frame->id);
            snprintf(frame->end_label, sizeof(frame->end_label),
                     "wasm_end_%u_%u", func_index, frame->id);
            fprintf(output, "    BEQ R%d, R0, %s  ; if\n",
                    TOP, frame->else_label);
            POP();
            pos++;  /* blocktype */
            break;
        }
        case WASM_ELSE: {
            WasmControlFrame *frame;
            if (control_depth <= 1 ||
                controls[control_depth - 1].kind != 3) {
                fprintf(stderr, "WASM function %u: else without if\n",
                        func_index);
                return -1;
            }
            frame = &controls[control_depth - 1];
            if (frame->saw_else) {
                fprintf(stderr, "WASM function %u: duplicate else\n", func_index);
                return -1;
            }
            fprintf(output, "    JMP %s\n", frame->end_label);
            fprintf(output, "%s:\n", frame->else_label);
            frame->saw_else = 1;
            break;
        }
        case WASM_END: {
            WasmControlFrame *frame;
            if (control_depth == 0) {
                fprintf(stderr, "WASM function %u: unmatched end\n", func_index);
                return -1;
            }
            frame = &controls[--control_depth];
            if (frame->kind == 0) {
                /* The function's implicit end falls through to the epilogue. */
                break;
            }
            if (frame->kind == 3 && !frame->saw_else)
                fprintf(output, "%s:\n", frame->else_label);
            fprintf(output, "%s:\n", frame->end_label);
            break;
        }
        case WASM_BR: {
            uint64_t depth_br = read_uleb128(body, body_size, &pos);
            WasmControlFrame *target;
            if (depth_br >= control_depth) {
                fprintf(stderr, "WASM function %u: br depth out of range\n",
                        func_index);
                return -1;
            }
            target = &controls[control_depth - 1 - (unsigned)depth_br];
            fprintf(output, "    JMP %s  ; br\n",
                    target->kind == 2 ? target->start_label : target->end_label);
            break;
        }
        case WASM_BR_IF: {
            uint64_t depth_br = read_uleb128(body, body_size, &pos);
            WasmControlFrame *target;
            if (depth <= 0 || depth_br >= control_depth) {
                fprintf(stderr, "WASM function %u: br_if depth out of range\n",
                        func_index);
                return -1;
            }
            target = &controls[control_depth - 1 - (unsigned)depth_br];
            fprintf(output, "    BNE R%d, R0, %s  ; br_if\n", TOP,
                    target->kind == 2 ? target->start_label : target->end_label);
            POP(); break;
        }
        case WASM_BR_TABLE: {
            uint64_t table_count;
            uint64_t i;
            unsigned selector;
            if (depth <= 0) {
                fprintf(stderr, "WASM function %u: br_table stack underflow\n",
                        func_index);
                return -1;
            }
            table_count = read_uleb128(body, body_size, &pos);
            selector = (unsigned)TOP;
            for (i = 0; i < table_count; i++) {
                uint64_t branch_depth = read_uleb128(body, body_size, &pos);
                WasmControlFrame *target;
                if (branch_depth >= control_depth) {
                    fprintf(stderr,
                            "WASM function %u: br_table depth out of range\n",
                            func_index);
                    return -1;
                }
                target = &controls[control_depth - 1 - (unsigned)branch_depth];
                fprintf(output, "    MOVI R28, %llu\n", (unsigned long long)i);
                fprintf(output, "    CMPEQ R28, R%d, R28\n", selector);
                fprintf(output, "    JNZ R28, %s\n",
                        target->kind == 2 ? target->start_label : target->end_label);
            }
            {
                uint64_t default_depth = read_uleb128(body, body_size, &pos);
                WasmControlFrame *target;
                if (default_depth >= control_depth) {
                    fprintf(stderr,
                            "WASM function %u: br_table default depth out of range\n",
                            func_index);
                    return -1;
                }
                target = &controls[control_depth - 1 - (unsigned)default_depth];
                fprintf(output, "    JMP %s  ; br_table default\n",
                        target->kind == 2 ? target->start_label : target->end_label);
            }
            POP();
            break;
        }
        default:
            fprintf(stderr,
                    "WASM function %u: unsupported opcode 0x%02X at byte %zu\n",
                    func_index, op, pos - 1);
            return -1;
        }
#undef TOP
#undef PUSH
#undef POP
    }

    fprintf(output, "wasm_return_%u:\n", func_index);
    fprintf(output, "    LOAD R30, R29, 0\n");
    fprintf(output, "    LOAD R28, R29, 1\n");
    fprintf(output, "    MOVI R1, %u\n", WASM_FRAME_WORDS);
    fprintf(output, "    ADD R31, R31, R1\n");
    fprintf(output, "    MOV R29, R28\n");
    fprintf(output, "    JALR R0, R30, 0\n\n");
    fprintf(output, "; end wasm_func_%u\n\n", func_index);
    return 0;
}

/* Ana giriş: WASM binary dosyasını Oxalyn assembly'ye çevirir */
int wasm_translate_module(const char *input_path, const char *output_path,
                          char *error_buffer, size_t error_capacity)
{
    FILE *f;
    unsigned char *buf;
    long fsize;
    size_t code_start = 0, code_size = 0;
    size_t pos;
    unsigned func_index;
    WasmModuleInfo module_info;
    FILE *out;

    f = fopen(input_path, "rb");
    if (!f) {
        if (error_buffer) snprintf(error_buffer, error_capacity, "WASM dosyası açılamadı");
        return -1;
    }
    fseek(f, 0, SEEK_END); fsize = ftell(f); fseek(f, 0, SEEK_SET);
    if (fsize <= 0) { fclose(f); snprintf(error_buffer, error_capacity, "Boş WASM dosyası"); return -1; }
    buf = (unsigned char *)malloc((size_t)fsize);
    if (!buf) { fclose(f); snprintf(error_buffer, error_capacity, "Bellek yetersiz"); return -1; }
    if ((long)fread(buf, 1, (size_t)fsize, f) != fsize) {
        fclose(f); free(buf);
        snprintf(error_buffer, error_capacity, "WASM okunamadı"); return -1;
    }
    fclose(f);

    if (wasm_parse_module(buf, (size_t)fsize, &module_info,
                          &code_start, &code_size) < 0) {
        free(buf);
        snprintf(error_buffer, error_capacity,
                 "WASM module metadata/code section okunamadı");
        return -1;
    }
    if (!module_info.has_entry) {
        free(buf);
        snprintf(error_buffer, error_capacity,
                 "WASM kernel_main export'u bulunamadı");
        return -1;
    }

    out = fopen(output_path, "wb");
    if (!out) { free(buf); snprintf(error_buffer, error_capacity, "Çıktı açılamadı"); return -1; }

    fprintf(out, "; Oxalyn-64 assembly — WASM module translation\n");
    fprintf(out, "; Kaynak: %s\n\n", input_path);
    fprintf(out, ".text\n_wasm_start:\n    MOVI R28, wasm_func_%u\n"
                 "    JALR R30, R28, 0\n    HALT\n\n",
            module_info.entry_function);

    active_wasm_module = &module_info;
    func_index = module_info.imported_functions;
    pos = code_start;
    {
        size_t tmp = pos;
        uint64_t func_count = read_uleb128(buf, (size_t)fsize, &tmp);
        uint64_t fi;
        pos = tmp;
        if (func_count != module_info.defined_functions) {
            fclose(out);
            free(buf);
            remove(output_path);
            active_wasm_module = NULL;
            snprintf(error_buffer, error_capacity,
                     "WASM function/code section sayıları uyuşmuyor");
            return -1;
        }
        for (fi = 0; fi < func_count && pos < code_start + code_size; fi++) {
            uint64_t body_len = read_uleb128(buf, (size_t)fsize, &pos);
            unsigned current_function = func_index++;
            if (body_len > code_start + code_size - pos) {
                fprintf(stderr,
                        "WASM function %u: body length %llu exceeds code section\n",
                        current_function, (unsigned long long)body_len);
                fclose(out);
                free(buf);
                remove(output_path);
                active_wasm_module = NULL;
                snprintf(error_buffer, error_capacity,
                         "WASM function body sınırı geçersiz");
                return -1;
            }
            if (wasm_translate_function(out, buf + pos, (size_t)body_len,
                                        current_function) != 0) {
                fprintf(stderr,
                        "WASM function %u translation failed (body=%llu)\n",
                        current_function, (unsigned long long)body_len);
                fclose(out);
                free(buf);
                remove(output_path);
                active_wasm_module = NULL;
                snprintf(error_buffer, error_capacity,
                         "WASM içinde desteklenmeyen opcode veya bozuk fonksiyon");
                return -1;
            }
            pos += (size_t)body_len;
        }
    }

    fclose(out);
    active_wasm_module = NULL;
    free(buf);
    return 0;
}

int compiler_translate_source(CompilerArchKind arch,
                              const char *input_path,
                              const char *output_path,
                              char *error_buffer,
                              size_t error_capacity)
{
    FILE *input = fopen(input_path, "rb");
    FILE *output;
    char line[LINE_CAP];
    unsigned line_number = 0;
    int result = 0;

    if (!input) {
        set_error(error_buffer, error_capacity, 0, "kaynak assembly açılamadı");
        return -1;
    }
    output = fopen(output_path, "wb");
    if (!output) {
        fclose(input);
        set_error(error_buffer, error_capacity, 0, "çeviri çıktısı açılamadı");
        return -1;
    }

    while (fgets(line, sizeof(line), input)) {
        char original[LINE_CAP];
        char tokens[TOKEN_CAP][TOKEN_LEN];
        int count;
        int att;

        line_number++;
        snprintf(original, sizeof(original), "%s", line);
        if (line_number == 1 && (unsigned char)line[0] == 0xEF &&
            (unsigned char)line[1] == 0xBB &&
            (unsigned char)line[2] == 0xBF)
            memmove(line, line + 3, strlen(line + 3) + 1);
        remove_comment(line, arch);
        trim(line);
        if (!*line)
            continue;

        /*
         * Label'ları aynen taşı. Bir label satırın geri kalanıyla gelirse
         * geri kalan komutu sonraki parse aşamasına bırakmak için satırı
         * yeniden işlemek yerine yalnızca ayrı label satırlarını destekliyoruz.
         */
        {
            char *colon = strchr(line, ':');
            if (colon) {
                char rest[LINE_CAP];
                size_t label_length = (size_t)(colon - line) + 1;
                fprintf(output, "%.*s\n", (int)label_length, line);
                snprintf(rest, sizeof(rest), "%s", colon + 1);
                trim(rest);
                if (!*rest)
                    continue;
                snprintf(line, sizeof(line), "%s", rest);
            }
        }

        lower(line);
        count = tokenize(line, tokens);
        if (count == 0)
            continue;
        if (is_directive(tokens[0]))
            continue;
        att = strchr(original, '%') != NULL;

        if (arch == COMPILER_ARCH_X86_64)
            result = translate_x86(output, tokens, count, att, line_number,
                                   error_buffer, error_capacity);
        else if (arch == COMPILER_ARCH_ARM64)
            result = translate_arm(output, tokens, count, line_number,
                                   error_buffer, error_capacity);
        else if (arch == COMPILER_ARCH_RISCV64)
            result = translate_riscv(output, tokens, count, line_number,
                                     error_buffer, error_capacity);
        else {
            set_error(error_buffer, error_capacity, line_number,
                      "bu mimari için kaynak backend yok");
            result = -1;
        }
        if (result != 0)
            break;
    }

    fclose(input);
    if (fclose(output) != 0)
        result = -1;
    if (result != 0)
        remove(output_path);
    return result;
}