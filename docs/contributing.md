# Oxalyn-64 Katkı Kılavuzu

Projeye hoş geldiniz! Bu belge kod gönderme sürecini, kodlama standartlarını
ve geliştirme ortamı kurulumunu açıklar.

---

## Hızlı Başlangıç

```bash
git clone https://github.com/mecforch/oxalyn.git
cd oxalyn
make all         # tüm araçları derle
make test        # regresyon testlerini çalıştır
cd kernel && make test-kernel   # kernel unit testleri
```

---

## Depo Yapısı

```
oxalyn/
├── kernel/          C kernel (HILAL_BIS)
│   ├── kernel.c/h   Çekirdek başlangıcı
│   ├── memory.c/h   Heap tabanlı bellek yönetimi (kmalloc/kfree)
│   ├── scheduler.c  İşlemci zamanlayıcısı
│   ├── auth.c       Kullanıcı kimlik doğrulama
│   ├── filesystem.c Dosya sistemi
│   ├── platform.h   Platform soyutlama katmanı ★ YENİ
│   ├── spinlock.c   Spinlock yardımcıları (çok çekirdek hazırlığı)
│   └── mmio.h       MMIO soyutlaması
├── simulator/
│   ├── sim.c        Yazılım simülatörü (MMU/MPU dahil; FPU yok)
│   └── sim.h
├── compiler/
│   ├── cc.c         Minimal C→Oxalyn derleyici ★ YENİ
│   ├── compiler.c   Mimari çevirici
│   └── arch.h       ISA tanımları
├── tests/
│   ├── test_framework.h   Unit test altyapısı ★ YENİ
│   ├── test_kernel.c      Kernel unit testleri ★ YENİ
│   ├── run_tests.sh       Entegrasyon testleri
│   ├── compiler_tests.sh  Derleyici testleri
│   └── bin2mem_tests.sh   FPGA binary format testleri
├── docs/            Dokümantasyon
├── fpga/            FPGA kaynak dosyaları (Verilog, XDC, skriptler)
└── cpu.v            5-aşamalı pipeline RTL (cache/MMU/FPU bağlı değil)
```

---

## Kodlama Standartları

### C Kodu (kernel, simülatör, derleyici)

- **Stil:** K&R, 4 boşluk girinti, 80 karakter satır limiti
- **Standart:** C99 (`-std=c99`)
- **Uyarılar:** `-Wall -Wextra` uyarısız derlenmeli
- **Bağımlılık:** Sistem başlıkları yalnızca host test modunda
- **MMIO:** `volatile*` pointer yerine `MMIO_READ/MMIO_WRITE` makroları
- **Çıktı:** `printf` yerine `KPRINT(...)` (platform bağımsız)
- **Giriş:** `uart_getchar/uart_putchar` yerine `KGETCHAR()/KPUTCHAR()`
- **Framebuffer:** doğrudan `FB_ADDR` pointer'ı yerine
  `platform_framebuffer()` kullanın
- **Kare sunumu:** çizim grubunun sonunda `gpu_present()` çağırın; host
  modunda bu çağrı `framebuffer.raw` dışa aktarımını, GUI simülatöründe ise
  periyodik pencere yenilemesini besler
- **GUI güvenliği:** kullanıcı/uygulama çizimlerini doğrudan framebuffer'a
  yazmayın; `sys_gpu_draw()` veya `sys_write(fd=2)` sınırlarını kullanın.
  Geçersiz istekler GUI guard tarafından reddedilir ve tekrar eden hatalarda
  yalnızca GUI karantinaya alınır, kernel panic yapılmaz.
- GUI syscall ABI'sinde `syscall 14`, tek `GuiStatus*` argümanı ile mevcut
  sürecin durumunu okur; `syscall 15` mevcut sürecin GUI kotasını ve hata
  geçmişini sıfırlar. `exec` de bu durumu yeni program için sıfırlar.
