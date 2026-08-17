; test_new_isa.asm — Yeni ISA komutlarını test eder
start:
    LI   R7, 511        ; SP

    ; LUI testi: R1 = 0xAB << 16 = 0x00AB0000
    LUI  R1, 0xAB       ; R1 = 0xAB0000 = 11206656
    OUT  R1, 0          ; port[0] = 11206656

    ; JALR testi: R3'e adres koy, JALR ile atla
    LI   R3, jalr_target
    JALR R30, R3, 0     ; PC = R3, R30 = donüs adresi
jalr_back:
    ; CMPEQ testi
    LI   R1, 42
    LI   R2, 42
    CMPEQ R5, R1, R2    ; R5 = 1 (esit)
    OUT  R5, 1          ; port[1] = 1

    ; CMPLT testi
    LI   R1, 10
    LI   R2, 20
    CMPLT R5, R1, R2    ; R5 = 1 (10 < 20)
    OUT  R5, 2          ; port[2] = 1

    ; BSET testi
    LI   R1, 0
    BSET R1, R1, 5      ; R1 = bit5 set = 32
    OUT  R1, 3          ; port[3] = 32

    ; BTEST testi
    BTEST R5, R1, 5     ; R5 = 1 (bit5 var)
    OUT  R5, 4          ; port[4] = 1

    ; BCLR testi
    BCLR R1, R1, 5      ; R1 = 0
    OUT  R1, 5          ; port[5] = 0

    HALT

jalr_target:
    LI   R4, 99         ; jalr geldi
    JMP  jalr_back      ; geri don
