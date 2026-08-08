#!/usr/bin/env bash
#
# bin2mem sözleşme testleri:
#   - Oxalyn .bin kelimeleri big-endian okunmalı
#   - 32 ve 64 bit Vivado satır genişlikleri doğru yazılmalı
#   - kapasite aşımı güvenli biçimde reddedilmeli

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR" || exit 1

BIN2MEM="${BIN2MEM_BIN:-./build/bin2mem}"
TMP_DIR="$(mktemp -d /tmp/oxalyn_bin2mem_tests.XXXXXX)"
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

if [[ ! -x "$BIN2MEM" ]]; then
    echo "[HATA] bin2mem yok. Önce 'make bin2mem' çalıştırın." >&2
    exit 1
fi

# İki kelime: 0x12345678 ve 0xA0B0C0D0, big-endian byte sırasıyla.
printf '\x12\x34\x56\x78\xa0\xb0\xc0\xd0' > "$TMP_DIR/input.bin"

if "$BIN2MEM" "$TMP_DIR/input.bin" "$TMP_DIR/out32.mem" \
       --depth 4 --width 32 > "$TMP_DIR/out32.log" 2>&1 &&
   [[ "$(sed -n '1p' "$TMP_DIR/out32.mem")" == "12345678" ]] &&
   [[ "$(sed -n '2p' "$TMP_DIR/out32.mem")" == "A0B0C0D0" ]] &&
   [[ "$(sed -n '3p' "$TMP_DIR/out32.mem")" == "00000000" ]]; then
    pass "big-endian binary → 32-bit .mem"
else
    fail "big-endian binary → 32-bit .mem"
fi

if "$BIN2MEM" "$TMP_DIR/input.bin" "$TMP_DIR/out64.mem" \
       --depth 2 --width 64 > "$TMP_DIR/out64.log" 2>&1 &&
   [[ "$(sed -n '1p' "$TMP_DIR/out64.mem")" == "0000000012345678" ]] &&
   [[ "$(sed -n '2p' "$TMP_DIR/out64.mem")" == "00000000A0B0C0D0" ]]; then
    pass "32-bit kelimelerin 64-bit sıfır genişletmesi"
else
    fail "32-bit kelimelerin 64-bit sıfır genişletmesi"
fi

if ! "$BIN2MEM" "$TMP_DIR/input.bin" "$TMP_DIR/overflow.mem" \
        --depth 1 > "$TMP_DIR/overflow.log" 2>&1 &&
   grep -q "Binary çok büyük" "$TMP_DIR/overflow.log"; then
    pass "bellek kapasitesi aşımı reddediliyor"
else
    fail "bellek kapasitesi aşımı reddediliyor"
fi

printf '\x01\x02\x03' > "$TMP_DIR/partial.bin"
if "$BIN2MEM" "$TMP_DIR/partial.bin" "$TMP_DIR/partial.mem" \
       --depth 1 --width 32 > "$TMP_DIR/partial.log" 2>&1 &&
   grep -q "4'ün katı değil" "$TMP_DIR/partial.log"; then
    pass "kısmi binary kelimesi uyarı veriyor"
else
    fail "kısmi binary kelimesi uyarı veriyor"
fi

echo ""
echo "bin2mem sonucu: $PASS geçti, $FAIL başarısız."
[[ "$FAIL" -eq 0 ]]