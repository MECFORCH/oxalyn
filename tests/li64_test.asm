; LUI / ADDI / LI64 test programı
; R1'e 0xDEAD_BEEF yüklüyoruz (LUI zinciriyle)
; Sonucu port[0]'a yazıp HALT

start:
    ; 0xDEADBEEF = 0b 110 11110 10101 10111 01111 01111
    ; 11-bit parçalara böl (alttakinden yukarı):
    ;   parça2 = 0x6D5  (bits 21..11)  → 0x6D5 = 1749
    ;   parça1 = 0x5BB  (bits 10..0 üst yarı) — hayır, doğrudan LI64 kullanalım

    ; LI64 pseudo-instruction — assembler halleder
    LI64 R1, 0xDEADBEEF
    OUT  R1, 0
    
    ; ADDI testi: R2 = R1 + 1
    ADDI R2, R1, 1
    OUT  R2, 1

    ; küçük değer: LI64 tek komuta indirgenmeli
    LI64 R3, 42
    OUT  R3, 2

    HALT
