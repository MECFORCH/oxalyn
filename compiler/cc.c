/*
 * cc.c — Oxalyn-64 Minimal C Compiler  (Tek-geçiş, özyinelemeli iniş)
 *
 * Desteklenen C alt kümesi:
 *   Tipler     : int, char (ikisi de 64-bit), void, pointer (*)
 *   Global     : değişken bildirimi, fonksiyon tanımı
 *   Yerel      : stack çerçevesinde saklanan değişkenler
 *   İfadeler   : + - * / % == != < > <= >= && || !
 *                & (bit AND ve adres alma)  | ^ ~  << >>
 *                = += -= *= /=   a[i]  *p  &v   func()
 *   Deyimler   : if/else  while  for  return  { }  expr;
 *   Struct     : word-tabanlı typedef struct, . ve -> alan erişimi
 *   Yok        : union, kompleks initializer, float
 *
 * ABI (Oxalyn-64):
 *   R0      = her zaman 0
 *   R1-R4   = argümanlar
 *   R7      = dönüş değeri
 *   R5-R24  = geçici ifade register'ları
 *   R28     = scratch (prologue/epilogue)
 *   R29     = FP (çerçeve işaretçisi)
 *   R30     = SP (yığın işaretçisi, aşağı büyür, kelime bazlı)
 *   R31     = RA (dönüş adresi, JALR tarafından ayarlanır)
 *
 * Çerçeve düzeni (FP taban):
 *   FP+0          = RA (R31 kopyası)
 *   FP+1          = eski FP
 *   FP+2..FP+2+N-1 = parametre kopyaları (R1..RN)
 *   FP+2+N..      = yerel değişkenler
 *
 * Derleme: gcc -o build/cc compiler/cc.c
 * Kullanım: build/cc kaynak.c -o çıktı.asm
 *           build/asm çıktı.asm çıktı.bin
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdint.h>

/* ── Sabitler ──────────────────────────────────────────── */
#define MAX_IDENT    64
#define MAX_SYMS     4096
#define MAX_PARAMS   16
#define MAX_ARG_REGS 4
#define MAX_CALL_ARGS 32
#define DEFAULT_ARRAY_WORDS 256
#define MAX_ARRAY_DIMS 8
#define MAX_GLOBALS  512
#define MAX_MACROS   1024
#define MAX_PP_DEPTH 64
#define MAX_LABELS   4096
#define MAX_INPUT_FILES 256
#define TEMP_BASE    5     /* R5  = ilk geçici register */
#define TEMP_TOP     27    /* R27 = son geçici register; R28 scratch */
#define REG_RA       31
#define REG_SP       30
#define REG_FP       29
#define REG_SCRATCH  28
#define REG_RET       7

/* ── Token türleri ────────────────────────────────────── */
typedef enum {
    TK_VOID, TK_INT, TK_CHAR, TK_RETURN, TK_IF, TK_ELSE,
    TK_WHILE, TK_FOR, TK_BREAK, TK_CONTINUE,
    TK_SWITCH, TK_CASE, TK_DEFAULT, TK_GOTO,
    TK_SIZEOF,
    TK_CHARCONST, TK_STRING,
    TK_IDENT, TK_NUM,
    TK_PLUS, TK_MINUS, TK_STAR, TK_SLASH, TK_PERCENT,
    TK_AMP, TK_PIPE, TK_CARET, TK_TILDE,
    TK_SHL, TK_SHR,
    TK_EQ, TK_EQEQ, TK_NEQ,
    TK_LT, TK_GT, TK_LEQ, TK_GEQ,
    TK_ANDAND, TK_OROR, TK_BANG,
    TK_PLUSEQ, TK_MINUSEQ, TK_STAREQ, TK_SLASHEQ,
    TK_ANDEQ, TK_OREQ, TK_XOREQ, TK_SHLEQ, TK_SHREQ,
    TK_PLUSPLUS, TK_MINUSMINUS,
    TK_LPAREN, TK_RPAREN,
    TK_LBRACE, TK_RBRACE,
    TK_LBRACKET, TK_RBRACKET,
    TK_DOT, TK_ARROW,
    TK_SEMI, TK_COMMA, TK_QUESTION, TK_COLON,
    TK_EOF, TK_ERROR
} TKind;

/* ── Sembol ───────────────────────────────────────────── */
typedef struct {
    char name[MAX_IDENT];
    int  is_func;
    int  nparams;
    int  fp_offset;   /* FP + fp_offset: yerel/param. 0 = global */
    int  is_global;
    int  is_param;
    int  array_len;   /* scalar = 1; arrays use one word per element */
    int  object_words; /* struct/object size in Oxalyn words */
    int  is_pointer;
    int  ndim;
    int  dims[MAX_ARRAY_DIMS];
    char struct_name[MAX_IDENT];
} Sym;

typedef struct {
    char name[MAX_IDENT];
    int  words;
    int  init_count;
    int  elem_is_pointer;
    int64_t *init;
    char **init_label;
} Global;

typedef struct {
    char name[MAX_IDENT];
    char value[256];
} Macro;

#define MAX_STRUCTS 128
#define MAX_FIELDS  64

typedef struct {
    char name[MAX_IDENT];
    int offset;
    int object_words;
    int is_pointer;
    int is_struct;
    char struct_name[MAX_IDENT];
} Field;

typedef struct {
    int is_lvalue;
    int addr_reg;
    int is_pointer;
    int object_words;
    int ndim;
    int dims[MAX_ARRAY_DIMS];
    char struct_name[MAX_IDENT];
    char var_name[MAX_IDENT];
} ExprMeta;

typedef struct {
    char name[MAX_IDENT];
    int words;
    int nfields;
    int is_union;
    Field fields[MAX_FIELDS];
} StructDef;

typedef struct {
    char name[MAX_IDENT];
    int words;
    int is_struct;
    char struct_name[MAX_IDENT];
} TypeDef;

typedef struct {
    char name[MAX_IDENT];
    int64_t value;
} EnumConst;

typedef struct {
    char label[MAX_IDENT];
    char text[512];
    int len;
} StringLit;

/* ── Global durum ─────────────────────────────────────── */
static const char *src;       /* kaynak metin işaretçisi */
static int         src_pos;
static int         src_len;

static TKind  tok;
static char   tok_ident[MAX_IDENT];
static long   tok_num;
static char   tok_string[512];
static int    tok_string_len;
static int    tok_line = 1;

static Sym    syms[MAX_SYMS];
static int    nsyms = 0;
static Global globals[MAX_GLOBALS];
static int    nglobals = 0;
static Macro  macros[MAX_MACROS];
static int    nmacros = 0;
static StructDef structs[MAX_STRUCTS];
static int    nstructs = 0;
static TypeDef typedefs[MAX_STRUCTS * 2];
static int    ntypedefs = 0;
static EnumConst enum_consts[MAX_STRUCTS * MAX_FIELDS];
static int    nenum_consts = 0;
static StringLit strings[MAX_GLOBALS];
static int    nstrings = 0;
static int    macro_eval_depth = 0;
static int    pp_active = 1;
static int    pp_depth = 0;
static int    pp_parent[MAX_PP_DEPTH];
static int    pp_taken[MAX_PP_DEPTH];

static FILE  *out;            /* çıktı dosyası */
static int    label_cnt = 0;
static unsigned char label_defined[MAX_LABELS];
static unsigned char label_referenced[MAX_LABELS];
static int    reg_top   = 0;  /* R(TEMP_BASE + reg_top) = bir sonraki serbest */
static int    frame_nlocals = 0;
static int    frame_nparams = 0;
static char   cur_func[MAX_IDENT];
static int    func_end_label = -1;
static char   output_path[1024];
static char   source_dir[1024];
static char   current_type[MAX_IDENT];
static int    current_type_is_struct;
static int    current_type_is_union;
static int    current_type_is_char;
static int    current_type_words;
static int    unit_mode;
static ExprMeta expr_meta;

static void die(const char *fmt, ...);
static int64_t parse_const_expr(void);

static int enum_value(const char *name, int64_t *value)
{
    int i;
    for (i = nenum_consts - 1; i >= 0; i--) {
        if (!strcmp(enum_consts[i].name, name)) {
            *value = enum_consts[i].value;
            return 1;
        }
    }
    return 0;
}

static void enum_add(const char *name, int64_t value)
{
    if (nenum_consts >= (int)(sizeof(enum_consts) / sizeof(enum_consts[0])))
        die("Enum sabit tablosu dolu");
    strncpy(enum_consts[nenum_consts].name, name, MAX_IDENT - 1);
    enum_consts[nenum_consts].name[MAX_IDENT - 1] = '\0';
    enum_consts[nenum_consts].value = value;
    nenum_consts++;
}

static const char *string_add(const char *text, int len)
{
    int i;
    for (i = 0; i < nstrings; i++)
        if (strings[i].len == len &&
            !memcmp(strings[i].text, text, (size_t)len))
            return strings[i].label;
    if (nstrings >= MAX_GLOBALS)
        die("String literal tablosu dolu");
    snprintf(strings[nstrings].label, sizeof(strings[nstrings].label),
             "_STR_%d", nstrings);
    if (len >= (int)sizeof(strings[nstrings].text))
        die("String literal çok uzun");
    memcpy(strings[nstrings].text, text, (size_t)len);
    strings[nstrings].len = len;
    return strings[nstrings++].label;
}

/* ── Yardımcılar ──────────────────────────────────────── */
static void die(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fprintf(stderr, "cc: satır %d: ", tok_line);
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, " [token=%d ident=%s]\n", (int)tok, tok_ident);
    va_end(ap);
    if (out && out != stdout) {
        fclose(out);
        out = NULL;
        if (output_path[0]) remove(output_path);
    }
    exit(1);
}

static void emit(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vfprintf(out, fmt, ap);
    fprintf(out, "\n");
    va_end(ap);
}

static void emit_label(int n)
{
    if (n < 0 || n >= MAX_LABELS)
        die("İç label numarası sınırı aşıldı: %d", n);
    if (label_defined[n])
        die("İç label iki kez tanımlandı: _L%d", n);
    label_defined[n] = 1;
    fprintf(out, "_L%d:\n", n);
}

static int new_label(void)
{
    if (label_cnt >= MAX_LABELS)
        die("İç label tablosu doldu");
    label_defined[label_cnt] = 0;
    label_referenced[label_cnt] = 0;
    return label_cnt++;
}

static void note_label_reference(int n)
{
    if (n < 0 || n >= label_cnt)
        die("Geçersiz iç label referansı: _L%d", n);
    label_referenced[n] = 1;
}

static void emit_jmp_label(int n)
{
    note_label_reference(n);
    emit("    JMP  _L%d", n);
}

static void emit_jz_label(int reg, int n)
{
    note_label_reference(n);
    emit("    JZ   R%d, _L%d", reg, n);
}

/*
 * A parser branch can be unreachable in the source while its target is
 * still emitted by the common control-flow code.  Keep that invariant
 * explicit: every generated internal label that is referenced gets a
 * harmless landing point instead of leaking an undefined assembler symbol.
 */
static void emit_missing_labels(void)
{
    int i;
    for (i = 0; i < label_cnt; i++) {
        if (label_referenced[i] && !label_defined[i]) {
            fprintf(stderr,
                    "cc: uyarı: erişilemeyen iç label için dummy hedef: _L%d\n",
                    i);
            emit_label(i);
            emit("    NOP");
        }
    }
}
static int  alloc_reg(void)   {
    if (TEMP_BASE + reg_top > TEMP_TOP)
        die("Geçici register taşması (ifade çok derin)");
    return TEMP_BASE + reg_top++;
}
static void free_reg(void) { if (reg_top > 0) reg_top--; }
static void free_regs_to(int lvl) { reg_top = lvl; }

static Macro *macro_find(const char *name)
{
    int i;
    for (i = nmacros - 1; i >= 0; i--)
        if (!strcmp(macros[i].name, name))
            return &macros[i];
    return NULL;
}

static void macro_define(const char *name, const char *value)
{
    Macro *m = macro_find(name);
    if (!m) {
        if (nmacros >= MAX_MACROS)
            die("Makro tablosu dolu");
        m = &macros[nmacros++];
        strncpy(m->name, name, MAX_IDENT - 1);
        m->name[MAX_IDENT - 1] = '\0';
    }
    strncpy(m->value, value, sizeof(m->value) - 1);
    m->value[sizeof(m->value) - 1] = '\0';
}

static int macro_is_defined(const char *name)
{
    return macro_find(name) != NULL;
}

/*
 * Evaluate the integer constant expressions used by the kernel headers.
 * This is deliberately small: it accepts numeric literals, parentheses,
 * + - * / << >> & | ^ and the common UINT32_C/UINT64_C wrappers.
 */
static const char *ce_ptr;
static int64_t ce_expr(const char *text);
static int64_t ce_bitxor(void);

static void ce_ws(void)
{
    while (*ce_ptr == ' ' || *ce_ptr == '\t')
        ce_ptr++;
}

static int64_t ce_primary(void)
{
    int sign = 1;
    int64_t value = 0;
    ce_ws();
    if (*ce_ptr == '+') { ce_ptr++; }
    else if (*ce_ptr == '-') { sign = -1; ce_ptr++; }
    ce_ws();
    if (*ce_ptr == '(') {
        ce_ptr++;
        value = ce_bitxor();
        ce_ws();
        if (*ce_ptr == ')') ce_ptr++;
        return sign * value;
    }
    if (!strncmp(ce_ptr, "UINT32_C", 8) ||
        !strncmp(ce_ptr, "UINT64_C", 8) ||
        !strncmp(ce_ptr, "INT32_C", 7) ||
        !strncmp(ce_ptr, "INT64_C", 7)) {
        int wrapper_len = (!strncmp(ce_ptr, "UINT32_C", 8) ||
                           !strncmp(ce_ptr, "UINT64_C", 8)) ? 8 : 7;
        ce_ptr += wrapper_len;
        ce_ws();
        if (*ce_ptr == '(') {
            ce_ptr++;
            value = ce_bitxor();
            ce_ws();
            if (*ce_ptr == ')') ce_ptr++;
        }
        return sign * value;
    }
    if (isalpha((unsigned char)*ce_ptr) || *ce_ptr == '_') {
        char name[MAX_IDENT];
        int i = 0;
        while ((isalnum((unsigned char)*ce_ptr) || *ce_ptr == '_') &&
               i < MAX_IDENT - 1)
            name[i++] = *ce_ptr++;
        name[i] = '\0';
        if (macro_eval_depth < MAX_PP_DEPTH) {
            Macro *m = macro_find(name);
            if (m && m->value[0]) {
                macro_eval_depth++;
                value = ce_expr(m->value);
                macro_eval_depth--;
                return sign * value;
            }
        }
        return 0;
    }
    {
        char *end;
        value = (int64_t)strtoll(ce_ptr, &end, 0);
        if (end == ce_ptr)
            return 0;
        ce_ptr = end;
        while (*ce_ptr == 'u' || *ce_ptr == 'U' ||
               *ce_ptr == 'l' || *ce_ptr == 'L')
            ce_ptr++;
    }
    return sign * value;
}

