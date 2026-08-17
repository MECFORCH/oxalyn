# Oxalyn-64 ISA Referans Kartı

Tüm opcode'lar, encoding formatı ve CSR listesi.

---

## Komut Formatı

Her komut 32 bit sabittir:

```
 31      26 25    21 20    16 15    11 10       0
 ┌────────┬───────┬───────┬───────┬───────────┐
 │ OPCODE │  Fd   │  Fa   │  Fb   │    IMM    │
 │  6 bit │ 5 bit │ 5 bit │ 5 bit │  11 bit   │
 └────────┴───────┴───────┴───────┴───────────┘
```

- **Fd**: Hedef register (yazılan)
- **Fa**: Kaynak A register (okunan)
- **Fb**: Kaynak B register (okunan)
- **IMM**: 11-bit işaret uzatmalı immediate (-1024..+1023)
- **R0**: Her zaman 0 (yazma görmezden gelinir)

---

## Opcode Tablosu

### Temel ISA

| Opcode | Hex | Mnemonik | İşlem | Notlar |
|--------|-----|----------|-------|--------|
| 0 | 0x00 | NOP | — | Hiçbir şey yapma |
| 1 | 0x01 | ADD Fd,Fa,Fb | Fd = Fa + Fb | FLAGS güncellenir |
| 2 | 0x02 | SUB Fd,Fa,Fb | Fd = Fa - Fb | FLAGS güncellenir |
| 3 | 0x03 | AND Fd,Fa,Fb | Fd = Fa & Fb | |
| 4 | 0x04 | OR Fd,Fa,Fb | Fd = Fa \| Fb | |
| 5 | 0x05 | XOR Fd,Fa,Fb | Fd = Fa ^ Fb | |
| 6 | 0x06 | SHL Fd,Fa,imm | Fd = Fa << imm | imm[0..5] |
| 7 | 0x07 | SHR Fd,Fa,imm | Fd = Fa >> imm | Mantıksal sağ kaydırma |
| 8 | 0x08 | LOAD Fd,Fa,imm | Fd = mem[Fa+imm] | Word adresi |
| 9 | 0x09 | STORE Fd,Fa,imm | mem[Fa+imm] = Fd | Word adresi |
| 10 | 0x0A | LI Fd,imm | Fd = sign_ext(imm) | 11-bit immediate |
| 11 | 0x0B | JMP Fd,imm | PC += imm (Fd için dal koşulu yok) | Koşulsuz göreli dal |
| 12 | 0x0C | JZ Fd,imm | if Fd==0: PC+=imm | Sıfırsa atla |
| 13 | 0x0D | JNZ Fd,imm | if Fd!=0: PC+=imm | Sıfır değilse atla |
| 14 | 0x0E | CALL Fd,imm | Fd=PC+1, PC+=imm | Alt program çağrısı |
| 15 | 0x0F | RET Fa | PC = Fa | Dönüş |
| 16 | 0x10 | OUT Fa,imm | port[imm] = Fa | G/Ç yazma |
| 17 | 0x11 | IN Fd,imm | Fd = port[imm] | G/Ç okuma |
| 63 | 0x3F | HALT | CPU durur | |

### Güvenlik Uzantısı (SEC)

| Opcode | Hex | Mnemonik | İşlem |
|--------|-----|----------|-------|
| 18 | 0x12 | ECALL | Sistem çağrısı (kullanıcı→kernel) |
| 19 | 0x13 | ERET | Trap'ten dön (kernel→kullanıcı) |
| 20 | 0x14 | CSRW Fa,csr | CSR[csr] = Fa |
| 21 | 0x15 | CSRR Fd,csr | Fd = CSR[csr] |
| 22 | 0x16 | RAND Fd | Fd = TRNG (gerçek rastgele sayı) |
| 23 | 0x17 | FENCE | Bellek bariyeri |
| 24 | 0x18 | AESE Fd,Fa,Fb | AES S-box lookup |
| 25 | 0x19 | HASH Fd,Fa,Fb | FNV-1a hash adımı |

### Aritmetik Uzantısı

| Opcode | Hex | Mnemonik | İşlem |
|--------|-----|----------|-------|
| 26 | 0x1A | MUL Fd,Fa,Fb | Fd = Fa × Fb (64×64→64) |
| 27 | 0x1B | DIV Fd,Fa,Fb | Fd = Fa ÷ Fb (işaretli) |
| 45 | 0x2D | DIVU Fd,Fa,Fb | Fd = Fa ÷ Fb (işaretsiz) |
| 46 | 0x2E | REM Fd,Fa,Fb | Fd = Fa mod Fb (işaretli) |
| 47 | 0x2F | REMU Fd,Fa,Fb | Fd = Fa mod Fb (işaretsiz) |

### Kalıcı Bellek Uzantısı

| Opcode | Hex | Mnemonik | İşlem |
|--------|-----|----------|-------|
| 28 | 0x1C | ELOAD Fd,Fa,imm | Fd = EEPROM[Fa+imm] |
| 29 | 0x1D | ESTORE Fd,Fa,imm | EEPROM[Fa+imm] = Fd |

### Bayrak / Kesme Uzantısı

| Opcode | Hex | Mnemonik | İşlem |
|--------|-----|----------|-------|
| 30 | 0x1E | RFLAGS Fd | Fd = FLAGS (Z/C/V/N bitleri) |
| 31 | 0x1F | WFI | Kesme bekle (Wait For Interrupt) |

### Yeni ISA Uzantıları

