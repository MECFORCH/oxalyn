# Oxalyn-64 Toolchain Kurulum Kılavuzu

Bu belge, Oxalyn-64 projesini sıfırdan derleyebilmek için gereken araçların
nasıl kurulacağını ve kullanılacağını açıklar.

---

## Gereksinimler

| Araç | Sürüm | Amaç |
|------|-------|------|
| GCC | ≥ 11 | Host binary + kernel derleyici |
| Make | ≥ 4.0 | Build sistemi |
| iverilog | ≥ 11 | Verilog simülasyonu (opsiyonel) |
| Yosys | ≥ 0.25 | Sentez kontrolü (opsiyonel) |

---

## Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y gcc make iverilog yosys
```

## Windows (MSYS2 / MinGW64)

```bash
pacman -Syu
pacman -S mingw-w64-x86_64-gcc make
# GUI için SDL2:
pacman -S mingw-w64-x86_64-SDL2
```

## macOS

```bash
brew install gcc make icarus-verilog yosys
```

---

## Projeyi Klonla ve Derle

```bash
git clone https://github.com/mecforch/oxalyn.git
cd oxalyn
make all           # sim + asm + dbg + hexdump araçlarını derle
```

---

## Kernel Host Binary

Kernel'i PC'nizde (Linux/Windows/macOS) çalıştırmak için:

```bash
cd kernel
make host           # hilal_bis_host binary'sini derle
./hilal_bis_host    # çalıştır (login: root / root)
```

**Ne yapar?**
Gerçek Oxalyn donanımı yerine standart C stdio kullanarak kernel'i PC'de
çalıştırır. MMIO erişimleri, framebuffer ve UART hepsi simüle edilir.

---

## Oxalyn Binary (Simülatör için)

Gerçek Oxalyn ISA ile kernel'i derlemek:

```bash
cd kernel
make oxalyn        # WASM → Oxalyn asm → boot-linked .bin → .mem
```

Kernel C frontend'inin tamamını gerçek bir freestanding ara hedefe almak için:

```bash
cd kernel
make oxalyn-objects  # 30/30 kernel/*.c → ayrı WASM object
make oxalyn-wasm     # object'leri tek geçerli WASM modülünde linkle
```

Bu çıktı (`build/kernel-wasm/hilal_bis.wasm`) kernel'in tüm C kaynaklarının
Clang tarafından işlendiğini ve linker ile birleştirildiğini doğrular. WASM
bir ara hedeftir; Oxalyn komut kelimeleri değildir ve simülatöre `.bin` diye
verilemez. `make oxalyn` WASM modülünü gerçek Oxalyn assembly'ye çevirir,
`tools/oxalyn_link.py` ile `_start` boot wrapper'ını ve `_wasm_start`
girişini birleştirir, ardından gerçek `.bin` üretir. Son `bin2mem` adımı
65.536 word fiziksel bellek kapasitesini aşan image'ları kesmeden reddeder.

Mevcut kernel için doğrulanmış sonuç:

```text
198082 Oxalyn instruction word → 792328 byte .bin
bin2mem: 65537 word > 65536 word kapasitesi → güvenli ret
```

Bu nedenle tam kernel için henüz `.mem` veya FPGA boot image'ı üretilmez.
Küçük linked boot fixture'ı ise `.bin` ve simulator zincirinden HALT'a kadar
geçer. Image boyutu küçültülmeden veya fiziksel bellek düzeni genişletilmeden
gerçek kernel boot'u başarı olarak raporlanmamalıdır.

Üretilen örnek binary'yi simülatörde test:

```bash
cd ..
build/sim /tmp/program.bin
# Beklenen: programın tanımladığı port çıktısı
```

### Oxalyn Cross-Toolchain

Oxalyn ISA'sı standart GCC tarafından desteklenmez. Depoda iki ayrı araç
vardır: `build/compiler` mimari algılama ve sınırlı assembly çevirisi yapar;
`build/cc` ise `compiler/cc.c` içindeki desteklenen minimal C alt kümesini
Oxalyn assembly'ye çevirir. İkisi de doğrudan host ELF'i üretmez; assembly
çıktısı ayrıca Oxalyn assembler'dan geçirilmelidir:

```bash
make -C .. cc
build/cc path/to/program.c -o /tmp/program.asm
build/asm /tmp/program.asm /tmp/program.bin
build/sim /tmp/program.bin
```

### Kernel GUI → Gravityon wire adapterı

`kernel/gpu_hw.c`, kernel'in kabul edilmiş çizim isteğini Gravityon ring
protokolüne çevirir. Ortak `gravityon/gpu/gpu_wire.h` sözleşmesi:

- GPU portlarını, ring tabanını ve boyutunu tanımlar.
- 2D komut kimliklerini (`pixel`, `line`, `rect`, `circle`,
  `fill-circle`, `clear`, `present`) tanımlar.
- Her 2D payload'ın ilk 32-bit kelimesini kernel tarafından doğrulanmış
  owner PID olarak taşır; Gravityon bu PID'yi güvenlik sınırı olarak değil,
  muhasebe/izleme metadata'sı olarak kaydeder.

`make gpu-kernel-test`, gerçek Oxalyn word-RAM ring düzeninde bu paketleri
Gravityon GPU simülatörüne vererek framebuffer pikselini, frame completion'ı
ve owner sayacını doğrular. Test, payload içinde owner olmadan gelen 2D
paketleri kabul etmez. Bu yol simulator'ın senkron doorbell davranışını
doğrular; gerçek donanımda ring wrap-around ve backpressure hâlâ ayrıca
doğrulanmalıdır.

`build/cc`, gerçek bir C→Oxalyn assembly backend'idir; çıktı assembler'dan
geçirilmeden binary olarak kabul edilmez. Doğrulanmış alt küme; `int`/`char`
fonksiyonları, en fazla dört parametre, yerel değişkenler, aritmetik ve
karşılaştırmalar, mantıksal/bit işlemleri, `if`, `while`, `for`, atama,
fonksiyon çağrısı, `return` ve postfix `++/--` ifadelerini kapsar. C çağrı ABI'si
R1–R4 argüman, R7 dönüş değeri ve JALR/R31 dönüş adresi kullanır.

Minimal backend'de global değişkenler, pointer/memory erişimi ve gerçek data
section/linker akışı henüz doğrulanmadığı için backend bunları açıkça reddeder.
Kernel'in tamamı için C frontend artık WASM ara hedefine kadar çalışır; ancak
güvenilir C→Oxalyn kernel/runtime/linker akışı henüz yoktur.
Bu nedenle `make oxalyn`, host ELF'ini Oxalyn `.bin` olarak paketlemek yerine
bilinçli olarak hata verir. El yazımı assembly regresyonu için:

```bash
make -C .. tools
build/asm tests/test_new_isa.asm /tmp/test_new_isa.bin
build/sim /tmp/test_new_isa.bin
```

---

## FPGA (Basys3 / Vivado)

```bash
# 1. Desteklenen bir Oxalyn assembly binary'sini .mem formatına dönüştür:
build/bin2mem /tmp/program.bin fpga/program.mem

