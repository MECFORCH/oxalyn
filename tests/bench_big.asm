; Büyük benchmark: 1000x1000x10 = 10.000.000 iterasyon
    LI   R1, 0
    LI   R2, 10

mega:
    LI   R11, 0
    LI   R12, 1000

mid:
    LI   R3, 0
    LI   R4, 1000
    LI   R5, 0

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
    ADD  R11, R11, R9
    SUB  R10, R12, R11
    JNZ  R10, mid

    LI   R9, 1
    ADD  R1, R1, R9
    SUB  R10, R2, R1
    JNZ  R10, mega

done:
    OUT  R5, 0
    HALT