| Opcode | Hex | Mnemonik | İşlem |
|--------|-----|----------|-------|
| 32 | 0x20 | LUI Fd,imm | Fd = imm << 16 |
| 33 | 0x21 | JALR Fd,Fa,imm | Fd=PC+1, PC=Fa+imm |
| 34 | 0x22 | CMPEQ Fd,Fa,Fb | Fd = (Fa==Fb) ? 1 : 0 |
| 35 | 0x23 | CMPNE Fd,Fa,Fb | Fd = (Fa!=Fb) ? 1 : 0 |
| 36 | 0x24 | CMPLT Fd,Fa,Fb | Fd = (Fa<Fb) ? 1 : 0 (işaretli) |
| 37 | 0x25 | CMPLE Fd,Fa,Fb | Fd = (Fa≤Fb) ? 1 : 0 (işaretli) |
| 38 | 0x26 | CMPLTU Fd,Fa,Fb | Fd = (Fa<Fb) ? 1 : 0 (işaretsiz) |
| 39 | 0x27 | CMPLEU Fd,Fa,Fb | Fd = (Fa≤Fb) ? 1 : 0 (işaretsiz) |
| 40 | 0x28 | BSET Fd,Fa,imm | Fd = Fa \| (1<<imm) |
| 41 | 0x29 | BCLR Fd,Fa,imm | Fd = Fa & ~(1<<imm) |
| 42 | 0x2A | BTEST Fd,Fa,imm | Fd = (Fa>>imm) & 1 |
| 43 | 0x2B | LOADB Fd,Fa,imm | Fd = mem8[Fa+imm] | Byte adresi, big-endian byte lane |
| 44 | 0x2C | STOREB Fd,Fa,imm | mem8[Fa+imm] = Fd[7:0] | Byte adresi, big-endian byte lane |

### FPU Uzantısı — rezerve (henüz uygulanmadı)

`0x30` opcode'u roadmap'te IEEE 754 single-precision FPU için ayrılmıştır.
`0x2B–0x2F` aralığı artık byte memory ve kalan integer remainder/divide
uzantıları tarafından kullanılır.
Bu sürümde assembler bu mnemonic'leri reddeder, simulator ham opcode'ları
“bilinmeyen opcode” trap'i ile durdurur ve `cpu.v` register writeback yapmadan
CPU'yu durdurur.
FPU sözleşmesi, RTL ve simulator birlikte güncellenmeden etkin bir ISA özelliği
olarak kabul edilmemelidir.

---

## FLAGS Register

| Bit | Ad | Anlam |
|-----|----|-------|
| 0 | Z | Zero: sonuç sıfır |
| 1 | C | Carry: işaretsiz taşma |
| 2 | V | oVerflow: işaretli taşma |
| 3 | N | Negative: bit63 = 1 |

---

## CSR Listesi

| İndeks | Ad | Açıklama |
|--------|----|----------|
| 0 | PRIV | Mevcut ayrıcalık seviyesi (salt okunur) |
| 1 | MEPC | Machine Exception PC |
| 2 | MCAUSE | Trap nedeni (salt okunur) |
| 3 | MTVEC | Machine Trap Vector (handler adresi) |
| 4 | MSTATUS | Machine Status (MIE, MPIE, MPP bitleri) |
| 5 | SEPC | Supervisor Exception PC |
| 6 | STVEC | Supervisor Trap Vector |
| 7 | SATP | Sayfa tablosu tabanı (0=ID eşleme) |
| 8-15 | MPU_BASE[0..7] | MPU bölge taban adresleri |
| 16-23 | MPU_MASK[0..7] | MPU bölge maskeleri |
| 24-31 | MPU_PERM[0..7] | MPU bölge izinleri (r/w/x + priv) |
| 32 | MIE | Machine Interrupt Enable |
| 33 | MIP | Machine Interrupt Pending |
| 34 | MTIMECMP | Timer karşılaştırma değeri |
| 35 | MTIME | Cycle sayacı [31:0] (salt okunur) |
| 36 | MTIME_HI | Cycle sayacı [63:32] (salt okunur) |
| 37 | MIDELEG | Machine → Supervisor kesme delegasyonu |
| 38 | MEDELEG | Machine → Supervisor istisna delegasyonu |
| 39 | SIE | Supervisor Interrupt Enable |
| 40 | SCAUSE | Supervisor Cause (salt okunur) |

### Harici kesme nedenleri

Kesme nedenlerinde üst bit (`bit63`) set edilir:

| MCAUSE | Kaynak |
|--------|--------|
| `0x8000000000000001` | Timer |
| `0x8000000000000002` | UART RX: RX tamponu dolu |
| `0x8000000000000003` | UART TX: verici yeni byte kabul etmeye hazır |
| `0x8000000000000004` | Harici/GPIO/GPU |

---

## Ayrıcalık Seviyeleri (PRIV)

| Değer | Ad | Açıklama |
|-------|----|----------|
| 0 | MACHINE | En yüksek — donanım erişimi tam |
| 1 | SUPERVISOR | Kernel modu — sürücü kodu |
| 2 | USER | Kullanıcı modu — kısıtlı erişim |

---

## G/Ç Portları

| Port | Hex | Açıklama |
|------|-----|----------|
| 240 | 0xF0 | GPIO_DIR: yön kaydı |
| 241 | 0xF1 | GPIO_VAL: değer kaydı |
| 242 | 0xF2 | GPIO_INT_EN: kesme etkinleştirme |
| 243 | 0xF3 | GPIO_INT_ST: kesme durumu |
| 254 | 0xFE | UART_TX: gönderme |
| 255 | 0xFF | UART_RX: alma |
