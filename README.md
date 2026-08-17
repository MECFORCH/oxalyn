# Oxalyn-64

Oxalyn-64, öğrenim ve deney amaçlı, sıfırdan tasarlanmış 64-bit bir CPU
mimarisidir. Proje şunları içerir:

- **`simulator/`** — C ile yazılmış Oxalyn-64 simülatörü (kesmeler, CSR,
  MPU/güvenlik uzantısı, GPIO, UART ve Gravityon GPU dahil)
- **`asm.c`** — İki geçişli assembler (`.asm` → `.bin`)
- **`dbg.c`** — Basit adım adım hata ayıklayıcı (step debugger)
- **`compiler/`** — mimari algılama ve Oxalyn backend'i olan genişletilebilir
  compiler çekirdeği
- **`cpu.v`** — Gerçek donanım hedefli Verilog RTL (`oxalyn_cpu`), FPGA'ya
  sentezlenebilir (bkz. `fpga/`)
- **`gravityon/`** — Vulkan ilhamlı yazılım GPU API'si (texture, rasterizer,
  shader, framebuffer)
- **`kernel/`** — Oxalyn-64 üzerinde çalışan deneysel işletim sistemi çekirdeği
- **`tests/`** — Tüm `.asm` test ve benchmark dosyaları + regresyon betikleri
- **`SPEC.md`** — Tam ISA spesifikasyonu (opcode tablosu, kodlama, FLAGS,
  bellek haritası)
