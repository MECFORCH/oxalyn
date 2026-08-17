; UART RX interrupt testi
;
; Çalıştırma:
;   build/sim build/uart_interrupt_test.bin -q --uart-rx 12 65
;
; Beklenen:
;   port[0] = 1       (RX ISR bir kez çalıştı)
;   port[1] = 65      ('A')
;   port[2] = 0x80000002
;   port[4] = 1       (WFI'dan dönüldü)

start:
    LI   R1, isr
    CSRW R1, 3              ; MTVEC

    LI   R1, 4
    CSRW R1, 32             ; MIE bit2 = UART RX

    LI   R6, 0
    LI   R1, 1
    CSRW R1, 4              ; MSTATUS.MIE

    WFI

after_wfi:
    LI   R1, 1
    OUT  R1, 4
    OUT  R6, 0
    HALT

isr:
    LI   R1, 1
    ADD  R6, R6, R1

    CSRR R2, 2
    OUT  R2, 2              ; MCAUSE

    IN   R3, 0xFF           ; RX byte'ı oku ve pending'i temizle
    OUT  R3, 1

    LI   R1, 0
    CSRW R1, 32             ; ISR yalnızca bir kez çalışsın
    ERET