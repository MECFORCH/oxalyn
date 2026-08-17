; Cache-facing memory benchmark program.
; Repeated reads after the first fill must preserve the stored value.
start:
    LI    R1, 2
    STORE R1, R0, 96
    LOAD  R2, R0, 96
    LOAD  R3, R0, 96
    OUT   R2, 0
    OUT   R3, 1

    LI    R4, 99
    STORE R4, R0, 97
    LOAD  R5, R0, 97
    OUT   R5, 2
    HALT