/*
 * Oxalyn-64 Assembler
 *
 * Derleme: gcc -o asm asm.c
 * Kullanım: ./asm kaynak.asm çıktı.bin
 *
 * Giriş : .asm metin dosyası (Oxalyn-64 assembly söz dizimi)
 * Çıkış : .bin dosyası (big-endian 32-bit kelimeler)
 *
 * İki geçişli assembler:
 *   Geçiş 1 — label adreslerini topla
 *   Geçiş 2 — komutları kodla, .bin yaz
 *
 * Oxalyn-64'de her komut tek bir 32-bit kelimedir; 64-bit kelimede saklanır (word_addr += 1).
 * Dal ofseti: hedef_kelime_adr - (mevcut_kelime_adr + 1)
 */

#include <stdio.h>
#include <stdint.h>
#include <string.h>

/* ─── Sabitler ─────────────────────────────────────────── */

#define MAX_LABELS    8192
#define MAX_LABEL_LEN 64
#define MAX_LINE_LEN  256
#define MAX_INSNS     262144

/* ─── Opcode Tanımları ─────────────────────────────────── */

#define OP_NOP   0x00
#define OP_ADD   0x01
#define OP_SUB   0x02
#define OP_AND   0x03
#define OP_OR    0x04
#define OP_XOR   0x05
#define OP_SHL   0x06
#define OP_SHR   0x07
#define OP_LOAD  0x08
#define OP_STORE 0x09
#define OP_LI    0x0A
#define OP_JMP   0x0B
#define OP_JZ    0x0C
#define OP_JNZ   0x0D
#define OP_CALL  0x0E
#define OP_RET   0x0F
#define OP_OUT   0x10
#define OP_IN    0x11
#define OP_HALT  0x3F

/* ── Güvenlik Uzantısı (Oxalyn-64 SEC) ──────────────────── */
#define OP_ECALL 0x12
#define OP_ERET  0x13
#define OP_CSRW  0x14
#define OP_CSRR  0x15
#define OP_RAND  0x16
#define OP_FENCE 0x17
#define OP_AESE  0x18
#define OP_HASH  0x19

/* ── Aritmetik Uzantısı ────────────────────────────────── */
#define OP_MUL   0x1A
#define OP_DIV   0x1B
#define OP_ELOAD  0x1C
#define OP_ESTORE 0x1D
#define OP_RFLAGS 0x1E
#define OP_WFI   0x1F

/* ── Yeni ISA Uzantıları (0x20–0x2A) ───────────────────── */
#define OP_LUI    0x20
#define OP_JALR   0x21
#define OP_CMPEQ  0x22
#define OP_CMPNE  0x23
#define OP_CMPLT  0x24
#define OP_CMPLE  0x25
#define OP_CMPLTU 0x26
#define OP_CMPLEU 0x27
#define OP_BSET   0x28
#define OP_BCLR   0x29
#define OP_BTEST  0x2A
#define OP_LOADB  0x2B
#define OP_STOREB 0x2C
#define OP_DIVU   0x2D
#define OP_REM    0x2E
#define OP_REMU   0x2F

/* ─── Label Tablosu ────────────────────────────────────── */

typedef struct {
    char     name[MAX_LABEL_LEN];
    uint32_t word_addr;
} Label;

static Label   labels[MAX_LABELS];
static int     label_count = 0;
static void asm_error(int line_no, const char *msg);

static int label_add(const char *name, uint32_t addr)
{
    int i;
    if (label_count >= MAX_LABELS) {
        fprintf(stderr, "[HATA] Label tablosu doldu.\n");
        return 0;
    }
    for (i = 0; i < label_count; i++) {
        if (strcmp(labels[i].name, name) == 0)
            return 0;
    }
    strncpy(labels[label_count].name, name, MAX_LABEL_LEN - 1);
    labels[label_count].name[MAX_LABEL_LEN - 1] = '\0';
    labels[label_count].word_addr = addr;
    label_count++;
    return 1;
}

static int32_t label_find(const char *name)
{
    int i;
    for (i = 0; i < label_count; i++) {
        if (strcmp(labels[i].name, name) == 0)
            return (int32_t)labels[i].word_addr;
    }
    return -1;
}

static int resolve_label_address(const char *token, int pass, int line_no)
{
    int32_t address = label_find(token);

    if (address < 0) {
        if (pass == 2) {
            asm_error(line_no, "Tanımsız label");
            return -1;
        }
        return 0;
    }
    return address;
}

static uint32_t insn_buf[MAX_INSNS];
static int      insn_count = 0;

static uint32_t encode(uint32_t opcode, uint32_t fd, uint32_t fa,
                       uint32_t fb, int32_t imm);

static int parse_number64(const char *s, int64_t *out)
{
    int sign = 1;
    uint64_t value = 0;
    const char *p = s;

    if (*p == '-') { sign = -1; p++; }
    else if (*p == '+') p++;

    if (p[0] == '0' && (p[1] == 'b' || p[1] == 'B')) {
        p += 2;
        if (!*p) return 0;
        while (*p == '0' || *p == '1') {
            value = (value << 1) | (uint64_t)(*p - '0');
            p++;
        }
    } else {
        int base = 10;
        if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
            base = 16;
            p += 2;
        }
        if (!*p) return 0;
        while (*p) {
            unsigned digit;
            if (*p >= '0' && *p <= '9') digit = (unsigned)(*p - '0');
            else if (*p >= 'a' && *p <= 'f') digit = (unsigned)(*p - 'a' + 10);
            else if (*p >= 'A' && *p <= 'F') digit = (unsigned)(*p - 'A' + 10);
            else break;
            if (digit >= (unsigned)base) return 0;
            value = value * (unsigned)base + digit;
            p++;
        }
    }
    if (*p != '\0') return 0;
    *out = sign > 0 ? (int64_t)value : -(int64_t)value;
    return 1;
}

/*
 * LUI is intentionally a 16-bit upper-immediate instruction
 * (documented as imm << 16).  MOVI therefore builds a value a byte at a
 * time instead of pretending that LUI carries the assembler's 11-bit
 * immediate field.  A fixed two-byte form is used for labels so pass one
 * and pass two keep all following label addresses identical.
 */
static unsigned movi_bytes(int64_t signed_value)
{
    unsigned bytes;

    for (bytes = 1; bytes < 8; bytes++) {
        int bits = (int)bytes * 8;
        int64_t min = -(1LL << (bits - 1));
        int64_t max =  (1LL << (bits - 1)) - 1;
        if (signed_value >= min && signed_value <= max)
            return bytes;
    }
    return 8;
}

static unsigned movi_words(unsigned bytes)
{
    return bytes == 0 ? 1u : 1u + 3u * (bytes - 1u);
}