- **`SECURITY.md`** — Güvenlik uzantısı (MPU, ayrıcalık modları, trap'ler)

---

## Mimari Özeti

| Özellik | Değer |
|---|---|
| Veri yolu | 64-bit |
| Register sayısı | 32 (R0 sabit 0, R31 = SP) |
| Komut uzunluğu | Sabit 32-bit |
| Bellek | 65536 kelime (word-addressed, 512 KB) |
| G/Ç portu | 256 adet 64-bit |
| Ayrıcalık modları | Machine / Supervisor / User |

Ayrıntılar için `SPEC.md` dosyasına bakın.

---

## Hızlı Başlangıç

```bash
make            # simulator, asm, dbg, hexdump derle
make test       # regresyon testlerini çalıştır
make sim-verilog# cpu.v RTL testbench'ini çalıştır (iverilog gerekir)

build/asm tests/test.asm /tmp/program.bin
build/sim /tmp/program.bin
```

Adım adım hata ayıklama:

```bash
build/dbg /tmp/program.bin
```

---

## Compiler

```bash
make compiler
build/compiler program.asm -o build/program
build/compiler --inspect program.elf   # dosya incele
build/compiler --list-arch             # desteklenen mimariler
```

Regresyon testleri:

```bash
make compiler-test
```

Compiler; x86-64, ARM64 ve RISC-V64 assembly'lerinin temel komutlarını
Oxalyn-64 formatına çevirebilir.

---

## Görüntü Sistemi

Simülatör, Gravityon yazılım GPU'sunu harici grafik kütüphanesi olmadan
çalıştırır:

```bash
build/sim program.bin --frame-out frame.ppm   # PPM olarak kaydet
build/sim program.bin --frame-ascii           # terminal önizlemesi
```

---

## GDB ile Hata Ayıklama

Simülatör, GDB Remote Serial Protocol (RSP) üzerinden tam GDB desteği sunar:

```bash
# Terminalde simülatörü GDB modunda başlat
build/sim program.bin --gdb 1234

# Ayrı terminalde GDB bağlan
gdb-multiarch program.elf -ex "target remote :1234"
```

### Desteklenen GDB komutları

| Komut | Açıklama |
|---|---|
| `break *0xADDR` | Belirtilen adreste breakpoint ekle |
| `watch *0xADDR` | Yazma watchpoint (adrese yazılınca dur) |
| `rwatch *0xADDR` | Okuma watchpoint |
| `awatch *0xADDR` | Erişim watchpoint (okuma + yazma) |
| `stepi` | Tek komut adımla |
| `continue` | Breakpoint/watchpoint'e kadar çalıştır |
| `info registers` | Tüm register'ları göster |
| `x/8xg 0xADDR` | Bellek içeriğini hexdump olarak göster |

### Watchpoint Entegrasyonu (sim.c)

`simulator/sim.c` içindeki `OP_LOAD` ve `OP_STORE` handler'ları
`gdb_watchpoint_check()` çağırmaktadır. GDB'den `watch` komutu verildiğinde,
simülatör o adrese erişen her `LOAD`/`STORE` komutunu yakalayıp GDB'ye
`T05watch:<addr>;` bildirimi gönderir.

---

## Gravityon GPU API

`gravityon/` dizini, Vulkan ilhamlı bir yazılım GPU API'si içerir:

```
Instance → Device → CommandBuffer → Submit
```

### Texture Yükleme (PNG / BMP)

Dosyadan doğrudan `GravImage` oluşturma:

```c
#include "gravityon/gravityon.h"

GravImage tex;

// PNG yükle (stb_image — sıfır dış bağımlılık)
gravLoadImagePNG(device, "assets/texture.png", &tex);

// BMP yükle (24-bit ve 32-bit sıkıştırılmamış DIB)
gravLoadImageBMP(device, "assets/sprite.bmp", &tex);

// Sampler ile kullan
GravSampler sampler;
gravCreateSampler(device, &info, &sampler);
float color[4];
gravSampleTexture(sampler, tex, u, v, color);

// Bitince serbest bırak
gravDestroyImage(device, tex);
```

`stb_image.h` (`gravityon/stb_image.h`) tek dosya, public domain bir
kütüphanedir — sistem kütüphanesi kurulumu gerekmez.

**Desteklenen formatlar:**

| Format | Detay |
|---|---|
| PNG | 8-bit/kanal, RGB ve RGBA (tüm filtre tipleri) |
| BMP | 24-bit BGR ve 32-bit BGRA, sıkıştırılmamış DIB |

Derleme:

```bash
# Gravityon kütüphanesini derle
make -C gravityon

# Kendi programınla bağla
gcc myapp.c -Igravityon -Lgravityon -lgravityon -lm -o myapp
```

---

## Trap Handler ve Kesme Yönetimi

### trap.asm — MEPC Kaydetme/Geri Yükleme

`tests/trap.asm` dosyası, gerçek donanımda güvenli kesme yönetimi için
eksiksiz bir şablon sunar:

```asm
isr_entry:
    ; Kullanılan register'ları kaydet
    PUSH R1
    PUSH R2

    ; MEPC'yi stack'e kaydet (kritik!)
    ; İç içe trap/ECALL gelirse MEPC ezilir; önce saklıyoruz.
    CSRR R1, 1       ; R1 = MEPC
    PUSH R1          ; MEPC → stack

    ; ... ISR gövdesi ...

    ; MEPC'yi geri yükle
    POP  R1
    CSRW R1, 1       ; CSR[1] = MEPC

    ; Register'ları geri yükle
    POP  R2
    POP  R1

    ERET             ; MEPC adresine dön
```

**Neden MEPC kaydedilmeli?**
- ISR içinde başka bir trap veya `ECALL` gerçekleşirse `MEPC` ezilir.
- Kaydedilmezse `ERET`, yanlış (bozulmuş) adrese döner.
- İç içe (nested) kesme desteği eklendiğinde zorunludur.

**Test dosyası:** `tests/trap.asm`  
**Timer test (düzeltilmiş):** `tests/irq_timer_test.asm`

---

## Test Dosyaları

Tüm test ve benchmark `.asm` dosyaları `tests/` klasöründedir:

| Dosya | Açıklama |
|---|---|
| `test.asm` | Temel komut seti testi |
| `test_new_isa.asm` | Yeni ISA özellikleri testi |
| `test_pseudo.asm` | Pseudo-instruction testi |
| `muldiv_test.asm` | MUL/DIV ve sıfıra bölme testi |
| `li64_test.asm` | 64-bit immediate yükleme testi |
| `mmu_test.asm` | MMU/MPU erişim testi |
| `sec_test.asm` | Güvenlik uzantısı testi |
| `sec_trap_test.asm` | Güvenlik trap testi |
| `irq_timer_test.asm` | Donanım timer kesmesi (MEPC save/restore **düzeltildi**) |
| `trap.asm` | Genel trap handler şablonu (MEPC kaydetme/geri yükleme) |
| `gpio_irq_test.asm` | GPIO kesmesi testi |
| `supervisor_irq_test.asm` | Supervisor modu kesme testi |
| `clock_test.asm` | Clock/cycle sayacı testi |
| `gpu_render_test.asm` | GPU render pipeline testi |
| `gpu_triangle_test.asm` | GPU üçgen rasterizer testi |
| `interactive_sum.asm` | UART etkileşimli toplama örneği |
| `bench.asm` | Temel performans benchmark |
| `bench_big.asm` | Büyük döngü benchmark |

Test çalıştırma:

```bash
# Tüm regresyon testleri
make test

# Tek bir test dosyası
build/asm tests/irq_timer_test.asm /tmp/irq.bin
build/sim /tmp/irq.bin -q
```

---

## FPGA

`fpga/` klasörü, `cpu.v`'yi Xilinx Basys3 (Artix-7) FPGA'ya bağlayan
üst modülü (`oxalyn_top.v`), block RAM'i ve 7-segment sürücüsünü içerir.

Ayrıntılar: `fpga/README.md`

---

## Katkıda Bulunma

Bkz. [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Lisans

Lisans bilgisi için depo kökündeki lisans dosyasına bakın.
