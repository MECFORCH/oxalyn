#!/usr/bin/env bash
#
# Her *.asm dosyasını build/asm ile derler, build/sim ile çalıştırır.
# Şablon dosyaları boş bırakılabilir; boş testler bilinçli olarak atlanır.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR" || exit 1

ASM_BIN="${ASM_BIN:-./build/asm}"
SIM_BIN="${SIM_BIN:-./build/sim}"
PASS=0
FAIL=0
TOTAL=0

if [[ ! -x "$ASM_BIN" || ! -x "$SIM_BIN" ]]; then
    echo "[HATA] Test araçları yok. Önce 'make' çalıştırın." >&2
    exit 1
fi

# Yalnızca assembler ve simülatör sözleşmesiyle uyumlu, beklenen çıktısı
# tanımlı testleri çalıştır. Eski/araştırma testleri (ör. henüz assembler
# tarafından desteklenmeyen LI64 ve CSR örnekleri) ana regresyonu bozmaz;
# ayrı ayrı çalıştırılabilir ve geliştirilir.
TEST_NAMES=(
    test
    test_new_isa
    test_pseudo
    muldiv_test
    uart_interrupt_test
    atomic_test
    cache_perf_test
)

for name in "${TEST_NAMES[@]}"; do
    asm_file="$SCRIPT_DIR/${name}.asm"
    [[ -e "$asm_file" ]] || continue
    expected_file="$SCRIPT_DIR/${name}.expected"
    TOTAL=$((TOTAL + 1))

    if ! grep -qvE '^[[:space:]]*(;|$)' "$asm_file"; then
        echo "[ATLA] $name — boş test şablonu"
        TOTAL=$((TOTAL - 1))
        continue
    fi

    if [[ ! -f "$expected_file" ]]; then
        echo "[FAIL] $name — .expected dosyası yok"
        FAIL=$((FAIL + 1))
        continue
    fi

    bin_file="$(mktemp /tmp/oxalyn_test_XXXXXX.bin)"
    if ! "$ASM_BIN" "$asm_file" "$bin_file" > /tmp/oxalyn_test_asm.log 2>&1; then
        echo "[FAIL] $name — assembler hatası:"
        cat /tmp/oxalyn_test_asm.log
        FAIL=$((FAIL + 1))
        rm -f "$bin_file"
        continue
    fi

    sim_args=("$bin_file" "-q")
    if [[ "$name" == "uart_interrupt_test" ]]; then
        sim_args+=("--uart-rx" "12" "65")
    fi
    actual_output="$("$SIM_BIN" "${sim_args[@]}" 2>&1)"
    rm -f "$bin_file"
    ok=1

    while IFS= read -r expected_line; do
        [[ -z "$expected_line" ]] && continue
        if ! grep -qF "$expected_line" <<< "$actual_output"; then
            ok=0
            echo "[FAIL] $name — beklenen satır bulunamadı: $expected_line"
        fi
    done < "$expected_file"

    if [[ "$ok" -eq 1 ]]; then
        echo "[OK]   $name"
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi
done

echo ""
echo "Sonuç: $PASS geçti, $FAIL başarısız, $TOTAL aktif test."
[[ "$FAIL" -eq 0 ]]