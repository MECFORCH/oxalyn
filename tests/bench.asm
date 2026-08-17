; bench.asm — ALU yoğun benchmark
; 1000 x 1000 = 1.000.000 iterasyon
; Her iterasyonda: ADD, MUL, XOR, SHL, SHR, AND, OR, SUB (8 komut)

    LI   R1, 0       ; dis sayac
    LI   R2, 1000    ; dis limit
    LI   R5, 0       ; akumulatur

outer:
    LI   R3, 0       ; ic sayac
    LI   R4, 1000    ; ic limit

inner:
    ADD  R5, R5, R3
    MUL  R6, R3, R3
    XOR  R5, R5, R6
    SHL  R7, R5, 1
    SHR  R7, R7, 1
    AND  R6, R5, R7
    OR   R6, R6, R3
    SUB  R8, R5, R3

    LI   R9, 1
    ADD  R3, R3, R9
    SUB  R10, R4, R3
    JNZ  R10, inner

    LI   R9, 1
    ADD  R1, R1, R9
    SUB  R10, R2, R1
    JNZ  R10, outer

done:
    OUT  R5, 0
    OUT  R1, 1
    HALT
