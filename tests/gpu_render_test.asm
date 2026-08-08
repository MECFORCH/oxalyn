; =============================================================
; gpu_render_test.asm — Gerçek GPU Render Testi
;
; Struct boyutları (gpu_cmd.h'dan):
;   GPUCmdClear    = 28 byte (7 × uint32_t/float)
;   GPUCmdFillRect = 32 byte (8 × int32_t/uint32_t/float)
;
; Ring buffer layout (word addr 0x200'den):
;   [0x200] = 1            ; CLEAR type
;   [0x201] = 28           ; CLEAR payloadBytes
;   [0x202] = 3            ; flags (color|depth)
;   [0x203] = 0            ; r = 0.0
;   [0x204] = 0            ; g = 0.0
;   [0x205] = 0            ; b = 0.0
;   [0x206] = 0x3F800000   ; a = 1.0
;   [0x207] = 0x3F800000   ; depth = 1.0
;   [0x208] = 0            ; stencil
;   -- 9 kelime toplam (2 header + 7 payload)
;
;   [0x209] = 19           ; FILL_RECT type (0x13)
;   [0x20A] = 32           ; FILL_RECT payloadBytes
;   [0x20B] = 200          ; x
;   [0x20C] = 150          ; y
;   [0x20D] = 400          ; width
;   [0x20E] = 300          ; height
;   [0x20F] = 0x3F800000   ; r = 1.0 (kırmızı)
;   [0x210] = 0            ; g = 0.0
;   [0x211] = 0            ; b = 0.0
;   [0x212] = 0x3F800000   ; a = 1.0
;   -- 10 kelime (2 header + 8 payload)
;
;   [0x213] = 15           ; PRESENT type (0x0F)
;   [0x214] = 0            ; payloadBytes
;   -- 2 kelime
;
; Toplam: 9 + 10 + 2 = 21 kelime → RING_HEAD = 21
; =============================================================

start:
    LI   R7, 511

    ; GPU sıfırla
    LI   R1, 1
    OUT  R1, 0xE3

    ; GPU kimlik kontrolü
    IN   R6, 0xE0
    JZ   R6, fail

    ; FB ayarları
    LI   R1, 0
    OUT  R1, 0xEE           ; FB_ADDR

    LI   R1, 25
    SHL  R1, R1, 5
    OUT  R1, 0xEF           ; FB_WIDTH = 800

    LI   R1, 75
    SHL  R1, R1, 3
    OUT  R1, 0xF0           ; FB_HEIGHT = 600

    LI   R1, 25
    SHL  R1, R1, 7
    OUT  R1, 0xF1           ; FB_PITCH = 3200

    LI   R1, 0
    OUT  R1, 0xF2           ; FB_FORMAT = RGBA8

    ; Ring buffer
    LI   R3, 1
    SHL  R3, R3, 9          ; R3 = 0x200
    OUT  R3, 0xE4           ; RING_BASE
    LI   R1, 256
    OUT  R1, 0xE5           ; RING_SIZE
    LI   R2, 0
    OUT  R2, 0xE6           ; RING_HEAD = 0

    ; float 1.0 = 0x3F800000
    ; = 127 << 23 = 127 * 8388608
    ; Parçalı: LI R8, 127 = 0x7F, SHL 3 → 0x3F8, SHL 10 → 0x3F800, SHL 10 → 0x3F800000
    LI   R8, 127
    SHL  R8, R8, 3          ; 0x3F8
    SHL  R8, R8, 10         ; 0x3F800
    SHL  R8, R8, 10         ; 0x3F800000

    ; ── GPU_CMD_CLEAR ─────────────────────────────────
    LI   R1, 1
    STORE R1, R3, 0         ; type = CLEAR
    LI   R1, 28
    STORE R1, R3, 1         ; payloadBytes = 28

    LI   R1, 3
    STORE R1, R3, 2         ; flags = 3
    LI   R1, 0
    STORE R1, R3, 3         ; r = 0.0
    STORE R1, R3, 4         ; g = 0.0
    STORE R1, R3, 5         ; b = 0.0
    STORE R8, R3, 6         ; a = 1.0
    STORE R8, R3, 7         ; depth = 1.0
    LI   R1, 0
    STORE R1, R3, 8         ; stencil = 0

    ; ── GPU_CMD_FILL_RECT ─────────────────────────────
    LI   R1, 19
    STORE R1, R3, 9         ; type = FILL_RECT
    LI   R1, 32
    STORE R1, R3, 10        ; payloadBytes = 32

    LI   R1, 200
    STORE R1, R3, 11        ; x
    LI   R1, 150
    STORE R1, R3, 12        ; y
    LI   R1, 400
    STORE R1, R3, 13        ; width
    LI   R1, 300
    STORE R1, R3, 14        ; height
    STORE R8, R3, 15        ; r = 1.0
    LI   R1, 0
    STORE R1, R3, 16        ; g = 0.0
    STORE R1, R3, 17        ; b = 0.0
    STORE R8, R3, 18        ; a = 1.0

    ; ── GPU_CMD_PRESENT ───────────────────────────────
    LI   R1, 15
    STORE R1, R3, 19        ; type = PRESENT
    LI   R1, 0
    STORE R1, R3, 20        ; payloadBytes = 0

    ; Ring head = 21
    LI   R2, 21
    OUT  R2, 0xE6

    ; Doorbell
    LI   R1, 1
    OUT  R1, 0xE8

    ; GPU bitmesini bekle
wait:
    IN   R5, 0xE2
    LI   R1, 1
    AND  R5, R5, R1
    JZ   R5, wait

    LI   R1, 71
    OUT  R1, 0
    HALT

fail:
    LI   R1, 0xFF
    OUT  R1, 0
    HALT
