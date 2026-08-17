; FENCE.I/FENCE.RW and load-store ordering smoke test.
; The current ISA models FENCE as a precise ordering barrier; this test
; verifies that stores are visible to subsequent loads around both forms.
start:
    LI    R1, 41
    STORE R1, R0, 64
    FENCE.I
    LOAD  R2, R0, 64
    LI    R3, 1
    ADD   R2, R2, R3
    OUT   R2, 0

    LI    R1, 99
    STORE R1, R0, 65
    FENCE.RW
    LOAD  R2, R0, 65
    OUT   R2, 1
    HALT