static int emit_movi_words(int rd, int64_t signed_value, unsigned bytes,
                           int pass, int line_no)
{
    uint64_t value = (uint64_t)signed_value;
    unsigned i;
    int temp = rd == 27 ? 26 : 27;

    if (bytes == 0 || bytes > 8) {
        asm_error(line_no, "MOVI byte genişliği geçersiz");
        return 0;
    }
    if (pass != 2) return 1;
    if (insn_count + (int)movi_words(bytes) > MAX_INSNS) {
        asm_error(line_no, "Program çok büyük");
        return 0;
    }

    /* Big-endian construction in register order: most significant byte first. */
    for (i = bytes; i-- > 0;) {
        /*
         * LI's 11-bit immediate sign bit is bit 10, so every 8-bit byte
         * (including 0x80..0xFF) is loaded as a positive value.
         */
        int32_t byte = (int32_t)((value >> (i * 8u)) & 0xFFu);
        if (i == bytes - 1u) {
            insn_buf[insn_count++] = encode(OP_LI, (uint32_t)rd, 0, 0,
                                            (int32_t)byte);
        } else {
            insn_buf[insn_count++] = encode(OP_SHL, (uint32_t)rd,
                                            (uint32_t)rd, 0, 8);
            insn_buf[insn_count++] = encode(OP_LI, (uint32_t)temp, 0, 0,
                                            (int32_t)byte);
            insn_buf[insn_count++] = encode(OP_OR, (uint32_t)rd,
                                            (uint32_t)rd, (uint32_t)temp, 0);
        }
    }
    return 1;
}

/* ─── Hata Yönetimi ────────────────────────────────────── */

static int error_count = 0;

static void asm_error(int line_no, const char *msg)
{
    fprintf(stderr, "[HATA] Satır %d: %s\n", line_no, msg);
    error_count++;
}

/* ─── Metin Yardımcıları ───────────────────────────────── */

static const char *skip_ws(const char *p)
{
    while (*p == ' ' || *p == '\t') p++;
    return p;
}

static void trim_line(char *buf)
{
    char *p = buf;
    while (*p && *p != ';' && *p != '\n' && *p != '\r') p++;
    *p = '\0';
    while (p > buf && (*(p-1) == ' ' || *(p-1) == '\t')) {
        p--;
        *p = '\0';
    }
}

static int next_token(const char **pp, char *out, int max)
{
    const char *p = skip_ws(*pp);
    int i = 0;
    if (!*p) return 0;
    while (*p && *p != ' ' && *p != '\t' && *p != ',' && *p != ';') {
        if (i < max - 1) out[i++] = *p;
        p++;
    }
    out[i] = '\0';
    p = skip_ws(p);
    if (*p == ',') p++;
    *pp = p;
    return i > 0;
}

static void to_upper(char *s)
{
    while (*s) {
        if (*s >= 'a' && *s <= 'z') *s -= 32;
        s++;
    }
}

/* ─── Sayı Ayrıştırıcı ─────────────────────────────────── */

static int parse_number(const char *s, int32_t *out)
{
    int      sign = 1;
    int32_t  val  = 0;
    const char *p = s;

    if (*p == '-') { sign = -1; p++; }
    else if (*p == '+') { p++; }

    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        p += 2;
        if (!*p) return 0;
        while (*p) {
            int d;
            if (*p >= '0' && *p <= '9') d = *p - '0';
            else if (*p >= 'a' && *p <= 'f') d = *p - 'a' + 10;
            else if (*p >= 'A' && *p <= 'F') d = *p - 'A' + 10;
            else return 0;
            val = val * 16 + d;
            p++;
        }
    } else if (p[0] == '0' && (p[1] == 'b' || p[1] == 'B')) {
        p += 2;
        if (!*p) return 0;
        while (*p) {
            if (*p != '0' && *p != '1') return 0;
            val = val * 2 + (*p - '0');
            p++;
        }
    } else {
        if (!(*p >= '0' && *p <= '9')) return 0;
        while (*p >= '0' && *p <= '9') {
            val = val * 10 + (*p - '0');
            p++;
        }
        if (*p) return 0;
    }

    *out = sign * val;
    return 1;
}

/* ─── Register Ayrıştırıcı ─────────────────────────────── */