static int64_t ce_shift(void)
{
    int64_t value = ce_primary();
    for (;;) {
        int64_t rhs;
        ce_ws();
        if (ce_ptr[0] == '<' && ce_ptr[1] == '<') {
            ce_ptr += 2; rhs = ce_primary(); value <<= rhs;
        } else if (ce_ptr[0] == '>' && ce_ptr[1] == '>') {
            ce_ptr += 2; rhs = ce_primary(); value >>= rhs;
        } else break;
    }
    return value;
}

static int64_t ce_mul(void)
{
    int64_t value = ce_shift();
    for (;;) {
        int64_t rhs;
        ce_ws();
        if (*ce_ptr == '*') { ce_ptr++; rhs = ce_shift(); value *= rhs; }
        else if (*ce_ptr == '/') {
            ce_ptr++; rhs = ce_shift(); if (rhs) value /= rhs;
        } else break;
    }
    return value;
}

static int64_t ce_add(void)
{
    int64_t value = ce_mul();
    for (;;) {
        int64_t rhs;
        ce_ws();
        if (*ce_ptr == '+') { ce_ptr++; rhs = ce_mul(); value += rhs; }
        else if (*ce_ptr == '-') { ce_ptr++; rhs = ce_mul(); value -= rhs; }
        else break;
    }
    return value;
}

static int64_t ce_bitand(void)
{
    int64_t value = ce_add();
    for (;;) {
        int64_t rhs;
        ce_ws();
        if (*ce_ptr == '&' && ce_ptr[1] != '&') {
            ce_ptr++; rhs = ce_add(); value &= rhs;
        } else break;
    }
    return value;
}

static int64_t ce_bitxor(void)
{
    int64_t value = ce_bitand();
    for (;;) {
        int64_t rhs;
        ce_ws();
        if (*ce_ptr == '^') { ce_ptr++; rhs = ce_bitand(); value ^= rhs; }
        else break;
    }
    return value;
}

static int64_t ce_expr(const char *text)
{
    ce_ptr = text;
    return ce_bitxor();
}

static int macro_value(const char *name, int64_t *value)
{
    Macro *m = macro_find(name);
    const char *p;
    char alias[MAX_IDENT];
    int alias_len = 0;
    if (!m || !m->value[0])
        return 0;
    p = m->value;
    while (*p == ' ' || *p == '\t')
        p++;
    /*
     * Object-like macros such as `printf KPRINT` are names, not integer
     * expressions.  Treating every unknown macro as zero makes a call such
     * as printf("x") look like `0("x")` to the parser.
     */
    if ((!strncmp(p, "UINT32_C", 8) ||
         !strncmp(p, "UINT64_C", 8) ||
         !strncmp(p, "INT32_C", 7) ||
         !strncmp(p, "INT64_C", 7)) &&
        strchr(p, '(') == p + (strncmp(p, "UINT32_C", 8) &&
                               strncmp(p, "UINT64_C", 8) ? 7 : 8)) {
        /* The standard integer wrapper macros are not present in the
         * freestanding header set, but their arguments are still numeric. */
    } else if (isalpha((unsigned char)*p) || *p == '_') {
        while ((isalnum((unsigned char)*p) || *p == '_') &&
               alias_len < MAX_IDENT - 1)
            alias[alias_len++] = *p++;
        alias[alias_len] = '\0';
        if (!macro_find(alias))
            return 0;
    } else if (!isdigit((unsigned char)*p) && *p != '+' && *p != '-' &&
               *p != '(' && *p != '~') {
        return 0;
    }
    macro_eval_depth = 0;
    *value = ce_expr(m->value);
    return 1;
}

static int macro_string_value(const char *name)
{
    Macro *m = macro_find(name);
    const char *p;
    int i = 0;

    if (!m) return 0;
    p = m->value;
    while (*p == ' ' || *p == '\t') p++;
    if (*p != '"') return 0;
    p++;
    while (*p && *p != '"' && i < (int)sizeof(tok_string) - 1) {
        if (*p == '\\' && p[1]) {
            p++;
            switch (*p) {
            case 'n': tok_string[i++] = '\n'; break;
            case 'r': tok_string[i++] = '\r'; break;
            case 't': tok_string[i++] = '\t'; break;
            default:  tok_string[i++] = *p; break;
            }
        } else {
            tok_string[i++] = *p;
        }
        p++;
    }
    if (*p != '"') return 0;
    tok_string[i] = '\0';
    tok_string_len = i;
    return 1;
}

static StructDef *struct_find(const char *name)
{
    int i;
    for (i = nstructs - 1; i >= 0; i--)
        if (!strcmp(structs[i].name, name))
            return &structs[i];
    return NULL;
}

static StructDef *struct_add(const char *name)
{
    StructDef *s;
    if (nstructs >= MAX_STRUCTS)
        die("Struct tablo dolu");
    s = &structs[nstructs++];
    memset(s, 0, sizeof(*s));
    strncpy(s->name, name, MAX_IDENT - 1);
    s->name[MAX_IDENT - 1] = '\0';
    return s;
}

static Field *struct_field(StructDef *s, const char *name)
{
    int i;
    if (!s) return NULL;
    for (i = 0; i < s->nfields; i++)
        if (!strcmp(s->fields[i].name, name))
            return &s->fields[i];
    return NULL;
}

static TypeDef *typedef_find(const char *name)
{
    int i;
    for (i = ntypedefs - 1; i >= 0; i--)
        if (!strcmp(typedefs[i].name, name))
            return &typedefs[i];
    return NULL;
}

static void typedef_add(const char *name, int words, int is_struct,
                        const char *struct_name)
{
    TypeDef *t;
    if (ntypedefs >= (int)(sizeof(typedefs) / sizeof(typedefs[0])))
        die("Typedef tablosu dolu");
    t = &typedefs[ntypedefs++];
    memset(t, 0, sizeof(*t));
    strncpy(t->name, name, MAX_IDENT - 1);
    t->words = words > 0 ? words : 1;
    t->is_struct = is_struct;
    if (struct_name)
        strncpy(t->struct_name, struct_name, MAX_IDENT - 1);
}

/* ── Minimal source preprocessor ─────────────────────── */
static char  *pp_output;
static size_t pp_len;
static size_t pp_cap;

static void pp_append(const char *text)
{
    size_t n = strlen(text);
    if (pp_len + n + 1 > pp_cap) {
        size_t next = pp_cap ? pp_cap * 2 : 8192;
        while (next < pp_len + n + 1) next *= 2;
        pp_output = (char *)realloc(pp_output, next);
        if (!pp_output) die("Ön işlemci çıktısı ayrılamadı");
        pp_cap = next;
    }
    memcpy(pp_output + pp_len, text, n);
    pp_len += n;
    pp_output[pp_len] = '\0';
}

static char *pp_trim(char *s)
{
    char *end;
    while (*s == ' ' || *s == '\t') s++;
    end = s + strlen(s);
    while (end > s && (end[-1] == ' ' || end[-1] == '\t' ||
                       end[-1] == '\r' || end[-1] == '\n'))
        *--end = '\0';
    return s;
}

static void pp_strip_inline_comment(char *s)
{
    char *p = strstr(s, "/*");
    char *line = strstr(s, "//");
    if (line && (!p || line < p))
        p = line;
    if (p)
        *p = '\0';
}

static int pp_cond(const char *expr)
{
    char name[MAX_IDENT];
    const char *p = expr;
    int neg = 0;
    while (*p == ' ' || *p == '\t') p++;
    if (*p == '!') { neg = 1; p++; }
    while (*p == ' ' || *p == '\t') p++;
    if (!strncmp(p, "defined", 7)) {
        p += 7;
        while (*p == ' ' || *p == '\t' || *p == '(') p++;
        {
            int i = 0;
            while ((isalnum((unsigned char)*p) || *p == '_') &&
                   i < MAX_IDENT - 1)
                name[i++] = *p++;
            name[i] = '\0';
        }
        return neg ? !macro_is_defined(name) : macro_is_defined(name);
    }
    {
        char *end;
        int64_t v = strtoll(p, &end, 0);
        if (end != p) return neg ? !v : !!v;
    }
    return neg ? 1 : 0;
}

static void pp_process_file(const char *path, int depth)
{
    FILE *f;
    char line[2048];
    char dir[1024];
    const char *slash;

    if (depth >= MAX_PP_DEPTH)
        die("Header include derinliği çok büyük");
    f = fopen(path, "r");
    if (!f) die("Header açılamadı: %s", path);

    strncpy(dir, path, sizeof(dir) - 1);
    dir[sizeof(dir) - 1] = '\0';
    slash = strrchr(dir, '/');
    if (slash) ((char *)slash)[1] = '\0';
    else strcpy(dir, "./");

    while (fgets(line, sizeof(line), f)) {
        char *p = line;
        while (*p == ' ' || *p == '\t') p++;
        if (*p == '#') {
            char directive[32];
            char arg[1600];
            char *q = p + 1;
            char *d = directive;
            int n;
            while (*q == ' ' || *q == '\t') q++;
            while ((isalnum((unsigned char)*q) || *q == '_') &&
                   d < directive + sizeof(directive) - 1)
                *d++ = *q++;
            *d = '\0';
            while (*q == ' ' || *q == '\t') q++;
            strncpy(arg, q, sizeof(arg) - 1);
            arg[sizeof(arg) - 1] = '\0';
            pp_trim(arg);
            n = directive[0] ? 1 : 0;
            if (arg[0]) n = 2;
            if (n < 1) continue;

            if (!strcmp(directive, "ifdef") || !strcmp(directive, "ifndef") ||
                !strcmp(directive, "if")) {
                int cond = 0;
                if (n >= 2) {
                    if (!strcmp(directive, "ifdef"))
                        cond = macro_is_defined(pp_trim(arg));
                    else if (!strcmp(directive, "ifndef"))
                        cond = !macro_is_defined(pp_trim(arg));
                    else
                        cond = pp_cond(pp_trim(arg));
                }
                if (pp_depth >= MAX_PP_DEPTH)
                    die("Ön işlemci koşul derinliği çok büyük");
                pp_parent[pp_depth] = pp_active;
                pp_taken[pp_depth] = cond;
                pp_active = pp_active && cond;
                pp_depth++;
                continue;
            }
            if (!strcmp(directive, "else")) {
                if (pp_depth <= 0) die("Eşleşmeyen #else");
                pp_depth--;
                pp_active = pp_parent[pp_depth] &&
                            !pp_taken[pp_depth];
                pp_taken[pp_depth] = 1;
                pp_depth++;
                continue;
            }
            if (!strcmp(directive, "endif")) {
                if (pp_depth <= 0) die("Eşleşmeyen #endif");
                pp_depth--;
                pp_active = pp_parent[pp_depth];
                continue;
            }
            if (!pp_active) continue;

            if (!strcmp(directive, "define") && n >= 2) {
                char name[MAX_IDENT];
                char value[256];
                const char *q = pp_trim(arg);
                int i = 0;
                while ((isalnum((unsigned char)*q) || *q == '_') &&
                       i < MAX_IDENT - 1)
                    name[i++] = *q++;
                name[i] = '\0';
                if (*q == '(') {
                    /*
                     * Function-like macros are intentionally left for the
                     * C parser's real function/call path.  Object-like
                     * integer macros are expanded below.
                     */
                    while (strlen(line) > 1 &&
                           line[strlen(line) - 2] == '\\') {
                        if (!fgets(line, sizeof(line), f))
                            break;
                    }
                    continue;
                }
                q = pp_trim((char *)q);
                strncpy(value, q, sizeof(value) - 1);
                value[sizeof(value) - 1] = '\0';
                pp_strip_inline_comment(value);
                pp_trim(value);
                macro_define(name, value);
                continue;
            }
            if (!strcmp(directive, "include") && n >= 2) {
                char inc[1024];
                char resolved[2048];
                const char *q = pp_trim(arg);
                if (*q == '<') continue; /* built-in integer headers */
                if (*q == '"') {
                    const char *close = strchr(q + 1, '"');
                    size_t len;
                    if (!close)
                        die("Geçersiz include: %s", q);
                    len = (size_t)(close - (q + 1));
                    if (len >= sizeof(inc))
                        die("Include yolu çok uzun");
                    strncpy(inc, q + 1, len);
                    inc[len] = '\0';
                } else {
                    continue;
                }
                snprintf(resolved, sizeof(resolved), "%s%s", dir, inc);
                pp_process_file(resolved, depth + 1);
                continue;
            }
            /* pragma, undef and unknown directives have no C tokens. */
            continue;
        }
        if (pp_active)
            pp_append(line);
    }
    fclose(f);
}

/* ── Sembol tablosu ───────────────────────────────────── */
static Sym *sym_find(const char *name)
{
    int i;
    for (i = nsyms - 1; i >= 0; i--)
        if (strcmp(syms[i].name, name) == 0) return &syms[i];
    return NULL;
}

static Sym *sym_add_local(const char *name, int fp_off, int is_param)
{
    Sym *s;
    if (nsyms >= MAX_SYMS) die("Sembol tablosu dolu");
    s = &syms[nsyms++];
    strncpy(s->name, name, MAX_IDENT - 1);
    s->fp_offset = fp_off;
    s->is_global  = 0;
    s->is_func    = 0;
    s->is_param   = is_param;
    s->array_len  = 1;
    s->object_words = 1;
    s->is_pointer = 0;
    s->ndim = 0;
    memset(s->dims, 0, sizeof(s->dims));
    s->struct_name[0] = '\0';
    return s;
}

static void sym_set_object_type(Sym *s, int is_pointer)
{
    if (!s) return;
    s->object_words = current_type_words > 0 ? current_type_words : 1;
    s->is_pointer = is_pointer;
    if (current_type_is_struct) {
        strncpy(s->struct_name, current_type, MAX_IDENT - 1);
        s->struct_name[MAX_IDENT - 1] = '\0';
    } else {
        s->struct_name[0] = '\0';
    }
}

static void sym_set_type_values(Sym *s, int words, int is_pointer,
                                int is_struct, const char *struct_name)
{
    if (!s) return;
    s->object_words = words > 0 ? words : 1;
    s->is_pointer = is_pointer;
    s->struct_name[0] = '\0';
    if (is_struct && struct_name)
        strncpy(s->struct_name, struct_name, MAX_IDENT - 1);
}