- Freestanding hedefte GUI buffer/komut pointer'ları process stack/user
  aralığında (`0x2000..0x7FFF`) olmalıdır; framebuffer ve MMIO adresleri
  istemci buffer'ı olarak kabul edilmez.

```c
/* DOĞRU */
MMIO_WRITE(SND_PORT_CTRL, 1);
KPRINT("Ses başlatıldı\n");
KPUTCHAR('>');
volatile uint32_t *fb = platform_framebuffer();

/* YANLIŞ */
*(volatile uint64_t*)0x40 = 1;
printf("Ses başlatıldı\n");
```

### Verilog (RTL)

- **Stil:** 4 boşluk girinti, modül başına yorum bloğu
- **Zamanlama:** `timescale 1ns / 1ps`
- **Reset:** Aktif düşük `rst_n`
- **Port isimleri:** alt çizgi ile ayrılmış lowercase

### Assembly (`.asm`)

- **Register prefix:** `R0`–`R31` (büyük R)
- **Yorum:** `;` ile başlar
- **Label:** küçük harf, `_` ile ayrılmış (`dongu:`, `_if_else_1:`)
- **Immediate:** decimal veya `0x` hex

---

## Test Yazma

### Kernel Unit Testleri

`tests/test_kernel.c` dosyasına yeni bir test fonksiyonu ekleyin:

```c
static void test_memory_alloc(void)
{
    TEST_BEGIN("kmalloc/kfree — ayrılan bellek kullanılabilir olmalı");
    void *ptr = kmalloc(64);
    ASSERT_NE(ptr, NULL);
    ((unsigned char *)ptr)[0] = 0xA5;
    ASSERT_EQ(((unsigned char *)ptr)[0], 0xA5);
    kfree(ptr);
}
```

Ardından `main()` içinde çağırın:
```c
TEST_SUITE("MEMORY");
test_memory_alloc();
```

### Regresyon Testleri

`tests/run_tests.sh` dosyasını düzenleyin:
```bash
run_test program.asm expected_output 42
```

---

## Pull Request Süreci

1. `main`'den fork edin ya da dal oluşturun: `git checkout -b ozellik/adi`
2. Değişikliklerinizi yapın
3. Testlerin geçtiğini doğrulayın:
   ```bash
   make all && make test
   make test-kernel
   ```
4. Commit mesajı formatı:
   ```
   [kernel] auth: parola trim düzeltmesi
   [rtl] cpu.v: opcode veya pipeline düzeltmesi
   [sim] MMU/CSR regresyon testi
   [docs] ISA referans kartı eklendi
   ```
5. PR açın, CI yeşil olduğunu doğrulayın

---

## CI Pipeline

GitHub Actions 5 iş çalıştırır:

| İş | Açıklama |
|----|----------|
| build-and-test | `make all && make test` |
| kernel-test | `make -C kernel typecheck` ve `make test-kernel` |
| verilog-sim | `make sim-verilog` (iverilog) |
| synth-check | `make synth-check` (Yosys) |

CI geçmeden PR birleştirilmez.

---

## Bilinen Kısıtlamalar

- `abs_i()` (gpu_cmd.c) şimdilik stub olarak sıfır döndürür — düşük öncelikli
- RAND opcode test modunda `rand()` kullanır, deterministik değil
- FPU opcode'u (`0x30`) rezerve; assembler ve simulator bunu
  bilinçli olarak reddeder. `cpu_cache.v` bağımsız cache bloklarını içerir,
  fakat `cpu.v` top-level pipeline'ına henüz bağlanmış değildir.
- MMU/MPU davranışı simulator tarafındadır; RTL page-table yürütmesi henüz yok
- Çok çekirdek (`NUM_CORES > 1`): spinlock altyapısı hazır, CPU instansiasyonu yapılmamış
- Native C derleyici (`cc.c`): struct/union, typedef, preprocessor desteklenmiyor

---

## İletişim

- Issue açın: GitHub Issues
- Soru / tartışma: GitHub Discussions
- Güvenlik açığı: doğrudan repository sahibine özel mesaj atın