static int parse_reg(const char *s)
{
    char buf[8];
    int  i, n;
    for (i = 0; s[i] && i < 7; i++) {
        buf[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
    }
    buf[i] = '\0';
    if (buf[0] != 'R') return -1;
    /* R0-R9 */
    if (buf[1] >= '0' && buf[1] <= '9' && buf[2] == '\0') {
        n = buf[1] - '0';
        return (n <= 31) ? n : -1;
    }
    /* R10-R31 */
    if (buf[1] >= '1' && buf[1] <= '3' &&
        buf[2] >= '0' && buf[2] <= '9' && buf[3] == '\0') {
        n = (buf[1] - '0') * 10 + (buf[2] - '0');
        return (n <= 31) ? n : -1;
    }
    return -1;
}

/* ─── Komut Kodlayıcı ──────────────────────────────────── */

/*
 * 32-bit Oxalyn-64 komut kelimesini oluşturur.
 *
 * Bit düzeni:
 *   [31:26] opcode (6 bit)
 *   [25:21] fd     (5 bit → R0-R31)
 *   [20:16] fa     (5 bit)
 *   [15:11] fb     (5 bit)
 *   [10:0]  imm    (11 bit, işaretli: -1024..1023)
 */
static uint32_t encode(uint32_t opcode, uint32_t fd, uint32_t fa,
                       uint32_t fb, int32_t imm)
{
    uint32_t imm11 = (uint32_t)imm & 0x7FFu;
    return (opcode << 26) | (fd << 21) | (fa << 16) | (fb << 11) | imm11;
}

/* ─── IMM Doğrulama ────────────────────────────────────── */

static int check_imm11(int32_t v, int line_no)
{
    if (v < -1024 || v > 1023) {
        asm_error(line_no, "Immediate değer 11-bit aralığını aşıyor "
                           "(-1024..1023)");
        return 0;
    }
    return 1;
}

/* ─── İki Geçişli Assembler ────────────────────────────── */

/*
 * Bir metin satırını işle.
 *
 * Oxalyn-64: her komut TEK kelime → word_addr += 1
 * Dal ofseti: hedef - (word_addr + 1)   [Oxalyn-16'da +2'ydi]
 */
static int process_line(const char *raw, int line_no,
                        int pass, uint32_t *word_addr)
{
    char line[MAX_LINE_LEN];
    char tok[MAX_LABEL_LEN];
    const char *p;
    int  rlen;

    rlen = 0;
    while (raw[rlen] && rlen < MAX_LINE_LEN - 1) {
        line[rlen] = raw[rlen];
        rlen++;
    }
    line[rlen] = '\0';
    /*
     * Bazı Windows editörleri UTF-8 BOM ekler. BOM ilk token'ın parçası
     * değildir; temizlenmezse geçerli bir yorum satırı bile "bilinmeyen
     * mnemonik" olarak raporlanır.
     */
    if (rlen >= 3 &&
        (unsigned char)line[0] == 0xEF &&
        (unsigned char)line[1] == 0xBB &&
        (unsigned char)line[2] == 0xBF) {
        memmove(line, line + 3, (size_t)(rlen - 2));
        rlen -= 3;
    }
    trim_line(line);

    p = skip_ws(line);
    if (!*p) return 1;

    /* ── Label tespiti ── */
    {
        const char *colon = p;
        int is_label = 0;
        while ((*colon >= 'a' && *colon <= 'z') ||
               (*colon >= 'A' && *colon <= 'Z') ||
               (*colon >= '0' && *colon <= '9') ||
               *colon == '_')
            colon++;
        if (*colon == ':') is_label = 1;
        if (is_label) {
            char lname[MAX_LABEL_LEN];
            int  llen = (int)(colon - p);
            if (llen >= MAX_LABEL_LEN) {
                asm_error(line_no, "Label ismi çok uzun");
                return 0;
            }
            strncpy(lname, p, (unsigned)llen);
            lname[llen] = '\0';
            if (pass == 1) {
                if (label_find(lname) >= 0) {
                    asm_error(line_no, "Label zaten tanımlı");
                    return 0;
                }
                label_add(lname, *word_addr);
            }
            p = skip_ws(colon + 1);
            if (!*p) return 1;
        }
    }

    /* ── Mnemonik oku ── */
    if (!next_token(&p, tok, (int)sizeof(tok))) return 1;
    to_upper(tok);

    /* ELF/assembly kaynaklarından gelen bölüm direktifleri kod üretmez. */
    if (strcmp(tok, ".TEXT") == 0 || strcmp(tok, ".DATA") == 0 ||
        strcmp(tok, ".RODATA") == 0 || strcmp(tok, ".BSS") == 0)
        return 1;

    /* ── Komut Kodlama ── */

#define REQ_REG(var)                                            \
    do {                                                        \
        char _t[MAX_LABEL_LEN];                                 \
        if (!next_token(&p, _t, (int)sizeof(_t))) {             \
            asm_error(line_no, "Register bekleniyor");          \
            return 0;                                           \
        }                                                       \
        (var) = parse_reg(_t);                                  \
        if ((var) < 0) {                                        \
            asm_error(line_no, "Geçersiz register");            \
            return 0;                                           \
        }                                                       \
    } while(0)

    /*
     * Oxalyn-64 dal ofseti: hedef - (word_addr + 1)
     * (Oxalyn-16'da +2'ydi çünkü her komut 2 kelime kaplıyordu)
     */
#define REQ_IMM_OR_LABEL(imm_var, is_branch)                        \
    do {                                                             \
        char    _t[MAX_LABEL_LEN];                                   \
        int32_t _v;                                                  \
        if (!next_token(&p, _t, (int)sizeof(_t))) {                  \
            asm_error(line_no, "Immediate veya label bekleniyor");   \
            return 0;                                                \
        }                                                            \
        if (parse_number(_t, &_v)) {                                 \
            (imm_var) = _v;                                          \
        } else {                                                     \
            int32_t _addr = label_find(_t);                          \
            if (_addr < 0) {                                         \
                if (pass == 2) {                                     \
                    asm_error(line_no, "Tanımsız label");            \
                    return 0;                                        \
                }                                                    \
                _addr = 0;                                           \
            }                                                        \
            if (is_branch)                                           \
                (imm_var) = _addr - (int32_t)(*word_addr + 1);      \
            else                                                     \
                (imm_var) = _addr;                                   \
        }                                                            \
    } while(0)

    {
        int     rd = 0, rs1 = 0, rs2 = 0;
        int32_t imm = 0;
        uint32_t insn = 0;
        unsigned direct_words = 0;

        if (strcmp(tok, ".WORD") == 0) {
            char value_token[MAX_LABEL_LEN];
            int64_t value;
            if (!next_token(&p, value_token, (int)sizeof(value_token))) {
                asm_error(line_no, ".word değeri bekleniyor");
                return 0;
            }
            if (!parse_number64(value_token, &value)) {
                int32_t address = label_find(value_token);
                if (address < 0) {
                    if (pass == 2) {
                        asm_error(line_no, "Tanımsız .word sembolü");
                        return 0;
                    }
                    value = 0;
                } else {
                    value = address;
                }
            }
            if (pass == 2) {
                if (insn_count >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük");
                    return 0;
                }
                insn_buf[insn_count++] = (uint32_t)(uint64_t)value;
            }
            direct_words = 1;
        } else if (strcmp(tok, ".ZERO") == 0) {
            char count_token[MAX_LABEL_LEN];
            int64_t count;
            if (!next_token(&p, count_token, (int)sizeof(count_token)) ||
                !parse_number64(count_token, &count) || count < 0 ||
                count > MAX_INSNS) {
                asm_error(line_no, ".zero sayısı geçersiz");
                return 0;
            }
            if ((uint64_t)insn_count + (uint64_t)count > MAX_INSNS) {
                asm_error(line_no, "Program çok büyük");
                return 0;
            }
            if (pass == 2) {
                int64_t i;
                for (i = 0; i < count; i++)
                    insn_buf[insn_count++] = 0;
            }
            direct_words = (unsigned)count;
        } else if (strcmp(tok, "NOP") == 0) {
            insn = encode(OP_NOP, 0, 0, 0, 0);

        } else if (strcmp(tok, "HALT") == 0) {
            insn = encode(OP_HALT, 0, 0, 0, 0);

        } else if (strcmp(tok, "ADD") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_ADD, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "SUB") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_SUB, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "AND") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_AND, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "OR") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_OR, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "XOR") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_XOR, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "MUL") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_MUL, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "DIV") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_DIV, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "DIVU") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_DIVU, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "REM") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_REM, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "REMU") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_REMU, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        } else if (strcmp(tok, "SHL") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_SHL, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "SHR") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_SHR, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "LOAD") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_LOAD, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "STORE") == 0) {
            REQ_REG(rs1); REQ_REG(rs2);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_STORE, (uint32_t)rs1, (uint32_t)rs2, 0, imm);

        } else if (strcmp(tok, "LOADB") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_LOADB, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "STOREB") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_STOREB, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "ELOAD") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_ELOAD, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "ESTORE") == 0) {
            REQ_REG(rs1); REQ_REG(rs2);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_ESTORE, (uint32_t)rs1, (uint32_t)rs2, 0, imm);

        } else if (strcmp(tok, "LI") == 0) {
            REQ_REG(rd);
            REQ_IMM_OR_LABEL(imm, 0);
            /*
             * LI 17-bit işaretli immediate yükler (-65536..+65535).
             * 0x8000–0xFFFF için bit16'yı işaret biti yaparak negatif kodla
             * (sim'de sign_extend11 ile 32-bit'e uzar).
             */
            if (imm >= 0 && imm <= 2047) {
                if (imm > 1023) {
                    int32_t signed_imm = imm - 2048;
                    imm = signed_imm;
                }
            } else if (!check_imm11(imm, line_no)) {
                return 0;
            }
            insn = encode(OP_LI, (uint32_t)rd, 0, 0, imm);

        } else if (strcmp(tok, "JMP") == 0) {
            char target[MAX_LABEL_LEN];
            int32_t address;
            if (!next_token(&p, target, (int)sizeof(target))) {
                asm_error(line_no, "Immediate veya label bekleniyor");
                return 0;
            }
            if (parse_number(target, &imm)) {
                if (!check_imm11(imm, line_no)) return 0;
                insn = encode(OP_JMP, 0, 0, 0, imm);
            } else {
                address = resolve_label_address(target, pass, line_no);
                if (address < 0) return 0;
                {
                    const unsigned bytes = 2;
                    if (pass == 2) {
                        if (!emit_movi_words(28, address,
                                             bytes, pass, line_no))
                            return 0;
                    }
                    *word_addr += movi_words(bytes);
                    insn = encode(OP_JALR, 0, 28, 0, 0);
                }
            }

        } else if (strcmp(tok, "JZ") == 0) {
            char target[MAX_LABEL_LEN];
            int32_t address;
            REQ_REG(rs1);
            if (!next_token(&p, target, (int)sizeof(target))) {
                asm_error(line_no, "Immediate veya label bekleniyor");
                return 0;
            }
            if (parse_number(target, &imm)) {
                if (!check_imm11(imm, line_no)) return 0;
                insn = encode(OP_JZ, (uint32_t)rs1, 0, 0, imm);
            } else {
                address = resolve_label_address(target, pass, line_no);
                if (address < 0) return 0;
                {
                    /*
                     * Label branches use one fixed six-word form in both
                     * passes.  JZ must skip the target-load block when the
                     * condition is true; JNZ must skip it when false.
                     */
                    if (pass == 2) {
                        if (insn_count + 6 > MAX_INSNS) {
                            asm_error(line_no, "Program çok büyük");
                            return 0;
                        }
                        insn_buf[insn_count++] =
                            encode(OP_JNZ, (uint32_t)rs1, 0, 0, 5);
                        if (!emit_movi_words(28, address, 2, pass, line_no))
                            return 0;
                    }
                    *word_addr += 5;
                    insn = encode(OP_JALR, 0, 28, 0, 0);
                }
            }

        } else if (strcmp(tok, "JNZ") == 0) {
            char target[MAX_LABEL_LEN];
            int32_t address;
            REQ_REG(rs1);
            if (!next_token(&p, target, (int)sizeof(target))) {
                asm_error(line_no, "Immediate veya label bekleniyor");
                return 0;
            }
            if (parse_number(target, &imm)) {
                if (!check_imm11(imm, line_no)) return 0;
                insn = encode(OP_JNZ, (uint32_t)rs1, 0, 0, imm);
            } else {
                address = resolve_label_address(target, pass, line_no);
                if (address < 0) return 0;
                {
                    /*
                     * Keep the label form fixed at six words in both
                     * passes, mirroring JZ above.  JZ +5 skips MOVI+JALR
                     * when the condition is false.
                     */
                    if (pass == 2) {
                        if (insn_count + 6 > MAX_INSNS) {
                            asm_error(line_no, "Program çok büyük");
                            return 0;
                        }
                        insn_buf[insn_count++] =
                            encode(OP_JZ, (uint32_t)rs1, 0, 0, 5);
                        if (!emit_movi_words(28, address, 2, pass, line_no))
                            return 0;
                    }
                    *word_addr += 5;
                    insn = encode(OP_JALR, 0, 28, 0, 0);
                }
            }

        } else if (strcmp(tok, "CALL") == 0) {
            REQ_IMM_OR_LABEL(imm, 1);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_CALL, 0, 0, 0, imm);

        } else if (strcmp(tok, "RET") == 0) {
            insn = encode(OP_RET, 0, 0, 0, 0);

        } else if (strcmp(tok, "OUT") == 0) {
            REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_OUT, (uint32_t)rs1, 0, 0, imm);

        } else if (strcmp(tok, "IN") == 0) {
            REQ_REG(rd);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_IN, (uint32_t)rd, 0, 0, imm);

        /* ══ GÜVENLİK UZANTISI KOMUTLARI (Oxalyn-64 SEC) ══════ */

        } else if (strcmp(tok, "ECALL") == 0) {
            insn = encode(OP_ECALL, 0, 0, 0, 0);

        } else if (strcmp(tok, "ERET") == 0) {
            insn = encode(OP_ERET, 0, 0, 0, 0);

        } else if (strcmp(tok, "CSRW") == 0) {
            REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_CSRW, (uint32_t)rs1, 0, 0, imm);

        } else if (strcmp(tok, "CSRR") == 0) {
            REQ_REG(rd);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_CSRR, (uint32_t)rd, 0, 0, imm);

        } else if (strcmp(tok, "RAND") == 0) {
            REQ_REG(rd);
            insn = encode(OP_RAND, (uint32_t)rd, 0, 0, 0);

        } else if (strcmp(tok, "RFLAGS") == 0) {
            REQ_REG(rd);
            insn = encode(OP_RFLAGS, (uint32_t)rd, 0, 0, 0);

        } else if (strcmp(tok, "WFI") == 0) {
            insn = encode(OP_WFI, 0, 0, 0, 0);

        } else if (strcmp(tok, "FENCE") == 0) {
            insn = encode(OP_FENCE, 0, 0, 0, 0);

        } else if (strcmp(tok, "AESE") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            insn = encode(OP_AESE, (uint32_t)rd, (uint32_t)rs1, 0, 0);

        } else if (strcmp(tok, "HASH") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_HASH, (uint32_t)rd, (uint32_t)rs1,
                          (uint32_t)rs2, 0);

        /* ══ YENİ ISA UZANTILARI (0x20–0x2A) ════════════════ */

        } else if (strcmp(tok, "LUI") == 0) {
            REQ_REG(rd);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_LUI, (uint32_t)rd, 0, 0, imm);

        } else if (strcmp(tok, "JALR") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_JALR, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "CMPEQ") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPEQ, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "CMPNE") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPNE, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "CMPLT") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPLT, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "CMPLE") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPLE, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "CMPLTU") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPLTU, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "CMPLEU") == 0) {
            REQ_REG(rd); REQ_REG(rs1); REQ_REG(rs2);
            insn = encode(OP_CMPLEU, (uint32_t)rd, (uint32_t)rs1, (uint32_t)rs2, 0);

        } else if (strcmp(tok, "BSET") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_BSET, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "BCLR") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_BCLR, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        } else if (strcmp(tok, "BTEST") == 0) {
            REQ_REG(rd); REQ_REG(rs1);
            REQ_IMM_OR_LABEL(imm, 0);
            if (!check_imm11(imm, line_no)) return 0;
            insn = encode(OP_BTEST, (uint32_t)rd, (uint32_t)rs1, 0, imm);

        /* ══ PSEUDO-INSTRUCTION'LAR ══════════════════════════
         *
         * Bu komutlar gerçek opcode değildir — assembler bunları
         * 1 veya 2 gerçek komuta dönüştürür.
         *
         * ABI (Oxalyn64 v2):
         *   R0  = sıfır (hardwired)
         *   R29 = Frame Pointer (FP)
         *   R30 = Link Register (LR) — JALR dönüş adresi
         *   R31 = Stack Pointer (SP)
         *   R7  = dönüş değeri
         *
         * MOVI RD, büyük_değer → LUI + OR  (22-bit değer)
         * MOV  RD, RS          → ADD RD, RS, R0
         * CLR  RD              → ADD RD, R0, R0
         * NOT  RD, RS          → XOR RD, RS, R0 ile tüm bit flip
         *                        (gerçekte: NOR R0,RS → yok, XOR+CMPEQ ile yapılır)
         *                        Basit: XOR RD, RS, 0xFF...FF → ADD + XOR
         * NEG  RD, RS          → SUB RD, R0, RS
         * INC  RD               → ADD RD, RD, R0 + LI temp,1 + ADD
         *                        Tek komutla: BSET yok, ADDI → ADD RD,RD + LI
         *                        Basit: ADD RD, RD, t + LI t,1 — ama 2 komut
         *                        Pseudo: 2 komut üretir
         * DEC  RD               → 2 komut (LI tmp,-1 + ADD)
         * PUSH RS               → STORE RS, R31, 0; ADD R31, R31, -1
         * POP  RD               → ADD R31, R31, 1; LOAD RD, R31, 0
         * CALL.R RD, RS         → JALR RD, RS, 0
         * RET.L RD              → JALR R0, RD, 0
         * BGT  RS1, RS2, label  → CMPLT tmp, RS2, RS1; JNZ tmp, label
         * BLT  RS1, RS2, label  → CMPLT tmp, RS1, RS2; JNZ tmp, label
         * BGE  RS1, RS2, label  → CMPLE tmp, RS2, RS1; JNZ tmp, label
         * BLE  RS1, RS2, label  → CMPLE tmp, RS1, RS2; JNZ tmp, label
         * BEQ  RS1, RS2, label  → CMPEQ tmp, RS1, RS2; JNZ tmp, label
         * BNE  RS1, RS2, label  → CMPNE tmp, RS1, RS2; JNZ tmp, label
         *
         * tmp = R1 (assembler geçici register — caller-saved)
         */

        } else if (strcmp(tok, "MOV") == 0) {
            /* MOV RD, RS → ADD RD, RS, R0 */
            REQ_REG(rd); REQ_REG(rs1);
            insn = encode(OP_ADD, (uint32_t)rd, (uint32_t)rs1, 0, 0);

        } else if (strcmp(tok, "CLR") == 0) {
            /* CLR RD → ADD RD, R0, R0 */
            REQ_REG(rd);
            insn = encode(OP_ADD, (uint32_t)rd, 0, 0, 0);

        } else if (strcmp(tok, "NEG") == 0) {
            /* NEG RD, RS → SUB RD, R0, RS */
            REQ_REG(rd); REQ_REG(rs1);
            insn = encode(OP_SUB, (uint32_t)rd, 0, (uint32_t)rs1, 0);

        } else if (strcmp(tok, "NOT") == 0) {
            /* NOT RD, RS → XOR RD, RS, R0 değil — gerçek NOT yok.
             * Yerine: SUB RD, R0, RS sonra SUB RD, RD, 1 (−x − 1 = ~x)
             * Tek komutla: 2 komut üretir:
             *   LI  R1, -1
             *   XOR RD, RS, R1   (R1 ile XOR → tüm bitleri çevir)
             * NOT sadece pass 2'de iki komut üretir */
            REQ_REG(rd); REQ_REG(rs1);
            if (pass == 2) {
                if (insn_count + 1 >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = encode(OP_LI, 1, 0, 0, -1); /* LI R1, -1 */
            }
            *word_addr += 1;
            insn = encode(OP_XOR, (uint32_t)rd, (uint32_t)rs1, 1, 0); /* XOR RD, RS, R1 */

        } else if (strcmp(tok, "INC") == 0) {
            /* INC RD → LI R1, 1; ADD RD, RD, R1 (2 komut) */
            REQ_REG(rd);
            if (pass == 2) {
                if (insn_count + 1 >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = encode(OP_LI, 1, 0, 0, 1); /* LI R1, 1 */
            }
            *word_addr += 1;
            insn = encode(OP_ADD, (uint32_t)rd, (uint32_t)rd, 1, 0);

        } else if (strcmp(tok, "DEC") == 0) {
            /* DEC RD → LI R1, -1; ADD RD, RD, R1 (2 komut) */
            REQ_REG(rd);
            if (pass == 2) {
                if (insn_count + 1 >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = encode(OP_LI, 1, 0, 0, -1); /* LI R1, -1 */
            }
            *word_addr += 1;
            insn = encode(OP_ADD, (uint32_t)rd, (uint32_t)rd, 1, 0);

        } else if (strcmp(tok, "MOVI") == 0) {
            char value_token[MAX_LABEL_LEN];
            int64_t value;
            int value_is_label = 0;
            REQ_REG(rd);
            if (!next_token(&p, value_token, (int)sizeof(value_token))) {
                asm_error(line_no, "Immediate veya label bekleniyor");
                return 0;
            }
            if (!parse_number64(value_token, &value)) {
                value_is_label = 1;
                int32_t address = label_find(value_token);
                if (address < 0) {
                    if (pass == 2) {
                        asm_error(line_no, "Tanımsız label");
                        return 0;
                    }
                    value = 0;
                } else {
                    value = address;
                }
            }
            {
                /*
                 * Label addresses are unknown during pass 1. Reserve the
                 * full 16-bit word-address form in both passes so resolving
                 * a label cannot shift every later symbol.
                 */
                unsigned bytes = value_is_label ? 2u : movi_bytes(value);
                direct_words = movi_words(bytes);
                if (!emit_movi_words(rd, value, bytes,
                                     pass, line_no))
                    return 0;
                *word_addr += direct_words;
            }

        } else if (strcmp(tok, "PUSH") == 0) {
            /* PUSH RS → STORE RS, R31, 0; ADD R31, R31, -1  (2 komut)
             * SP (R31) aşağı büyür */
            REQ_REG(rs1);
            if (pass == 2) {
                if (insn_count + 1 >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = encode(OP_STORE, (uint32_t)rs1, 31, 0, 0);
            }
            *word_addr += 1;
            insn = encode(OP_ADD, 31, 31, 0, -1); /* R31 -= 1, ama -1 LI ile: SUB R31,R31,1 */
            /* Daha doğrusu: SUB R31, R31, R_one → R_one her zaman 1 olmalı */
            /* Basit: LI gerek yok — ADDI R31,R31,-1 → ADD+LI: 2 komut */
            /* Burada encode(OP_ADD,31,31,0,-1) → IMM=-1, fa=31, fb=0 */
            /* sim.c: ADD RD = reg[fa] + reg[fb], IMM kullanmıyor */
            /* ADD IMM'siz, dolayısıyla: LI R1,-1 + ADD R31,R31,R1 = 2 komut */
            /* Toplam PUSH = 3 komut. Daha verimli için ADDI olabilirdi */
            /* Şimdilik 3 komut versiyonu: */
            if (pass == 2) insn_buf[insn_count++] = encode(OP_LI, 1, 0, 0, -1);
            *word_addr += 1;
            insn = encode(OP_ADD, 31, 31, 1, 0);

        } else if (strcmp(tok, "POP") == 0) {
            /* POP RD → ADD R31, R31, 1; LOAD RD, R31, 0  (3 komut) */
            REQ_REG(rd);
            if (pass == 2) {
                if (insn_count + 2 >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = encode(OP_LI,  1, 0, 0, 1);   /* LI R1, 1 */
                insn_buf[insn_count++] = encode(OP_ADD, 31, 31, 1, 0); /* R31++ */
            }
            *word_addr += 2;
            insn = encode(OP_LOAD, (uint32_t)rd, 31, 0, 0); /* LOAD RD, R31, 0 */

        } else if (strcmp(tok, "CALL.R") == 0) {
            /* CALL.R RD, RS → JALR RD, RS, 0 */
            REQ_REG(rd); REQ_REG(rs1);
            insn = encode(OP_JALR, (uint32_t)rd, (uint32_t)rs1, 0, 0);

        } else if (strcmp(tok, "RET.L") == 0) {
            /* RET.L RS → JALR R0, RS, 0 (link register'dan dön) */
            REQ_REG(rs1);
            insn = encode(OP_JALR, 0, (uint32_t)rs1, 0, 0);

        } else if (strcmp(tok, "BGT") == 0 || strcmp(tok, "BLT") == 0 ||
                   strcmp(tok, "BGE") == 0 || strcmp(tok, "BLE") == 0 ||
                   strcmp(tok, "BEQ") == 0 || strcmp(tok, "BNE") == 0) {
            /* Dal pseudo-instruction'ları:
             * BGT RS1, RS2, label → CMPLT R1, RS2, RS1; JNZ R1, label
             * BLT RS1, RS2, label → CMPLT R1, RS1, RS2; JNZ R1, label
             * BGE RS1, RS2, label → CMPLE R1, RS2, RS1; JNZ R1, label
             * BLE RS1, RS2, label → CMPLE R1, RS1, RS2; JNZ R1, label
             * BEQ RS1, RS2, label → CMPEQ R1, RS1, RS2; JNZ R1, label
             * BNE RS1, RS2, label → CMPNE R1, RS1, RS2; JNZ R1, label
             * Her biri 2 komut üretir. tmp = R1. */
            uint32_t cmp_op;
            int swap_args = 0;
            char target[MAX_LABEL_LEN];
            int32_t target_value;
            int target_is_number;

            REQ_REG(rs1); REQ_REG(rs2);
            if (!next_token(&p, target, (int)sizeof(target))) {
                asm_error(line_no, "Immediate veya label bekleniyor");
                return 0;
            }
            target_is_number = parse_number(target, &target_value);

            if (strcmp(tok, "BGT") == 0) { cmp_op = OP_CMPLT; swap_args = 1; }
            else if (strcmp(tok, "BLT") == 0) { cmp_op = OP_CMPLT; swap_args = 0; }
            else if (strcmp(tok, "BGE") == 0) { cmp_op = OP_CMPLE; swap_args = 1; }
            else if (strcmp(tok, "BLE") == 0) { cmp_op = OP_CMPLE; swap_args = 0; }
            else if (strcmp(tok, "BEQ") == 0) { cmp_op = OP_CMPEQ; swap_args = 0; }
            else                               { cmp_op = OP_CMPNE; swap_args = 0; }

            /* CMP komutu */
            if (pass == 2) {
                if (insn_count >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük"); return 0;
                }
                insn_buf[insn_count++] = swap_args
                    ? encode(cmp_op, 1, (uint32_t)rs2, (uint32_t)rs1, 0)
                    : encode(cmp_op, 1, (uint32_t)rs1, (uint32_t)rs2, 0);
            }
            *word_addr += 1;
            if (target_is_number) {
                /*
                 * Numeric pseudo-branches retain the compact two-word form.
                 * The comparison occupies the first word, hence the -1.
                 */
                imm = target_value - 1;
                if (!check_imm11(imm, line_no)) return 0;
                insn = encode(OP_JNZ, 1, 0, 0, imm);
            } else {
                /*
                 * Label branches always use a fixed six-word form:
                 * CMP; JZ skip-four; LUI/LI/OR; JALR.
                 * Fixed size is required so pass 1 and pass 2 agree even
                 * when the label is far away.
                 */
                int32_t address = resolve_label_address(target, pass, line_no);
                if (address < 0) return 0;
                /*
                 * B* label branches also need a fixed-size form.  A
                 * two-byte MOVI is four words, so CMP + JZ + MOVI + JALR
                 * occupies six words in both passes.
                 */
                unsigned bytes = 2u;
                unsigned load_words = movi_words(bytes);
                if (pass == 2) {
                    insn_buf[insn_count++] = encode(OP_JZ, 1, 0, 0,
                                                    (int32_t)(load_words + 1));
                    if (!emit_movi_words(28, (uint64_t)(uint32_t)address,
                                         bytes, pass, line_no))
                        return 0;
                }
                *word_addr += load_words + 1;
                insn = encode(OP_JALR, 0, 28, 0, 0);
            }

        } else {
            asm_error(line_no, "Bilinmeyen mnemonik");
            return 0;
        }

        if (pass == 2) {
            if (direct_words == 0) {
                if (insn_count >= MAX_INSNS) {
                    asm_error(line_no, "Program çok büyük");
                    return 0;
                }
                insn_buf[insn_count++] = insn;
            }
        }
        if (direct_words == 0)
            *word_addr += 1;   /* Oxalyn-64: her komut 1 kelime */
        else
            *word_addr += direct_words;
    }

#undef REQ_REG
#undef REQ_IMM_OR_LABEL

    return 1;
}

/* ─── Dosya Geçişi ─────────────────────────────────────── */

static int run_pass(FILE *f, int pass)
{
    char     line[MAX_LINE_LEN];
    int      line_no  = 0;
    uint32_t word_addr = 0;

    rewind(f);
    while (fgets(line, (int)sizeof(line), f)) {
        line_no++;
        if (!process_line(line, line_no, pass, &word_addr))
            if (error_count > 10) {
                fprintf(stderr, "[HATA] Çok fazla hata, derleme durdu.\n");
                return 0;
            }
    }
    return error_count == 0;
}

/* ─── ELF Yardımcıları ─────────────────────────────────── */

static void elf_u16(FILE *f, uint16_t v)
{
    fputc((v >> 8) & 0xFF, f);
    fputc( v       & 0xFF, f);
}

static void elf_u32(FILE *f, uint32_t v)
{
    fputc((v >> 24) & 0xFF, f);
    fputc((v >> 16) & 0xFF, f);
    fputc((v >>  8) & 0xFF, f);
    fputc( v        & 0xFF, f);
}

/* ─── ELF32 Big-Endian Yazıcı ──────────────────────────── */

/*
 * ELF32 big-endian çıktı (EM_NONE = özel mimari).
 * GDB ile kullanım:
 *   (gdb) set architecture big
 *   (gdb) file program.elf
 *   (gdb) target remote :2345
 *
 * Bölümler: .text (komutlar) + .symtab (label'lar) + .strtab + .shstrtab
 * Tüm label'lar global STT_NOTYPE sembol olarak dışa aktarılır.
 *
 * Dosya düzeni:
 *   0     : ELF başlığı      (52 byte)
 *   52    : Program başlığı  (32 byte) — PT_LOAD, vaddr=0
 *   84    : .text verisi     (insn_count * 4 byte)
 *   84+T  : .symtab          ((1 + label_count) * 16 byte)
 *   84+T+Y: .strtab          (1 + toplam label uzunlukları)
 *   ...   : .shstrtab        (33 byte sabit)
 *   son   : 5 bölüm başlığı  (5 * 40 byte)
 */
static int write_elf(const char *path)
{
    FILE    *f;
    int      i;
    unsigned k;
    uint32_t text_sz, sym_sz, strtab_sz;
    uint32_t off_text, off_symtab, off_strtab, off_shstrtab, off_shdrs;

    /* .shstrtab sabit içerik: "\0.text\0.symtab\0.strtab\0.shstrtab\0"
     * Toplam 33 byte:
     *   [0]  ""         → boş bölüm adı
     *   [1]  ".text"    → bölüm 1
     *   [7]  ".symtab"  → bölüm 2
     *   [15] ".strtab"  → bölüm 3
     *   [23] ".shstrtab"→ bölüm 4
     */
    static const char shstrtab_data[] =
        "\0.text\0.symtab\0.strtab\0.shstrtab\0";
    uint32_t shstrtab_sz = (uint32_t)(sizeof(shstrtab_data) - 1u); /* 33 */

    /* Boyut hesapları */
    text_sz   = (uint32_t)insn_count * 4u;
    sym_sz    = (uint32_t)(1 + label_count) * 16u; /* 1 null + N label */
    strtab_sz = 1u;  /* baştaki null */
    for (i = 0; i < label_count; i++)
        strtab_sz += (uint32_t)strlen(labels[i].name) + 1u;

    /* Dosya ofseti hesapları */
    off_text     = 84u;                            /* ELF(52) + PHDR(32) */
    off_symtab   = off_text     + text_sz;
    off_strtab   = off_symtab   + sym_sz;
    off_shstrtab = off_strtab   + strtab_sz;
    off_shdrs    = off_shstrtab + shstrtab_sz;

    f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "[HATA] ELF çıktı dosyası açılamadı: %s\n", path);
        return 0;
    }

    /* ── ELF Başlığı (52 byte) ── */
    fputc(0x7F, f); fputc('E', f); fputc('L', f); fputc('F', f); /* magic */
    fputc(1, f);    /* ELFCLASS32   */
    fputc(2, f);    /* ELFDATA2MSB  */
    fputc(1, f);    /* EV_CURRENT   */
    fputc(0, f);    /* ELFOSABI_NONE */
    for (i = 0; i < 8; i++) fputc(0, f);  /* e_ident padding */
    elf_u16(f, 2);            /* ET_EXEC      */
    elf_u16(f, 0);            /* EM_NONE      */
    elf_u32(f, 1);            /* e_version    */
    elf_u32(f, 0);            /* e_entry      */
    elf_u32(f, 52);           /* e_phoff      */
    elf_u32(f, off_shdrs);    /* e_shoff      */
    elf_u32(f, 0);            /* e_flags      */
    elf_u16(f, 52);           /* e_ehsize     */
    elf_u16(f, 32);           /* e_phentsize  */
    elf_u16(f, 1);            /* e_phnum      */
    elf_u16(f, 40);           /* e_shentsize  */
    elf_u16(f, 5);            /* e_shnum      */
    elf_u16(f, 4);            /* e_shstrndx   */

    /* ── Program Başlığı (32 byte) ── */
    elf_u32(f, 1);            /* PT_LOAD      */
    elf_u32(f, off_text);     /* p_offset     */
    elf_u32(f, 0);            /* p_vaddr      */
    elf_u32(f, 0);            /* p_paddr      */
    elf_u32(f, text_sz);      /* p_filesz     */
    elf_u32(f, text_sz);      /* p_memsz      */
    elf_u32(f, 5);            /* PF_R | PF_X  */
    elf_u32(f, 4);            /* p_align      */

    /* ── .text bölümü ── */
    for (i = 0; i < insn_count; i++) {
        uint32_t insn = insn_buf[i];
        fputc((insn >> 24) & 0xFF, f);
        fputc((insn >> 16) & 0xFF, f);
        fputc((insn >>  8) & 0xFF, f);
        fputc( insn        & 0xFF, f);
    }

    /* ── .symtab bölümü ── */
    /* Null sembol (16 byte sıfır) */
    for (i = 0; i < 16; i++) fputc(0, f);
    /* Her label için bir Elf32_Sym girişi */
    {
        uint32_t strtab_off = 1u; /* baştaki null sonrası */
        for (i = 0; i < label_count; i++) {
            elf_u32(f, strtab_off);               /* st_name  */
            elf_u32(f, labels[i].word_addr * 8u); /* st_value (byte adr, 64-bit bellek) */
            elf_u32(f, 0);                         /* st_size  */
            fputc(0x10, f);                        /* st_info: STB_GLOBAL|STT_NOTYPE */
            fputc(0, f);                           /* st_other */
            elf_u16(f, 1);                         /* st_shndx (.text = 1) */
            strtab_off += (uint32_t)strlen(labels[i].name) + 1u;
        }
    }

    /* ── .strtab bölümü ── */
    fputc(0, f); /* baştaki null */
    for (i = 0; i < label_count; i++) {
        const char *n = labels[i].name;
        while (*n) fputc(*n++, f);
        fputc(0, f);
    }

    /* ── .shstrtab bölümü ── */
    for (k = 0; k < (unsigned)(sizeof(shstrtab_data) - 1); k++)
        fputc(shstrtab_data[k], f);

    /* ── Bölüm Başlıkları (5 × 40 byte) ── */

    /* [0] NULL */
    for (i = 0; i < 40; i++) fputc(0, f);

    /* [1] .text — SHT_PROGBITS(1), SHF_ALLOC|SHF_EXECINSTR(6) */
    elf_u32(f, 1);        elf_u32(f, 1);        elf_u32(f, 6);
    elf_u32(f, 0);        elf_u32(f, off_text);  elf_u32(f, text_sz);
    elf_u32(f, 0);        elf_u32(f, 0);         elf_u32(f, 4);
    elf_u32(f, 0);

    /* [2] .symtab — SHT_SYMTAB(2), link=3(.strtab), info=1(ilk global) */
    elf_u32(f, 7);        elf_u32(f, 2);         elf_u32(f, 0);
    elf_u32(f, 0);        elf_u32(f, off_symtab); elf_u32(f, sym_sz);
    elf_u32(f, 3);        elf_u32(f, 1);          elf_u32(f, 4);
    elf_u32(f, 16);

    /* [3] .strtab — SHT_STRTAB(3) */
    elf_u32(f, 15);       elf_u32(f, 3);         elf_u32(f, 0);
    elf_u32(f, 0);        elf_u32(f, off_strtab); elf_u32(f, strtab_sz);
    elf_u32(f, 0);        elf_u32(f, 0);          elf_u32(f, 1);
    elf_u32(f, 0);

    /* [4] .shstrtab — SHT_STRTAB(3) */
    elf_u32(f, 23);          elf_u32(f, 3);            elf_u32(f, 0);
    elf_u32(f, 0);           elf_u32(f, off_shstrtab);  elf_u32(f, shstrtab_sz);
    elf_u32(f, 0);           elf_u32(f, 0);             elf_u32(f, 1);
    elf_u32(f, 0);

    fclose(f);
    return 1;
}

/* ─── .bin Yazıcı ──────────────────────────────────────── */

/*
 * Her komut big-endian 4 byte olarak yazılır.
 * sim.c'nin load_bin() fonksiyonu aynı formatı okur.
 */
static int write_bin(const char *path)
{
    FILE    *f;
    int      i;

    f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "[HATA] Çıktı dosyası açılamadı: %s\n", path);
        return 0;
    }

    for (i = 0; i < insn_count; i++) {
        uint32_t insn = insn_buf[i];
        fputc((insn >> 24) & 0xFF, f);
        fputc((insn >> 16) & 0xFF, f);
        fputc((insn >>  8) & 0xFF, f);
        fputc( insn        & 0xFF, f);
    }

    fclose(f);
    return 1;
}