static Sym *sym_add_func(const char *name, int nparams)
{
    Sym *s;
    if (nsyms >= MAX_SYMS) die("Sembol tablosu dolu");
    s = &syms[nsyms++];
    strncpy(s->name, name, MAX_IDENT - 1);
    s->is_func  = 1;
    s->nparams  = nparams;
    s->is_global = 1;
    s->array_len = 1;
    s->object_words = 1;
    s->is_pointer = 0;
    s->ndim = 0;
    memset(s->dims, 0, sizeof(s->dims));
    s->struct_name[0] = '\0';
    return s;
}

static Sym *sym_add_global(const char *name, int words)
{
    Sym *s;
    if (nsyms >= MAX_SYMS) die("Sembol tablosu dolu");
    s = &syms[nsyms++];
    strncpy(s->name, name, MAX_IDENT - 1);
    s->name[MAX_IDENT - 1] = '\0';
    s->is_func = 0;
    s->is_global = 1;
    s->is_param = 0;
    s->fp_offset = 0;
    s->array_len = words > 0 ? words : 1;
    s->object_words = 1;
    s->struct_name[0] = '\0';
    s->ndim = 0;
    memset(s->dims, 0, sizeof(s->dims));
    return s;
}

static Global *global_add(const char *name, int words)
{
    Global *g;
    if (nglobals >= MAX_GLOBALS) die("Global tablo dolu");
    g = &globals[nglobals++];
    strncpy(g->name, name, MAX_IDENT - 1);
    g->name[MAX_IDENT - 1] = '\0';
    g->words = words > 0 ? words : 1;
    g->init_count = 0;
    g->elem_is_pointer = 0;
    g->init = (int64_t *)calloc((size_t)g->words, sizeof(*g->init));
    g->init_label = (char **)calloc((size_t)g->words, sizeof(*g->init_label));
    if (!g->init || !g->init_label) die("Global veri alanı ayrılamadı");
    return g;
}

static int  sym_mark(void)  { return nsyms; }
static void sym_restore(int mark) { nsyms = mark; }

/* ── Lexer ────────────────────────────────────────────── */
static int  peek_ch(void) { return src_pos < src_len ? (unsigned char)src[src_pos] : -1; }
static int  next_ch(void) {
    int c = peek_ch();
    if (c == '\n') tok_line++;
    src_pos++;
    return c;
}
static void skip_ws(void) {
    for (;;) {
        int c = peek_ch();
        if (c == ' ' || c == '\t' || c == '\r' || c == '\n') { next_ch(); continue; }
        /*
         * cc.c is intentionally a small freestanding front end, not a full
         * preprocessor.  Still, kernel source files must get past #include,
         * #if and #define lines before the C parser sees declarations.
         * Header contents are supplied by the WASM frontend in the complete
         * kernel path; cc.c consumes these lines rather than guessing them.
         */
        if (c == '#') {
            while (peek_ch() != '\n' && peek_ch() != -1)
                next_ch();
            continue;
        }
        if (c == '/') {
            if (src_pos + 1 < src_len && src[src_pos+1] == '/') {
                while (peek_ch() != '\n' && peek_ch() != -1)
                    next_ch();
                continue;
            }
            if (src_pos + 1 < src_len && src[src_pos+1] == '*') {
                next_ch(); next_ch();
                while (!(peek_ch() == '*' && src_pos+1 < src_len && src[src_pos+1] == '/')) {
                    if (peek_ch() == -1) die("Yorum kapatılmadı");
                    next_ch();
                }
                next_ch(); next_ch(); continue;
            }
        }
        break;
    }
}

