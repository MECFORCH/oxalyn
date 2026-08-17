#!/usr/bin/env bash
#
# Compiler mimari algılama ve güvenli kaynak çevirisi testleri.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR" || exit 1

COMPILER="${COMPILER_BIN:-./build/compiler}"
CC_MINIMAL="${CC_MINIMAL_BIN:-./build/cc}"
ASM="${ASM_BIN:-./build/asm}"
SIM="${SIM_BIN:-./build/sim}"
TMP_DIR="$(mktemp -d /tmp/oxalyn_compiler_tests.XXXXXX)"
PASS=0
FAIL=0

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

pass() {
    echo "[OK]   $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "[FAIL] $1"
    FAIL=$((FAIL + 1))
}

if [[ ! -x "$COMPILER" || ! -x "$CC_MINIMAL" ]]; then
    echo "[HATA] Compiler yok. Önce 'make compiler' çalıştırın." >&2
    exit 1
fi

if [[ ! -x "$ASM" || ! -x "$SIM" ]]; then
    echo "[HATA] Assembler/simülatör yok. Önce 'make' çalıştırın." >&2
    exit 1
fi

cat >"$TMP_DIR/x86.s" <<'EOF'
.text
_start:
  mov rax, 5
  mov rbx, 7
  add rax, rbx
  ret
EOF

cat >"$TMP_DIR/arm64.s" <<'EOF'
.text
_start:
  mov x0, #5
  mov x1, #7
  add x0, x0, x1
  ret
EOF

cat >"$TMP_DIR/riscv64.s" <<'EOF'
.text
_start:
  li a0, 5
  li a1, 7
  add a0, a0, a1
  addi a0, a0, 1
  ret
EOF

cat >"$TMP_DIR/oxalyn.asm" <<'EOF'
LI R1, 5
LI R2, 7
ADD R3, R1, R2
HALT
EOF

if "$COMPILER" "$TMP_DIR/x86.s" -o "$TMP_DIR/x86" >/dev/null 2>&1 &&
   grep -q '^ADD R1, R1, R2$' "$TMP_DIR/x86.asm" &&
   [[ -s "$TMP_DIR/x86.bin" ]]; then
    pass "x86-64 otomatik algılama ve çeviri"
else
    fail "x86-64 otomatik algılama ve çeviri"
fi

if "$COMPILER" "$TMP_DIR/arm64.s" -o "$TMP_DIR/arm64" >/dev/null 2>&1 &&
   grep -q '^ADD R1, R1, R2$' "$TMP_DIR/arm64.asm" &&
   [[ -s "$TMP_DIR/arm64.bin" ]]; then
    pass "ARM64 otomatik algılama ve çeviri"
else
    fail "ARM64 otomatik algılama ve çeviri"
fi

if "$COMPILER" "$TMP_DIR/riscv64.s" -o "$TMP_DIR/riscv64" >/dev/null 2>&1 &&
   grep -q '^ADD R10, R10, R11$' "$TMP_DIR/riscv64.asm" &&
   [[ -s "$TMP_DIR/riscv64.bin" ]]; then
    pass "RISC-V64 otomatik algılama ve çeviri"
else
    fail "RISC-V64 otomatik algılama ve çeviri"
fi

if "$COMPILER" "$TMP_DIR/oxalyn.asm" -o "$TMP_DIR/oxalyn-out" >/dev/null 2>&1 &&
   grep -q '^ADD R3, R1, R2$' "$TMP_DIR/oxalyn-out.asm" &&
   [[ -s "$TMP_DIR/oxalyn-out.bin" ]]; then
    pass "Oxalyn assembly ve .bin üretimi"
else
    fail "Oxalyn assembly ve .bin üretimi"
fi

printf '\x00asm\x01\x00\x00\x00' >"$TMP_DIR/module.wasm"
if "$COMPILER" --inspect "$TMP_DIR/module.wasm" 2>&1 |
   grep -q 'Mimari     : wasm'; then
    pass "WebAssembly başlık algılama"
else
    fail "WebAssembly başlık algılama"
