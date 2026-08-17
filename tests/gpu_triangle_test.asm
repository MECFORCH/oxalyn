; =============================================================
; gpu_triangle_test.asm — Gravityon GPU Port Testi
;
; Oxalyn64 LI komutu sadece -1024..1023 aralığını destekler.
; Büyük değerler için SHL + OR kombinasyonu kullanılır.
;   800 = 0x320 = 800  → LI R1, 25  + SHL R1, R1, 5  = 800
;   600 = 0x258         → LI R1, 75  + SHL R1, R1, 3  = 600
;   0x200 = 512         → LI R1, 1   + SHL R1, R1, 9  = 512
;   3200 = 800*4        → LI R1, 25  + SHL R1,R1,5 + SHL R1,R1,2
;
; NOT: Oxalyn64 SPEC'ine göre LI -65536..+65535 yükleyebilir ancak
;      mevcut assembler sürümü sadece 11-bit (-1024..1023) destekliyor.
; =============================================================

start:
    LI   R7, 511          ; SP başlangıcı

    ; ── 1. GPU sıfırla ────────────────────────────────
    LI   R1, 1
    OUT  R1, 0xE3         ; GPU_PORT_CTRL = RESET

    ; ── 2. GPU kimliğini oku (0xE0) ───────────────────
    IN   R6, 0xE0         ; R6 = GPU_ID
    JZ   R6, gpu_error    ; 0 ise GPU yok

    ; ── 3. Framebuffer ayarla ─────────────────────────

    ; FB_ADDR = 0
    LI   R1, 0
    OUT  R1, 0xEE         ; GPU_PORT_FB_ADDR

    ; FB_WIDTH = 800 = 25 << 5
    LI   R1, 25
    SHL  R1, R1, 5        ; R1 = 800
    OUT  R1, 0xEF         ; GPU_PORT_FB_WIDTH

    ; FB_HEIGHT = 600 = 75 << 3
    LI   R1, 75
    SHL  R1, R1, 3        ; R1 = 600
    OUT  R1, 0xF0         ; GPU_PORT_FB_HEIGHT

    ; FB_PITCH = 3200 = 25 << 7
    LI   R1, 25
    SHL  R1, R1, 7        ; R1 = 3200
    OUT  R1, 0xF1         ; GPU_PORT_FB_PITCH

    ; FB_FORMAT = 0 (RGBA8)
    LI   R1, 0
    OUT  R1, 0xF2         ; GPU_PORT_FB_FORMAT

    ; ── 4. Ring buffer kur ────────────────────────────

    ; RING_BASE = 0x200 = 512 = 1 << 9
    LI   R3, 1
    SHL  R3, R3, 9        ; R3 = 0x200 (ring base word addr)
    OUT  R3, 0xE4         ; GPU_PORT_RING_BASE

    ; RING_SIZE = 256
    LI   R1, 256
    OUT  R1, 0xE5         ; GPU_PORT_RING_SIZE

    ; RING_HEAD = 0
    LI   R2, 0
    OUT  R2, 0xE6         ; GPU_PORT_RING_HEAD

    ; ── 5. Ring buffer'a GPU_CMD_PRESENT yaz ──────────
    ; GPUCmdHeader: [type:32][payloadBytes:32]
    ; Oxalyn64 mem: 64-bit kelime, komut alt 32 bite gidiyor
    ; İki kelime: mem[R3+0] = cmd_type, mem[R3+1] = payload_size

    LI   R1, 0x0F         ; GPU_CMD_PRESENT type
    STORE R1, R3, 0       ; mem[ring+0] = type

    LI   R1, 0
    STORE R1, R3, 1       ; mem[ring+1] = payloadBytes=0

    ; Ring head = 2 (iki kelime yazdık)
    LI   R2, 2
    OUT  R2, 0xE6         ; GPU_PORT_RING_HEAD = 2

    ; ── 6. Doorbell — GPU'yu tetikle ──────────────────
    LI   R1, 1
    OUT  R1, 0xE8         ; GPU_PORT_DOORBELL

    ; ── 7. GPU'nun bitmesini bekle ────────────────────
wait_loop:
    IN   R5, 0xE2         ; GPU_PORT_STATUS
    LI   R1, 1            ; GPU_STATUS_IDLE = bit0
    AND  R5, R5, R1
    JZ   R5, wait_loop    ; IDLE değilse döngü

    ; ── 8. Başarı: port[0] = 0x47 ("G") ──────────────
    LI   R1, 71           ; ASCII 'G'
    OUT  R1, 0            ; port[0] = 71 (LED'de görünür)

    HALT

gpu_error:
    LI   R1, 0xDE         ; 0xDE = hata kodu
    OUT  R1, 0
    HALT