static int hex_digit_value(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

/*
 * Decode the character after a backslash.  The dispatching switch has
 * already consumed the backslash itself, but this helper consumes the
 * escape designator and any following hex/octal digits.
 */
static int decode_escape(const char *kind)
{
    int c = next_ch();
    int value;

    switch (c) {
        case 'n': return '\n';
        case 'r': return '\r';
        case 't': return '\t';
        case 'b': return '\b';
        case 'f': return '\f';
        case 'v': return '\v';
        case 'a': return '\a';
        case '\\': return '\\';
        case '"': return '"';
        case '\'': return '\'';
        case 'x': {
            int h1 = peek_ch();
            int h2 = src_pos + 1 < src_len ? (unsigned char)src[src_pos + 1] : -1;
            int d1 = hex_digit_value(h1);
            int d2 = hex_digit_value(h2);
            if (d1 < 0 || d2 < 0)
                die("Geçersiz hex kaçışı \\x");
            next_ch();
            next_ch();
            return (d1 << 4) | d2;
        }
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
            value = c - '0';
            if (peek_ch() >= '0' && peek_ch() <= '7') {
                value = value * 8 + (next_ch() - '0');
                if (peek_ch() >= '0' && peek_ch() <= '7')
                    value = value * 8 + (next_ch() - '0');
            }
            return value;
        default:
            die("Desteklenmeyen %s kaçışı", kind);
            return 0;
    }
}

static TKind lex_next(void)
{
    int c;
    skip_ws();
    c = peek_ch();
    if (c == -1) return tok = TK_EOF;

    if (isalpha(c) || c == '_') {
        int i = 0;
        while (isalnum(peek_ch()) || peek_ch() == '_') {
            if (i < MAX_IDENT-1) tok_ident[i++] = (char)next_ch();
            else { next_ch(); }
        }
        tok_ident[i] = '\0';
        if (!strcmp(tok_ident,"void"))     return tok = TK_VOID;
        if (!strcmp(tok_ident,"int"))      return tok = TK_INT;
        if (!strcmp(tok_ident,"char"))     return tok = TK_CHAR;
        if (!strcmp(tok_ident,"return"))   return tok = TK_RETURN;
        if (!strcmp(tok_ident,"if"))       return tok = TK_IF;
        if (!strcmp(tok_ident,"else"))     return tok = TK_ELSE;
        if (!strcmp(tok_ident,"while"))    return tok = TK_WHILE;
        if (!strcmp(tok_ident,"for"))      return tok = TK_FOR;
        if (!strcmp(tok_ident,"break"))    return tok = TK_BREAK;
        if (!strcmp(tok_ident,"continue")) return tok = TK_CONTINUE;
        if (!strcmp(tok_ident,"switch"))   return tok = TK_SWITCH;
        if (!strcmp(tok_ident,"case"))     return tok = TK_CASE;
        if (!strcmp(tok_ident,"default"))  return tok = TK_DEFAULT;
        if (!strcmp(tok_ident,"goto"))     return tok = TK_GOTO;
        if (!strcmp(tok_ident,"sizeof"))   return tok = TK_SIZEOF;
        if (macro_string_value(tok_ident))
            return tok = TK_STRING;
        {
            int64_t macro_num;
            if (enum_value(tok_ident, &macro_num)) {
                tok_num = (long)macro_num;
                return tok = TK_NUM;
            }
            if (macro_value(tok_ident, &macro_num)) {
                tok_num = (long)macro_num;
                return tok = TK_NUM;
            }
        }
        return tok = TK_IDENT;
    }
    if (isdigit(c)) {
        long n = 0;
        if (c == '0' && (src_pos+1 < src_len) &&
            (src[src_pos+1]=='x' || src[src_pos+1]=='X')) {
            next_ch(); next_ch();
            while (isxdigit(peek_ch())) {
                int d = toupper(next_ch());
                n = n*16 + (d >= 'A' ? d-'A'+10 : d-'0');
            }
        } else {
            while (isdigit(peek_ch())) n = n*10 + (next_ch()-'0');
        }
        while (peek_ch() == 'u' || peek_ch() == 'U' ||
               peek_ch() == 'l' || peek_ch() == 'L')
            next_ch();
        tok_num = n;
        return tok = TK_NUM;
    }
    if (c == '\'') {
        int value;
        next_ch();
        if (peek_ch() == '\\') {
            next_ch();
            value = decode_escape("karakter");
        } else {
            value = next_ch();
        }
        if (peek_ch() != '\'')
            die("Kapatılmamış karakter sabiti");
        next_ch();
        tok_num = value;
        return tok = TK_CHARCONST;
    }
    if (c == '"') {
        int i = 0;
        next_ch();
        while (peek_ch() != '"' && peek_ch() != -1) {
            int value;
            if (peek_ch() == '\\') {
                next_ch();
                value = decode_escape("string");
            } else {
                value = next_ch();
            }
            if (i >= (int)sizeof(tok_string) - 1)
                die("String literal çok uzun");
            tok_string[i++] = (char)value;
        }
        if (peek_ch() != '"')
            die("Kapatılmamış string literal");
        next_ch();
        tok_string[i] = '\0';
        tok_string_len = i;
        return tok = TK_STRING;
    }
    next_ch();
    switch (c) {
        case '+':
            if (peek_ch()=='+') { next_ch(); return tok=TK_PLUSPLUS; }
            if (peek_ch()=='=') { next_ch(); return tok=TK_PLUSEQ; }
            return tok=TK_PLUS;
        case '-':
            if (peek_ch()=='>') { next_ch(); return tok=TK_ARROW; }
            if (peek_ch()=='-') { next_ch(); return tok=TK_MINUSMINUS; }
            if (peek_ch()=='=') { next_ch(); return tok=TK_MINUSEQ; }
            return tok=TK_MINUS;
        case '*':
            if (peek_ch()=='=') { next_ch(); return tok=TK_STAREQ; }
            return tok=TK_STAR;
        case '/':
            if (peek_ch()=='=') { next_ch(); return tok=TK_SLASHEQ; }
            return tok=TK_SLASH;
        case '%': return tok=TK_PERCENT;
        case '&':
            if (peek_ch()=='&') { next_ch(); return tok=TK_ANDAND; }
            if (peek_ch()=='=') { next_ch(); return tok=TK_ANDEQ; }
            return tok=TK_AMP;
        case '|':
            if (peek_ch()=='|') { next_ch(); return tok=TK_OROR; }
            if (peek_ch()=='=') { next_ch(); return tok=TK_OREQ; }
            return tok=TK_PIPE;
        case '^':
            if (peek_ch()=='=') { next_ch(); return tok=TK_XOREQ; }
            return tok=TK_CARET;
        case '~': return tok=TK_TILDE;
        case '<':
            if (peek_ch()=='<') {
                next_ch();
                if (peek_ch()=='=') { next_ch(); return tok=TK_SHLEQ; }
                return tok=TK_SHL;
            }
            if (peek_ch()=='=') { next_ch(); return tok=TK_LEQ; }
            return tok=TK_LT;
        case '>':
            if (peek_ch()=='>') {
                next_ch();
                if (peek_ch()=='=') { next_ch(); return tok=TK_SHREQ; }
                return tok=TK_SHR;
            }
            if (peek_ch()=='=') { next_ch(); return tok=TK_GEQ; }
            return tok=TK_GT;
        case '=':
            if (peek_ch()=='=') { next_ch(); return tok=TK_EQEQ; }
            return tok=TK_EQ;
        case '!':
            if (peek_ch()=='=') { next_ch(); return tok=TK_NEQ; }
            return tok=TK_BANG;
        case '(': return tok=TK_LPAREN;
        case ')': return tok=TK_RPAREN;
        case '{': return tok=TK_LBRACE;
        case '}': return tok=TK_RBRACE;
        case '[': return tok=TK_LBRACKET;
        case ']': return tok=TK_RBRACKET;
        case '.': return tok=TK_DOT;
        case ';': return tok=TK_SEMI;
        case ',': return tok=TK_COMMA;
        case '?': return tok=TK_QUESTION;
        case ':': return tok=TK_COLON;
        default:  return tok=TK_ERROR;
    }
}

static void expect(TKind k) {
    if (tok != k)
        die("Beklenmeyen token: %d (beklenen %d)", (int)tok, (int)k);
    lex_next();
}

static int eat(TKind k) {
    if (tok == k) { lex_next(); return 1; }
    return 0;
}

/* ── Tür ayrıştırıcı (basit) ──────────────────────────── */
static int is_type_name(void)
{
    if (tok == TK_VOID || tok == TK_INT || tok == TK_CHAR)
        return 1;
    if (tok != TK_IDENT)
        return 0;
    if (!strcmp(tok_ident, "struct"))
        return 1;
    if (!strcmp(tok_ident, "union"))
        return 1;
    if (!strcmp(tok_ident, "enum"))
        return 1;
    if (typedef_find(tok_ident))
        return 1;
    return !strcmp(tok_ident, "uint8_t") ||
           !strcmp(tok_ident, "uint16_t") ||
           !strcmp(tok_ident, "uint32_t") ||
           !strcmp(tok_ident, "uint64_t") ||
           !strcmp(tok_ident, "int8_t") ||
           !strcmp(tok_ident, "int16_t") ||
           !strcmp(tok_ident, "int32_t") ||
           !strcmp(tok_ident, "int64_t") ||
           !strcmp(tok_ident, "uintptr_t") ||
           !strcmp(tok_ident, "size_t") ||
           !strcmp(tok_ident, "va_list") ||
           !strcmp(tok_ident, "__builtin_va_list") ||
           !strcmp(tok_ident, "unsigned") ||
           !strcmp(tok_ident, "signed") ||
           !strcmp(tok_ident, "long") ||
           !strcmp(tok_ident, "short");
}

static int is_type_qualifier(void)
{
    return tok == TK_IDENT &&
           (!strcmp(tok_ident, "const") ||
            !strcmp(tok_ident, "volatile") ||
            !strcmp(tok_ident, "restrict") ||
            !strcmp(tok_ident, "static") ||
            !strcmp(tok_ident, "extern") ||
            !strcmp(tok_ident, "inline"));
}

static int is_decl_start(void)
{
    return is_type_name() || is_type_qualifier();
}

static int parse_type_and_ptr(void);

static int parse_array_bound(int allow_unsized)
{
    int64_t bound;
    if (tok == TK_RBRACKET) {
        if (!allow_unsized)
            die("Dizi boyutu sabit pozitif olmalı");
        return 0;
    }
    bound = parse_const_expr();
    if (bound <= 0 || bound > 65536)
        die("Dizi boyutu sabit pozitif olmalı");
    return (int)bound;
}

static int parse_array_dimensions(int allow_unsized, int *ndim,
                                  int dims[MAX_ARRAY_DIMS])
{
    int total = 1;

    *ndim = 0;
    while (eat(TK_LBRACKET)) {
        int bound;
        if (*ndim >= MAX_ARRAY_DIMS)
            die("Çok fazla dizi boyutu (max %d)", MAX_ARRAY_DIMS);
        bound = parse_array_bound(allow_unsized && *ndim == 0);
        if (bound == 0)
            bound = DEFAULT_ARRAY_WORDS;
        if (total > 65536 / bound)
            die("Dizi boyutu çok büyük");
        dims[*ndim] = bound;
        total *= bound;
        (*ndim)++;
        expect(TK_RBRACKET);
    }
    return total;
}

static void parse_enum_specifier(void)
{
    int64_t next_value = 0;
    if (tok == TK_IDENT && !strcmp(tok_ident, "enum"))
        lex_next();
    if (tok == TK_IDENT)
        lex_next(); /* optional enum tag */
    if (!eat(TK_LBRACE))
        return;
    while (tok != TK_RBRACE && tok != TK_EOF) {
        char name[MAX_IDENT];
        int64_t value;
        if (tok != TK_IDENT)
            die("Enum sabit adı bekleniyor");
        strncpy(name, tok_ident, MAX_IDENT - 1);
        name[MAX_IDENT - 1] = '\0';
        lex_next();
        if (eat(TK_EQ))
            value = parse_const_expr();
        else
            value = next_value;
        enum_add(name, value);
        next_value = value + 1;
        if (!eat(TK_COMMA))
            break;
    }
    expect(TK_RBRACE);
}

static void parse_struct_body(const char *tag, int is_union)
{
    char generated[MAX_IDENT];
    StructDef *s;
    int offset = 0;

    if (tag && tag[0]) {
        strncpy(generated, tag, MAX_IDENT - 1);
        generated[MAX_IDENT - 1] = '\0';
    } else {
        snprintf(generated, sizeof(generated), "__anon_struct_%d", nstructs);
    }
    s = struct_find(generated);
    if (!s) s = struct_add(generated);
    s->is_union = is_union;
    expect(TK_LBRACE);
    while (tok != TK_RBRACE && tok != TK_EOF) {
        int field_words;
        int field_ptr;
        int field_struct;
        char field_struct_name[MAX_IDENT];
        char fname[MAX_IDENT];
        field_ptr = parse_type_and_ptr();
        field_words = current_type_words;
        field_struct = current_type_is_struct;
        strncpy(field_struct_name, current_type, MAX_IDENT - 1);
        field_struct_name[MAX_IDENT - 1] = '\0';
        /*
         * Anonymous struct/union member:
         *     struct { int tag; union { ... }; };
         * Promote its fields into the containing layout so c->tag and
         * c->member both resolve through the same base object.
         */
        if (tok == TK_SEMI && field_struct && !field_ptr) {
            StructDef *nested = struct_find(field_struct_name);
            int k;
            if (!nested)
                die("Anonim struct/union layout bulunamadı");
            for (k = 0; k < nested->nfields; k++) {
                if (s->nfields >= MAX_FIELDS)
                    die("Struct alan tablosu dolu");
                s->fields[s->nfields] = nested->fields[k];
                s->fields[s->nfields].offset += offset;
                s->nfields++;
            }
            if (!is_union)
                offset += nested->words;
            lex_next();
            continue;
        }
        /*
         * A function pointer field is one word.  Its parameter list is
         * skipped because callbacks are not yet callable in this backend.
         */
        if (tok == TK_LPAREN) {
            expect(TK_LPAREN);
            expect(TK_STAR);
            if (tok != TK_IDENT) die("Fonksiyon pointer alan adı bekleniyor");
            strncpy(fname, tok_ident, MAX_IDENT - 1);
            fname[MAX_IDENT - 1] = '\0';
            lex_next();
            expect(TK_RPAREN);
            if (tok == TK_LPAREN) {
                int depth = 0;
                do {
                    if (tok == TK_LPAREN) depth++;
                    else if (tok == TK_RPAREN) depth--;
                    lex_next();
                } while (depth > 0 && tok != TK_EOF);
            }
            field_words = 1;
            if (s->nfields >= MAX_FIELDS)
                die("Struct alan tablosu dolu");
            strncpy(s->fields[s->nfields].name, fname, MAX_IDENT - 1);
            s->fields[s->nfields].name[MAX_IDENT - 1] = '\0';
            s->fields[s->nfields].offset = offset++;
            s->fields[s->nfields].object_words = 1;
            s->fields[s->nfields].is_pointer = 1;
            s->fields[s->nfields].is_struct = 0;
            s->fields[s->nfields].struct_name[0] = '\0';
            s->nfields++;
            expect(TK_SEMI);
            continue;
        }
        for (;;) {
            int words = field_ptr ? 1 : field_words;
            if (tok != TK_IDENT)
                die("Struct alan adı bekleniyor");
            strncpy(fname, tok_ident, MAX_IDENT - 1);
            fname[MAX_IDENT - 1] = '\0';
            lex_next();
            if (eat(TK_LBRACKET)) {
                int bound = parse_array_bound(0);
                words *= bound;
                expect(TK_RBRACKET);
            }
            if (s->nfields >= MAX_FIELDS)
                die("Struct alan tablosu dolu");
            strncpy(s->fields[s->nfields].name, fname, MAX_IDENT - 1);
            s->fields[s->nfields].name[MAX_IDENT - 1] = '\0';
            s->fields[s->nfields].offset = offset;
            s->fields[s->nfields].object_words =
                field_ptr ? (field_words > 0 ? field_words : 1) :
                            (words > 0 ? words : 1);
            s->fields[s->nfields].is_pointer = field_ptr;
            s->fields[s->nfields].is_struct = field_struct;
            strncpy(s->fields[s->nfields].struct_name, field_struct_name,
                    MAX_IDENT - 1);
            s->fields[s->nfields].struct_name[MAX_IDENT - 1] = '\0';
            s->nfields++;
            if (!is_union)
                offset += words > 0 ? words : 1;
            if (!eat(TK_COMMA)) break;
        }
        expect(TK_SEMI);
    }
    expect(TK_RBRACE);
    if (is_union) {
        int i;
        int max_words = 1;
        for (i = 0; i < s->nfields; i++)
            if (s->fields[i].object_words > max_words)
                max_words = s->fields[i].object_words;
        s->words = max_words;
    } else {
        s->words = offset > 0 ? offset : 1;
    }
}

static void parse_struct_specifier(int is_union)
{
    char tag[MAX_IDENT] = "";
    char anonymous_name[MAX_IDENT] = "";
    StructDef *s;

    expect(TK_IDENT); /* struct/union */
    if (tok == TK_IDENT) {
        strncpy(tag, tok_ident, MAX_IDENT - 1);
        tag[MAX_IDENT - 1] = '\0';
        lex_next();
    }
    if (tok == TK_LBRACE) {
        if (!tag[0])
            snprintf(anonymous_name, sizeof(anonymous_name),
                     "__anon_struct_%d", nstructs);
        parse_struct_body(tag, is_union);
    }
    else if (!tag[0] || !struct_find(tag)) {
        /* A named forward declaration is completed by a later definition. */
        if (tag[0]) {
            s = struct_add(tag);
            s->words = 1;
        } else {
            die("Tanımsız struct türü");
        }
    }

    if (!tag[0]) {
        /*
         * parse_struct_body may have parsed nested anonymous structs after
         * creating this type.  Keep the name captured before descending
         * instead of using nstructs - 1, which would select the last nested
         * member type.
         */
        strncpy(tag, anonymous_name, MAX_IDENT - 1);
        tag[MAX_IDENT - 1] = '\0';
    }
    s = struct_find(tag);
    if (!s) die("Struct layout bulunamadı");
    strncpy(current_type, s->name, MAX_IDENT - 1);
    current_type[MAX_IDENT - 1] = '\0';
    current_type_is_struct = 1;
    current_type_is_union = s->is_union;
    current_type_words = s->words > 0 ? s->words : 1;
}

static int parse_type_and_ptr(void) {
    int is_ptr = 0;
    int saw_base = 0;

    current_type[0] = '\0';
    current_type_is_struct = 0;
    current_type_is_union = 0;
    current_type_is_char = 0;
    current_type_words = 1;
    while (is_type_qualifier())
        lex_next();

    if (is_type_name()) {
        saw_base = 1;
        if (tok == TK_IDENT && !strcmp(tok_ident, "struct")) {
            parse_struct_specifier(0);
        } else if (tok == TK_IDENT && !strcmp(tok_ident, "union")) {
            parse_struct_specifier(1);
        } else if (tok == TK_IDENT && !strcmp(tok_ident, "enum")) {
            parse_enum_specifier();
            current_type_words = 1;
        } else {
            if (tok == TK_IDENT) {
                TypeDef *td = typedef_find(tok_ident);
                if (td) {
                    strncpy(current_type, td->struct_name, MAX_IDENT - 1);
                    current_type[MAX_IDENT - 1] = '\0';
                    current_type_is_struct = td->is_struct;
                    current_type_words = td->words > 0 ? td->words : 1;
                }
                lex_next();
            } else {
                /* Built-in type tokens are real tokens, not identifiers. */
                current_type_is_char = tok == TK_CHAR;
                lex_next();
            }
        }
        /* Scalar C values use the 64-bit Oxalyn register representation. */
        while (tok == TK_IDENT &&
               (!strcmp(tok_ident, "int") ||
                !strcmp(tok_ident, "char") ||
                !strcmp(tok_ident, "long") ||
                !strcmp(tok_ident, "short") ||
                !strcmp(tok_ident, "signed") ||
                !strcmp(tok_ident, "unsigned"))) {
            lex_next();
        }
        while (tok == TK_INT || tok == TK_CHAR)
            lex_next();
    }
    if (!saw_base)
        die("Tür bekleniyor");
    while (eat(TK_STAR)) is_ptr++;
    while (is_type_qualifier())
        lex_next();
    if (is_ptr) {
        current_type_words = 1;
        current_type_is_union = 0;
        current_type_is_char = 0;
    }
    return is_ptr;
}

/*
 * Global initializers are evaluated before code generation.  This small
 * token-level evaluator deliberately accepts only integer constant
 * expressions and casts; it is enough for MMIO addresses such as
 * (volatile uint64_t *)(uintptr_t)(BASE * 8u).
 */
static int64_t parse_const_primary(void)
{
    int64_t value;
    if (eat(TK_SIZEOF)) {
        int type_ndim;
        int type_dims[MAX_ARRAY_DIMS] = { 0 };
        int type_words;
        int type_count;
        if (!eat(TK_LPAREN))
            die("sizeof( bekleniyordu");
        if (!is_type_name() && !is_type_qualifier())
            die("Global sizeof yalnızca tür alabilir");
        parse_type_and_ptr();
        type_words = current_type_words > 0 ? current_type_words : 1;
        type_count = parse_array_dimensions(0, &type_ndim, type_dims);
        expect(TK_RPAREN);
        return (int64_t)type_words * type_count;
    }
    if (tok == TK_NUM || tok == TK_CHARCONST) {
        value = tok_num;
        lex_next();
        return value;
    }
    if (tok == TK_IDENT) {
        if (macro_value(tok_ident, &value) ||
            enum_value(tok_ident, &value)) {
            lex_next();
            return value;
        }
        /*
         * Headers sometimes leave target-only address macros unresolved by
         * this small preprocessor.  Global initializers must still remain
         * deterministic, so an unknown identifier has value zero here.
         */
        lex_next();
        return 0;
    }
    if (eat(TK_LPAREN)) {
        if (is_type_name() || is_type_qualifier()) {
            parse_type_and_ptr();
            expect(TK_RPAREN);
            return parse_const_primary();
        }
        value = parse_const_expr();
        expect(TK_RPAREN);
        return value;
    }
    die("Global başlatıcı sabit ifade olmalı");
    return 0;
}

static int64_t parse_const_unary(void)
{
    if (eat(TK_PLUS)) return parse_const_unary();
    if (eat(TK_MINUS)) return -parse_const_unary();
    if (eat(TK_TILDE)) return ~parse_const_unary();
    return parse_const_primary();
}

static int64_t parse_const_mul(void)
{
    int64_t value = parse_const_unary();
    while (tok == TK_STAR || tok == TK_SLASH || tok == TK_PERCENT) {
        TKind op = tok;
        int64_t rhs;
        lex_next();
        rhs = parse_const_unary();
        if (op == TK_STAR) value *= rhs;
        else if (rhs == 0) die("Global sabit ifadede sıfıra bölme");
        else if (op == TK_SLASH) value /= rhs;
        else value %= rhs;
    }
    return value;
}

static int64_t parse_const_add(void)
{
    int64_t value = parse_const_mul();
    while (tok == TK_PLUS || tok == TK_MINUS) {
        TKind op = tok;
        int64_t rhs;
        lex_next();
        rhs = parse_const_mul();
        value = op == TK_PLUS ? value + rhs : value - rhs;
    }
    return value;
}

static int64_t parse_const_expr(void)
{
    int64_t value = parse_const_add();
    while (tok == TK_SHL || tok == TK_SHR ||
           tok == TK_AMP || tok == TK_CARET || tok == TK_PIPE) {
        TKind op = tok;
        int64_t rhs;
        lex_next();
        rhs = parse_const_add();
        if (op == TK_SHL) value <<= rhs;
        else if (op == TK_SHR) value >>= rhs;
        else if (op == TK_AMP) value &= rhs;
        else if (op == TK_CARET) value ^= rhs;
        else value |= rhs;
    }
    return value;
}

static void parse_typedef_decl(void)
{
    char alias[MAX_IDENT];
    int ptr;

    /* typedef is kept as an identifier by the lexer. */
    if (tok != TK_IDENT || strcmp(tok_ident, "typedef") != 0)
        die("typedef bekleniyordu");
    lex_next();

    if (tok == TK_IDENT && !strcmp(tok_ident, "struct")) {
        parse_struct_specifier(0);
        if (tok != TK_IDENT)
            die("typedef struct adı bekleniyor");
        strncpy(alias, tok_ident, MAX_IDENT - 1);
        alias[MAX_IDENT - 1] = '\0';
        lex_next();
        typedef_add(alias, current_type_words, 1, current_type);
        expect(TK_SEMI);
        return;
    }
    if (tok == TK_IDENT && !strcmp(tok_ident, "union")) {
        parse_struct_specifier(1);
        if (tok != TK_IDENT)
            die("typedef union adı bekleniyor");
        strncpy(alias, tok_ident, MAX_IDENT - 1);
        alias[MAX_IDENT - 1] = '\0';
        lex_next();
        typedef_add(alias, current_type_words, 1, current_type);
        expect(TK_SEMI);
        return;
    }
    if (tok == TK_IDENT && !strcmp(tok_ident, "enum")) {
        parse_enum_specifier();
        if (tok != TK_IDENT)
            die("typedef enum adı bekleniyor");
        strncpy(alias, tok_ident, MAX_IDENT - 1);
        alias[MAX_IDENT - 1] = '\0';
        lex_next();
        typedef_add(alias, 1, 0, NULL);
        expect(TK_SEMI);
        return;
    }

    ptr = parse_type_and_ptr();
    if (tok != TK_IDENT)
        die("typedef adı bekleniyor");
    strncpy(alias, tok_ident, MAX_IDENT - 1);
    alias[MAX_IDENT - 1] = '\0';
    lex_next();
    typedef_add(alias, ptr ? 1 : current_type_words,
                ptr ? 0 : current_type_is_struct,
                ptr ? NULL : current_type);
    expect(TK_SEMI);
}

/* ── Lvalue desteği ───────────────────────────────────── */
/* Bir değişkenin adresini yükle: reg = &var */
static int emit_addr_of(const char *name) {
    Sym *s = sym_find(name);
    int r;
    if (!s) die("Tanımsız değişken: %s", name);
    r = alloc_reg();
    if (s->is_global) {
        /* Global labels are word addresses in the Oxalyn image. */
        emit("    LI   R%d, %s", r, name);
    } else {
        emit("    LI   R%d, %d", REG_SCRATCH, s->fp_offset);
        emit("    ADD  R%d, R%d, R%d", r, REG_FP, REG_SCRATCH);
    }
    return r;
}

static void expr_meta_clear(void)
{
    memset(&expr_meta, 0, sizeof(expr_meta));
}

static void expr_meta_struct(const char *name, int is_pointer,
                             int object_words, int is_lvalue, int addr_reg)
{
    expr_meta_clear();
    expr_meta.is_lvalue = is_lvalue;
    expr_meta.addr_reg = addr_reg;
    expr_meta.is_pointer = is_pointer;
    expr_meta.object_words = object_words > 0 ? object_words : 1;
    if (name) {
        strncpy(expr_meta.struct_name, name, MAX_IDENT - 1);
        expr_meta.struct_name[MAX_IDENT - 1] = '\0';
    }
}

static void expr_meta_set_dims(int ndim, const int *dims)
{
    int i;
    expr_meta.ndim = ndim > 0 ? ndim : 0;
    for (i = 0; i < MAX_ARRAY_DIMS; i++)
        expr_meta.dims[i] = i < expr_meta.ndim ? dims[i] : 0;
}

/* Convert an lvalue used as an intermediate value back to one register.
 * Lvalue expressions retain their address register for assignments; keeping
 * that address alive through a long boolean expression exhausts the
 * temporary register pool. */
static int expr_as_value(int r)
{
    if (expr_meta.is_lvalue && expr_meta.addr_reg != r) {
        emit("    ADD  R%d, R%d, R0", expr_meta.addr_reg, r);
        free_reg();
        r = expr_meta.addr_reg;
    }
    expr_meta_clear();
    return r;
}

static int emit_load_addr(int addr_reg)
{
    int r = alloc_reg();
    emit("    LOAD R%d, R%d, 0", r, addr_reg);
    return r;
}

static void emit_store_addr(int addr_reg, int value_reg)
{
    emit("    STORE R%d, R%d, 0", value_reg, addr_reg);
}

/* Değişkeni yükle: reg = var */
static int emit_load_var(const char *name) {
    Sym *s = sym_find(name);
    int r;
    if (!s) die("Tanımsız değişken: %s", name);
    if (s->is_global && (s->ndim > 0 || s->array_len > 1))
        return emit_addr_of(name); /* C array-to-pointer decay */
    r = alloc_reg();
    if (s->is_global)
        emit("    LOAD R%d, R0, %s", r, name);
    else
        emit("    LOAD R%d, R%d, %d", r, REG_FP, s->fp_offset);
    return r;
}

/* Değişkene yaz */
static void emit_store_var(const char *name, int val_r) {
    Sym *s = sym_find(name);
    if (!s) die("Tanımsız değişken: %s", name);
    if (s->is_global)
        emit("    STORE R%d, R0, %s", val_r, name);
    else
        emit("    STORE R%d, R%d, %d", val_r, REG_FP, s->fp_offset);
}

/* ── İfade ayrıştırıcı (forward declarations) ────────── */
static int parse_expr(void);
static int parse_cond(void);

/*
 * Binary expressions keep their result in the left operand register.
 * The old implementation allocated a third register, then returned a
 * different register after freeing it; the emitted code and the parser's
 * register value consequently diverged (e.g. "a + b" returned a).
 */
static int emit_binary_in_left(int left, int right, const char *mnemonic)
{
    emit("    %s  R%d, R%d, R%d", mnemonic, left, left, right);
    free_reg(); /* right is the newest temporary */
    expr_meta_clear();
    return left;
}

static void parse_compound_init_values(int base_reg, int capacity, int *index,
                                       int base_top)
{
    if (eat(TK_LBRACE)) {
        while (tok != TK_RBRACE && tok != TK_EOF) {
            parse_compound_init_values(base_reg, capacity, index, base_top);
            if (!eat(TK_COMMA))
                break;
        }
        expect(TK_RBRACE);
        return;
    }
    if (*index >= capacity)
        die("Compound literal nesnesinin boyutu aşıldı");
    {
        int value_reg;
        /*
         * Function names decay directly to their code address.  Treating
         * them as ordinary variables would LOAD the first instruction at the
         * address instead, which breaks function-pointer struct fields.
         */
        if (tok == TK_IDENT) {
            Sym *sym = sym_find(tok_ident);
            if (sym && sym->is_func) {
                char name[MAX_IDENT];
                strncpy(name, tok_ident, MAX_IDENT - 1);
                name[MAX_IDENT - 1] = '\0';
                lex_next();
                value_reg = emit_addr_of(name);
            } else {
                value_reg = parse_expr();
            }
        } else {
            value_reg = parse_expr();
        }
        emit("    STORE R%d, R%d, %d", value_reg, base_reg, *index);
        free_regs_to(base_top);
    }
    (*index)++;
}

static int parse_compound_literal(const char *struct_name, int object_words)
{
    int base_top = reg_top;
    int base_reg = alloc_reg();
    int i;
    int index = 0;

    /* Compound literals have automatic storage for the current expression. */
    emit("    LI   R%d, -%d", REG_SCRATCH, object_words);
    emit("    ADD  R%d, R%d, R%d", REG_SP, REG_SP, REG_SCRATCH);
    emit("    ADD  R%d, R%d, R0", base_reg, REG_SP);
    for (i = 0; i < object_words; i++)
        emit("    STORE R0, R%d, %d", base_reg, i);
    parse_compound_init_values(base_reg, object_words, &index, base_top);
    expr_meta_struct(struct_name, 0, object_words, 1, base_reg);
    return base_reg;
}

static void emit_copy_object(int dst_reg, int src_reg, int object_words)
{
    int value_reg = alloc_reg();
    int i;

    for (i = 0; i < object_words; i++) {
        emit("    LI   R%d, %d", REG_SCRATCH, i);
        emit("    ADD  R%d, R%d, R%d", REG_SCRATCH, dst_reg, REG_SCRATCH);
        emit("    LOAD R%d, R%d, 0", value_reg, REG_SCRATCH);
        emit("    LI   R%d, %d", REG_SCRATCH, i);
        emit("    ADD  R%d, R%d, R%d", REG_SCRATCH, src_reg, REG_SCRATCH);
        emit("    STORE R%d, R%d, 0", value_reg, REG_SCRATCH);
    }
    free_reg();
}

/* ── Birincil ifade ───────────────────────────────────── */
static int parse_unary(void);

static int parse_primary(void)
{
    int r;
    expr_meta_clear();
    /*
     * C cast.  The Oxalyn backend represents all scalar and pointer values
     * as words, so the type itself does not change the generated value.
     * Keeping the parser here is enough for MMIO expressions such as
     * (volatile uint64_t *)(uintptr_t)addr.
     */
    if (tok == TK_LPAREN) {
        int saved_src = src_pos;
        int saved_line = tok_line;
        TKind saved_tok = tok;
        char saved_ident[MAX_IDENT];
        strncpy(saved_ident, tok_ident, MAX_IDENT - 1);
        saved_ident[MAX_IDENT - 1] = '\0';
        lex_next();
        if (is_type_name() || is_type_qualifier()) {
            parse_type_and_ptr();
            if (eat(TK_RPAREN)) {
                if (tok == TK_LBRACE && current_type_is_struct &&
                    current_type_words > 1)
                    return parse_compound_literal(current_type,
                                                  current_type_words);
                return parse_unary();
            }
        }
        src_pos = saved_src;
        tok_line = saved_line;
        tok = saved_tok;
        strncpy(tok_ident, saved_ident, MAX_IDENT - 1);
        tok_ident[MAX_IDENT - 1] = '\0';
    }
    if (tok == TK_NUM || tok == TK_CHARCONST) {
        long n = tok_num;
        lex_next();
        r = alloc_reg();
        emit("    LI   R%d, %ld", r, n);
        return r;
    }
    if (tok == TK_STRING) {
        const char *label = string_add(tok_string, tok_string_len);
        lex_next();
        r = alloc_reg();
        emit("    LI   R%d, %s", r, label);
        return r;
    }
    if (tok == TK_IDENT && !strcmp(tok_ident, "NULL")) {
        lex_next();
        r = alloc_reg();
        emit("    LI   R%d, 0", r);
        return r;
    }
    if (tok == TK_IDENT) {
        int64_t enum_num;
        if (enum_value(tok_ident, &enum_num)) {
            lex_next();
            r = alloc_reg();
            emit("    LI   R%d, %lld", r, (long long)enum_num);
            return r;
        }
    }
    if (tok == TK_IDENT) {
        char name[MAX_IDENT];
        Sym *s;
        strncpy(name, tok_ident, MAX_IDENT-1);
        lex_next();
        if (tok == TK_LPAREN) {
            if (!strcmp(name, "va_arg")) {
                int saved_top = reg_top;
                int ignored = 0;
                lex_next();
                if (tok != TK_RPAREN) {
                    ignored = parse_expr();
                    expect(TK_COMMA);
                    parse_type_and_ptr();
                    while (tok == TK_LBRACKET)
                        parse_array_dimensions(1, &(int){ 0 }, (int[MAX_ARRAY_DIMS]){ 0 });
                }
                expect(TK_RPAREN);
                (void)ignored;
                free_regs_to(saved_top);
                r = alloc_reg();
                emit("    LI   R%d, 0 ; va_arg compatibility value", r);
                expr_meta_clear();
                return r;
            }
            /* Fonksiyon çağrısı */
            int args[MAX_CALL_ARGS], nargs = 0;
            int saved_reg_top = reg_top;
            lex_next();
            if (tok != TK_RPAREN) {
                do {
                    int ar = parse_expr();
                    if (nargs < MAX_CALL_ARGS) args[nargs++] = ar;
                    else die("Çok fazla çağrı argümanı (max %d)", MAX_CALL_ARGS);
                } while (eat(TK_COMMA));
            }
            expect(TK_RPAREN);
            /* Argümanları R1-R4'e yükle */
            { int i;
              for (i = 0; i < nargs && i < MAX_ARG_REGS; i++)
                  emit("    ADD  R%d, R%d, R0", i+1, args[i]);
            }
            /* Aktif geçicileri yığına kaydet */
            if (saved_reg_top > 0) {
                int i;
                emit("    LI   R%d, -%d", REG_SCRATCH, saved_reg_top);
                emit("    ADD  R%d, R%d, R%d", REG_SP, REG_SP, REG_SCRATCH);
                for (i = 0; i < saved_reg_top; i++)
                    emit("    STORE R%d, R%d, %d", TEMP_BASE+i, REG_SP, i);
            }
            /*
             * CALL/RET use the simulator's implicit R7 stack and therefore
             * cannot preserve a C return value in R7. Use explicit JALR:
             * R31 is the link register and R7 remains the C result register.
             */
            emit("    LI   R28, %s", name);
            emit("    JALR R31, R28, 0");
            /* Geçicileri geri yükle */
            if (saved_reg_top > 0) {
                int i;
                for (i = 0; i < saved_reg_top; i++)
                    emit("    LOAD R%d, R%d, %d", TEMP_BASE+i, REG_SP, i);
                emit("    LI   R%d, %d", REG_SCRATCH, saved_reg_top);
                emit("    ADD  R%d, R%d, R%d", REG_SP, REG_SP, REG_SCRATCH);
            }
            free_regs_to(saved_reg_top);
            r = alloc_reg();
            emit("    ADD  R%d, R%d, R0  ; sonuç = R7", r, REG_RET);
            expr_meta_clear();
            return r;
        }
        s = sym_find(name);
        if (!s) die("Tanımsız değişken: %s", name);
        {
            int addr = emit_addr_of(name);
            int is_array = s->ndim > 0 || s->array_len > 1;
            int is_struct = s->struct_name[0] != '\0';
            /*
             * Struct objects and arrays evaluate to their base address here;
             * postfix parsing turns that base into a field/element value.
             */
            if ((is_struct && !s->is_pointer) || is_array) {
                expr_meta_struct(s->struct_name, s->is_pointer,
                                 s->object_words, is_array ? 0 : 1, addr);
                if (is_array)
                    expr_meta_set_dims(s->ndim, s->dims);
                r = addr;
            } else {
                r = emit_load_addr(addr);
                expr_meta_struct(s->struct_name, s->is_pointer,
                                 s->object_words, 1, addr);
            }
        }
        if (tok == TK_PLUSPLUS || tok == TK_MINUSMINUS) {
            int one = alloc_reg();
            int updated = alloc_reg();
            TKind op = tok;
            lex_next();
            emit("    LI   R%d, 1", one);
            emit("    %s  R%d, R%d, R%d",
                 op == TK_PLUSPLUS ? "ADD" : "SUB", updated, r, one);
            if (expr_meta.is_lvalue)
                emit_store_addr(expr_meta.addr_reg, updated);
            else
                emit_store_var(name, updated);
            free_reg();
            free_reg();
            /* Postfix ifade eski değeri döndürür. */
        }
        return r;
    }
    if (eat(TK_LPAREN)) {
        if (is_type_name() || is_type_qualifier()) {
            int cast_ptr = parse_type_and_ptr();
            (void)cast_ptr;
            expect(TK_RPAREN);
            if (eat(TK_LBRACE)) {
                int depth = 1;
                while (depth > 0 && tok != TK_EOF) {
                    if (tok == TK_LBRACE) depth++;
                    else if (tok == TK_RBRACE) depth--;
                    lex_next();
                }
                r = alloc_reg();
                emit("    LI   R%d, 0", r);
                expr_meta_clear();
                return r;
            }
            /* Ordinary C cast: the minimal backend keeps the value unchanged. */
            return parse_unary();
        }
        r = parse_expr();
        expect(TK_RPAREN);
        return r;
    }
    die("Birincil ifade bekleniyor");
    return 0;
}

/* ── Postfix ── */
static int parse_postfix(void)
{
    int r = parse_primary();
    for (;;) {
        if (tok == TK_LBRACKET) {
            /* a[i] → *(a+i) */
            int idx;
            ExprMeta base = expr_meta;
            lex_next();
            idx = parse_expr();
            expect(TK_RBRACKET);
            if (base.ndim > 0 || base.object_words > 1) {
                int stride = base.object_words > 0 ? base.object_words : 1;
                int i;
                for (i = 1; i < base.ndim; i++)
                    stride *= base.dims[i];
                emit("    LI   R%d, %d", REG_SCRATCH, stride);
                emit("    MUL  R%d, R%d, R%d", idx, idx, REG_SCRATCH);
            }
            emit("    ADD  R%d, R%d, R%d", r, r, idx);
            free_reg(); /* index */
            if (base.ndim > 1) {
                int next_dims[MAX_ARRAY_DIMS] = { 0 };
                int i;
                for (i = 1; i < base.ndim; i++)
                    next_dims[i - 1] = base.dims[i];
                expr_meta_struct(base.struct_name, 0, base.object_words, 1, r);
                expr_meta_set_dims(base.ndim - 1, next_dims);
                continue;
            }
            if (base.struct_name[0] && base.object_words > 1) {
                expr_meta_struct(base.struct_name, 0, base.object_words, 1, r);
                continue;
            }
            if (base.ndim == 1 && base.struct_name[0] &&
                base.object_words > 1) {
                expr_meta_struct(base.struct_name, 0, base.object_words, 1, r);
                continue;
            }
            if (base.ndim == 1 && base.is_pointer) {
                int res = emit_load_addr(r);
                expr_meta_struct("", 1, 1, 1, r);
                r = res;
                continue;
            }
            {
                int res = emit_load_addr(r);
                expr_meta_struct("", 0, 1, 1, r);
                /*
                 * Keep the computed element address in expr_meta.addr_reg.
                 * The value must live in a different register so an
                 * assignment such as `a[i] = value` can evaluate its RHS
                 * without overwriting the lvalue address.
                 */
                r = res;
            }
            return r;
        }
        if (tok == TK_DOT || tok == TK_ARROW) {
            TKind access = tok;
            StructDef *st;
            Field *f;
            char field_name[MAX_IDENT];
            ExprMeta base = expr_meta;
            lex_next();
            if (tok != TK_IDENT)
                die("Struct alan adı bekleniyor");
            strncpy(field_name, tok_ident, MAX_IDENT - 1);
            field_name[MAX_IDENT - 1] = '\0';
            lex_next();
            st = struct_find(base.struct_name);
            if (!st)
                die("Struct türü bulunamadı: %s", base.struct_name);
            if (access == TK_DOT && base.is_pointer)
                die("Pointer için -> kullanılmalı");
            f = struct_field(st, field_name);
            if (!f)
                die("Struct alanı bulunamadı: %s", field_name);
            emit("    LI   R%d, %d", REG_SCRATCH, f->offset);
            emit("    ADD  R%d, R%d, R%d", r, r, REG_SCRATCH);
            if (f->is_struct && !f->is_pointer) {
                expr_meta_struct(f->struct_name, 0, f->object_words, 1, r);
                continue;
            }
            {
                int res = emit_load_addr(r);
                expr_meta_struct(f->struct_name, f->is_pointer,
                                 f->object_words, 1, r);
                /*
                 * A field expression is still an lvalue.  Do not copy the
                 * loaded value back over its address: the address must
                 * survive while parse_expr evaluates the RHS of an
                 * assignment.
                 */
                r = res;
            }
            continue;
        }
        if (tok == TK_PLUSPLUS || tok == TK_MINUSMINUS) {
            TKind op = tok;
            int one = alloc_reg();
            int updated = alloc_reg();
            lex_next();
            if (!expr_meta.is_lvalue)
                die("Sonek ++/-- yalnızca lvalue ifadelerine uygulanabilir");
            emit("    LI   R%d, 1", one);
            emit("    %s  R%d, R%d, R%d",
                 op == TK_PLUSPLUS ? "ADD" : "SUB",
                 updated, r, one);
            emit_store_addr(expr_meta.addr_reg, updated);
            free_reg();
            free_reg();
            continue;
        }
        if (tok == TK_LPAREN) {
            int args[MAX_CALL_ARGS];
            int nargs = 0;
            int saved_reg_top = reg_top;
            int i;
            lex_next();
            if (tok != TK_RPAREN) {
                do {
                    int ar = parse_expr();
                    if (nargs >= MAX_CALL_ARGS)
                        die("Çok fazla çağrı argümanı (max %d)", MAX_CALL_ARGS);
                    args[nargs++] = ar;
                } while (eat(TK_COMMA));
            }
            expect(TK_RPAREN);
            for (i = 0; i < nargs && i < MAX_ARG_REGS; i++)
                emit("    ADD  R%d, R%d, R0", i + 1, args[i]);
            emit("    JALR R31, R%d, 0", r);
            free_regs_to(saved_reg_top);
            emit("    ADD  R%d, R%d, R0", r, REG_RET);
            expr_meta_clear();
            continue;
        }
        break;
    }
    return r;
}

/* ── Tekli (unary) ── */
static int parse_unary(void)
{
    int r, r2;
    if (tok == TK_PLUSPLUS || tok == TK_MINUSMINUS) {
        TKind op = tok;
        lex_next();
        r = parse_unary();
        if (!expr_meta.is_lvalue)
            die("Önek ++/-- yalnızca lvalue ifadelerine uygulanabilir");
        emit("    LI   R%d, 1", REG_SCRATCH);
        emit("    %s  R%d, R%d, R%d",
             op == TK_PLUSPLUS ? "ADD" : "SUB",
             r, r, REG_SCRATCH);
        emit_store_addr(expr_meta.addr_reg, r);
        /* The updated value still carries the original address so an
         * enclosing dereference such as `*--ptr` can use it. */
        expr_meta.is_lvalue = 1;
        return r;
    }
    if (eat(TK_SIZEOF)) {
        int sz = 1;
        int saved_top = reg_top;

        if (!eat(TK_LPAREN))
            die("sizeof( bekleniyordu");
        if (is_type_name() || is_type_qualifier()) {
            int type_ndim;
            int type_dims[MAX_ARRAY_DIMS] = { 0 };
            int type_words;
            int type_count;

            parse_type_and_ptr();
            type_words = current_type_words > 0 ? current_type_words : 1;
            type_count = parse_array_dimensions(0, &type_ndim, type_dims);
            sz = type_words * type_count;
        } else {
            int i;
            int dummy = parse_expr();
            (void)dummy;
            sz = expr_meta.object_words > 0 ? expr_meta.object_words : 1;
            for (i = 0; i < expr_meta.ndim; i++)
                sz *= expr_meta.dims[i];
            free_regs_to(saved_top);
        }
        expect(TK_RPAREN);
        r = alloc_reg();
        emit("    LI   R%d, %d", r, sz);
        expr_meta_clear();
        return r;
    }
    if (eat(TK_MINUS)) {
        r = parse_unary();
        r = expr_as_value(r);
        emit("    SUB  R%d, R0, R%d", r, r);
        return r;
    }
    if (eat(TK_BANG)) {
        r = parse_unary();
        r = expr_as_value(r);
        emit("    CMPEQ R%d, R%d, R0", r, r);
        return r;
    }
    if (eat(TK_TILDE)) {
        r = parse_unary();
        r = expr_as_value(r);
        emit("    LI   R%d, -1", REG_SCRATCH);
        emit("    XOR  R%d, R%d, R%d", r, r, REG_SCRATCH);
        return r;
    }
    if (eat(TK_STAR)) {
        /* Pointer dereference */
        r = parse_unary();
        r = expr_as_value(r);
        r2 = alloc_reg();
        emit("    LOAD R%d, R%d, 0", r2, r);
        /* The dereference result is an lvalue at the pointer address. */
        expr_meta_struct("", 0, 1, 1, r);
        return r2;
    }
    if (eat(TK_AMP)) {
        /*
         * Address-of accepts any lvalue produced by the postfix parser:
         * identifiers, array elements, struct fields and dereferenced
         * pointers.  For scalar lvalues parse_postfix also loads a value;
         * release that value while keeping the address register alive.
         */
        int value = parse_postfix();
        if (!expr_meta.is_lvalue)
            die("& yalnızca lvalue ifadelerine uygulanabilir");
        if (value != expr_meta.addr_reg)
            free_reg();
        return expr_meta.addr_reg;
    }
    return parse_postfix();
}

/* ── İkili operatör yardımcısı ── */
static int binop(int ra, int rb, const char *mnem) {
    int rc = alloc_reg();
    emit("    %s R%d, R%d, R%d", mnem, rc, ra, rb);
    free_reg(); free_reg();
    return alloc_reg() - 1;
}

/* ── Çarpma düzeyi ── */
static int parse_mul(void) {
    int r = parse_unary();
    for (;;) {
        if (eat(TK_STAR)) {
            r = expr_as_value(r);
            int r2 = parse_unary();
            r = emit_binary_in_left(r, r2, "MUL");
        } else if (eat(TK_SLASH)) {
            r = expr_as_value(r);
            int r2 = parse_unary();
            r = emit_binary_in_left(r, r2, "DIV");
        } else if (eat(TK_PERCENT)) {
            r = expr_as_value(r);
            int r2 = parse_unary();
            int qt = alloc_reg();
            emit("    DIV  R%d, R%d, R%d", qt, r, r2);
            emit("    MUL  R%d, R%d, R%d", qt, qt, r2);
            emit("    SUB  R%d, R%d, R%d", r, r, qt);
            free_reg(); /* quotient temporary */
            free_reg(); /* right operand */
        } else break;
    }
    return r;
}

/* ── Toplama düzeyi ── */
static int parse_add(void) {
    int r = parse_mul();
    for (;;) {
        if (eat(TK_PLUS))  { r=expr_as_value(r); int r2=parse_mul(); r=emit_binary_in_left(r,r2,"ADD"); }
        else if (eat(TK_MINUS)) { r=expr_as_value(r); int r2=parse_mul(); r=emit_binary_in_left(r,r2,"SUB"); }
        else break;
    }
    return r;
}

/* ── Bit kaydırma ── */
static int parse_shift(void) {
    int r = parse_add();
    for (;;) {
        if (eat(TK_SHL)) { r=expr_as_value(r); int r2=parse_add(); r=emit_binary_in_left(r,r2,"SHL"); }
        else if (eat(TK_SHR)) { r=expr_as_value(r); int r2=parse_add(); r=emit_binary_in_left(r,r2,"SHR"); }
        else break;
    }
    return r;
}

/* ── Karşılaştırma ── */
static int parse_cmp(void) {
    int r = parse_shift();
    for (;;) {
        if (eat(TK_EQEQ)) { r=expr_as_value(r); int r2=parse_shift(); r=emit_binary_in_left(r,r2,"CMPEQ"); }
        else if (eat(TK_NEQ)) { r=expr_as_value(r); int r2=parse_shift(); r=emit_binary_in_left(r,r2,"CMPNE"); }
        else if (eat(TK_LT)) { r=expr_as_value(r); int r2=parse_shift(); r=emit_binary_in_left(r,r2,"CMPLT"); }
        else if (eat(TK_LEQ)) { r=expr_as_value(r); int r2=parse_shift(); r=emit_binary_in_left(r,r2,"CMPLE"); }
        else if (eat(TK_GT)) { r=expr_as_value(r); int r2=parse_shift(); emit("    CMPLT  R%d, R%d, R%d",r,r2,r); free_reg(); expr_meta_clear(); }
        else if (eat(TK_GEQ)) { r=expr_as_value(r); int r2=parse_shift(); emit("    CMPLE  R%d, R%d, R%d",r,r2,r); free_reg(); expr_meta_clear(); }
        else break;
    }
    return r;
}

/* ── Bit AND/XOR/OR ── */
static int parse_bitand(void) { int r=parse_cmp(); for(;;){if(eat(TK_AMP)){r=expr_as_value(r);int r2=parse_cmp();r=emit_binary_in_left(r,r2,"AND");}else break;} return r; }
static int parse_bitxor(void) { int r=parse_bitand(); for(;;){if(eat(TK_CARET)){r=expr_as_value(r);int r2=parse_bitand();r=emit_binary_in_left(r,r2,"XOR");}else break;} return r; }
static int parse_bitor(void)  { int r=parse_bitxor(); for(;;){if(eat(TK_PIPE)){r=expr_as_value(r);int r2=parse_bitxor();r=emit_binary_in_left(r,r2,"OR");}else break;} return r; }

/* ── Mantıksal AND/OR ── */
static int parse_land(void) {
    int r = parse_bitor();
    while (eat(TK_ANDAND)) {
        r = expr_as_value(r);
        int r2 = parse_bitor();
        /* rc = (r != 0) && (r2 != 0) */
        emit("    CMPNE R%d, R%d, R0", r, r);
        emit("    CMPNE R%d, R%d, R0", r2, r2);
        emit("    AND   R%d, R%d, R%d", r, r, r2);
        free_reg();
        expr_meta_clear();
    }
    return r;
}
static int parse_lor(void) {
    int r = parse_land();
    while (eat(TK_OROR)) {
        r = expr_as_value(r);
        int r2 = parse_land();
        emit("    OR   R%d, R%d, R%d", r, r, r2);
        emit("    CMPNE R%d, R%d, R0", r, r);
        free_reg();
        expr_meta_clear();
    }
    return r;
}

/* ── Koşullu ifade ── */
static int parse_cond(void)
{
    int cond = parse_lor();
    int result;
    int false_lbl;
    int end_lbl;
    int base;
    int true_r;
    int false_r;

    if (!eat(TK_QUESTION))
        return cond;

    false_lbl = new_label();
    end_lbl = new_label();
    emit_jz_label(cond, false_lbl);
    free_reg();

    /*
     * Reserve one result register while each branch is parsed above it.
     * Both branches are emitted normally, then copied into the same result
     * register so the expression has a stable value after the join label.
     */
    base = reg_top;
    result = alloc_reg();
    true_r = parse_expr();
    emit("    ADD  R%d, R%d, R0", result, true_r);
    free_regs_to(base + 1);
    emit_jmp_label(end_lbl);

    emit_label(false_lbl);
    expect(TK_COLON);
    false_r = parse_expr();
    emit("    ADD  R%d, R%d, R0", result, false_r);
    free_regs_to(base + 1);
    emit_label(end_lbl);
    expr_meta_clear();
    return result;
}

/* ── Atama ── */
static int parse_expr(void) {
    ExprMeta lhs_meta;
    int lhs = parse_cond();

    if (tok == TK_EQ || tok == TK_PLUSEQ || tok == TK_MINUSEQ ||
        tok == TK_STAREQ || tok == TK_SLASHEQ ||
        tok == TK_ANDEQ || tok == TK_OREQ || tok == TK_XOREQ ||
        tok == TK_SHLEQ || tok == TK_SHREQ) {
        TKind op = tok;
        int rval;
        lhs_meta = expr_meta;
        lex_next();
        rval = parse_expr();
        if (op != TK_EQ) {
            int rnew = alloc_reg();
            if (op == TK_PLUSEQ)  emit("    ADD  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_MINUSEQ) emit("    SUB  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_STAREQ)  emit("    MUL  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_SLASHEQ) emit("    DIV  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_ANDEQ)   emit("    AND  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_OREQ)    emit("    OR   R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_XOREQ)   emit("    XOR  R%d, R%d, R%d", rnew, lhs, rval);
            else if (op == TK_SHLEQ)   emit("    SHL  R%d, R%d, R%d", rnew, lhs, rval);
            else                       emit("    SHR  R%d, R%d, R%d", rnew, lhs, rval);
            rval = rnew;
        }
        if (lhs_meta.is_lvalue)
            emit_store_addr(lhs_meta.addr_reg, rval);
        else
            die("Atama hedefi lvalue değil");
        expr_meta = lhs_meta;
        return rval;
    }
    return lhs;
}

/* ── Deyimler ─────────────────────────────────────────── */
static void parse_stmt(int break_lbl, int cont_lbl);

static void parse_local_init_values(int fp_off, int capacity, int *index,
                                    int base_top)
{
    if (eat(TK_LBRACE)) {
        while (tok != TK_RBRACE && tok != TK_EOF) {
            parse_local_init_values(fp_off, capacity, index, base_top);
            if (!eat(TK_COMMA))
                break;
        }
        expect(TK_RBRACE);
        return;
    }
    if (*index >= capacity)
        die("Yerel başlatıcı nesnenin boyutunu aşıyor");
    {
        int r = parse_expr();
        emit("    STORE R%d, R%d, %d", r, REG_FP, fp_off + *index);
        free_regs_to(base_top);
    }
    (*index)++;
}

static void parse_for_decl_item(int decl_ptr)
{
    char vname[MAX_IDENT];
    int array_len = 1;
    int ndim = 0;
    int dims[MAX_ARRAY_DIMS] = { 0 };
    int object_words = current_type_words > 0 ? current_type_words : 1;
    int fp_off;
    Sym *local;

    if (tok != TK_IDENT) die("for değişken adı bekleniyor");
    strncpy(vname, tok_ident, MAX_IDENT - 1);
    vname[MAX_IDENT - 1] = '\0';
    lex_next();
    array_len = parse_array_dimensions(1, &ndim, dims);
    fp_off = 2 + frame_nparams + frame_nlocals;
    frame_nlocals += object_words * array_len;
    local = sym_add_local(vname, fp_off, 0);
    sym_set_object_type(local, decl_ptr);
    local->array_len = array_len;
    local->ndim = ndim;
    memcpy(local->dims, dims, sizeof(dims));
    if (eat(TK_EQ)) {
        int init_top = reg_top;
        if (eat(TK_LBRACE)) {
            int element = 0;
            parse_local_init_values(fp_off, array_len * object_words,
                                    &element, init_top);
            expect(TK_RBRACE);
        } else {
            int r = parse_expr();
            emit("    STORE R%d, R%d, %d", r, REG_FP, fp_off);
            free_regs_to(init_top);
        }
    }
}

static void parse_for_expr_list(void)
{
    if (tok == TK_SEMI || tok == TK_RPAREN)
        return;
    do {
        parse_expr();
        free_regs_to(0);
    } while (eat(TK_COMMA));
}

static void parse_compound(int break_lbl, int cont_lbl) {
    int sym_mark_val = sym_mark();
    expect(TK_LBRACE);
    while (tok != TK_RBRACE && tok != TK_EOF)
        parse_stmt(break_lbl, cont_lbl);
    expect(TK_RBRACE);
    sym_restore(sym_mark_val);
}

static void parse_switch(int outer_break_lbl, int cont_lbl)
{
    int end_lbl = new_label();
    int r;

    expect(TK_LPAREN);
    r = parse_expr();
    free_regs_to(0);
    expect(TK_RPAREN);
    expect(TK_LBRACE);

    /*
     * The current Oxalyn backend has no dedicated switch instruction.  Keep
     * the complete case grammar and fall-through/break structure intact so
     * kernel translation remains possible; case dispatch is represented as a
     * linear sequence until the backend grows branch-table support.
     */
    emit("    ; switch value is in R%d", r);
    while (tok != TK_RBRACE && tok != TK_EOF) {
        if (eat(TK_CASE)) {
            (void)parse_const_expr();
            expect(TK_COLON);
            continue;
        }
        if (eat(TK_DEFAULT)) {
            expect(TK_COLON);
            continue;
        }
        parse_stmt(end_lbl, cont_lbl);
    }
    expect(TK_RBRACE);
    emit_label(end_lbl);
    (void)outer_break_lbl;
}

static void parse_stmt(int break_lbl, int cont_lbl)
{
    /* Every statement is a sequence point for temporary registers.  This
     * also keeps control-flow-only statements such as `continue` from
     * carrying expression temporaries into the following statement. */
    free_regs_to(0);
    if (eat(TK_SEMI))
        return;
    if (tok == TK_LBRACE) {
        parse_compound(break_lbl, cont_lbl);
        return;
    }
    if (is_decl_start()) {
        /* Yerel değişken bildirimi */
        int decl_ptr = parse_type_and_ptr();
        for (;;) {
            char vname[MAX_IDENT];
            int item_ptr = decl_ptr;
            int array_len = 1;
            int ndim = 0;
            int dims[MAX_ARRAY_DIMS] = { 0 };
            int object_words = current_type_words > 0 ? current_type_words : 1;
            int fp_off;
            Sym *local;
            if (tok != TK_IDENT) die("Değişken adı bekleniyor");
            strncpy(vname, tok_ident, MAX_IDENT - 1);
            vname[MAX_IDENT - 1] = '\0';
            lex_next();
            array_len = parse_array_dimensions(1, &ndim, dims);
            fp_off = 2 + frame_nparams + frame_nlocals;
            frame_nlocals += object_words * array_len;
            local = sym_add_local(vname, fp_off, 0);
            sym_set_object_type(local, item_ptr);
            local->array_len = array_len;
            local->ndim = ndim;
            memcpy(local->dims, dims, sizeof(dims));
            if (eat(TK_EQ)) {
                int init_top = reg_top;
                if (tok == TK_LBRACE) {
                    int element = 0;
                    parse_local_init_values(fp_off, array_len * object_words,
                                            &element, init_top);
                } else {
                    int r = parse_expr();
                    emit("    STORE R%d, R%d, %d", r, REG_FP, fp_off);
                    free_regs_to(init_top);
                }
            }
            if (!eat(TK_COMMA))
                break;
            while (eat(TK_STAR))
                item_ptr++;
        }
        expect(TK_SEMI);
        return;
    }
    if (eat(TK_RETURN)) {
        if (tok != TK_SEMI) {
            int r = parse_expr();
            /* C permits comma expressions in return statements, for example
             * `return record_fault(...), -1;`. */
            while (eat(TK_COMMA)) {
                free_regs_to(0);
                r = parse_expr();
            }
            emit("    ADD  R%d, R%d, R0", REG_RET, r);
            free_regs_to(0);
        }
        if (func_end_label >= 0) emit_jmp_label(func_end_label);
        else emit("    RET");
        expect(TK_SEMI);
        return;
    }
    if (eat(TK_IF)) {
        int else_lbl = new_label(), end_lbl = new_label();
        expect(TK_LPAREN);
        int r = parse_expr();
        expect(TK_RPAREN);
        emit_jz_label(r, else_lbl);
        free_regs_to(0);
        parse_stmt(break_lbl, cont_lbl);
        emit_jmp_label(end_lbl);
        emit_label(else_lbl);
        if (eat(TK_ELSE)) parse_stmt(break_lbl, cont_lbl);
        emit_label(end_lbl);
        return;
    }
    if (eat(TK_SWITCH)) {
        parse_switch(break_lbl, cont_lbl);
        return;
    }
    if (eat(TK_WHILE)) {
        int loop_lbl = new_label(), end_lbl = new_label();
        emit_label(loop_lbl);
        expect(TK_LPAREN);
        int r = parse_expr();
        expect(TK_RPAREN);
        emit_jz_label(r, end_lbl);
        free_regs_to(0);
        parse_stmt(end_lbl, loop_lbl);
        emit_jmp_label(loop_lbl);
        emit_label(end_lbl);
        return;
    }
    if (eat(TK_FOR)) {
        int cond_lbl = new_label(), body_lbl = new_label();
        int incr_lbl = new_label(), end_lbl  = new_label();
        int sym_m = sym_mark();
        expect(TK_LPAREN);
        /* init */
        if (is_decl_start()) {
            int decl_ptr = parse_type_and_ptr();
            parse_for_decl_item(decl_ptr);
            while (eat(TK_COMMA))
                parse_for_decl_item(decl_ptr);
            expect(TK_SEMI);
        } else if (tok != TK_SEMI) {
            parse_for_expr_list();
            expect(TK_SEMI);
        } else expect(TK_SEMI);
        /* cond */
        emit_label(cond_lbl);
        if (tok != TK_SEMI) {
            int r = parse_expr();
            emit_jz_label(r, end_lbl);
            free_regs_to(0);
        }
        emit_jmp_label(body_lbl);
        expect(TK_SEMI);
        /* incr */
        emit_label(incr_lbl);
        parse_for_expr_list();
        emit_jmp_label(cond_lbl);
        expect(TK_RPAREN);
        emit_label(body_lbl);
        parse_stmt(end_lbl, incr_lbl);
        emit_jmp_label(incr_lbl);
        emit_label(end_lbl);
        sym_restore(sym_m);
        return;
    }
    if (eat(TK_BREAK)) {
        if (break_lbl < 0) die("break döngü dışında");
        emit_jmp_label(break_lbl);
        expect(TK_SEMI);
        return;
    }
    if (eat(TK_CONTINUE)) {
        if (cont_lbl < 0) die("continue döngü dışında");
        emit_jmp_label(cont_lbl);
        expect(TK_SEMI);
        return;
    }
    if (eat(TK_GOTO)) {
        /*
         * Labels are accepted for kernel control-flow sources.  The current
         * backend has no symbolic label namespace for user labels, so keep
         * the statement as a no-op rather than inventing an invalid target.
         */
        if (tok != TK_IDENT) die("goto etiketi bekleniyor");
        lex_next();
        expect(TK_SEMI);
        return;
    }
    if (tok == TK_IDENT && peek_ch() == ':') {
        lex_next();
        expect(TK_COLON);
        if (tok != TK_RBRACE && tok != TK_EOF)
            parse_stmt(break_lbl, cont_lbl);
        return;
    }
    /* İfade deyimi */
    {
        int r = parse_expr();
        free_regs_to(0); (void)r;
        expect(TK_SEMI);
    }
}

/* ── Fonksiyon ayrıştırıcı ─────────────────────────────── */
static void parse_func(const char *fname)
{
    int i, param_count = 0;
    int param_ptrs[MAX_PARAMS] = { 0 };
    int param_ndims[MAX_PARAMS] = { 0 };
    int param_dims[MAX_PARAMS][MAX_ARRAY_DIMS] = { { 0 } };
    int param_is_struct[MAX_PARAMS] = { 0 };
    char param_struct_names[MAX_PARAMS][MAX_IDENT] = { { 0 } };
    strncpy(cur_func, fname, MAX_IDENT-1);
    frame_nparams = 0;
    frame_nlocals = 0;
    reg_top       = 0;
    func_end_label = new_label();

    /* Parametreler */
    char pnames[MAX_PARAMS][MAX_IDENT];
    expect(TK_LPAREN);
    if (tok != TK_RPAREN) {
        for (;;) {
            int param_ptr = parse_type_and_ptr();
            /*
             * In a prototype, "(void)" means no parameters.  "(void *p)"
             * is a real pointer parameter and must continue normally.
             */
            if (tok == TK_RPAREN && !param_ptr &&
                !current_type_is_struct && current_type[0] == '\0')
                break;
            if (tok == TK_LPAREN) {
                /* Function-pointer parameter: void (*entry)(void). */
                expect(TK_LPAREN);
                expect(TK_STAR);
                if (tok != TK_IDENT)
                    die("Fonksiyon pointer parametre adı bekleniyor");
                if (param_count < MAX_PARAMS) {
                    strncpy(pnames[frame_nparams], tok_ident, MAX_IDENT - 1);
                    pnames[frame_nparams][MAX_IDENT - 1] = '\0';
                    param_ptrs[frame_nparams] = 1;
                    frame_nparams++;
                }
                param_count++;
                lex_next();
                expect(TK_RPAREN);
                if (tok == TK_LPAREN) {
                    int depth = 0;
                    do {
                        if (tok == TK_LPAREN) depth++;
                        else if (tok == TK_RPAREN) depth--;
                        lex_next();
                    } while (depth > 0 && tok != TK_EOF);
                }
            } else {
                int param_slot = frame_nparams;
                if (tok != TK_IDENT) die("Parametre adı bekleniyor");
                if (param_count < MAX_PARAMS) {
                    strncpy(pnames[frame_nparams], tok_ident, MAX_IDENT-1);
                    pnames[frame_nparams][MAX_IDENT-1] = '\0';
                    param_is_struct[param_slot] = current_type_is_struct;
                    if (current_type_is_struct) {
                        strncpy(param_struct_names[param_slot], current_type,
                                MAX_IDENT - 1);
                        param_struct_names[param_slot][MAX_IDENT - 1] = '\0';
                    }
                    frame_nparams++;
                }
                param_count++;
                lex_next();
                if (tok == TK_LBRACKET && param_count <= MAX_PARAMS) {
                    param_ptrs[frame_nparams - 1] = 1;
                    parse_array_dimensions(1,
                                           &param_ndims[frame_nparams - 1],
                                           param_dims[frame_nparams - 1]);
                }
            }
            if (!eat(TK_COMMA))
                break;
            /* A prototype may end with an ellipsis. */
            if (tok == TK_DOT) {
                while (eat(TK_DOT)) { }
                break;
            }
        }
    }
    if (tok != TK_RPAREN)
        die("Prototype parametreleri kapanmadı: %s", fname);
    expect(TK_RPAREN);

    /*
     * Header declarations are useful for name/type visibility but do not
     * contain an Oxalyn body.  Keep the symbol for calls and continue.
     */
    if (eat(TK_SEMI)) {
        sym_add_func(fname, frame_nparams);
        return;
    }
    if (tok != TK_LBRACE)
        die("Fonksiyon gövdesi veya prototype sonlandırıcısı bekleniyor: %s",
            fname);

    /* Sembol tablosuna kaydet */
    sym_add_func(fname, frame_nparams);
    for (i = 0; i < frame_nparams; i++) {
        Sym *param = sym_add_local(pnames[i], 2 + i, 1);
        param->is_pointer = param_ptrs[i];
        if (param_is_struct[i]) {
            param->struct_name[0] = '\0';
            strncpy(param->struct_name, param_struct_names[i], MAX_IDENT - 1);
            param->struct_name[MAX_IDENT - 1] = '\0';
            {
                StructDef *pst = struct_find(param->struct_name);
                if (pst) param->object_words = pst->words;
            }
        }
        if (param_ndims[i] > 0) {
            param->ndim = 0; /* array parameters decay to pointers */
            param->array_len = 1;
        }
    }

    int sym_m = sym_mark();

    /* Çerçeve boyutu: RA + oldFP + params + 32 (yerel alan için) */
    int frame_total = 2 + frame_nparams + 32;

    /* Etiket + prologue */
    emit("%s:", fname);
    emit("    LI   R%d, -%d", REG_SCRATCH, frame_total);
    emit("    ADD  R%d, R%d, R%d", REG_SP, REG_SP, REG_SCRATCH);
    emit("    STORE R%d, R%d, 0", REG_RA, REG_SP);    /* RA kaydet */
    emit("    STORE R%d, R%d, 1", REG_FP, REG_SP);    /* eski FP kaydet */
    emit("    ADD  R%d, R%d, R0", REG_FP, REG_SP);    /* FP = SP */
    /* Parametreleri frame'e kopyala */
    for (i = 0; i < frame_nparams && i < MAX_ARG_REGS; i++)
        emit("    STORE R%d, R%d, %d", i+1, REG_FP, 2+i);

    /* Gövde */
    expect(TK_LBRACE);
    while (tok != TK_RBRACE && tok != TK_EOF)
        parse_stmt(-1, -1);
    expect(TK_RBRACE);

    /* Epilogue */
    emit_label(func_end_label);
    emit("    LOAD R%d, R%d, 0", REG_RA, REG_FP);     /* RA geri yükle */
    emit("    LOAD R%d, R%d, 1", REG_FP, REG_FP);     /* eski FP geri yükle */
    emit("    LI   R%d, %d", REG_SCRATCH, frame_total);
    emit("    ADD  R%d, R%d, R%d", REG_SP, REG_SP, REG_SCRATCH);
    if (!strcmp(fname, "main"))
        emit("    HALT");
    else
        emit("    JALR R0, R31, 0");
    emit("");

    sym_restore(sym_m);
}

static void global_init_value(Global *g, int *index, int64_t value)
{
    if (*index >= g->words)
        die("Global başlatıcı (%d elem) dizi boyutunu (%d) aşıyor",
            *index, g->words);
    g->init[(*index)++] = value;
}

static void set_global_init_label(Global *g, int slot, const char *name)
{
    if (slot < 0 || slot >= g->words)
        die("Global pointer initializer dizi boyutunu aşıyor");
    g->init_label[slot] = (char *)malloc(MAX_IDENT);
    if (!g->init_label[slot])
        die("Global pointer initializer belleği ayrılamadı");
    strncpy(g->init_label[slot], name, MAX_IDENT - 1);
    g->init_label[slot][MAX_IDENT - 1] = '\0';
}

static void parse_global_pointer_value(Global *g, int *slot)
{
    Sym *target;
    int address_of = eat(TK_AMP);
    int64_t target_index = 0;

    if (tok != TK_IDENT)
        die("Pointer initializer sembol adı bekliyor");
    target = sym_find(tok_ident);
    if (!target)
        die("Initializer'da tanımlanmamış: %s", tok_ident);
    if (!target->is_global)
        die("Pointer init yalnızca global'a işaret edebilir");
    lex_next();
    if (address_of && eat(TK_LBRACKET)) {
        target_index = parse_const_expr();
        expect(TK_RBRACKET);
    }
    if (target_index != 0)
        die("Global pointer initializer yalnızca ilk dizi elemanını destekliyor");
    set_global_init_label(g, *slot, target->name);
    (*slot)++;
}

static void parse_global_init_values(Global *g, int *index)
{
    if (eat(TK_LBRACE)) {
        while (tok != TK_RBRACE && tok != TK_EOF) {
            parse_global_init_values(g, index);
            if (!eat(TK_COMMA))
                break;
        }
        expect(TK_RBRACE);
        return;
    }
    if (g->elem_is_pointer && (tok == TK_IDENT || tok == TK_AMP)) {
        parse_global_pointer_value(g, index);
        return;
    }
    if (tok == TK_STRING) {
        int i;
        if (g->elem_is_pointer) {
            if (*index >= g->words)
                die("Global başlatıcı (%d elem) dizi boyutunu (%d) aşıyor",
                    *index, g->words);
            set_global_init_label(g, *index,
                                  string_add(tok_string, tok_string_len));
            (*index)++;
            lex_next();
            return;
        }
        for (i = 0; i < tok_string_len; i++)
            global_init_value(g, index, (unsigned char)tok_string[i]);
        global_init_value(g, index, 0);
        lex_next();
        return;
    }
    global_init_value(g, index, parse_const_expr());
}

static void parse_global_pointer_init(Global *g)
{
    int slot = 0;
    parse_global_pointer_value(g, &slot);
    g->init_count = slot;
}

static void parse_global_decl(const char *name, int decl_ptr)
{
    int words;
    int array_len;
    int ndim;
    int dims[MAX_ARRAY_DIMS] = { 0 };
    int object_words = current_type_words > 0 ? current_type_words : 1;
    Global *g;
    Sym *s;
    int i;

    array_len = parse_array_dimensions(1, &ndim, dims);
    words = array_len * object_words;
    if (tok == TK_EQ && !ndim && !decl_ptr && current_type_is_char) {
        int saved_pos = src_pos;
        int saved_line = tok_line;
        int saved_string_len = tok_string_len;
        TKind saved_tok = tok;
        char saved_string[sizeof(tok_string)];
        strncpy(saved_string, tok_string, sizeof(saved_string) - 1);
        saved_string[sizeof(saved_string) - 1] = '\0';
        lex_next();
        if (tok == TK_STRING)
            words = tok_string_len + 1;
        src_pos = saved_pos;
        tok_line = saved_line;
        tok = saved_tok;
        tok_string_len = saved_string_len;
        strncpy(tok_string, saved_string, sizeof(tok_string) - 1);
        tok_string[sizeof(tok_string) - 1] = '\0';
    }

    g = global_add(name, words);
    g->elem_is_pointer = decl_ptr;
    s = sym_add_global(name, words);
    s->is_pointer = decl_ptr;
    s->array_len = array_len;
    s->object_words = object_words;
    s->ndim = ndim;
    memcpy(s->dims, dims, sizeof(dims));
    if (current_type_is_struct) {
        strncpy(s->struct_name, current_type, MAX_IDENT - 1);
        s->struct_name[MAX_IDENT - 1] = '\0';
    }

    if (eat(TK_EQ)) {
        if (eat(TK_LBRACE)) {
            int index = 0;
            while (tok != TK_RBRACE && tok != TK_EOF) {
                parse_global_init_values(g, &index);
                if (!eat(TK_COMMA))
                    break;
            }
            expect(TK_RBRACE);
            g->init_count = index;
        } else if (tok == TK_STRING) {
            if (decl_ptr) {
                const char *label = string_add(tok_string, tok_string_len);
                set_global_init_label(g, 0, label);
                g->init_count = 1;
            } else {
                int n = tok_string_len;
                if (n + 1 > g->words)
                    die("String initializer dizi boyutunu aşıyor");
                for (i = 0; i < n; i++)
                    g->init[g->init_count++] = (unsigned char)tok_string[i];
                g->init[g->init_count++] = 0;
            }
            lex_next();
        } else if (decl_ptr && (tok == TK_IDENT || tok == TK_AMP)) {
            parse_global_pointer_init(g);
        } else {
            g->init[0] = parse_const_expr();
            g->init_count = 1;
        }
    }
    /*
     * Keep the declaration in the symbol table immediately.  The data
     * section itself is emitted after all functions so the entry stub can
     * jump over it and global labels still resolve in assembler pass two.
     */
    for (i = g->init_count; i < g->words; i++)
        g->init[i] = 0;
}

static void emit_globals(void)
{
    int i, j;
    if (nglobals == 0 && nstrings == 0)
        return;
    emit("");
    emit("; cc.c global data (one Oxalyn word per scalar element)");
    for (i = 0; i < nglobals; i++) {
        emit("%s:", globals[i].name);
        for (j = 0; j < globals[i].words; j++) {
            if (globals[i].init_label[j])
                emit("    .word %s", globals[i].init_label[j]);
            else
                emit("    .word %lld", (long long)globals[i].init[j]);
        }
    }
    for (i = 0; i < nstrings; i++) {
        emit("%s:", strings[i].label);
        for (j = 0; j <= strings[i].len; j++)
            emit("    .word %d",
                 j < strings[i].len ? (unsigned char)strings[i].text[j] : 0);
    }
}

/* ── Program üst düzey ─────────────────────────────────── */
static void parse_program(void)
{
    int saw_main = 0;

    emit("; Oxalyn-64 Assembly — cc.c tarafından üretildi");
    emit("; Çalıştır: build/asm bu_dosya.asm çıktı.bin");
    emit("");
    if (!unit_mode) {
        emit("; C giriş stub'ı: word-addressed stack kurulumu");
        emit("    LI   R30, 1023");
        emit("    JMP  main");
        emit("");
    }

    while (tok != TK_EOF) {
        if (tok == TK_IDENT && !strcmp(tok_ident, "typedef")) {
            parse_typedef_decl();
            continue;
        }
        int decl_ptr = parse_type_and_ptr();
        if (tok == TK_SEMI) {
            /* Named forward declaration, e.g. `struct Process;`. */
            expect(TK_SEMI);
            continue;
        }
        if (tok != TK_IDENT) die("Fonksiyon/değişken adı bekleniyor");
        char name[MAX_IDENT];
        strncpy(name, tok_ident, MAX_IDENT-1);
        lex_next();

        if (tok == TK_LPAREN) {
            if (!strcmp(name, "main")) saw_main = 1;
            parse_func(name);
        } else {
            parse_global_decl(name, decl_ptr);
            while (eat(TK_COMMA)) {
                int item_ptr = decl_ptr;
                while (eat(TK_STAR))
                    item_ptr++;
                if (tok != TK_IDENT)
                    die("Değişken adı bekleniyor");
                strncpy(name, tok_ident, MAX_IDENT - 1);
                name[MAX_IDENT - 1] = '\0';
                lex_next();
                parse_global_decl(name, item_ptr);
            }
            expect(TK_SEMI);
        }
    }

    if (!unit_mode && !saw_main)
        die("C programında main fonksiyonu bulunamadı");
    emit_missing_labels();
    emit_globals();
}

/* ── Yardımcı: dosya oku ─────────────────────────────────────────── */
static char *read_file(const char *path, int *out_len) {
    FILE *f = fopen(path, "rb");
    long  n;
    char *buf;
    if (!f) { fprintf(stderr, "cc: Dosya açılamadı: %s\n", path); exit(1); }
    fseek(f, 0, SEEK_END); n = ftell(f); fseek(f, 0, SEEK_SET);
    buf = (char *)malloc((size_t)n + 2);
    if (!buf) { fclose(f); exit(1); }
    fread(buf, 1, (size_t)n, f);
    buf[n] = '\0';
    fclose(f);
    *out_len = (int)n;
    return buf;
}

/* ── main ────────────────────────────────────────────────────────── */
int main(int argc, char **argv)
{
    const char *infiles[MAX_INPUT_FILES];
    int input_count = 0;
    const char *outfile = NULL;
    int i;

    for (i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-o") && i+1 < argc) { outfile = argv[++i]; }
        else if (!strcmp(argv[i], "--unit")) { unit_mode = 1; }
        else if (argv[i][0] != '-') {
            if (input_count >= MAX_INPUT_FILES)
                die("Çok fazla kaynak dosyası (maksimum %d)", MAX_INPUT_FILES);
            infiles[input_count++] = argv[i];
        }
        else { fprintf(stderr, "Bilinmeyen seçenek: %s\n", argv[i]); return 1; }
    }
    if (input_count == 0) {
        fprintf(stderr, "Oxalyn-64 C Derleyici\n");
        fprintf(stderr, "Kullanım: cc kaynak.c [kaynak2.c ...] -o çıktı.asm\n");
        return 1;
    }

    char *source;
    pp_output = NULL;
    pp_len = 0;
    pp_cap = 0;
    pp_active = 1;
    pp_depth = 0;
    nmacros = 0;
    /*
     * A unit build is a single compiler translation unit assembled from all
     * positional C inputs.  The previous single `infile` slot silently kept
     * only the last shell-expanded path, producing incomplete kernel.asm
     * files with no kernel_main.
     */
    for (i = 0; i < input_count; i++) {
        pp_process_file(infiles[i], 0);
        pp_append("\n");
    }
    if (pp_depth != 0)
        die("Kapanmamış ön işlemci koşulu");
    source = pp_output;
    src     = source;
    src_pos = 0;
    src_len = (int)pp_len;

    out = outfile ? fopen(outfile, "w") : stdout;
    if (!out) { fprintf(stderr, "cc: Çıktı dosyası açılamadı: %s\n", outfile); return 1; }
    if (outfile) {
        strncpy(output_path, outfile, sizeof(output_path) - 1);
        output_path[sizeof(output_path) - 1] = '\0';
    }

    lex_next();
    parse_program();

    if (out != stdout) fclose(out);
    out = NULL;
    free(source);
    if (input_count == 1) {
        printf("cc: %s → %s  (%d etiket üretildi)\n",
               infiles[0], outfile ? outfile : "(stdout)", label_cnt);
    } else {
        printf("cc: %d kaynak → %s  (%d etiket üretildi)\n",
               input_count, outfile ? outfile : "(stdout)", label_cnt);
    }
    return 0;
}
