; test_pseudo.asm — Pseudo-instruction testleri
start:
    LI   R31, 511       ; SP başlangıcı (R31)
    LI   R30, 0         ; LR sıfırla

    ; MOV testi: R2 = R31 = 511
    MOV  R2, R31
    OUT  R2, 0          ; port[0] = 511

    ; CLR testi
    CLR  R3
    OUT  R3, 1          ; port[1] = 0

    ; NEG testi: -42
    LI   R4, 42
    NEG  R5, R4
    OUT  R5, 2          ; port[2] = 0xFFFF...D6 (−42)

    ; NOT testi: ~0 = -1 = 0xFFFF...FF
    CLR  R6
    NOT  R6, R6         ; R6 = ~0
    LI   R9, 0
    CMPEQ R9, R6, R9    ; R9 = (R6 == 0) ? 1 : 0 = 0 (R6 != 0)
    OUT  R9, 3          ; port[3] = 0 (NOT çalıştı, R6 != 0)

    ; INC testi
    LI   R8, 41
    INC  R8             ; R8 = 42
    OUT  R8, 4          ; port[4] = 42

    ; DEC testi
    DEC  R8             ; R8 = 41
    OUT  R8, 5          ; port[5] = 41

    ; BGT testi: 20 > 10 → atla
    LI   R10, 20
    LI   R11, 10
    BGT  R10, R11, bgt_ok
    LI   R12, 0
    JMP  bgt_done
bgt_ok:
    LI   R12, 1
bgt_done:
    OUT  R12, 6         ; port[6] = 1

    ; BLT testi: 5 < 15 → atla
    LI   R10, 5
    LI   R11, 15
    BLT  R10, R11, blt_ok
    LI   R13, 0
    JMP  blt_done
blt_ok:
    LI   R13, 1
blt_done:
    OUT  R13, 7         ; port[7] = 1

    ; BEQ testi: 42 == 42 → atla
    LI   R10, 42
    LI   R11, 42
    BEQ  R10, R11, beq_ok
    LI   R14, 0
    JMP  beq_done
beq_ok:
    LI   R14, 1
beq_done:
    OUT  R14, 8         ; port[8] = 1

    ; PUSH/POP testi
    LI   R20, 0x55      ; değer = 0x55 = 85
    PUSH R20            ; stack'e it
    CLR  R20            ; R20 = 0
    POP  R20            ; stack'ten al
    OUT  R20, 9         ; port[9] = 85

    ; CALL.R / RET.L testi
    LI   R5, my_func    ; fonksiyon adresi
    JALR R30, R5, 0     ; çağır (R30 = dönüş adresi)
    OUT  R7, 10         ; port[10] = dönüş değeri (100)

    HALT

my_func:
    LI   R7, 100        ; dönüş değeri = 100
    RET.L R30           ; JALR R0, R30, 0

