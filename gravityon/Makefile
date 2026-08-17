# ============================================================================
# GRAVITYON GPU API — Makefile
# ============================================================================

CC      = gcc
CFLAGS  = -std=gnu99 -O3 -march=native -funroll-loops -Wall -Wextra -pthread -I.
DBGFLAGS = -std=gnu99 -O0 -g -Wall -Wextra -I. -lm
LDLIBS  = -lm -pthread

# GPU backend ile derleme (Oxalyn64 GPU simülatörü entegrasyonu)
GPU_SRC  = gpu/gpu_sim.c gpu/gpu_backend.c
GPU_CFLAGS = -DGRAVITYON_GPU_BACKEND -Doxalyn_SIMULATOR -I.

SRC     = gravityon.c gravityon_fb.c
OBJ     = gravityon.o gravityon_fb.o

# GPU destekli nesneler
GPU_OBJ = gravityon_gpu.o gravityon_fb.o gpu/gpu_sim.o gpu/gpu_backend.o

# Paylaşılan kütüphane
LIBNAME     = libgravityon.a
LIBNAME_GPU = libgravityon_gpu.a

# Örnekler
EXAMPLES = triangle cube oxalyn_os

.PHONY: all lib lib-gpu examples benchmark clean test

all: lib lib-gpu examples

# ─── Statik kütüphane (software rasterizer) ───────────────────────────────
lib: $(LIBNAME)

$(LIBNAME): $(OBJ)
	ar rcs $@ $^
	@echo "[Gravityon] $(LIBNAME) oluşturuldu."

gravityon.o: gravityon.c gravityon.h
	$(CC) $(CFLAGS) -c gravityon.c -o gravityon.o

gravityon_fb.o: gravityon_fb.c gravityon_fb.h gravityon.h
	$(CC) $(CFLAGS) -c gravityon_fb.c -o gravityon_fb.o

# ─── Statik kütüphane (GPU backend) ───────────────────────────────────────
lib-gpu: $(LIBNAME_GPU)

$(LIBNAME_GPU): $(GPU_OBJ)
	ar rcs $@ $^
	@echo "[Gravityon] $(LIBNAME_GPU) oluşturuldu (GPU backend)."

gravityon_gpu.o: gravityon.c gravityon.h
	$(CC) $(CFLAGS) $(GPU_CFLAGS) -c gravityon.c -o gravityon_gpu.o

gpu/gpu_sim.o: gpu/gpu_sim.c gpu/gpu_sim.h gpu/gpu_bytecode.h gpu/gpu_io.h gpu/gpu_cmd.h gpu/gpu_wire.h gravityon.h
	$(CC) $(CFLAGS) $(GPU_CFLAGS) -c gpu/gpu_sim.c -o gpu/gpu_sim.o

gpu/gpu_backend.o: gpu/gpu_backend.c gpu/gpu_sim.h gravityon.h
	$(CC) $(CFLAGS) $(GPU_CFLAGS) -c gpu/gpu_backend.c -o gpu/gpu_backend.o

# ─── Örnekler ─────────────────────────────────────────────────────────────
examples: $(EXAMPLES)

benchmark: tests/benchmark.c $(LIBNAME)
	$(CC) $(CFLAGS) $< -L. -lgravityon $(LDLIBS) -o $@
	@echo "[Gravityon] benchmark derlendi."

triangle: examples/triangle.c $(LIBNAME)
	$(CC) $(CFLAGS) $< -L. -lgravityon $(LDLIBS) -o $@
	@echo "[Gravityon] 'triangle' derlendi."

cube: examples/cube.c $(LIBNAME)
	$(CC) $(CFLAGS) $< -L. -lgravityon $(LDLIBS) -o $@
	@echo "[Gravityon] 'cube' derlendi."

oxalyn_os: examples/oxalyn_os.c $(LIBNAME)
	$(CC) $(CFLAGS) $< -L. -lgravityon $(LDLIBS) -o $@
	@echo "[Gravityon] 'oxalyn_os' derlendi."

# ─── Debug derlemesi ──────────────────────────────────────────────────────
debug: gravityon.c gravityon.h
	$(CC) $(DBGFLAGS) -c gravityon.c -o gravityon_dbg.o
	ar rcs libgravityon_dbg.a gravityon_dbg.o
	@echo "[Gravityon] Debug kütüphanesi hazır."

# ─── Hızlı test: triangle çalıştır ───────────────────────────────────────
test: triangle
	./triangle
	@echo "[Gravityon] Test tamamlandı. output_triangle.ppm / .bmp incelenebilir."

# ─── Temizlik ─────────────────────────────────────────────────────────────
clean:
	rm -f $(OBJ) $(GPU_OBJ) gravityon_dbg.o $(LIBNAME) $(LIBNAME_GPU) libgravityon_dbg.a
	rm -f $(EXAMPLES) benchmark $(addsuffix .exe,$(EXAMPLES)) benchmark.exe
	rm -f output_*.ppm output_*.bmp gpu_output.ppm
	@echo "[Gravityon] Temizlendi."

# ─── Yardım ───────────────────────────────────────────────────────────────
help:
	@echo "Hedefler:"
	@echo "  all       — kütüphane + GPU kütüphane + örnekler (varsayılan)"
	@echo "  lib       — sadece libgravityon.a (software rasterizer)"
	@echo "  lib-gpu   — libgravityon_gpu.a (GPU simülatör backend)"
	@echo "  examples  — triangle ve cube örnekleri"
	@echo "  benchmark — tekrarlı render ölçümü (GRAV_THREADS / GRAV_BENCH_FRAMES)"
	@echo "  test      — triangle'ı derle ve çalıştır"
	@echo "  debug     — debug bayraklarıyla derle"
	@echo "  clean     — tüm üretilmiş dosyaları sil"
