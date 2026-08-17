# Oxalyn-64 / HILAL_BIS Yol Haritası Durumu

Bu rapor, `docs/` içindeki yol haritası ile mevcut kaynak ağacının
karşılaştırılması sonrasında hazırlanmıştır.

## Bu çalışmada tamamlananlar

- GitHub deposu `mecforch/oxalyn` klonlandı ve kaynak ağaç doğrulandı.
- Platform soyutlama katmanı (`kernel/platform.h` ve `kernel/mmio.h`) mevcut
  ve host/donanım MMIO, çıktı, UART, panik ve atomik işlem sınırlarını
  merkezi makrolarla sağlıyor. Kernel sürücülerinin çıktı ve giriş yolları
  `KPRINT`, `KPUTCHAR` ve `KGETCHAR` üzerinden geçiyor; framebuffer erişimi de
  `platform_framebuffer()` ile tek sınıra taşındı.
- Host kernel framebuffer'ı `gpu_present()` ile `framebuffer.raw` olarak
  RGBA8 biçiminde dışa aktarabiliyor; splash, yükleme çubuğu, masaüstü,
  pencere yöneticisi ve syscall çizimleri bu sunum noktasını çağırıyor.
- Simülatör GUI'si CPU çalışırken framebuffer'ı düzenli aralıklarla pencereye
  taşıyor; `--frame-out` ise Gravityon GPU framebuffer'ını PPM olarak
  kaydediyor.
- GUI kernel sınırı eklendi: çizim isteklerinde komut/koordinat doğrulaması,
  süreç başına işlem ve piksel kotası, hata sayacı ve üç hatada GUI
  karantinası var. Karantina kernel'i durdurmaz; `gui reset` ile süreç
  yeniden etkinleştirilebilir.
- `read_line()` içinde `\r` ve sondaki boşlukların temizlenmesi mevcut;
  CRLF login senaryosu korunuyor.
- Kernel host unit-test altyapısı mevcut ve çalışıyor:
  42 test geçti, 0 hata.
- Assembler/simülatör regresyonları mevcut:
  4 test geçti, 0 hata.
- Compiler regresyon testi düzeltildi. Ham FPU opcode testi artık simülatörün
  gerçek big-endian binary formatını kullanıyor ve illegal-instruction trap'ini
  doğru biçimde doğruluyor:
  8 test geçti, 0 hata.
