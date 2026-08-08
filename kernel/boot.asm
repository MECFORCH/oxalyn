; HILAL_BIS Bootloader - Pure Oxalyn-64 Assembly
; Fits within 256 words (< 2 KB)
; Initializes stack, sets trap vector, jumps to kernel_main()

.text
_start:
    ; ----------------------------------------------------------------
    ; Set kernel stack pointer: R31 = 0x0FFF
    ; ----------------------------------------------------------------
    LI   R31, 0x0FFF

    ; ----------------------------------------------------------------
    ; Set trap vector CSR[3] = MTVEC = address of trap_handler
    ; Use LUI + OR because LI64 is not supported.
    ; trap_handler address is split into upper (>>11) and lower (&0x7FF).
    ; ----------------------------------------------------------------
    LUI  R1, (trap_handler >> 11)
    OR   R1, R1, (trap_handler & 0x7FF)
    CSRW R1, 3                          ; CSR[3] = MTVEC

    ; ----------------------------------------------------------------
    ; Jump to kernel_main (C function)
    ; ----------------------------------------------------------------
    LUI  R1, (kernel_main >> 11)
    OR   R1, R1, (kernel_main & 0x7FF)
    JALR R30, R1, 0                     ; R30 = link register

    ; ----------------------------------------------------------------
    ; Safety: halt if kernel_main ever returns
    ; ----------------------------------------------------------------
    HALT

; ================================================================
; Trap handler entry point
; Full register save → call trap_dispatcher(cause, tval) → restore
;
; Oxalyn-64 register convention used here:
;   R0  = always zero (read-only)
;   R1  = scratch (caller-saved, used freely in trap)
;   R2  = syscall/trap arg0  (MCAUSE on entry)
;   R3  = syscall/trap arg1  (MTVAL  on entry)
;   R30 = link register (JALR writes return address here)
;   R31 = stack pointer
;
; Saved layout on kernel stack (each 8 bytes, grows downward):
;   [SP+0 ]  saved R1
;   [SP+8 ]  saved R2
;   ...
;   [SP+240] saved R30
;   (R0 always 0; R31 implicit from ERET CSR restore)
;
; MEPC (return PC) is saved automatically by hardware in CSR[4].
; ================================================================
trap_handler:
    ; ── 1. Allocate frame: SP -= 240  (30 regs × 8 bytes) ──────
    LI   R1, 240
    SUB  R31, R31, R1           ; R31 = new SP

    ; ── 2. Save R1-R30 to stack frame ───────────────────────────
    STORE R1,  R31,  0
    STORE R2,  R31,  8
    STORE R3,  R31, 16
    STORE R4,  R31, 24
    STORE R5,  R31, 32
    STORE R6,  R31, 40
    STORE R7,  R31, 48
    STORE R8,  R31, 56
    STORE R9,  R31, 64
    STORE R10, R31, 72
    STORE R11, R31, 80
    STORE R12, R31, 88
    STORE R13, R31, 96
    STORE R14, R31, 104
    STORE R15, R31, 112
    STORE R16, R31, 120
    STORE R17, R31, 128
    STORE R18, R31, 136
    STORE R19, R31, 144
    STORE R20, R31, 152
    STORE R21, R31, 160
    STORE R22, R31, 168
    STORE R23, R31, 176
    STORE R24, R31, 184
    STORE R25, R31, 192
    STORE R26, R31, 200
    STORE R27, R31, 208
    STORE R28, R31, 216
    STORE R29, R31, 224
    STORE R30, R31, 232

    ; ── 3. Load MCAUSE → R2 (arg0), MTVAL → R3 (arg1) ──────────
    CSRR R2, 1                  ; CSR[1] = MCAUSE
    CSRR R3, 2                  ; CSR[2] = MTVAL

    ; ── 4. Call C handler ────────────────────────────────────────
    LUI  R1, (trap_dispatcher >> 11)
    OR   R1, R1, (trap_dispatcher & 0x7FF)
    JALR R30, R1, 0

    ; ── 5. Restore R1-R30 ────────────────────────────────────────
    LOAD R1,  R31,  0
    LOAD R2,  R31,  8
    LOAD R3,  R31, 16
    LOAD R4,  R31, 24
    LOAD R5,  R31, 32
    LOAD R6,  R31, 40
    LOAD R7,  R31, 48
    LOAD R8,  R31, 56
    LOAD R9,  R31, 64
    LOAD R10, R31, 72
    LOAD R11, R31, 80
    LOAD R12, R31, 88
    LOAD R13, R31, 96
    LOAD R14, R31, 104
    LOAD R15, R31, 112
    LOAD R16, R31, 120
    LOAD R17, R31, 128
    LOAD R18, R31, 136
    LOAD R19, R31, 144
    LOAD R20, R31, 152
    LOAD R21, R31, 160
    LOAD R22, R31, 168
    LOAD R23, R31, 176
    LOAD R24, R31, 184
    LOAD R25, R31, 192
    LOAD R26, R31, 200
    LOAD R27, R31, 208
    LOAD R28, R31, 216
    LOAD R29, R31, 224
    LOAD R30, R31, 232

    ; ── 6. Deallocate frame: SP += 240 ───────────────────────────
    LI   R1, 240
    ADD  R31, R31, R1

    ; ── 7. Return from trap (restores MEPC → PC) ─────────────────
    ERET
