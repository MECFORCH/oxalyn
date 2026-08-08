; ─── MMU Sv16 Test Programı (tek seviyeli, 256-kelime sayfa) ──
;
; Fiziksel bellek düzeni:
;   0x0000..0x00FF : Program kodu (fiziksel sayfa 0, PPN=0)
;   0x0100..0x01FF : Sayfa tablosu (256 PTE, her biri 64-bit kelime)
;   0x0200..0x02FF : Fiziksel veri sayfası (PPN=2)
;
; SATP formatı: bit0=MODE, bit15:1=PT_BASE (kelime adresi)
;   PT_BASE = 0x0100 → SATP = (0x0100 << 1) | 1 = 0x0201
;
; Sayfa tablosu (@ 0x0100):
;   PTE[0] (virt sayfa 0 → phys sayfa 0): kod, R+X
;     PTE = (0 << 16) | 0x0B  = 0x0000000B  (V=1 R=1 X=1)
;   PTE[1] (virt sayfa 1 → phys sayfa 2): veri, R+W
;     PTE = (2 << 16) | 0x07  = 0x00020007  (V=1 R=1 W=1)
;
; Sanal adresler:
;   0x0000..0x00FF → Fiziksel 0x0000..0x00FF (kod)
;   0x0100..0x01FF → Fiziksel 0x0200..0x02FF (veri)

start:
    ; ── 1. PTE[0]: kod sayfası (virt 0 → phys 0), R+X ─────
    LI   R1, 0x0B           ; PPN=0, V=1 R=1 X=1
    LI64 R2, 0x100          ; sayfa tablosu başı
    STORE R1, R2, 0         ; mem[0x0100] = PTE[0]

    ; ── 2. PTE[1]: veri sayfası (virt 1 → phys 2), R+W ────
    LI64 R1, 0x00020007     ; PPN=2, V=1 R=1 W=1
    LI64 R2, 0x100
    STORE R1, R2, 1         ; mem[0x0101] = PTE[1]

    ; ── 3. SATP yaz: PT_BASE=0x0100, MODE=1 ────────────────
    ;    SATP = (0x0100 << 1) | 1 = 0x0201
    LI64 R10, 0x0201
    CSRW R10, 7             ; MMU aktif

    ; ── 4. Sanal 0x0100'e yaz (virt sayfa 1 → phys 0x0200) ─
    LI64 R3, 0xCAFEBABE
    LI64 R4, 0x100          ; sanal adres 0x0100
    STORE R3, R4, 0         ; mem_virt[0x0100] = 0xCAFEBABE

    ; ── 5. Sanal 0x0100'den oku ────────────────────────────
    LI64 R4, 0x100
    LOAD R5, R4, 0
    OUT  R5, 0              ; port[0]: 0xCAFEBABE bekleniyor

    ; ── 6. MMU kapat, fiziksel 0x0200'ü doğrudan oku ───────
    LI   R10, 0
    CSRW R10, 7             ; MMU kapat
    LI64 R6, 0x200
    LOAD R7, R6, 0
    OUT  R7, 1              ; port[1]: 0xCAFEBABE bekleniyor (fiziksel doğrulama)

    HALT