fi

cat >"$TMP_DIR/unsupported.s" <<'EOF'
.text
_start:
  frobnicate rax
EOF
if ! "$COMPILER" "$TMP_DIR/unsupported.s" -o "$TMP_DIR/unsupported" \
       --arch x86-64 >/dev/null 2>&1 &&
   [[ ! -e "$TMP_DIR/unsupported.bin" ]] &&
   grep -q 'desteklenmiyor' "$TMP_DIR/unsupported.report.txt"; then
    pass "desteklenmeyen komutta güvenli hata"
else
    fail "desteklenmeyen komutta güvenli hata"
fi

cat >"$TMP_DIR/fpu.asm" <<'EOF'
FADD R1, R2, R3
EOF
if ! "$ASM" "$TMP_DIR/fpu.asm" "$TMP_DIR/fpu.bin" \
       >"$TMP_DIR/fpu.asm.log" 2>&1 &&
   [[ ! -e "$TMP_DIR/fpu.bin" ]] &&
   grep -q 'Bilinmeyen mnemonik' "$TMP_DIR/fpu.asm.log"; then
    pass "rezerve FPU mnemonic'i binary üretmiyor"
else
    fail "rezerve FPU mnemonic'i binary üretmiyor"
fi

# Binary formatı big-endian 32-bit kelimelerden oluşur. 0x30 opcode'u
# mevcut ISA'da rezerve/illegal'dir; fd=1 ile encode edilmiştir.
printf '\xC2\x20\x00\x00' >"$TMP_DIR/fpu-raw.bin"
if "$SIM" "$TMP_DIR/fpu-raw.bin" -q >"$TMP_DIR/fpu.sim.log" 2>&1 &&
   grep -q 'Bilinmeyen opcode: 0x30' "$TMP_DIR/fpu.sim.log"; then
    pass "ham FPU opcode illegal instruction olarak duruyor"
else
    fail "ham FPU opcode illegal instruction olarak duruyor"
fi

cat >"$TMP_DIR/call.c" <<'EOF'
int add(int a, int b) { return a + b; }
int main(void) { int total = 3; return add(total, 7); }
EOF
if "$CC_MINIMAL" "$TMP_DIR/call.c" -o "$TMP_DIR/call.asm" \
       >"$TMP_DIR/call.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/call.asm" "$TMP_DIR/call.bin" \
       >"$TMP_DIR/call.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/call.bin" -q >"$TMP_DIR/call.sim.log" 2>&1 &&
   grep -q 'R7 = *10 ' "$TMP_DIR/call.sim.log"; then
    pass "C fonksiyon çağrısı ve ABI sonucu"
else
    fail "C fonksiyon çağrısı ve ABI sonucu"
fi

cat >"$TMP_DIR/loop.c" <<'EOF'
int main(void) {
    int i = 0;
    int total = 0;
    while (i < 5) { total += i; i++; }
    return total;
}
EOF
if "$CC_MINIMAL" "$TMP_DIR/loop.c" -o "$TMP_DIR/loop.asm" \
       >"$TMP_DIR/loop.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/loop.asm" "$TMP_DIR/loop.bin" \
       >"$TMP_DIR/loop.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/loop.bin" -q >"$TMP_DIR/loop.sim.log" 2>&1 &&
   grep -q 'R7 = *10 ' "$TMP_DIR/loop.sim.log"; then
    pass "C while, karşılaştırma ve postfix ++"
else
    fail "C while, karşılaştırma ve postfix ++"
fi

cat >"$TMP_DIR/expr.c" <<'EOF'
int main(void) {
    int a = 6;
    int b = 2;
    if (a > b && a != 0) return a * b + 1;
    return 99;
}
EOF
if "$CC_MINIMAL" "$TMP_DIR/expr.c" -o "$TMP_DIR/expr.asm" \
       >"$TMP_DIR/expr.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/expr.asm" "$TMP_DIR/expr.bin" \
       >"$TMP_DIR/expr.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/expr.bin" -q >"$TMP_DIR/expr.sim.log" 2>&1 &&
   grep -q 'R7 = *13 ' "$TMP_DIR/expr.sim.log"; then
    pass "C koşul, mantıksal ifade ve aritmetik"