/* ─── main ─────────────────────────────────────────────── */

int main(int argc, char *argv[])
{
    FILE *f;
    int   i;

    if (argc < 3) {
        fprintf(stderr,
            "Kullanım: %s <kaynak.asm> <çıktı.bin|çıktı.elf>\n"
            "  Çıktı dosyası \".elf\" ile bitiyorsa ELF32 big-endian\n"
            "  (sembol tablosu ile) üretilir; aksi halde ham .bin.\n",
            argv[0]);
        return 1;
    }

    f = fopen(argv[1], "r");
    if (!f) {
        fprintf(stderr, "[HATA] Kaynak dosya açılamadı: %s\n", argv[1]);
        return 1;
    }

    printf("Oxalyn-64 Assembler\n");
    printf("Kaynak: %s\n\n", argv[1]);

    /* ── Geçiş 1: Label adreslerini topla ── */
    printf("==> Geçiş 1: label'lar taranıyor...\n");
    if (!run_pass(f, 1)) goto fail;

    printf("    %d label bulundu:\n", label_count);
    for (i = 0; i < label_count; i++) {
        printf("      %-20s → kelime 0x%04X (byte 0x%05X)\n",
               labels[i].name,
               (unsigned)labels[i].word_addr,
               (unsigned)labels[i].word_addr * 8);
    }

    /* ── Geçiş 2: Komutları kodla ── */
    printf("\n==> Geçiş 2: komutlar kodlanıyor...\n");
    insn_count = 0;
    if (!run_pass(f, 2)) goto fail;

    printf("    %d komut kodlandı (%d byte).\n",
           insn_count, insn_count * 4);

    /* ── Çıktı yaz (.elf uzantısı → ELF32, aksi halde ham .bin) ── */
    {
        size_t outlen  = strlen(argv[2]);
        int    is_elf  = (outlen >= 4 &&
                           strcmp(argv[2] + outlen - 4, ".elf") == 0);
        if (is_elf) {
            if (!write_elf(argv[2])) goto fail;
            printf("\n==> ELF çıktı yazıldı: %s (%d sembol)\n",
                   argv[2], label_count);
        } else {
            if (!write_bin(argv[2])) goto fail;
            printf("\n==> Çıktı yazıldı: %s\n", argv[2]);
        }
    }

    fclose(f);
    return 0;

fail:
    fprintf(stderr, "\nDerleme %d hatayla başarısız.\n", error_count);
    fclose(f);
    return 1;
}
