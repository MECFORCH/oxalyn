; ═══════════════════════════════════════════════════════════════════════════
; trap.asm — Oxalyn-64 Genel Amaçlı Trap/Kesme Handler Şablonu
;
; Bu dosya üç şeyi gösterir:
;   1. MEPC'yi stack'e kaydetme ve geri yükleme (iç içe kesme güvenliği)
;   2. ISR'da kullanılan tüm caller-saved register'ları koruma
;   3. Timer kesintisi için tam bir örnek (Machine modunda)
;
; Kullanım:
;   ./build/asm trap.asm trap.bin
;   ./build/sim  trap.bin -q
;
; Beklenen çıktı:
;   port[0] = 2    (ISR iki kez çalıştı: cycle≥20 ve cycle≥40)
;   port[1] = 1    (main döngüsü devam etti)
;   port[5] = 0x80000001  (son MCAUSE = CAUSE_INT_TIMER)
; ═══════════════════════════════════════════════════════════════════════════

; ── Makrolar (pseudo-comment blokları, assembler'ın LI/PUSH/POP pseudo'larını kullanır) ──

; ── Kurulum ────────────────────────────────────────────────────────────────
start:
    ; Stack pointer'ı belleğin üstüne ayarla (0xFFFF = 65535)
    LI   R31, 0xFFFF

    ; ISR vektörü: MTVEC = isr_entry adresi
    LI   R1, isr_entry
    CSRW R1, 3              ; CSR[3] = MTVEC

    ; Timer: ilk tetiklenme = 20 cycle
    LI   R2, 20
    CSRW R2, 34             ; CSR[34] = MTIMECMP

    ; ISR sayacı sıfırla
    LI   R21, 0             ; R21 = isr_count (callee-saved → main döngü bozulmaz)

    ; Kesme etkinleştir: MIE.timer = 1
    LI   R3, 1
    CSRW R3, 32             ; CSR[32] = MIE (bit0: timer kesmesi)

    ; Global kesme aç: MSTATUS.MIE = 1
    LI   R3, 1
    CSRW R3, 4              ; CSR[4] = MSTATUS

; ── Ana döngü ──────────────────────────────────────────────────────────────
main_loop:
    ; ISR iki kez çalışana kadar bekle
    LI   R5, 2
    SUB  R5, R21, R5        ; R5 = R21 - 2
    JZ   R5, main_done      ; R21 == 2 ise çık

    ; Meşgul bekle (WFI yerine aktif döngü — iç içe kesme testinde kullanışlı)
    JMP  main_loop

main_done:
    LI   R4, 1
    OUT  R4, 1              ; port[1] = 1 (main döngüsü tamamlandı)
    OUT  R21, 0             ; port[0] = ISR sayacı (2 beklenir)
    HALT

; ═══════════════════════════════════════════════════════════════════════════
; ISR ENTRY — Tüm caller-saved register'ları ve MEPC'yi stack'e kaydet
;
; Oxalyn-64 ABI'sinde caller-saved: R1-R20, R30 (link register)
; ISR tüm register'ları bozabilir; güvenli olması için hepsini kaydet.
;
; MEPC kaydetme sebebi:
;   - ISR içinde başka bir trap/ECALL tetiklenirse MEPC ezilir.
;   - İç içe (nested) kesme desteği eklenirse MEPC yanlış dönüş
;     adresine işaret eder.
;   - Genel kural: ISR stack frame'ini her zaman atomik tut.
; ═══════════════════════════════════════════════════════════════════════════
isr_entry:

    ; ── Bağlam kaydetme (context save) ─────────────────────────────────
    ; R31 (SP) başka bir ISR tarafından bozulmaz; Machine modunda SP güvenlidir.
    PUSH R30                ; Link register kaydet
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10

    ; ── MEPC'yi stack'e kaydet (kritik!) ────────────────────────────────
    ; MEPC, ISR dönüşünde PC'ye yüklenir.
    ; İç içe trap gerçekleşirse MEPC ezileceğinden önce stack'e almalıyız.
    CSRR R1, 1              ; R1 = MEPC
    PUSH R1                 ; MEPC → stack

    ; ── İsteğe bağlı: nested interrupt kapatma ──────────────────────────
    ; Timer handler süresince başka kesme istemiyorsak MIE=0 yapabiliriz.
    ; (Bu örnekte kapalı bırakıyoruz; çıkışta MPIE→MIE otomatik restore edilir.)

    ; ── ISR gövdesi ─────────────────────────────────────────────────────
    LI   R1, 1
    ADD  R21, R21, R1       ; isr_count++  (callee-saved R21'i güncelle)

    ; MCAUSE oku ve kaydet
    CSRR R2, 2              ; MCAUSE
    OUT  R2, 5              ; port[5] = MCAUSE

    ; Timer donanım kesmesi bitini temizle: MIP.timer = 0
    LI   R1, 0
    CSRW R1, 33             ; CSR[33] = MIP = 0

    ; Bir sonraki timer tetiklenme zamanını ilerlet (mevcut + 20 cycle)
    ; (MTIMECMP = current_cycle + 20)
    ; Not: Bu simülatörde MTIME = cycles CSR'ından okunamaz; MTIMECMP
    ;      üzerine yeni değer yazarak sürekli tekrar eden timer yapılır.
    CSRR R3, 34             ; R3 = eski MTIMECMP
    LI   R4, 20
    ADD  R3, R3, R4         ; R3 = MTIMECMP + 20
    CSRW R3, 34             ; MTIMECMP = R3 (bir sonraki kesme)

    ; ISR tamamlandı — yalnızca 2 kesme alacağız
    LI   R5, 2
    SUB  R5, R21, R5
    JNZ  R5, isr_done       ; R21 != 2 ise timer'ı sürdür

    ; İkinci kesmeden sonra timer'ı devre dışı bırak
    LI   R1, 0
    CSRW R1, 32             ; MIE = 0 (timer kesmesini kapat)

isr_done:

    ; ── MEPC'yi stack'ten geri yükle ────────────────────────────────────
    POP  R1                 ; MEPC ← stack
    CSRW R1, 1              ; CSR[1] = MEPC (dönüş adresini geri yaz)

    ; ── Bağlam geri yükleme (context restore) ───────────────────────────
    POP  R10
    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R30

    ; ── Dönüş: ERET MEPC'ye atlar, MSTATUS.MPIE → MIE restore edilir ───
    ERET