# 2. Vivado ile sentez:
cd fpga
vivado -mode batch -source vivado_build.tcl

# 3. Basys3'e yükle:
#    Hardware Manager → Program Device → oxalyn_top.bit
```

UART bağlantısı (115200 baud, 8N1):

```bash
minicom -b 115200 -D /dev/ttyUSB0
# ya da:
screen /dev/ttyUSB0 115200
```

---

## Tüm Testleri Çalıştır

```bash
make test                          # assembler regresyon testleri
make test-kernel                   # kernel unit testleri
make -C kernel typecheck           # host/freestanding typecheck
```

`make test`, assembler/simülatör regresyonlarının yanında compiler testlerini
de ve `bin2mem` FPGA format testlerini çalıştırır. Ham FPU opcode testi,
`.bin` dosyalarının big-endian 32-bit kelime formatını kullanır; el ile binary
hazırlarken aynı byte sırasına uyun.

---

## Sorun Giderme

| Hata | Çözüm |
|------|-------|
| `Bilinmeyen opcode: 0x30` | FPU opcode'u henüz etkin değildir; FPU destekli image kullanmayın |
| `Segmentation fault` (host) | Eski binary — `make clean && make host` |
| `SDL2 not found` | `pacman -S mingw-w64-x86_64-SDL2` (Windows) |
| Login çalışmıyor | Enter'dan sonra boşluk eklemeyin; şifre: `root` |