- Gerçek minimal C backend'i `C → Oxalyn assembly → big-endian .bin →
  simulator` zincirinde doğrulandı: fonksiyon çağrısı/ABI, `while`/postfix
  `++`, karşılaştırma, koşul, mantıksal ifade ve aritmetik regresyonları var.
- Global değişkenler data section/linker olmadığı için sahte adres üretmek
  yerine açıkça reddediliyor; başarısız C derlemesi `.asm` çıktısını bırakmıyor.
- FPGA `bin2mem` yardımcı aracı için big-endian okuma, 32/64-bit çıktı,
  kapasite aşımı ve kısmi kelime regresyonları eklendi:
  4 test geçti, 0 hata.
- Kernel host ve freestanding sözdizimi kontrolleri geçti.
- Kernel'in 30 C kaynağının tamamı Clang freestanding WASM frontend'i ile ayrı
  object'lere derleniyor ve `wasm-ld` ile tek geçerli WASM modülünde
  (`kernel_main` export'u ve data section dahil) linkleniyor.
- Kernel GUI çizimleri için Gravityon'a açık bir adapter eklendi: owner PID
  metadata'sı taşıyan 2D pixel/line/rect/circle/clear/present paketleri ortak
  wire header üzerinden simulator GPU'suna ulaşıyor. Ring, framebuffer,
  `present` sayısı ve owner muhasebesi bağımsız entegrasyon testiyle doğrulanıyor.
- WASM→Oxalyn çeviricisi desteklenmeyen opcode'ları artık `NOP` olarak
  yutmuyor; açık hata verip kısmi `.asm`/`.bin` çıktısını temizliyor.
- Gerçek WASM→Oxalyn assembly backend'i ve boot linker zinciri eklendi:
  `_start` stack kurulumu, `_wasm_start` çağrısı, gerçek big-endian `.bin`
  üretimi ve fiziksel kapasiteyi kesmeden reddeden `.mem` paketleme adımı
  doğrulandı.
- Kısa etiket dalları gerçek göreli offset ile, uzak dallar uzun
  `JALR` formuyla indirgeniyor; iki assembler geçişinde sabit instruction
  sayısı korunuyor. ISA, compiler ve bin2mem regresyonları 4/4 + 12/12 + 4/4
  geçti.
- Toolchain, ISA, bellek haritası, boot akışı, Gravityon ve katkı belgeleri
  zaten mevcut; toolchain belgesine binary byte sırası ve test kapsamı notu
  eklendi.
- UART RX/TX seviye kesmeleri CPU RTL, FPGA UART/top-level mux ve C
  simülatöründe etkinleştirildi. RX için planlı olay testi, UART durum portu,
  port çakışması çözümü ve RX/TX MCAUSE ayrımı eklendi.
- CI tanımı; C regresyonları, kernel testleri, Verilog, sentez ve formal
  doğrulama adımlarını içeriyor.

## Henüz tamamlanmamış ana işler

| Alan | Mevcut durum | Devam noktası |
|---|---|---|
| L1 cache | `cpu_cache.v` içinde bağımsız I/D cache modülleri var | `cpu.v` pipeline bellek arayüzüne bağla, stall/ack protokolünü doğrula |
| FPU | `0x30` rezerve; assembler ve simülatör bilinçli olarak reddediyor | IEEE-754 single-precision sözleşmesini belirle, sonra simulator ve RTL'yi birlikte ekle |
| Sanal bellek | Simulator tarafında MPU/MMU davranışı var | RTL'de SATP tabanlı sanal-fiziksel çeviri ve page table yürütmesi ekle |
| Native C kernel build | 30/30 C kaynağı WASM object + linked WASM'a, ardından gerçek Oxalyn assembly ve `.bin` çıktısına dönüşüyor; `.mem` 65.536-word sınırında reddediliyor | Image boyutunu 65.536 word altına indir, data/BSS relocation ve gerçek boot fixture'ını tamamla |
| Çok çekirdek | Spinlock/IPI hazırlığı var | CPU instansları, cache coherency, scheduler ve simülasyon desteğini ekle |
| FPGA demo | Basys3 hedefi, `bin2mem`, UART ve örnek program mevcut | Güncel kernel binary ile gerçek kart boot demosunu doğrula ve kaydet |

## Doğrulama sonucu

Başarılı:

```text
make test                         → assembler/simülatör + compiler backend/regresyonları + bin2mem
make test-kernel                  → 42/42 kernel testi
make -C kernel typecheck          → host + freestanding typecheck geçti
make -C kernel oxalyn-objects     → 30/30 kernel C modülü derlendi
make -C kernel oxalyn-wasm        → geçerli linked WASM + kernel_main export'u
make -C kernel oxalyn              → gerçek linked `.bin`; mevcut kernel kapasite nedeniyle `.mem` adımında reddedilir
make kernel-oxalyn-link-test       → küçük boot wrapper → `.bin` → simulator fixture'ı
make build                        → araçlar ve host kernel derlendi
make -C kernel test-gui-guard     → GUI hata karantinası testleri
make gpu-kernel-test              → owner metadata + Gravityon framebuffer wire testi
```

Bu çalışma ortamında `iverilog` ve `yosys` kurulu olmadığı için şu kontroller
çalıştırılamadı:

```text
make sim-verilog
make synth-check
make formal
```

Dolayısıyla mevcut güvenilir durak şudur: **host araçları, minimal C akışı,
kernel'in tamamı için WASM frontend/linker ara akışı, gerçek
WASM→Oxalyn backend'i, boot wrapper'lı `.bin`, kernel testleri,
kernel→Gravityon 2D wire adapterı ve belgeler doğrulanmıştır; tam kernel'in
65.536-word fiziksel belleğe sığdırılması, `.mem` üretimi/gerçek boot,
RTL cache/FPU/MMU entegrasyonu ve gerçek donanım ring
backpressure/wrap-around davranışı sonraki aşamadadır.**
