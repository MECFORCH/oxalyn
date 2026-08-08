# Oxalyn-64 Boot Sırası

Bu belge, donanım sıfırlamasından (reset) kullanıcı oturumu açılmasına kadar
olan adımları adım adım açıklar.

---

## Genel Akış

```
Reset
  │
  ▼
[0x0000] boot.asm
  │  stack kurulumu
  │  BSS temizleme
  │  r29/r30 başlatma
  │
  ▼
kernel_main()  [kernel.c]
  │
  ├─ memory_init()     → heap hazırlığı
  ├─ uart_init()       → seri port
  ├─ gpu_init()        → framebuffer
  ├─ gpu_cmd_init()    → GPU komut kuyruğu
  ├─ fs_init()         → dosya sistemi
  ├─ scheduler_init()  → process scheduler
  ├─ auth_init()       → kullanıcı veritabanı
  ├─ network_init()    → ağ stack
  ├─ usb_hid_init()    → USB HID sürücüsü
  ├─ rtc_init()        → gerçek zamanlı saat
  ├─ sound_init()      → ses sürücüsü
  ├─ wifi_init()       → WiFi sürücüsü
  └─ shell_main()      → boot splash → login
```

---

## Detaylı Adımlar

### 1. Donanım Sıfırlaması

- PC = `0x0000`
- Tüm register'lar = 0
- PRIV = MACHINE (en yüksek ayrıcalık)
- Bellek içeriği belirsiz (SRAM) / sıfır (BRAM)

### 2. Boot Stub (`0x0000`)

```asm
; boot.asm — işlemci sıfırlandıktan hemen sonra çalışır
    LI   R30, 0x2000   ; SP = 0x2000 (kernel stack tabanı)
    LI   R29, 0x2000   ; FP = SP
    CALL R31, kernel_main
    HALT               ; kernel_main dönerse dur
```

**Not:** Stack `0x2000`'de başlar ve aşağı büyür (düşük adreslere doğru).

### 3. `kernel_main()` [kernel.c]

```c
void kernel_main(void)
{
    memory_init();    /* heap bloklarını başlat */
    uart_init();      /* UART: port 0xFF/0xFE */
    gpu_init();       /* framebuffer: 0x8000 temizle */
    gpu_cmd_init();   /* GPU komut kuyruğu */
    fs_init();        /* dosya sistemi: 512 blok × 256 byte */
    scheduler_init(); /* PCB tablosunu sıfırla */
    auth_init();      /* root/guest kullanıcı hash'lerini yükle */
    network_init();   /* NIC simülasyonu */
    usb_hid_init();   /* HID rapor tampon */
    rtc_init();       /* simülatörde: host saatiyle senkronize */
    sound_init();     /* ses portları başlat */
    wifi_init();      /* 9560 register simülasyonu */
    shell_main();     /* asla dönmez */
}
```

### 4. `shell_main()` [shell.c]

- GPU boot splash (logo, versiyon) çizer
- `printf("Oxalyn-64 HILAL_BIS v1.0\n")` yazar
- Login döngüsüne girer:
  ```
  Login: <kullanıcı adı girişi>
  Parola: <parola girişi (echo yok)>
  ```
- `auth_login()` → kullanıcı doğrulama
- Başarılıysa shell prompt: `oxalyn:/ $ `

---

## Bellek Durumu Boot Sonrası

| Bölge | Adres | İçerik |
|-------|-------|--------|
| Boot kodu | 0x0000 | `kernel_main`'a CALL |
| Kernel kodu | 0x0100+ | Derlenmiş kernel |
| Kernel heap | 0x1000 | Boş bloklar (memory.c) |
| Kernel stack | 0x1FFF↓ | Boş |
| Framebuffer | 0x8000 | Siyah (0x00000000) |
| MMIO | 0xF000+ | Donanım register'ları |

---

## Trap / Exception Akışı

Bir trap (illegal instruction, MPU violation, system call) oluştuğunda:

```
Trap tetiklenir
  │
  ├─ MEPC ← PC
  ├─ MCAUSE ← neden kodu
  ├─ MSTATUS.MPIE ← MSTATUS.MIE
  ├─ MSTATUS.MIE ← 0 (kesmeler engellendi)
  └─ PC ← CSR[MTVEC]

[MTVEC] = trap handler
  │
  ├─ Register kaydet (stack'e push)
  ├─ MCAUSE'a göre dal
  │   ├─ CAUSE_SYSCALL   → syscall_handler()
  │   ├─ CAUSE_MPU_READ  → mpufault_handler()
  │   ├─ CAUSE_ILL_INSN  → illegal_insn_handler()
  │   └─ diğer          → kernel_panic()
  └─ ERET → PC ← MEPC, kesmeleri yeniden etkinleştir
```

---

## Simülatörde Boot

```bash
# Kernel derle
cd kernel && make host

# Simülatörde çalıştır
./hilal_bis_host

# Beklenen çıktı:
# Oxalyn-64 HILAL_BIS v1.0
# Login: root
# Parola: (root yaz)
# oxalyn:/ $
```

---

## Donanımda Boot (FPGA)

1. `fpga/program.mem` BRAM'a yüklenir (Vivado bitstream içinde)
2. Basys3 güç verilince FPGA yapılandırılır
3. Reset butonu (BTNC) bırakıldığında `rst_n = 1` olur
4. PC = 0x0000'den çalışma başlar
5. UART üzerinden terminal bağlantısı: `screen /dev/ttyUSB0 115200`
