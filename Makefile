# Oxalyn-64 build akışı
#
# Kaynak simülatör kodu simulator/ altında tutulur.
# Derlenmiş dosyalar build/ altında üretilir; kaynak ağacına yazılmaz.

CC ?= cc
CPPFLAGS ?= -I.
CFLAGS ?= -std=c99 -O3 -march=native -funroll-loops -Wall -Wextra -Wno-unused-function
LDLIBS ?= -lm

BUILD_DIR := build
SIM := $(BUILD_DIR)/sim
ASM := $(BUILD_DIR)/asm
DBG := $(BUILD_DIR)/dbg
HEXDUMP := $(BUILD_DIR)/hexdump
COMPILER := $(BUILD_DIR)/compiler
CC_MINIMAL := $(BUILD_DIR)/cc
BIN2MEM := $(BUILD_DIR)/bin2mem
TOOLS := $(SIM) $(ASM) $(DBG) $(HEXDUMP) $(COMPILER) $(CC_MINIMAL) $(BIN2MEM)

.PHONY: all build simulator compiler cc bin2mem tools voxel-demo test test-kernel compiler-test bin2mem-test gpu-kernel-test sim-verilog timer-irq-test uart_interrupt uart_interrupt_tb uart_irq_tb gpu_interrupt_test scheduler_verify cache_perf_test atomic_test fpga-check synth-check formal gravityon clean help kernel kernel-oxalyn kernel-oxalyn-objects kernel-oxalyn-wasm kernel-oxalyn-link-test

all: tools

# ── Tam sistem derlemesi ─────────────────────────────────────────────
# make build → host kernel + compiler/simülatör/assembler araçları
build: tools kernel
	@echo ""
	@echo "╔══════════════════════════════════════════════╗"
	@echo "║     Oxalyn-64 — Host derleme tamamlandı      ║"
	@echo "╠══════════════════════════════════════════════╣"
	@echo "║  kernel/hilal_bis_host  → PC test binary     ║"
	@echo "║  build/compiler         → Oxalyn compiler    ║"
	@echo "║  build/sim              → CPU simülatörü     ║"
	@echo "╚══════════════════════════════════════════════╝"

# Kernel — host test modu (Linux/Windows/macOS — standart C)
kernel:
	$(MAKE) -C kernel host

# Kernel — gerçek WASM→Oxalyn boot image zinciri; kapasite aşımı bilinçli reddedilir.
kernel-oxalyn:
	$(MAKE) -C kernel oxalyn

# Complete kernel C frontend milestones. These produce real freestanding
# WASM intermediates, not Oxalyn instruction binaries.
kernel-oxalyn-objects:
	$(MAKE) -C kernel oxalyn-objects

kernel-oxalyn-wasm:
	$(MAKE) -C kernel oxalyn-wasm

kernel-oxalyn-link-test: tools
	@set -e; tmpdir=$$(mktemp -d); trap 'rm -rf "$$tmpdir"' EXIT; \
	printf '%s\n' '.text' '_wasm_start:' '    HALT' > $$tmpdir/module.asm; \
	python3 tools/oxalyn_link.py $$tmpdir/module.asm $$tmpdir/linked.asm; \
	$(ASM) $$tmpdir/linked.asm $$tmpdir/linked.bin; \
	test -s $$tmpdir/linked.bin; \
	$(SIM) $$tmpdir/linked.bin -q -c 32 >/dev/null
tools: $(TOOLS)

simulator: $(SIM)

compiler: $(COMPILER)

cc: $(CC_MINIMAL)

bin2mem: $(BIN2MEM)

voxel-demo:
	$(MAKE) -C gravityon lib
	@mkdir -p $(BUILD_DIR)
	$(CC) -std=c99 -O2 -Wall -Wextra -Werror -pedantic \
		-Isrc -Igravityon \
		-o $(BUILD_DIR)/voxel-demo \
		src/voxel_demo.c src/world.c src/mesher.c src/render.c \
		gravityon/libgravityon.a -lm
	@echo ">>> Voxel demo hazır: $(BUILD_DIR)/voxel-demo [çıktı.ppm]"

$(SIM): simulator/sim.c simulator/framebuffer.c simulator/framebuffer.h \
		simulator/gdb_stub.c simulator/gdb_stub.h \
		gravityon/gpu/gpu_sim.c gravityon/gpu/gpu_sim.h \
gravityon/gpu/gpu_bytecode.h gravityon/gpu/gpu_io.h \
gravityon/gpu/gpu_cmd.h gravityon/gpu/gpu_wire.h
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -Doxalyn_GPU_SIM -Doxalyn_SIMULATOR \
		-o $@ simulator/sim.c simulator/framebuffer.c simulator/gdb_stub.c \
		gravityon/gpu/gpu_sim.c $(LDLIBS)

