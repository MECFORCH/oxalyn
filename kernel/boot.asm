.text
_boot:
    LI   R30, 1023        # Stack pointer (R30!)
    JMP  kernel_main

; Macro emitted by the freestanding C frontend; no-op on the simulator.
MEMORY_BARRIER:
    JALR R0, R31, 0
