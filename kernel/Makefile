# HILAL_BIS Kernel Build System
#
# İki ayrı derleme hedefi:
#
#   make host      — PC'de çalışan test binary'si (Linux/Windows/macOS)
#                    Standart C kullanır, OS bağımlılığı yoktur.
#                    Sadece putchar/getchar ve stdio ile çalışır.
#
#   make oxalyn-wasm — Tüm kernel C dosyalarını gerçek freestanding WASM
#                      object'lerine derler ve tek WASM modülünde linkler.
#                      Bu ara çıktı Oxalyn .bin değildir.
#
#   make oxalyn    — WASM → Oxalyn assembly → linked boot assembly → .bin
#                    zincirini çalıştırır. Son bin2mem adımı fiziksel bellek
#                    kapasitesini aşan programı bilinçli olarak reddeder.
#
#   make           — Varsayılan: host (geliştirme için)
#   make typecheck — Sözdizimi kontrolü
#   make test-kernel — Host üzerinde kernel unit testlerini çalıştır
#   make clean     — Temizle

CC      = gcc
CLANG   ?= $(shell command -v clang 2>/dev/null || \
	ls /nix/store/*clang-wrapper-20.1.6/bin/clang 2>/dev/null | head -1)
# Replit/Nix ortamında wasm-ld çoğu zaman PATH'te değildir. PATH'teki
# sürümü tercih et; yoksa mevcut Nix store'daki linker'ı bul.
WASM_LD ?= $(shell command -v wasm-ld 2>/dev/null || \
	ls /nix/store/*llvm-binutils-20.1.6/bin/wasm-ld 2>/dev/null | head -1)

# ── Ortak bayraklar ──────────────────────────────────────────────────
COMMON_CFLAGS = -std=c99 -O2 -Wall -Wextra -I. -Wno-unused-parameter

# ── HOST TEST MODU ───────────────────────────────────────────────────
# Standart C — Linux, Windows (MinGW), macOS hepsinde derlenir.
# -DOXALYN_HOST_TEST: platform-agnostic kod yollarını açar.
HOST_CFLAGS  = $(COMMON_CFLAGS) -DOXALYN_HOST_TEST
TEST_BIN     = test_kernel
TEST_SOURCES = ../tests/test_kernel.c memory.c kstring.c auth.c perms.c filesystem.c hostio.c
GUI_GUARD_TEST_BIN = test_gui_guard
GUI_GUARD_TEST_SOURCES = ../tests/gui_guard_tests.c gui_guard.c hostio.c
# Host binary normal C başlangıç koduyla çalışır. Kernel entry point'i
# aşağıdaki OXALYN_HOST_TEST main() wrapper'ı üzerinden çağrılır; bu,
# stdio/dosya I/O için libc başlangıç kurulumunu korur.
HOST_LDFLAGS = -lgcc

# ── OXALYN KERNEL MODU ──────────────────────────────────────────────
# Native GCC/ELF çıktısı Oxalyn binary'si olarak paketlenmez. Gerçek kernel
# yolu aşağıdaki WASM frontend'i ve WASM→Oxalyn translator'ını kullanır.
OXA_CFLAGS  = $(COMMON_CFLAGS) -ffreestanding -DOXALYN_KERNEL
OXA_LDFLAGS = -nostartfiles -nostdlib -lgcc -Wl,-e,kernel_main

# ── Kaynak dosyalar ──────────────────────────────────────────────────
SOURCES = kernel.c scheduler.c memory.c uart.c gpu.c gpu_hw.c gui_guard.c shell.c kstring.c  \
          ui.c input.c mouse.c apps.c auth.c perms.c filesystem.c wm.c   \
          network.c usb_hid.c ipc.c vfs.c vfs_persist.c hostio.c         \
          syslog.c rtc.c sound.c spinlock.c smp.c wifi.c tcp.c gpu_cmd.c

HEADERS = kernel.h scheduler.h memory.h uart.h gpu.h gpu_hw.h gui_guard.h shell.h types.h \
          platform.h mmio.h                                                           \
          kstring.h ui.h input.h mouse.h apps.h auth.h perms.h            \
          filesystem.h wm.h network.h usb_hid.h ipc.h vfs.h vfs_persist.h\
          hostio.h syslog.h rtc.h sound.h spinlock.h smp.h wifi.h tcp.h gpu_cmd.h gpu_hw.h \
          ../gravityon/gpu/gpu_wire.h

# ── Çıktı dosyaları ─────────────────────────────────────────────────
HOST_ELF  = hilal_bis_host
OXA_ELF   = hilal_bis.elf
OXA_BIN   = hilal_bis.bin
WASM_DIR  = ../build/kernel-wasm
WASM_ELF  = $(WASM_DIR)/hilal_bis.wasm
OXA_DIR   = ../build/kernel-oxalyn
OXA_TRANSLATED_ASM = $(OXA_DIR)/hilal_bis.translated.asm
OXA_LINKED_ASM = $(OXA_DIR)/hilal_bis.linked.asm
OXA_REAL_BIN = $(OXA_DIR)/hilal_bis.bin
OXA_MEM = $(OXA_DIR)/hilal_bis.mem

HOST_OBJS = $(SOURCES:.c=.host.o)
OXA_OBJS  = $(SOURCES:.c=.oxa.o)
WASM_OBJS = $(SOURCES:%.c=$(WASM_DIR)/%.wasm.o)

.PHONY: all host oxalyn oxalyn-wasm oxalyn-objects typecheck test-kernel \
	test-gui-guard clean run run-host

# ── Varsayılan hedef ─────────────────────────────────────────────────
all: host

# ── HOST derle ───────────────────────────────────────────────────────
host: $(HOST_ELF)

$(HOST_ELF): $(HOST_OBJS)
	$(CC) $(HOST_CFLAGS) -o $@ $^ $(HOST_LDFLAGS)
	@echo "Host binary hazır: $@"

%.host.o: %.c $(HEADERS)
	$(CC) $(HOST_CFLAGS) -c -o $@ $<

# ── OXALYN derle ─────────────────────────────────────────────────────
oxalyn: $(OXA_MEM)
	@echo "Oxalyn kernel boot image hazır: $(OXA_MEM)"
	@ls -lh $(OXA_MEM)

$(OXA_TRANSLATED_ASM): $(WASM_ELF) ../build/compiler ../build/asm
	@mkdir -p $(OXA_DIR)
	../build/compiler $(WASM_ELF) -o $(OXA_DIR)/hilal_bis.translated \
		--assembler ../build/asm

$(OXA_LINKED_ASM): $(OXA_TRANSLATED_ASM) ../tools/oxalyn_link.py
	@mkdir -p $(OXA_DIR)
	python3 ../tools/oxalyn_link.py $(OXA_TRANSLATED_ASM) $@

$(OXA_REAL_BIN): $(OXA_LINKED_ASM) ../build/asm
	../build/asm $(OXA_LINKED_ASM) $@

$(OXA_MEM): $(OXA_REAL_BIN) ../build/bin2mem
	../build/bin2mem $(OXA_REAL_BIN) $@

$(OXA_BIN): $(OXA_ELF)
	objcopy -O binary $< $@
	@echo "Oxalyn kernel binary: $@"
	@ls -lh $@

$(OXA_ELF): $(OXA_OBJS)
	$(CC) $(OXA_CFLAGS) -o $@ $^ $(OXA_LDFLAGS)

%.oxa.o: %.c $(HEADERS)
	$(CC) $(OXA_CFLAGS) -c -o $@ $<

# ── WASM frontend/linker ara hedefi ──────────────────────────────────
# Clang, kernel'in gerçek C dilini (include, typedef, struct, pointer,
# global/data, function pointer vb.) işler. Bu aşama yalnızca doğrulanabilir
# WASM üretir; WASM binary'si Oxalyn instruction stream olarak kullanılamaz.
# Section bölümlendirmesi ve linker GC, kullanılmayan kernel yardımcılarını
# gerçek image'a taşımadan önce atar; translator yalnızca bağlı WASM gövdesini
# Oxalyn assembly'ye dönüştürür.
WASM_CFLAGS = -target wasm32 -std=c99 -O2 -ffreestanding -fno-builtin \
      -fno-stack-protector -ffunction-sections -fdata-sections \
      -nostdlib -I. -DOXALYN_KERNEL -DOXALYN_WASM

oxalyn-objects: $(WASM_OBJS)
	@echo "WASM frontend: $(words $(WASM_OBJS))/$(words $(SOURCES)) kernel modülü derlendi"

$(WASM_DIR)/%.wasm.o: %.c $(HEADERS)
	@mkdir -p $(WASM_DIR)
	$(CLANG) $(WASM_CFLAGS) -c -o $@ $<

oxalyn-wasm: $(WASM_ELF)
	@echo "Freestanding WASM kernel hazır: $(WASM_ELF)"
	@ls -lh $(WASM_ELF)

$(WASM_ELF): $(WASM_OBJS)
	@test -n "$(WASM_LD)" || (echo "HATA: wasm-ld bulunamadı; WASM_LD ile belirtin." >&2; exit 1)
	"$(WASM_LD)" --no-entry --export=kernel_main --export-memory \
--allow-undefined --gc-sections $^ -o $@

# ── Typecheck ────────────────────────────────────────────────────────
typecheck:
	@echo "--- Host typecheck ---"
	$(CC) $(HOST_CFLAGS) -fsyntax-only $(SOURCES)
	@echo "--- Oxalyn typecheck ---"
	$(CC) $(OXA_CFLAGS)  -fsyntax-only $(SOURCES)
	@echo "Typecheck passed"

# ── HOST KERNEL UNIT TESTLERİ ─────────────────────────────────────────
# kernel_main'i bağlamadan yalnızca saf kernel modüllerini test eder.
# Böylece login/shell gibi sonsuz döngülü uygulama akışı test koşusunu
# kilitlemez.
test-kernel:
	$(CC) $(HOST_CFLAGS) -o $(TEST_BIN) $(TEST_SOURCES)
	./$(TEST_BIN)
	$(MAKE) test-gui-guard

test-gui-guard:
	$(CC) $(HOST_CFLAGS) -o $(GUI_GUARD_TEST_BIN) $(GUI_GUARD_TEST_SOURCES)
	./$(GUI_GUARD_TEST_BIN)
# ── Çalıştır ─────────────────────────────────────────────────────────
run-host: host
	./$(HOST_ELF)

run: oxalyn
	../build/sim $(OXA_BIN)

run-debug: oxalyn
	../build/dbg $(OXA_BIN)

# ── Temizle ──────────────────────────────────────────────────────────
clean:
	rm -f $(HOST_OBJS) $(OXA_OBJS) $(HOST_ELF) $(OXA_ELF) $(OXA_BIN) $(TEST_BIN) $(GUI_GUARD_TEST_BIN)
	rm -rf $(WASM_DIR)
	@echo "Cleaned"