# ── GUI Simülatör Hedefleri ────────────────────────────────────────────
# OS çalışırken gerçek zamanlı framebuffer penceresi açar.
#
#   make sim-gui        → SDL2 (tavsiye edilen: Windows + Linux)
#   make sim-gui-x11    → X11/Xlib doğrudan (Linux, SDL2 yoksa)
#   make sim-gui-win32  → Windows GDI (SDL2 yoksa, MinGW ile derle)
#
# Kurulum (SDL2):
#   Linux   : sudo apt install libsdl2-dev
#   Windows : pacman -S mingw-w64-x86_64-SDL2   (MSYS2/MinGW64)
#
# Kullanım:
#   ./build/sim-gui /tmp/program.bin

SIM_GUI       := $(BUILD_DIR)/sim-gui
SIM_GUI_X11   := $(BUILD_DIR)/sim-gui-x11
SIM_GUI_WIN32 := $(BUILD_DIR)/sim-gui-win32

SIM_GUI_SRCS  := simulator/sim.c simulator/framebuffer.c \
                 simulator/gdb_stub.c simulator/display.c \
                 gravityon/gpu/gpu_sim.c

SIM_GUI_FLAGS := $(CPPFLAGS) $(CFLAGS) \
                 -Doxalyn_GPU_SIM -Doxalyn_SIMULATOR \
                 -DOXALYN_DISPLAY_GUI

.PHONY: sim-gui sim-gui-x11 sim-gui-win32

## SDL2 — çapraz platform (önerilen)
sim-gui: $(SIM_GUI)

$(SIM_GUI): $(SIM_GUI_SRCS) simulator/display.h
	@mkdir -p $(BUILD_DIR)
	$(CC) $(SIM_GUI_FLAGS) -DOXALYN_DISPLAY_SDL2 \
		-o $@ $(SIM_GUI_SRCS) $(LDLIBS) \
		$$(sdl2-config --cflags --libs 2>/dev/null || echo "-lSDL2")
	@echo ">>> GUI simülatör hazır: $@  (SDL2 backend)"
	@echo ">>> Kullanım: $@ <program.bin>"

## X11 — Linux, SDL2 gerekmez
sim-gui-x11: $(SIM_GUI_X11)

$(SIM_GUI_X11): $(SIM_GUI_SRCS) simulator/display.h
	@mkdir -p $(BUILD_DIR)
	$(CC) $(SIM_GUI_FLAGS) -DOXALYN_DISPLAY_X11 \
		-o $@ $(SIM_GUI_SRCS) $(LDLIBS) -lX11
	@echo ">>> GUI simülatör hazır: $@  (X11 backend)"
	@echo ">>> Kullanım: $@ <program.bin>"

## Win32 GDI — Windows, SDL2 gerekmez
sim-gui-win32: $(SIM_GUI_WIN32)

$(SIM_GUI_WIN32): $(SIM_GUI_SRCS) simulator/display.h
	@mkdir -p $(BUILD_DIR)
	$(CC) $(SIM_GUI_FLAGS) -DOXALYN_DISPLAY_WIN32 \
		-mwindows -o $@ $(SIM_GUI_SRCS) $(LDLIBS) -lgdi32 -luser32
	@echo ">>> GUI simülatör hazır: $@  (Win32 GDI backend)"
	@echo ">>> Kullanım: $@ <program.bin>"

$(ASM): asm.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(DBG): dbg.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(HEXDUMP): hexdump.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(COMPILER): compiler/compiler.c compiler/arch.c compiler/arch.h \
		compiler/translator.c compiler/translator.h $(ASM)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ \
		compiler/compiler.c compiler/arch.c compiler/translator.c

$(CC_MINIMAL): compiler/cc.c $(ASM)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ compiler/cc.c

$(BIN2MEM): fpga/bin2mem.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $<

test: $(ASM) $(SIM) $(COMPILER) $(CC_MINIMAL) $(BIN2MEM)
	bash tests/run_tests.sh
	bash tests/compiler_tests.sh
	bash tests/bin2mem_tests.sh
	$(MAKE) gpu_interrupt_test
	$(MAKE) atomic_test
	$(MAKE) cache_perf_test
	$(MAKE) scheduler_verify
	$(MAKE) gpu-kernel-test
	@set -e; tmpdir=$$(mktemp -d); trap 'rm -rf "$$tmpdir"' EXIT; \
	printf '%s\n' 'int main(void) { return 0; }' > $$tmpdir/smoke.c; \
	$(CC_MINIMAL) $$tmpdir/smoke.c -o $$tmpdir/smoke.asm; \
	$(ASM) $$tmpdir/smoke.asm $$tmpdir/smoke.bin; \
	test -s $$tmpdir/smoke.bin

test-kernel:
	$(MAKE) -C kernel test-kernel

gpu-kernel-test:
	$(MAKE) -C gravityon lib-gpu
	$(CC) -I. -std=gnu99 -O2 -Wall -Wextra \
		tests/gpu_kernel_wire_test.c gravityon/libgravityon_gpu.a $(LDLIBS) \
		-o /tmp/oxalyn_gpu_kernel_wire_test
	/tmp/oxalyn_gpu_kernel_wire_test

compiler-test: $(COMPILER)
	bash tests/compiler_tests.sh

bin2mem-test: $(BIN2MEM)
	bash tests/bin2mem_tests.sh

gravityon:
	$(MAKE) -C gravityon all

