; Scheduler verification companion program.
; Preserve a context-like register set across a fence and arithmetic path.
; The host scheduler_verify target validates actual Process context fields.
start:
    LI    R8,  18
    LI    R9,  24
    FENCE.RW
    ADD   R10, R8, R9
    OUT   R10, 0
    HALT