else
    fail "C koşul, mantıksal ifade ve aritmetik"
fi

cat >"$TMP_DIR/global.c" <<'EOF'
static int counter = 7;
static int values[3] = { 10, 20, 30 };
int main(void) {
    counter = counter + values[1];
    return counter;
}
EOF
if "$CC_MINIMAL" "$TMP_DIR/global.c" -o "$TMP_DIR/global.asm" \
       >"$TMP_DIR/global.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/global.asm" "$TMP_DIR/global.bin" \
       >"$TMP_DIR/global.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/global.bin" -q >"$TMP_DIR/global.sim.log" 2>&1 &&
   grep -q 'R7 = *27 ' "$TMP_DIR/global.sim.log"; then
    pass "C global scalar/array veri ve erişimi"
else
    fail "C global scalar/array veri ve erişimi"
fi

cat >"$TMP_DIR/lvalues.c" <<'EOF'
typedef struct { int x; int y; } Point;
int main(void) {
    Point point;
    int values[3] = { 1, 2, 3 };
    int *element = &values[0];
    point.x = 11;
    point.y = 4;
    *element = 3;
    return point.x + point.y + element[0];
}
EOF
if "$CC_MINIMAL" "$TMP_DIR/lvalues.c" -o "$TMP_DIR/lvalues.asm" \
       >"$TMP_DIR/lvalues.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/lvalues.asm" "$TMP_DIR/lvalues.bin" \
       >"$TMP_DIR/lvalues.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/lvalues.bin" -q >"$TMP_DIR/lvalues.sim.log" 2>&1 &&
   grep -q 'R7 = *18 ' "$TMP_DIR/lvalues.sim.log"; then
    pass "C struct alanı, dizi adresi ve lvalue ataması"
else
    fail "C struct alanı, dizi adresi ve lvalue ataması"
fi

cat >"$TMP_DIR/compiler_features.c" <<'EOF'
char c_hex = '\x41';
char c_oct = '\101';
char *escaped = "line1\nline2";
char *embedded = "hex\x00end";
char *messages[2] = { "a", "b" };
int sizeof_int = sizeof(int);
struct SizePair { int a; int b; };
int sizeof_struct = sizeof(struct SizePair);
int matrix[2][3];
int values[3] = { 1, 2, 3 };
int *values_ptr = &values[0];
struct Point { int x; int y; };
struct Point points[2] = {{ 1, 2 }, { 3, 4 }};
int main(void) {
    matrix[1][2] = 5;
    return c_hex + c_oct + sizeof_int + sizeof_struct +
           matrix[1][2] + values_ptr[1] + points[1].y + messages[1][0];
}
EOF
if "$CC_MINIMAL" "$TMP_DIR/compiler_features.c" \
       -o "$TMP_DIR/compiler_features.asm" \
       >"$TMP_DIR/compiler_features.cc.log" 2>&1 &&
   "$ASM" "$TMP_DIR/compiler_features.asm" "$TMP_DIR/compiler_features.bin" \
       >"$TMP_DIR/compiler_features.asm.log" 2>&1 &&
   "$SIM" "$TMP_DIR/compiler_features.bin" -q \
       >"$TMP_DIR/compiler_features.sim.log" 2>&1 &&
   grep -q 'R7 = *242 ' "$TMP_DIR/compiler_features.sim.log" &&
   grep -A8 -q '^_STR_1:' "$TMP_DIR/compiler_features.asm" &&
   grep -A8 -q '    \.word 0' "$TMP_DIR/compiler_features.asm"; then
    pass "C kaçış dizileri, sizeof, çok boyutlu dizi ve global initializer"
else
    fail "C kaçış dizileri, sizeof, çok boyutlu dizi ve global initializer"
fi

echo ""
echo "Compiler sonucu: $PASS geçti, $FAIL başarısız."
[[ "$FAIL" -eq 0 ]]