sim-verilog: cpu.v
	iverilog -o /tmp/oxalyn_cpu_tb cpu.v -DTESTBENCH
	vvp /tmp/oxalyn_cpu_tb

timer-irq-test: cpu.v fpga/timer_irq_tb.v
	iverilog -g2012 -s timer_irq_tb -o /tmp/oxalyn_timer_irq_tb \
	cpu.v fpga/timer_irq_tb.v
	vvp /tmp/oxalyn_timer_irq_tb

uart_interrupt: uart_interrupt_tb uart_irq_tb

uart_interrupt_tb: cpu.v fpga/uart_interrupt_pipeline_tb.v
	iverilog -g2012 -s uart_interrupt_pipeline_tb -o /tmp/oxalyn_uart_interrupt_pipeline_tb \
	cpu.v fpga/uart_interrupt_pipeline_tb.v
	vvp /tmp/oxalyn_uart_interrupt_pipeline_tb

uart_irq_tb: cpu.v fpga/uart_irq_tb.v
	iverilog -g2012 -s uart_irq_tb -o /tmp/oxalyn_uart_irq_tb \
	cpu.v fpga/uart_irq_tb.v
	vvp /tmp/oxalyn_uart_irq_tb

gpu_interrupt_test: cpu.v fpga/gpu_interrupt_test.v
	iverilog -g2012 -s gpu_interrupt_test -o /tmp/oxalyn_gpu_interrupt_test \
		cpu.v fpga/gpu_interrupt_test.v
	vvp /tmp/oxalyn_gpu_interrupt_test

atomic_test: $(ASM) $(SIM)
	@set -e; bin=$$(mktemp /tmp/oxalyn_atomic_XXXXXX.bin); \
	$(ASM) tests/atomic_test.asm $$bin >/dev/null; \
	$(SIM) $$bin -q | tee /tmp/oxalyn_atomic_test.log; \
grep -qE 'port\[  0\].*= *42 ' /tmp/oxalyn_atomic_test.log; \
grep -qE 'port\[  1\].*= *99 ' /tmp/oxalyn_atomic_test.log; \
	rm -f $$bin

cache_perf_test: $(ASM) $(SIM)
	@set -e; bin=$$(mktemp /tmp/oxalyn_cache_XXXXXX.bin); \
	$(ASM) tests/cache_perf_test.asm $$bin >/dev/null; \
	$(SIM) $$bin -q | tee /tmp/oxalyn_cache_perf_test.log; \
grep -qE 'port\[  0\].*= *2 ' /tmp/oxalyn_cache_perf_test.log; \
grep -qE 'port\[  1\].*= *2 ' /tmp/oxalyn_cache_perf_test.log; \
grep -qE 'port\[  2\].*= *99 ' /tmp/oxalyn_cache_perf_test.log; \
	rm -f $$bin

scheduler_verify:
	$(CC) -I. -std=c99 -O2 -Wall -Wextra -DOXALYN_HOST_TEST \
		tests/scheduler_verify.c kernel/scheduler.c kernel/gui_guard.c \
		kernel/hostio.c kernel/kstring.c -o /tmp/oxalyn_scheduler_verify
	/tmp/oxalyn_scheduler_verify

fpga-check: cpu.v fpga/oxalyn_top.v fpga/oxalyn_bram.v fpga/uart.v fpga/seg7_ctrl.v gravityon/fpga/gpu_core.v
	iverilog -g2012 -s oxalyn_top -o /tmp/oxalyn_top \
	fpga/oxalyn_top.v cpu.v fpga/oxalyn_bram.v fpga/uart.v \
	fpga/seg7_ctrl.v gravityon/fpga/gpu_core.v

synth-check: cpu.v
	@echo "==> Yosys sentez kontrolü başlıyor..."
	yosys -Q -p "read_verilog cpu.v; synth -top oxalyn_cpu -flatten; stat"

formal: cpu.v formal/oxalyn_props.v
	@echo "==> Yosys formal doğrulama başlıyor (depth=10)..."
	yosys -Q -p "read_verilog -formal cpu.v formal/oxalyn_props.v; prep -top oxalyn_cpu_formal; flatten; async2sync; sat -prove-asserts -seq 10 -show-inputs -show-outputs"

clean:
	rm -rf $(BUILD_DIR)
	$(MAKE) -C gravityon clean

help:
	@echo "make              — assembler, debugger, hexdump ve Gravityon simülatörü"
	@echo "make simulator    — sadece Gravityon destekli simülatör"
	@echo "make compiler     — mimari algılayan Oxalyn compiler"
	@echo "make cc           — minimal C→Oxalyn assembly derleyicisi"
	@echo "make bin2mem      — FPGA .bin→.mem dönüştürücüsü"
	@echo "make test         — tests/ içindeki testleri çalıştır"
	@echo "make gravityon    — Gravityon kütüphanesi ve örnekleri"
	@echo "make voxel-demo   — world + greedy mesher + Gravityon PPM demosu"
	@echo "make clean        — derlenmiş çıktıları temizle"
	@echo ""
	@echo "Görüntü: build/sim program.bin --frame-out frame.ppm"
	@echo "Önizleme: build/sim program.bin --frame-ascii"