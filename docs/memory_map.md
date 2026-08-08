# Oxalyn-64 Bellek Haritası

`0x0000`–`0xFFFF` arası 64K kelime (512 KB) adres alanı.
Her kelime 64 bit (8 bayt). Word-addressed (bayt değil).

---

## Adres Haritası Özeti

| Başlangıç | Bitiş | Boyut | Bölge |
|-----------|-------|-------|-------|
| 0x0000 | 0x00FF | 256 kelime | Reset/Boot kodu |
| 0x0100 | 0x0FFF | 3840 kelime | Kernel kodu |
| 0x1000 | 0x1FFF | 4096 kelime | Kernel heap (HEAP_SIZE) |
| 0x2000 | 0x3FFF | 8192 kelime | Process yığınları (MAX_PROCESSES × stack) |
| 0x4000 | 0x7FFF | 16384 kelime | Kullanıcı bölgesi / serbest RAM |
| **0x8000** | **0xE880** | **26752 kelime** | **GPU Framebuffer (800×600 piksel)** |
| 0xE881 | 0xEFFF | 3967 kelime | Ayrılmış (ileride GPU texture) |
| 0xF000 | 0xFFFF | 4096 kelime | MMIO register'ları |

---

## Framebuffer Detayı

- **Taban:** `FB_ADDR = 0x8000` (word adresi)
- **Boyut:** 800 × 600 = 480.000 piksel = 480.000 kelime
- **Bitiş:** 0x8000 + 0x75300 - 1 = 0xDD2FF (ancak 64K sınırı içinde)
- **Format:** 32-bit RGBA8 `0xAARRGGBB` (her kelimede alt 32 bit)
- **Satır genişliği:** 800 kelime (pitch = 800)

```c
/* Piksel yazma: */
mem[0x8000 + y * 800 + x] = 0xFF_RR_GG_BB;
/* oxalyn_fb_ptr() ile: */
uint32_t *fb = oxalyn_fb_ptr();
fb[y * 800 + x] = color;
```

---

## MMIO Bölgesi (0xF000–0xFFFF)

### UART (0xFF)

| Port | Açıklama |
|------|----------|
| 0xFF | UART_RX: okuma (EOF = 0xFFFFFFFF) |
| 0xFE | UART_TX: yazma (alt 8 bit gönderilir) |

### GPIO (0xF0–0xF3)

| Port | Açıklama |
|------|----------|
| 0xF0 | GPIO_DIR: pin yönleri (1=çıkış) |
| 0xF1 | GPIO_VAL: pin değerleri |
| 0xF2 | GPIO_INT_EN: kesme etkinleştirme |
| 0xF3 | GPIO_INT_ST: kesme durumu |

### Kernel MMIO Sürücü Portları

| Aralık | Sürücü | Amaç |
|--------|--------|------|
| 0x30–0x37 | USB HID | Klavye/fare HID rapor tampon |
| 0x40–0x45 | Sound | Ses kontrolü, frekans, süre |
| 0x50–0x58 | Network | NIC kontrol, MAC, IP, TX/RX |
| 0x60–0x67 | RTC | Gerçek zamanlı saat |
| 0x70–0x7F | WiFi | 9560 register simülasyonu |

---

## MMIO Port Detayları

### Ses (0x40–0x45)

```c
#define SND_PORT_CTRL     0x40  /* 0=durdur, 1=çal */
#define SND_PORT_FREQ_LO  0x41  /* Frekans düşük byte */
#define SND_PORT_FREQ_HI  0x42  /* Frekans yüksek byte */
#define SND_PORT_DURATION 0x43  /* Süre (ms) */
#define SND_PORT_VOLUME   0x44  /* Ses seviyesi (0–255) */
#define SND_PORT_STATUS   0x45  /* Durum (1=çalıyor) */
```

### RTC (0x60–0x67)

```c
#define RTC_PORT_SEC   0x60  /* Saniye (BCD) */
#define RTC_PORT_MIN   0x61  /* Dakika (BCD) */
#define RTC_PORT_HOUR  0x62  /* Saat (BCD, 24h) */
#define RTC_PORT_WDAY  0x63  /* Haftanın günü (1=Pazartesi) */
#define RTC_PORT_MDAY  0x64  /* Ayın günü */
#define RTC_PORT_MONTH 0x65  /* Ay (1–12) */
#define RTC_PORT_YEAR  0x66  /* Yıl (2000'den fark) */
#define RTC_PORT_CTRL  0x67  /* 0=serbest, 1=kilitli */
```

---

## Sanal Bellek (SATP ≠ 0)

SATP CSR'ı 0'dan farklı olduğunda MMU devreye girer.

### Sayfa Tablosu Formatı (Single-Level)

- Sayfa boyutu: 256 kelime
- VPN (sanal sayfa numarası): VA[15:8] = 8 bit → 256 sayfa
- Offset: VA[7:0] = 8 bit
- Sayfa tablosu taban adresi: SATP (word adresi)
- Giriş sayısı: 256 (SATP .. SATP+255)

### PTE Formatı

```
 63                  8  3  2  1  0
 ┌───────────────────┬──┬──┬──┬──┐
 │        PPN        │xx│ X│ W│ V│
 │  (fiziksel sayfa) │  │  │  │  │
 └───────────────────┴──┴──┴──┴──┘
 V=1: geçerli giriş
 W=1: yazma izni
 X=1: çalıştırma izni
 PPN[23:0]: fiziksel sayfa numarası
```

---

## Stack Düzeni (Yazılım Sözleşmesi)

```
Yüksek adres
  ┌──────────────────┐ ← SP başlangıcı (process'e atanan)
  │   fonksiyon A    │
  │   dönüş adresi   │
  │   eski FP        │
  │   yerel değişken │
  ├──────────────────┤ ← FP (R29)
  │   fonksiyon B    │
  │   ...            │
  └──────────────────┘ ← SP (R30, büyür aşağı)
Düşük adres
```

---

## Reset ve Boot

1. **Reset:** PC = 0x0000, tüm register sıfır, PRIV = MACHINE
2. **boot.asm:** 0x0000'den yürütülür → stack kurulumu → `kernel_main()` çağrısı
3. **kernel_main():** 0x0100 civarında (linker'a bağlı)
