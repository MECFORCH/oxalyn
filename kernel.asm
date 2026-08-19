; Oxalyn-64 Assembly — cc.c tarafından üretildi
; Çalıştır: build/asm bu_dosya.asm çıktı.bin

mmio_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L10
_L10:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mmio_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L11:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_hello:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_0
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L120:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_counter:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L122:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPLT  R5, R5, R6
    JZ   R5, _L125
    JMP  _L123
_L124:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L122
_L123:
    LI   R5, _STR_1
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 500
    ADD  R1, R5, R0
    LI   R28, sys_sleep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L124
_L125:
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L121:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_graphics:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_2
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 4278196787
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 100
    LI   R6, 100
    LI   R7, 200
    LI   R8, 150
    LI   R9, 4294901760
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 400
    LI   R6, 300
    LI   R7, 50
    LI   R8, 4278255360
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 10
    LI   R6, 10
    LI   R7, 790
    LI   R8, 590
    LI   R9, 4278190335
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_3
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L126:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_calc:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 5
    STORE R5, R29, 2
    LI   R5, 3
    STORE R5, R29, 3
    LI   R5, _STR_4
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R10, R10, R12
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    MUL  R10, R10, R12
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L127:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_paint:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_6
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 4294967295
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, mouse
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L129
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, 4278190080
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, gpu_put_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, mouse
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L130
_L129:
_L130:
    LI   R28, draw_cursor
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L128:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

prog_music:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 262
    STORE R5, R29, 2
    LI   R5, 200
    STORE R5, R29, 3
    LI   R5, 294
    STORE R5, R29, 4
    LI   R5, 200
    STORE R5, R29, 5
    LI   R5, 330
    STORE R5, R29, 6
    LI   R5, 200
    STORE R5, R29, 7
    LI   R5, 349
    STORE R5, R29, 8
    LI   R5, 200
    STORE R5, R29, 9
    LI   R5, 392
    STORE R5, R29, 10
    LI   R5, 200
    STORE R5, R29, 11
    LI   R5, 440
    STORE R5, R29, 12
    LI   R5, 200
    STORE R5, R29, 13
    LI   R5, 494
    STORE R5, R29, 14
    LI   R5, 200
    STORE R5, R29, 15
    LI   R5, 523
    STORE R5, R29, 16
    LI   R5, 400
    STORE R5, R29, 17
    LI   R5, 1
    STORE R5, R29, 18
    LI   R5, 150
    STORE R5, R29, 19
    LI   R5, 392
    STORE R5, R29, 20
    LI   R5, 120
    STORE R5, R29, 21
    LI   R5, 392
    STORE R5, R29, 22
    LI   R5, 120
    STORE R5, R29, 23
    LI   R5, 440
    STORE R5, R29, 24
    LI   R5, 120
    STORE R5, R29, 25
    LI   R5, 392
    STORE R5, R29, 26
    LI   R5, 240
    STORE R5, R29, 27
    LI   R5, 523
    STORE R5, R29, 28
    LI   R5, 480
    STORE R5, R29, 29
    LI   R5, 0
    STORE R5, R29, 30
    LI   R5, 0
    STORE R5, R29, 31
    LI   R5, _STR_7
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 220
    ADD  R1, R5, R0
    LI   R28, sound_set_volume
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    ADD  R1, R5, R0
    LI   R28, sound_sfx
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, sound_play_melody
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 3
    ADD  R1, R5, R0
    LI   R28, sound_sfx
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R1, R5, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L131:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

apps_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, app_count
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_8
    STORE R8, R7, 0
    LI   R7, _STR_9
    STORE R7, R7, 1
    LI   R7, prog_hello
    STORE R7, R7, 2
    LI   R7, 1
    STORE R7, R7, 3
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_10
    STORE R8, R7, 0
    LI   R7, _STR_11
    STORE R7, R7, 1
    LI   R7, prog_counter
    STORE R7, R7, 2
    LI   R7, 1
    STORE R7, R7, 3
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_12
    STORE R8, R7, 0
    LI   R7, _STR_13
    STORE R7, R7, 1
    LI   R7, prog_graphics
    STORE R7, R7, 2
    LI   R7, 1
    STORE R7, R7, 3
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_14
    STORE R8, R7, 0
    LI   R7, _STR_15
    STORE R7, R7, 1
    LI   R7, prog_calc
    STORE R7, R7, 2
    LI   R7, 1
    STORE R7, R7, 3
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_16
    STORE R8, R7, 0
    LI   R7, _STR_17
    STORE R7, R7, 1
    LI   R7, prog_paint
    STORE R7, R7, 2
    LI   R7, 0
    STORE R7, R7, 3
    STORE R7, R5, 0
    LI   R5, apps
    LI   R6, app_count
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
    ADD  R30, R30, R28
    ADD  R7, R30, R0
    STORE R0, R7, 0
    STORE R0, R7, 1
    STORE R0, R7, 2
    STORE R0, R7, 3
    LI   R8, _STR_18
    STORE R8, R7, 0
    LI   R7, _STR_19
    STORE R7, R7, 1
    LI   R7, prog_music
    STORE R7, R7, 2
    LI   R7, 0
    STORE R7, R7, 3
    STORE R7, R5, 0
_L132:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

app_list:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_20
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_21
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L134:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, app_count
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L137
    JMP  _L135
_L136:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L134
_L135:
    LI   R5, _STR_22
    LI   R6, apps
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    JZ   R8, _L138
    LI   R9, _STR_23
    ADD  R8, R9, R0
    JMP  _L139
_L138:
    LI   R9, _STR_24
    ADD  R8, R9, R0
_L139:
    LI   R9, apps
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 4
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    LI   R12, apps
    LI   R28, 2
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    LI   R28, 4
    MUL  R14, R14, R28
    ADD  R12, R12, R14
    LI   R28, 1
    ADD  R12, R12, R28
    LOAD R14, R12, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    ADD  R4, R14, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L136
_L137:
_L133:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

app_launch:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L141:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, app_count
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L144
    JMP  _L142
_L143:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L141
_L142:
    LI   R5, apps
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L145
    LI   R5, apps
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L147
    LI   R5, _STR_25
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L140
    JMP  _L148
_L147:
_L148:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, apps
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 4
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 2
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R10, 5
    ADD  R1, R9, R0
    ADD  R2, R10, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, process_create
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L149
    LI   R5, _STR_26
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L140
    JMP  _L150
_L149:
_L150:
    LI   R5, _STR_27
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L140
    JMP  _L146
_L145:
_L146:
    JMP  _L143
_L144:
    LI   R5, _STR_28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L140
_L140:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

app_install:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L152:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, app_count
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L155
    JMP  _L153
_L154:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L152
_L153:
    LI   R5, apps
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L156
    LI   R5, apps
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, _STR_29
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L151
    JMP  _L157
_L156:
_L157:
    JMP  _L154
_L155:
    LI   R5, _STR_28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L151
_L151:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

auth_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L164:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLT  R5, R5, R6
    JZ   R5, _L167
    JMP  _L165
_L166:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L164
_L165:
    LI   R5, users
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L166
_L167:
    LI   R5, users
    LI   R6, 0
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, _STR_30
    LI   R8, 16
    LI   R9, 1
    SUB  R8, R8, R9
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, users
    LI   R6, 0
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 16
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, _STR_30
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, simple_hash
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 0
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 17
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 0
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 18
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 0
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 1
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, _STR_31
    LI   R8, 16
    LI   R9, 1
    SUB  R8, R8, R9
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, users
    LI   R6, 1
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 16
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, _STR_31
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, simple_hash
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 1
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 17
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 1
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 18
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, users
    LI   R6, 1
    LI   R28, 20
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L163:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

simple_hash:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 2166136261
    STORE R5, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L169:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L172
    JMP  _L170
_L171:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L169
_L170:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    XOR  R11, R6, R10
    STORE R11, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16777619
    MUL  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L171
_L172:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L168
_L168:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

read_line:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 5
_L174:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L175
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, KGETCHAR
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L176
    JMP  _L175
    JMP  _L177
_L176:
_L177:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPEQ  R5, R5, R6
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 13
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L178
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L175
    JMP  _L179
_L178:
_L179:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPEQ  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L180
    LI   R5, _STR_33
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L174
    JMP  _L181
_L180:
_L181:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLE  R5, R6, R5
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 127
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L182
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L184
    LI   R7, 42
    ADD  R6, R7, R0
    JMP  _L185
_L184:
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R8, R0
_L185:
    ADD  R1, R6, R0
    LI   R28, KPUTCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
    JMP  _L183
_L182:
_L183:
    JMP  _L174
_L175:
_L186:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 32
    CMPEQ  R7, R7, R8
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 13
    CMPEQ  R9, R9, R10
    OR   R7, R7, R9
    CMPNE R7, R7, R0
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L187
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    SUB  R8, R8, R28
    STORE R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    JMP  _L186
_L187:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
_L173:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

login_prompt:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 0
    STORE R5, R29, 34
_L189:
    LI   R28, 34
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLT  R5, R5, R6
    JZ   R5, _L190
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_34
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_35
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_36
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_37
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R6, 16
    LI   R7, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, read_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_38
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 18
    ADD  R5, R29, R28
    LI   R6, 16
    LI   R7, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, read_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L191:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLT  R5, R5, R6
    JZ   R5, _L194
    JMP  _L192
_L193:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L191
_L192:
    LI   R5, users
    LI   R28, 35
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L195
    JMP  _L193
    JMP  _L196
_L195:
_L196:
    LI   R5, users
    LI   R28, 35
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    LI   R6, users
    LI   R28, 35
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 20
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 16
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R28, 18
    ADD  R8, R29, R28
    ADD  R1, R8, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, simple_hash
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    CMPEQ  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L197
    LI   R5, current_uid
    LOAD R6, R5, 0
    LI   R7, users
    LI   R28, 35
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 20
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 17
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    LI   R5, _STR_39
    LI   R28, 2
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, current_uid
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L188
    JMP  _L198
_L197:
_L198:
    JMP  _L193
_L194:
    LI   R5, _STR_40
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 34
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L189
_L190:
    LI   R5, _STR_41
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L188
_L188:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

auth_username:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L200:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLT  R5, R5, R6
    JZ   R5, _L203
    JMP  _L201
_L202:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L200
_L201:
    LI   R5, users
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, users
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 20
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 17
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L204
    LI   R5, users
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R7, R7, R0
    JMP  _L199
    JMP  _L205
_L204:
_L205:
    JMP  _L202
_L203:
    LI   R5, _STR_42
    ADD  R7, R5, R0
    JMP  _L199
_L199:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

auth_set_password:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L207:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLT  R5, R5, R6
    JZ   R5, _L210
    JMP  _L208
_L209:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L207
_L208:
    LI   R5, users
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 19
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, users
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 20
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 17
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L211
    LI   R5, users
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 20
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 16
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R9, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, simple_hash
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L206
    JMP  _L212
_L211:
_L212:
    JMP  _L209
_L210:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L206
_L206:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L225:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L228
    JMP  _L226
_L227:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L225
_L226:
    LI   R5, files
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L227
_L228:
    LI   R5, file_count
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L224:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

find_file:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L230:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L233
    JMP  _L231
_L232:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L230
_L231:
    LI   R5, files
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, files
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 291
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R9, R0
    ADD  R2, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R8, 0
    CMPEQ  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L234
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L229
    JMP  _L235
_L234:
_L235:
    JMP  _L232
_L233:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L229
_L229:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_exists:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, find_file
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLE  R5, R6, R5
    ADD  R7, R5, R0
    JMP  _L236
_L236:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_create:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 6
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, find_file
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L238
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, fs_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L237
    JMP  _L239
_L238:
_L239:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L240:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L243
    JMP  _L241
_L242:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L240
_L241:
    LI   R5, files
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L244
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L243
    JMP  _L245
_L244:
_L245:
    JMP  _L242
_L243:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L246
    LI   R5, -1
    ADD  R7, R5, R0
    JMP  _L237
    JMP  _L247
_L246:
_L247:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 256
    CMPLT  R5, R6, R5
    JZ   R5, _L248
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 256
    STORE R7, R5, 0
    JMP  _L249
_L248:
_L249:
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, files
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 291
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 0
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R10, 32
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L250
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L251
_L250:
_L251:
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 288
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 289
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, file_count
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    LI   R10, 2
    OR  R9, R9, R10
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, perms_register
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_43
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L237
_L237:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_write:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, find_file
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L253
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, fs_create
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L252
    JMP  _L254
_L253:
_L254:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 2
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, check_permission
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L255
    LI   R5, _STR_44
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -3
    ADD  R7, R5, R0
    JMP  _L252
    JMP  _L256
_L255:
_L256:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 256
    CMPLT  R5, R6, R5
    JZ   R5, _L257
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 256
    STORE R7, R5, 0
    JMP  _L258
_L257:
_L258:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L259
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L260
_L259:
_L260:
    LI   R5, files
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 288
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L252
_L252:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_read:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, find_file
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L262
    LI   R5, -2
    ADD  R7, R5, R0
    JMP  _L261
    JMP  _L263
_L262:
_L263:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, check_permission
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L264
    LI   R5, _STR_44
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -3
    ADD  R7, R5, R0
    JMP  _L261
    JMP  _L265
_L264:
_L265:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, files
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 291
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 288
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    CMPLT  R7, R7, R10
    JZ   R7, _L266
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R11, R0
    JMP  _L267
_L266:
    LI   R10, files
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 291
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 288
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    ADD  R9, R12, R0
_L267:
    STORE R9, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, files
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 291
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 32
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R28, 7
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L261
_L261:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_delete:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, find_file
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 4
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L269
    LI   R5, -2
    ADD  R7, R5, R0
    JMP  _L268
    JMP  _L270
_L269:
_L270:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 2
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, check_permission
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L271
    LI   R5, _STR_44
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -3
    ADD  R7, R5, R0
    JMP  _L268
    JMP  _L272
_L271:
_L272:
    LI   R5, files
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, file_count
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L268
_L268:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_count:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, file_count
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L273
_L273:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

fs_list:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_45
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L275:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L278
    JMP  _L276
_L277:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L275
_L276:
    LI   R5, files
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 291
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 290
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L279
    LI   R5, _STR_46
    LI   R6, files
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 291
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    LI   R9, files
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 291
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 288
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L280
_L279:
_L280:
    JMP  _L277
_L278:
    LI   R5, file_count
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L281
    LI   R5, _STR_47
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L282
_L281:
_L282:
_L274:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

ensure_fb:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
_L293:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

abs_i:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L295
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L296
_L295:
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R7, R0
_L296:
    ADD  R7, R5, R0
    JMP  _L294
_L294:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_put_pixel_local:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, fb_w
    LOAD R8, R7, 0
    CMPLE  R6, R8, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 0
    CMPLT  R7, R7, R8
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, fb_h
    LOAD R9, R8, 0
    CMPLE  R7, R9, R7
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L298
    JMP  _L297
    JMP  _L299
_L298:
_L299:
    LI   R5, framebuffer
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, fb_w
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    ADD  R6, R6, R7
    LOAD R9, R6, 0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    STORE R11, R6, 0
_L297:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_save_frame_raw:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
_L300:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

platform_framebuffer:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, ensure_fb
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, framebuffer
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L301
_L301:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, gpu_hw_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, ensure_fb
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 4278196787
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L302:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_clear:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L304:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, fb_w
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, fb_h
    LOAD R8, R7, 0
    MUL  R6, R6, R8
    CMPLT  R5, R5, R6
    JZ   R5, _L307
    JMP  _L305
_L306:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L304
_L305:
    LI   R5, framebuffer
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
    JMP  _L306
_L307:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, gpu_hw_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L303:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_put_pixel:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_hw_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L308:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_line:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 10
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, abs_i
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 11
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, abs_i
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 12
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L310
    LI   R7, 1
    ADD  R6, R7, R0
    JMP  _L311
_L310:
    LI   R7, 1
    SUB  R7, R0, R7
    ADD  R6, R7, R0
_L311:
    STORE R6, R29, 13
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L312
    LI   R7, 1
    ADD  R6, R7, R0
    JMP  _L313
_L312:
    LI   R7, 1
    SUB  R7, R0, R7
    ADD  R6, R7, R0
_L313:
    STORE R6, R29, 14
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 15
_L314:
    LI   R5, 1
    JZ   R5, _L315
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    CMPEQ  R7, R7, R9
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L316
    JMP  _L315
    JMP  _L317
_L316:
_L317:
    LI   R5, 2
    LI   R28, 15
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    MUL  R5, R5, R7
    STORE R5, R29, 16
    LI   R28, 16
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    SUB  R6, R0, R6
    CMPLT  R5, R6, R5
    JZ   R5, _L318
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 12
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 13
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L319
_L318:
_L319:
    LI   R28, 16
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 11
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L320
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 11
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L321
_L320:
_L321:
    JMP  _L314
_L315:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 9
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 10
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 6
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_hw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L309:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_rect:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L323:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L326
    JMP  _L324
_L325:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L323
_L324:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L327:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L330
    JMP  _L328
_L329:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L327
_L328:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L329
_L330:
    JMP  _L325
_L326:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 6
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_hw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L322:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R5, 3
    LI   R6, 2
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    MUL  R6, R6, R8
    SUB  R5, R5, R6
    STORE R5, R29, 8
_L332:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L333
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L334
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R9, 6
    ADD  R7, R7, R9
    ADD  R9, R6, R7
    STORE R9, R5, 0
    JMP  _L335
_L334:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SUB  R8, R8, R10
    MUL  R7, R7, R8
    LI   R9, 10
    ADD  R7, R7, R9
    ADD  R9, R6, R7
    STORE R9, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
_L335:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L332
_L333:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_hw_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L331:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_fill_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    SUB  R7, R0, R7
    STORE R7, R5, 0
_L337:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L340
    JMP  _L338
_L339:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L337
_L338:
    LI   R5, 0
    STORE R5, R29, 7
_L341:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    MUL  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    MUL  R8, R8, R10
    CMPLE  R5, R5, R8
    JZ   R5, _L342
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L341
_L342:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    STORE R7, R5, 0
_L343:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    CMPLE  R5, R5, R6
    JZ   R5, _L346
    JMP  _L344
_L345:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L343
_L344:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L345
_L346:
    JMP  _L339
_L340:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_hw_fill_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L336:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_present:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, MEMORY_BARRIER
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_hw_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L347:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_put_pixel_alpha:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, fb_w
    LOAD R8, R7, 0
    CMPLE  R6, R8, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 0
    CMPLT  R7, R7, R8
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, fb_h
    LOAD R9, R8, 0
    CMPLE  R7, R9, R7
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L349
    JMP  _L348
    JMP  _L350
_L349:
_L350:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 24
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 255
    CMPEQ  R5, R5, R6
    JZ   R5, _L351
    LI   R5, framebuffer
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, fb_w
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    ADD  R6, R6, R7
    LOAD R9, R6, 0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    STORE R11, R6, 0
    JMP  _L348
    JMP  _L352
_L351:
_L352:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L353
    JMP  _L348
    JMP  _L354
_L353:
_L354:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, framebuffer
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, fb_w
    LOAD R11, R10, 0
    MUL  R9, R9, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R9, R9, R12
    ADD  R8, R8, R9
    LOAD R11, R8, 0
    STORE R11, R5, 0
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 10
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 255
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R9, R9, R10
    ADD  R7, R7, R9
    LI   R10, 255
    DIV  R7, R7, R10
    STORE R7, R5, 0
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 11
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 255
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R9, R9, R10
    ADD  R7, R7, R9
    LI   R10, 255
    DIV  R7, R7, R10
    STORE R7, R5, 0
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 12
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 255
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R9, R9, R10
    ADD  R7, R7, R9
    LI   R10, 255
    DIV  R7, R7, R10
    STORE R7, R5, 0
    LI   R5, framebuffer
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, fb_w
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    ADD  R6, R6, R7
    LOAD R9, R6, 0
    LI   R10, 4278190080
    LI   R28, 13
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 16
    SHL  R11, R11, R12
    OR  R10, R10, R11
    LI   R28, 14
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 8
    SHL  R11, R11, R12
    OR  R10, R10, R11
    LI   R28, 15
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    OR  R10, R10, R12
    STORE R10, R6, 0
_L348:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_rounded_rect:
    LI   R28, -40
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 2
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    MUL  R10, R10, R12
    SUB  R9, R9, R10
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 7
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R12, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 2
    LI   R28, 6
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    MUL  R12, R12, R14
    SUB  R11, R11, R12
    LI   R28, 7
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 5
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 2
    LI   R28, 6
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    MUL  R13, R13, R15
    SUB  R12, R12, R13
    LI   R28, 7
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    ADD  R4, R12, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L356:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L359
    JMP  _L357
_L358:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L356
_L357:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L360:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L363
    JMP  _L361
_L362:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L360
_L361:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R28, 9
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 9
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    MUL  R9, R9, R11
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    MUL  R6, R6, R8
    CMPLE  R5, R5, R6
    JZ   R5, _L364
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LI   R28, 9
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R8, R8, R11
    LI   R28, 7
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R12, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R5, R5, R9
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 9
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R9, R9, R12
    LI   R28, 7
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R1, R5, R0
    ADD  R2, R9, R0
    ADD  R3, R13, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R8, R8, R11
    LI   R28, 9
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R8, R8, R12
    LI   R28, 7
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R13, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R5, R5, R9
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R9, R9, R12
    LI   R28, 9
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R9, R9, R13
    LI   R28, 7
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R5, R0
    ADD  R2, R9, R0
    ADD  R3, R14, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L365
_L364:
_L365:
    JMP  _L362
_L363:
    JMP  _L358
_L359:
_L355:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 40
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_min3:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L367
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L368
_L367:
_L368:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L369
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L370
_L369:
_L370:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L366
_L366:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_max3:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L372
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L373
_L372:
_L373:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L374
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L375
_L374:
_L375:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L371
_L371:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_fill_triangle:
    LI   R28, -41
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_min3
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 9
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_max3
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 10
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_min3
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 11
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_max3
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 12
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 11
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L377:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L380
    JMP  _L378
_L379:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L377
_L378:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L381:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R5, R7
    JZ   R5, _L384
    JMP  _L382
_L383:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L381
_L382:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    MUL  R5, R5, R7
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SUB  R8, R8, R10
    LI   R28, 13
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 2
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R8, R8, R10
    SUB  R5, R5, R8
    STORE R5, R29, 15
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    MUL  R5, R5, R7
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SUB  R8, R8, R10
    LI   R28, 13
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 4
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R8, R8, R10
    SUB  R5, R5, R8
    STORE R5, R29, 16
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    MUL  R5, R5, R7
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SUB  R8, R8, R10
    LI   R28, 13
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    SUB  R10, R10, R12
    MUL  R8, R8, R10
    SUB  R5, R5, R8
    STORE R5, R29, 17
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 16
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 17
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 15
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R6, R7
    LI   R28, 16
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 0
    CMPLE  R7, R7, R8
    CMPNE R6, R6, R0
    CMPNE R7, R7, R0
    AND   R6, R6, R7
    LI   R28, 17
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 0
    CMPLE  R7, R7, R8
    CMPNE R6, R6, R0
    CMPNE R7, R7, R0
    AND   R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L385
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L386
_L385:
_L386:
    JMP  _L383
_L384:
    JMP  _L379
_L380:
_L376:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 41
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_char:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    STORE R5, R29, 12
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 96
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L388
    JMP  _L387
    JMP  _L389
_L388:
_L389:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, font8x8
    LI   R28, 12
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 8
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L390:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L393
    JMP  _L391
_L392:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L390
_L391:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    STORE R8, R29, 13
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L394:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L397
    JMP  _L395
_L396:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L394
_L395:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SHR  R6, R6, R8
    AND  R5, R5, R6
    JZ   R5, _L398
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L400:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L403
    JMP  _L401
_L402:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L400
_L401:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L404:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L407
    JMP  _L405
_L406:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L404
_L405:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    MUL  R6, R6, R8
    ADD  R5, R5, R6
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    MUL  R9, R9, R11
    ADD  R8, R8, R9
    LI   R28, 10
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R8, R8, R11
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R12, R0
    LI   R28, gpu_put_pixel_local
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L406
_L407:
    JMP  _L402
_L403:
    JMP  _L399
_L398:
_L399:
    JMP  _L396
_L397:
    JMP  _L392
_L393:
_L387:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_draw_string:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R5, 8
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    MUL  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    STORE R5, R29, 8
_L409:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L410
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPEQ  R5, R5, R6
    JZ   R5, _L411
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R9, 2
    ADD  R7, R7, R9
    ADD  R9, R6, R7
    STORE R9, R5, 0
    JMP  _L412
_L411:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 6
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_draw_char
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
_L412:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L409
_L410:
_L408:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_cmd_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, cmd_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L437:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    JZ   R5, _L440
    JMP  _L438
_L439:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L437
_L438:
    LI   R5, sprites
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 260
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L439
_L440:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L441:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    JZ   R5, _L444
    JMP  _L442
_L443:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L441
_L442:
    LI   R5, tile_strips
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 258
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 257
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L443
_L444:
    LI   R5, _STR_48
    LI   R6, 256
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L436:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_cmd_push:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, cmd_head
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 256
    CMPLE  R5, R6, R5
    JZ   R5, _L446
    LI   R5, _STR_49
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_cmd_flush
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L447
_L446:
_L447:
    LI   R5, cmd_queue
    LI   R6, cmd_head
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 69
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R8, 69
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L445
_L445:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_cmd_reset:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, cmd_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L448:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_cmd_pending:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, cmd_head
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L449
_L449:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

blit_sprite_pixel:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L451
    JMP  _L450
    JMP  _L452
_L451:
_L452:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 24
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    LI   R9, 8
    SHR  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16777215
    AND  R7, R7, R8
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHL  R8, R8, R9
    OR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_alpha
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L450:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

draw_tile:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    JZ   R5, _L454
    JMP  _L453
    JMP  _L455
_L454:
_L455:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, tile_strips
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 258
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 256
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    CMPLE  R7, R10, R7
    OR   R6, R6, R7
    CMPNE R6, R6, R0
    JZ   R6, _L456
    JMP  _L453
    JMP  _L457
_L456:
_L457:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 8
    MUL  R9, R9, R10
    LI   R10, 8
    MUL  R9, R9, R10
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L458:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L461
    JMP  _L459
_L460:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L458
_L459:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L462:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L465
    JMP  _L463
_L464:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L462
_L463:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    MUL  R7, R7, R8
    LI   R28, 10
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    ADD  R6, R6, R7
    LOAD R8, R6, 0
    STORE R8, R29, 13
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L466:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L469
    JMP  _L467
_L468:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L466
_L467:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L470:
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L473
    JMP  _L471
_L472:
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L470
_L471:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    MUL  R6, R6, R8
    ADD  R5, R5, R6
    LI   R28, 12
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 9
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    MUL  R9, R9, R11
    ADD  R8, R8, R9
    LI   R28, 11
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R8, R8, R11
    LI   R28, 13
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R12, R0
    LI   R28, gpu_put_pixel_alpha
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L472
_L473:
    JMP  _L468
_L469:
    JMP  _L464
_L465:
    JMP  _L460
_L461:
_L453:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_cmd_flush:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L475:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, cmd_head
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L478
    JMP  _L476
_L477:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L475
_L476:
    LI   R5, cmd_queue
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 69
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ; switch value is in R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    LI   R28, gpu_put_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 3
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 1
    ADD  R18, R18, R28
    LI   R28, 4
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 14
    CMPEQ  R6, R6, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    ADD  R8, R8, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    CMPLT  R8, R8, R9
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    JZ   R6, _L480
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 16777215
    AND  R6, R6, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    ADD  R8, R8, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHL  R8, R8, R9
    OR  R6, R6, R8
    STORE R6, R29, 6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    ADD  R8, R8, R28
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
_L482:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 3
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    CMPLT  R5, R5, R7
    JZ   R5, _L485
    JMP  _L483
_L484:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L482
_L483:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    ADD  R8, R8, R28
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
_L486:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    CMPLT  R5, R5, R7
    JZ   R5, _L489
    JMP  _L487
_L488:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L486
_L487:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, gpu_put_pixel_alpha
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L488
_L489:
    JMP  _L484
_L485:
    JMP  _L481
_L480:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 3
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 1
    ADD  R18, R18, R28
    LI   R28, 4
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L481:
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    STORE R7, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    STORE R7, R29, 8
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    STORE R7, R29, 9
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    STORE R7, R29, 10
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    STORE R7, R29, 11
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 9
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R11, 1
    SUB  R9, R9, R11
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 11
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R12, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 10
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R9, 1
    SUB  R7, R7, R9
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 9
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R11, 1
    SUB  R9, R9, R11
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 10
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 1
    SUB  R11, R11, R13
    LI   R28, 11
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 10
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 1
    SUB  R11, R11, R13
    LI   R28, 11
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 9
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 1
    SUB  R5, R5, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 9
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R11, 1
    SUB  R9, R9, R11
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 10
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 1
    SUB  R11, R11, R13
    LI   R28, 11
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 3
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 3
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_fill_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 4
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 2
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 1
    ADD  R18, R18, R28
    LI   R28, 3
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_string
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    CMPLE  R6, R7, R6
    JZ   R6, _L490
    JMP  _L479
    JMP  _L491
_L490:
_L491:
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, sprites
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 261
    MUL  R10, R10, R28
    ADD  R7, R7, R10
    STORE R7, R5, 0
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 260
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L492
    JMP  _L479
    JMP  _L493
_L492:
_L493:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L494:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 257
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L497
    JMP  _L495
_L496:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L494
_L495:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L498:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 12
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 256
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L501
    JMP  _L499
_L500:
    LI   R28, 14
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L498
_L499:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    JZ   R7, _L502
    LI   R28, 12
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 256
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    SUB  R9, R9, R10
    LI   R28, 14
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R9, R9, R11
    ADD  R7, R9, R0
    JMP  _L503
_L502:
    LI   R28, 14
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R9, R0
_L503:
    STORE R7, R29, 17
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    JZ   R7, _L504
    LI   R28, 12
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 257
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    SUB  R9, R9, R10
    LI   R28, 13
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R9, R9, R11
    ADD  R7, R9, R0
    JMP  _L505
_L504:
    LI   R28, 13
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R9, R0
_L505:
    STORE R7, R29, 18
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 18
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 12
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 256
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    MUL  R8, R8, R11
    LI   R28, 17
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R8, R8, R12
    LI   R28, 256
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R11, R7, 0
    STORE R11, R29, 19
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 258
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 19
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16777215
    AND  R7, R7, R8
    LI   R28, 12
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 259
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 16777215
    AND  R9, R9, R10
    CMPEQ  R7, R7, R9
    CMPNE R6, R6, R0
    CMPNE R7, R7, R0
    AND   R6, R6, R7
    JZ   R6, _L506
    JMP  _L500
    JMP  _L507
_L506:
_L507:
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L508:
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L511
    JMP  _L509
_L510:
    LI   R28, 15
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L508
_L509:
    LI   R28, 16
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L512:
    LI   R28, 16
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L515
    JMP  _L513
_L514:
    LI   R28, 16
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L512
_L513:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 14
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 3
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    MUL  R7, R7, R10
    ADD  R6, R6, R7
    LI   R28, 16
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R6, R6, R10
    LI   R28, 3
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 1
    ADD  R11, R11, R28
    LI   R28, 2
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 13
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R28, 3
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    LI   R28, 1
    ADD  R14, R14, R28
    LI   R28, 3
    ADD  R14, R14, R28
    LOAD R15, R14, 0
    MUL  R12, R12, R15
    ADD  R11, R11, R12
    LI   R28, 15
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R11, R11, R15
    LI   R28, 19
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 1
    ADD  R18, R18, R28
    LI   R28, 6
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R6, R0
    ADD  R2, R11, R0
    ADD  R3, R16, R0
    ADD  R4, R19, R0
    LI   R28, blit_sprite_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L514
_L515:
    JMP  _L510
_L511:
    JMP  _L500
_L501:
    JMP  _L496
_L497:
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 1
    ADD  R15, R15, R28
    LI   R28, 3
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 1
    ADD  R18, R18, R28
    LI   R28, 4
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, draw_tile
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, 20
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L516:
    LI   R28, 20
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 5
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L519
    JMP  _L517
_L518:
    LI   R28, 20
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L516
_L517:
    LI   R28, 21
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L520:
    LI   R28, 21
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 4
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L523
    JMP  _L521
_L522:
    LI   R28, 21
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L520
_L521:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 3
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 20
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1
    ADD  R12, R12, R28
    LI   R28, 6
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 4
    DIV  R12, R12, R13
    MUL  R9, R9, R12
    LI   R28, 3
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 1
    ADD  R13, R13, R28
    LI   R28, 2
    ADD  R13, R13, R28
    LOAD R14, R13, 0
    ADD  R9, R9, R14
    LI   R28, 21
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R9, R9, R15
    ADD  R7, R7, R9
    LOAD R14, R7, 0
    STORE R14, R29, 22
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 21
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 20
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 22
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R9, R0
    ADD  R3, R12, R0
    LI   R28, gpu_put_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L522
_L523:
    JMP  _L518
_L519:
    JMP  _L479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, _STR_50
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1
    ADD  R10, R10, R28
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R5, _STR_51
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1
    ADD  R10, R10, R28
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
    LI   R5, _STR_52
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L479
_L479:
    JMP  _L477
_L478:
    LI   R5, cmd_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L474:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_clear:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L524:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_pixel:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 2
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L525:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_line:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L526:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_rect:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 4
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 255
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L527:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_rect_border:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 5
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 255
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L528:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 6
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L529:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_fill_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L530:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_string:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 10
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 63
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 63
    LI   R28, 64
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 7
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L531:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_sprite:
    LI   R28, -41
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 8
    STORE R7, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 6
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L532:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 41
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_tile:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L533:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_scroll:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 12
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L534:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_flip:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 13
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L535:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gcmd_present:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 15
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gpu_cmd_push
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L536:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_sprite_load:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    JZ   R5, _L538
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L537
    JMP  _L539
_L538:
_L539:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, sprites
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 261
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    LI   R7, 16
    MUL  R6, R6, R7
    CMPLT  R5, R6, R5
    JZ   R5, _L540
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L537
    JMP  _L541
_L540:
_L541:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 7
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 4
    MUL  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 256
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 258
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 259
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 260
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R5, _STR_53
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L537
_L537:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_sprite_set_color_key:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    LI   R6, sprites
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 261
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 260
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L543
    JMP  _L542
    JMP  _L544
_L543:
_L544:
    LI   R5, sprites
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 258
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, sprites
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 259
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
_L542:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_sprite_free:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    JZ   R5, _L546
    JMP  _L545
    JMP  _L547
_L546:
_L547:
    LI   R5, sprites
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 260
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
_L545:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_tile_load_strip:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    JZ   R5, _L549
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L548
    JMP  _L550
_L549:
_L550:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, tile_strips
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 258
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    MUL  R7, R7, R8
    LI   R8, 8
    MUL  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 4
    MUL  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 256
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R5, _STR_54
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L548
_L548:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_tile_draw_map:
    LI   R28, -41
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 8
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    MUL  R5, R5, R7
    STORE R5, R29, 11
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L552:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L555
    JMP  _L553
_L554:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L552
_L553:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L556:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L559
    JMP  _L557
_L558:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L556
_L557:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 9
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    MUL  R9, R9, R11
    LI   R28, 10
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R9, R9, R12
    ADD  R8, R8, R9
    LOAD R11, R8, 0
    LI   R28, 6
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R28, 10
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R28, 11
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    MUL  R13, R13, R15
    ADD  R12, R12, R13
    LI   R28, 7
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R14, R15, R0
    LI   R28, 9
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    ADD  R15, R16, R0
    LI   R28, 11
    ADD  R16, R29, R28
    LOAD R17, R16, 0
    MUL  R15, R15, R17
    ADD  R14, R14, R15
    LI   R28, 8
    ADD  R16, R29, R28
    LOAD R17, R16, 0
    ADD  R1, R6, R0
    ADD  R2, R11, R0
    ADD  R3, R12, R0
    ADD  R4, R14, R0
    LI   R28, draw_tile
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L558
_L559:
    JMP  _L554
_L555:
_L551:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 41
    ADD  R30, R30, R28
    JALR R0, R31, 0

ring_words:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, gpu_ring
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L560
_L560:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

ring_word:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, ring_words
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
_L561:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

color_component:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SHR  R5, R5, R7
    LI   R7, 255
    AND  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L562
_L562:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_doorbell:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, MEMORY_BARRIER
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 230
    LI   R6, ring_head
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 232
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L563:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_packet:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, gpu_ready
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L565
    JMP  _L564
    JMP  _L566
_L565:
_L566:
    LI   R5, ring_head
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 8192
    CMPLE  R5, R7, R5
    JZ   R5, _L567
    LI   R5, 227
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, 230
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L568
_L567:
_L568:
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, ring_word
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    LI   R8, 4
    MUL  R7, R7, R8
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ring_word
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R7, current_owner
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, ring_word
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L569:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L572
    JMP  _L570
_L571:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L569
_L570:
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R1, R6, R0
    ADD  R2, R10, R0
    LI   R28, ring_word
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L571
_L572:
    LI   R28, gpu_hw_doorbell
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L564:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, gpu_ready
    LOAD R6, R5, 0
    LI   R7, 224
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, MMIO_READ
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R8, 1196446976
    CMPEQ  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, ring_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, current_owner
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, gpu_ready
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L574
    JMP  _L573
    JMP  _L575
_L574:
_L575:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L576:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8192
    CMPLT  R5, R5, R6
    JZ   R5, _L579
    JMP  _L577
_L578:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L576
_L577:
    LI   R28, ring_words
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L578
_L579:
    LI   R5, 227
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 228
    LI   R6, 24576
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 229
    LI   R6, 8192
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 230
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 238
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 239
    LI   R6, 800
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 240
    LI   R6, 600
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 241
    LI   R6, 800
    LI   R7, 4
    MUL  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 242
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L573:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_available:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, gpu_ready
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L580
_L580:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_set_owner:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, current_owner
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L581:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_clear:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 3
    LI   R5, 261
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L582:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_pixel:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R5, 256
    LI   R28, 5
    ADD  R6, R29, R28
    LI   R7, 3
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L583:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_line:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 10
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 11
    LI   R5, 257
    LI   R28, 7
    ADD  R6, R29, R28
    LI   R7, 5
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L584:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_rect:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 10
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 11
    LI   R5, 258
    LI   R28, 7
    ADD  R6, R29, R28
    LI   R7, 5
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L585:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R5, 259
    LI   R28, 6
    ADD  R6, R29, R28
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L586:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_fill_circle:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R5, 260
    LI   R28, 6
    ADD  R6, R29, R28
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L587:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

gpu_hw_present:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 262
    LI   R6, 0
    LI   R7, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, gpu_hw_packet
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L588:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

abs_coord:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L597
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    ADD  R6, R6, R7
    SUB  R6, R0, R6
    LI   R7, 1
    ADD  R6, R6, R7
    ADD  R5, R6, R0
    JMP  _L598
_L597:
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R7, R0
_L598:
    ADD  R7, R5, R0
    JMP  _L596
_L596:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_user_buffer_valid:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L600
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L599
    JMP  _L601
_L600:
_L601:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 4
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8192
    CMPLT  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 32767
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L602
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L599
    JMP  _L603
_L602:
_L603:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32768
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R6, R6, R8
    CMPLT  R5, R6, R5
    JZ   R5, _L604
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L599
    JMP  _L605
_L604:
_L605:
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L599
_L599:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

coord_reasonable:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    SUB  R6, R0, R6
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLE  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L606
_L606:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

request_valid:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    CMPEQ R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L608
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
    JMP  _L609
_L608:
_L609:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 800
    LI   R8, 600
    MUL  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L610
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 800
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 600
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L611
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
    JMP  _L612
_L611:
_L612:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L610
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 800
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 600
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 800
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 600
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L613
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
    JMP  _L614
_L613:
_L614:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 4
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, abs_coord
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R9, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, abs_coord
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    CMPLT  R7, R8, R7
    JZ   R7, _L615
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R9, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, abs_coord
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    ADD  R7, R8, R0
    JMP  _L616
_L615:
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R9, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, abs_coord
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    ADD  R7, R8, R0
_L616:
    LI   R8, 1
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L610
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 800
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 600
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 800
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 600
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L617
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
    JMP  _L618
_L617:
_L618:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 4
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    STORE R7, R5, 0
    JMP  _L610
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 800
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 600
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, coord_reasonable
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 800
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L619
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
    JMP  _L620
_L619:
_L620:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    MUL  R7, R7, R9
    STORE R7, R5, 0
    JMP  _L610
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L607
_L610:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L607
_L607:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_init:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    CMPEQ R5, R5, R0
    JZ   R5, _L622
    JMP  _L621
    JMP  _L623
_L622:
_L623:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 40
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 41
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 42
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 43
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L621:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_enabled:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 40
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPNE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L624
_L624:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_record_fault:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    CMPEQ R5, R5, R0
    JZ   R5, _L626
    JMP  _L625
    JMP  _L627
_L626:
_L627:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 41
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLT  R5, R5, R6
    JZ   R5, _L628
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 41
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L629
_L628:
_L629:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L630
    LI   R5, _STR_55
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 41
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    LI   R10, 3
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L631
_L630:
_L631:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 41
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLE  R5, R6, R5
    JZ   R5, _L632
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 40
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_56
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L633
_L632:
_L633:
_L625:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_admit:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gui_guard_enabled
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L635
    LI   R5, -1
    ADD  R7, R5, R0
    JMP  _L634
    JMP  _L636
_L635:
_L636:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, request_valid
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L637
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R6, _STR_57
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, gui_guard_record_fault
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -2
    ADD  R7, R5, R0
    JMP  _L634
    JMP  _L638
_L637:
_L638:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, gui_guard_admit_pixels
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPNE  R5, R5, R6
    JZ   R5, _L639
    LI   R5, -3
    ADD  R7, R5, R0
    JMP  _L634
    JMP  _L640
_L639:
_L640:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L641
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L642
_L641:
_L642:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L634
_L634:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_admit_pixels:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gui_guard_enabled
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L644
    LI   R5, -1
    ADD  R7, R5, R0
    JMP  _L643
    JMP  _L645
_L644:
_L645:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L646
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R6, _STR_58
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, gui_guard_record_fault
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -2
    ADD  R7, R5, R0
    JMP  _L643
    JMP  _L647
_L646:
_L647:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 42
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4096
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 43
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L648
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R6, _STR_59
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, gui_guard_record_fault
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -3
    ADD  R7, R5, R0
    JMP  _L643
    JMP  _L649
_L648:
_L649:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 42
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 43
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L643
_L643:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

gui_guard_reset:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, gui_guard_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L650:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

hostio_open:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L656
_L656:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

hostio_close:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
_L657:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

hostio_read:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L658
_L658:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

hostio_write:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L659
_L659:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

hostio_lseek:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L660
_L660:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, key_buf
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, key_buf
    LI   R28, 257
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L668:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_feed:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, key_buf
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R6, 256
    DIV  R7, R5, R6
    MUL  R7, R7, R6
    SUB  R5, R5, R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, key_buf
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L670
    LI   R5, key_buf
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, key_buf
    LI   R28, 256
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 256
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
    LI   R5, key_buf
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L671
_L670:
_L671:
_L669:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

scancode_to_ascii:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 0
    STORE R5, R29, 3
    LI   R5, 27
    STORE R5, R29, 4
    LI   R5, 49
    STORE R5, R29, 5
    LI   R5, 50
    STORE R5, R29, 6
    LI   R5, 51
    STORE R5, R29, 7
    LI   R5, 52
    STORE R5, R29, 8
    LI   R5, 53
    STORE R5, R29, 9
    LI   R5, 54
    STORE R5, R29, 10
    LI   R5, 55
    STORE R5, R29, 11
    LI   R5, 56
    STORE R5, R29, 12
    LI   R5, 57
    STORE R5, R29, 13
    LI   R5, 48
    STORE R5, R29, 14
    LI   R5, 45
    STORE R5, R29, 15
    LI   R5, 61
    STORE R5, R29, 16
    LI   R5, 8
    STORE R5, R29, 17
    LI   R5, 9
    STORE R5, R29, 18
    LI   R5, 113
    STORE R5, R29, 19
    LI   R5, 119
    STORE R5, R29, 20
    LI   R5, 101
    STORE R5, R29, 21
    LI   R5, 114
    STORE R5, R29, 22
    LI   R5, 116
    STORE R5, R29, 23
    LI   R5, 121
    STORE R5, R29, 24
    LI   R5, 117
    STORE R5, R29, 25
    LI   R5, 105
    STORE R5, R29, 26
    LI   R5, 111
    STORE R5, R29, 27
    LI   R5, 112
    STORE R5, R29, 28
    LI   R5, 91
    STORE R5, R29, 29
    LI   R5, 93
    STORE R5, R29, 30
    LI   R5, 10
    STORE R5, R29, 31
    LI   R5, 0
    STORE R5, R29, 32
    LI   R5, 97
    STORE R5, R29, 33
    LI   R5, 115
    STORE R5, R29, 34
    LI   R5, 100
    STORE R5, R29, 35
    LI   R5, 102
    STORE R5, R29, 36
    LI   R5, 103
    STORE R5, R29, 37
    LI   R5, 104
    STORE R5, R29, 38
    LI   R5, 106
    STORE R5, R29, 39
    LI   R5, 107
    STORE R5, R29, 40
    LI   R5, 108
    STORE R5, R29, 41
    LI   R5, 59
    STORE R5, R29, 42
    LI   R5, 39
    STORE R5, R29, 43
    LI   R5, 96
    STORE R5, R29, 44
    LI   R5, 0
    STORE R5, R29, 45
    LI   R5, 92
    STORE R5, R29, 46
    LI   R5, 122
    STORE R5, R29, 47
    LI   R5, 120
    STORE R5, R29, 48
    LI   R5, 99
    STORE R5, R29, 49
    LI   R5, 118
    STORE R5, R29, 50
    LI   R5, 98
    STORE R5, R29, 51
    LI   R5, 110
    STORE R5, R29, 52
    LI   R5, 109
    STORE R5, R29, 53
    LI   R5, 44
    STORE R5, R29, 54
    LI   R5, 46
    STORE R5, R29, 55
    LI   R5, 47
    STORE R5, R29, 56
    LI   R5, 0
    STORE R5, R29, 57
    LI   R5, 42
    STORE R5, R29, 58
    LI   R5, 0
    STORE R5, R29, 59
    LI   R5, 32
    STORE R5, R29, 60
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R6, 256
    CMPLT  R5, R5, R6
    JZ   R5, _L673
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R7, R7, R0
    JMP  _L672
    JMP  _L674
_L673:
_L674:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L672
_L672:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_irq_handler:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, scancode_to_ascii
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L676
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, keyboard_feed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L677
_L676:
_L677:
_L675:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_has_key:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, key_buf
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, key_buf
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPNE  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L678
_L678:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_getkey:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
_L680:
    LI   R5, key_buf
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, key_buf
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L681
    LI   R28, keyboard_poll
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L680
_L681:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, key_buf
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, key_buf
    LI   R28, 257
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 256
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    STORE R10, R5, 0
    LI   R5, key_buf
    LI   R28, 257
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, key_buf
    LI   R28, 257
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    LI   R8, 256
    DIV  R9, R7, R8
    MUL  R9, R9, R8
    SUB  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L679
_L679:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

keyboard_poll:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, KGETCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L683
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, keyboard_feed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L684
_L683:
_L684:
_L682:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

ipc_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L698:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L701
    JMP  _L699
_L700:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L698
_L699:
    LI   R5, pipes
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 258
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L700
_L701:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L702:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L705
    JMP  _L703
_L704:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L702
_L703:
    LI   R5, queues
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1075
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L704
_L705:
    LI   R5, _STR_60
    LI   R6, 8
    LI   R7, 8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L697:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

pipe_create:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L707:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L710
    JMP  _L708
_L709:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L707
_L708:
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 258
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L711
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 256
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 257
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 258
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 259
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 260
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, pipes
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    LI   R9, 256
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 32
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 2
    MUL  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 32
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 2
    MUL  R8, R8, R9
    ADD  R7, R7, R8
    LI   R8, 1
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L706
    JMP  _L712
_L711:
_L712:
    JMP  _L709
_L710:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L706
_L706:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

pipe_write:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_TO_PIPE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L714
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L713
    JMP  _L715
_L714:
_L715:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_IS_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L716
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L713
    JMP  _L717
_L716:
_L717:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, pipes
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 261
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 258
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L718
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L713
    JMP  _L719
_L718:
_L719:
_L720:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L721
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 256
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    ADD  R6, R6, R7
    LI   R7, 256
    DIV  R8, R6, R7
    MUL  R8, R8, R7
    SUB  R6, R6, R8
    STORE R6, R29, 8
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 257
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPEQ  R5, R5, R8
    JZ   R5, _L722
    JMP  _L721
    JMP  _L723
_L722:
_L723:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 256
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 256
    MUL  R10, R10, R28
    ADD  R7, R7, R10
    LOAD R10, R7, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 6
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    LI   R15, 1
    ADD  R16, R14, R15
    STORE R16, R13, 0
    ADD  R12, R12, R14
    LOAD R14, R12, 0
    STORE R14, R7, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 256
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    JMP  _L720
_L721:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L713
_L713:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

pipe_read:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_TO_PIPE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L725
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L724
    JMP  _L726
_L725:
_L726:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_IS_READ
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L727
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L724
    JMP  _L728
_L727:
_L728:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, pipes
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 261
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 258
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L729
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L724
    JMP  _L730
_L729:
_L730:
_L731:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 257
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 256
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    CMPNE  R8, R8, R11
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    JZ   R5, _L732
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 0
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    LI   R28, 7
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 257
    ADD  R13, R13, R28
    LOAD R14, R13, 0
    LI   R28, 256
    MUL  R14, R14, R28
    ADD  R11, R11, R14
    LOAD R14, R11, 0
    STORE R14, R6, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 257
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 257
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    ADD  R9, R9, R10
    LI   R10, 256
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    STORE R9, R6, 0
    JMP  _L731
_L732:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L724
_L724:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

pipe_close:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_TO_PIPE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L734
    JMP  _L733
    JMP  _L735
_L734:
_L735:
    LI   R5, pipes
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 261
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 258
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
_L733:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

pipe_available:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    SUB  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, FD_TO_PIPE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L737
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L736
    JMP  _L738
_L737:
_L738:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, pipes
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 261
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 258
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L739
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L736
    JMP  _L740
_L739:
_L740:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 256
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 257
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    SUB  R6, R6, R9
    LI   R9, 256
    ADD  R6, R6, R9
    LI   R9, 256
    DIV  R10, R6, R9
    MUL  R10, R10, R9
    SUB  R6, R6, R10
    ADD  R7, R6, R0
    JMP  _L736
_L736:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_create:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L742:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L745
    JMP  _L743
_L744:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L742
_L743:
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1075
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L746
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1075
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1072
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1073
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1074
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, queues
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1076
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 0
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R10, 16
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L741
    JMP  _L747
_L746:
_L747:
    JMP  _L744
_L745:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L741
_L741:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_open:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L749:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L752
    JMP  _L750
_L751:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L749
_L750:
    LI   R5, queues
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1075
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, queues
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1076
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R9, R0
    ADD  R2, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R8, 0
    CMPEQ  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L753
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L748
    JMP  _L754
_L753:
_L754:
    JMP  _L751
_L752:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L748
_L748:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_send:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L756
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L755
    JMP  _L757
_L756:
_L757:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, queues
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1076
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1075
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L758
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L755
    JMP  _L759
_L758:
_L759:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1074
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 16
    CMPLE  R6, R7, R6
    JZ   R6, _L760
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L755
    JMP  _L761
_L760:
_L761:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R6, R5
    JZ   R5, _L762
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 64
    STORE R7, R5, 0
    JMP  _L763
_L762:
_L763:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 16
    ADD  R8, R8, R28
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1072
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    LI   R28, 1056
    MUL  R11, R11, R28
    ADD  R8, R8, R11
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 64
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 65
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1072
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1072
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    ADD  R9, R9, R10
    LI   R10, 16
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1074
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L755
_L755:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_recv:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L765
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L764
    JMP  _L766
_L765:
_L766:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, queues
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1076
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1075
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1074
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 0
    CMPEQ  R8, R8, R9
    OR   R6, R6, R8
    CMPNE R6, R6, R0
    JZ   R6, _L767
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L764
    JMP  _L768
_L767:
_L768:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 16
    ADD  R8, R8, R28
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1073
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    LI   R28, 1056
    MUL  R11, R11, R28
    ADD  R8, R8, R11
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1073
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1073
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    ADD  R9, R9, R10
    LI   R10, 16
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    STORE R9, R6, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1074
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    SUB  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 64
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L764
_L764:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_count:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L770
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L769
    JMP  _L771
_L770:
_L771:
    LI   R5, queues
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1074
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R7, R7, R0
    JMP  _L769
_L769:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mq_destroy:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L773
    JMP  _L772
    JMP  _L774
_L773:
_L774:
    LI   R5, queues
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1075
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, queues
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1076
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1074
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
_L772:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

kernel_main:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, uart_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, memory_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, scheduler_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_cmd_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, ui_boot_splash
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_81
    LI   R6, 10
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_82
    LI   R6, 20
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, keyboard_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, mouse_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, usb_hid_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_83
    LI   R6, 35
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, auth_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, perms_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_84
    LI   R6, 50
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, fs_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_85
    LI   R6, 65
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, apps_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_86
    LI   R6, 80
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, network_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wifi_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_87
    LI   R6, 100
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, ui_loading_bar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, desktop_welcome_screen
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_render
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_88
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_89
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_90
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_91
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_92
    LI   R6, 8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_93
    LI   R6, 800
    LI   R7, 600
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, login_prompt
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L838
    LI   R5, _STR_94
    ADD  R1, R5, R0
    LI   R28, panic
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L839
_L838:
_L839:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, shell_main
    LOAD R8, R7, 0
    LI   R9, 7
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, process_create
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L840
    LI   R5, _STR_95
    ADD  R1, R5, R0
    LI   R28, panic
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L841
_L840:
_L841:
    LI   R5, _STR_96
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_97
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, scheduler_run
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L837:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

panic:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, _STR_98
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_99
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L843:
    LI   R5, 1
    JZ   R5, _L844
    JMP  _L843
_L844:
_L842:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

trap_dispatcher:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R28, timer_interrupt_handler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L846
    LI   R28, ecall_handler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L846
    LI   R5, _STR_100
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, process_kill
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L846
    LI   R5, _STR_101
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, process_kill
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L846:
_L845:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

timer_interrupt_handler:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, total_ticks
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, usb_hid_poll
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, usb_hid_tick
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, smp_current_core
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    LI   R28, smp_handle_ipi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, smp_current_core
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    LI   R28, smp_account_tick
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R6, current_pid
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L849
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 47
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 46
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, smp_current_core
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R5, 0
    JMP  _L850
_L849:
_L850:
    LI   R28, wm_run
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_render
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L851
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    SUB  R9, R7, R8
    STORE R9, R5, 0
    JMP  _L852
_L851:
_L852:
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, signal_check
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, alarm_tick
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L853
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 10
    STORE R8, R5, 0
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L854
_L853:
_L854:
_L848:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

ecall_handler:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, syscalls_handled
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 2
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R9, process_table
    LI   R10, current_pid
    LOAD R11, R10, 0
    LI   R28, 48
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    LI   R12, 3
    LI   R28, 32
    MUL  R12, R12, R28
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    LI   R13, process_table
    LI   R14, current_pid
    LOAD R15, R14, 0
    LI   R28, 48
    MUL  R15, R15, R28
    ADD  R13, R13, R15
    LI   R28, 0
    ADD  R13, R13, R28
    LOAD R15, R13, 0
    LI   R16, 4
    LI   R28, 32
    MUL  R16, R16, R28
    ADD  R15, R15, R16
    LOAD R16, R15, 0
    LI   R17, process_table
    LI   R18, current_pid
    LOAD R19, R18, 0
    LI   R28, 48
    MUL  R19, R19, R28
    ADD  R17, R17, R19
    LI   R28, 0
    ADD  R17, R17, R28
    LOAD R19, R17, 0
    LI   R20, 5
    LI   R28, 32
    MUL  R20, R20, R28
    ADD  R19, R19, R20
    LOAD R20, R19, 0
    ADD  R1, R8, R0
    ADD  R2, R12, R0
    ADD  R3, R16, R0
    ADD  R4, R20, R0
    LI   R28, syscall_handler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L855:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

syscall_handler:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_fork
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_exec
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, sys_exit
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    ADD  R3, R12, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_write
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    ADD  R3, R12, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_sleep
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, current_pid
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_spawn
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_gpu_draw
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_kill
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_alarm
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, sys_yield
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_gettime
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_gui_status
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, sys_gui_reset
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L857
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
_L857:
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 7
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R7, 0
_L856:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_fork:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L859:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L862
    JMP  _L860
_L861:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L859
_L860:
    LI   R5, process_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L863
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L862
    JMP  _L864
_L863:
_L864:
    JMP  _L861
_L862:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L865
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L858
    JMP  _L866
_L865:
_L866:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, process_table
    LI   R8, current_pid
    LOAD R9, R8, 0
    LI   R28, 48
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R9, 48
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, memcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 36
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, current_pid
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 10
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 7
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R7, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 7
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R9, 0
    STORE R9, R7, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L858
_L858:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_exec:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    LI   R9, process_table
    LI   R10, current_pid
    LOAD R11, R10, 0
    LI   R28, 48
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    LI   R9, 32
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, memset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, gui_guard_reset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L867
_L867:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_exit:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 4
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 7
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R7, 0
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L868:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_write:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPEQ  R5, R5, R6
    JZ   R5, _L870
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, gui_user_buffer_valid
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L872
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L869
    JMP  _L873
_L872:
_L873:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L874:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L877
    JMP  _L875
_L876:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L874
_L875:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R1, R8, R0
    LI   R28, KPUTCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L876
_L877:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L869
    JMP  _L871
_L870:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPEQ  R5, R5, R6
    JZ   R5, _L878
    LI   R28, platform_framebuffer
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 6
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 800
    LI   R8, 600
    MUL  R7, R7, R8
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    MUL  R8, R8, R9
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, gui_user_buffer_valid
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L880
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, _STR_102
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, gui_guard_record_fault
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L869
    JMP  _L881
_L880:
_L881:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, process_table
    LI   R8, current_pid
    LOAD R9, R8, 0
    LI   R28, 48
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, gui_guard_admit_pixels
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPNE  R5, R5, R6
    JZ   R5, _L882
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L869
    JMP  _L883
_L882:
_L883:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L884:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L887
    JMP  _L885
_L886:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L884
_L885:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R10, R10, R12
    LOAD R12, R10, 0
    STORE R12, R6, 0
    JMP  _L886
_L887:
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L869
    JMP  _L879
_L878:
_L879:
_L871:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L869
_L869:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_read:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L889
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L891:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L894
    JMP  _L892
_L893:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L891
_L892:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, -4
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    STORE R8, R30, 3
    LI   R28, KGETCHAR
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LOAD R8, R30, 3
    LI   R28, 4
    ADD  R30, R30, R28
    ADD  R9, R7, R0  ; sonuç = R7
    STORE R9, R6, 0
    JMP  _L893
_L894:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L888
    JMP  _L890
_L889:
_L890:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L888
_L888:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_sleep:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 10
    DIV  R8, R8, R9
    LI   R9, 1
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 3
    STORE R8, R5, 0
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L895
_L895:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_spawn:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, sys_fork
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L897
    LI   R5, process_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L898
_L897:
_L898:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L896
_L896:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_kill:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L900
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L899
    JMP  _L901
_L900:
_L901:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L902
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L899
    JMP  _L903
_L902:
_L903:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, signal_deliver
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L899
_L899:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_alarm:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, alarm_table_init
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L905
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L907:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L910
    JMP  _L908
_L909:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L907
_L908:
    LI   R5, alarm_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    SUB  R8, R0, R8
    STORE R8, R5, 0
    JMP  _L909
_L910:
    LI   R5, alarm_table_init
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L906
_L905:
_L906:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L911:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L914
    JMP  _L912
_L913:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L911
_L912:
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, current_pid
    LOAD R8, R7, 0
    CMPEQ  R5, R5, R8
    JZ   R5, _L915
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    SUB  R8, R0, R8
    STORE R8, R5, 0
    JMP  _L914
    JMP  _L916
_L915:
_L916:
    JMP  _L913
_L914:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L917
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L904
    JMP  _L918
_L917:
_L918:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L919:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L922
    JMP  _L920
_L921:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L919
_L920:
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L923
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, current_pid
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    DIV  R9, R9, R10
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L904
    JMP  _L924
_L923:
_L924:
    JMP  _L921
_L922:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L904
_L904:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

alarm_tick:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, alarm_table_init
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L926
    JMP  _L925
    JMP  _L927
_L926:
_L927:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L928:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L931
    JMP  _L929
_L930:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L928
_L929:
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPLE  R5, R7, R5
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, alarm_table
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 2
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    CMPLE  R7, R10, R7
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L932
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 14
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, signal_deliver
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, alarm_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    SUB  R8, R0, R8
    STORE R8, R5, 0
    JMP  _L933
_L932:
_L933:
    JMP  _L930
_L931:
_L925:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_yield:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L934:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_gettime:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L936
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L937
_L936:
_L937:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L938
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1000
    LI   R9, 10
    DIV  R8, R8, R9
    DIV  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L939
_L938:
_L939:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L935
_L935:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_gui_status:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    STORE R5, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, gui_user_buffer_valid
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L941
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L940
    JMP  _L942
_L941:
_L942:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 40
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 41
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 42
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 43
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L940
_L940:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_gui_reset:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, gui_guard_reset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_103
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L943
_L943:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

signal_deliver:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L945
    JMP  _L944
    JMP  _L946
_L945:
_L946:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L947
    JMP  _L944
    JMP  _L948
_L947:
_L948:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 31
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L949
    JMP  _L944
    JMP  _L950
_L949:
_L950:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SHL  R8, R8, R10
    OR   R10, R7, R8
    STORE R10, R5, 0
_L944:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

signal_check:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L952
    JMP  _L951
    JMP  _L953
_L952:
_L953:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L954
    JMP  _L951
    JMP  _L955
_L954:
_L955:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, process_table
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 48
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 37
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L956
    JMP  _L951
    JMP  _L957
_L956:
_L957:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L958:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 31
    CMPLE  R5, R5, R6
    JZ   R5, _L961
    JMP  _L959
_L960:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L958
_L959:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SHL  R6, R6, R8
    AND  R5, R5, R6
    CMPEQ R5, R5, R0
    JZ   R5, _L962
    JMP  _L960
    JMP  _L963
_L962:
_L963:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SHL  R8, R8, R10
    LI   R28, -1
    XOR  R8, R8, R28
    AND  R10, R7, R8
    STORE R10, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L965
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L966
_L965:
_L966:
    JMP  _L951
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 4
    STORE R8, R5, 0
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L967
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L968
_L967:
_L968:
    JMP  _L951
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 3
    CMPEQ  R5, R5, R7
    JZ   R5, _L969
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    JMP  _L970
_L969:
_L970:
    JMP  _L964
    JMP  _L964
_L964:
    JMP  _L951
    JMP  _L960
_L961:
_L951:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sys_gpu_draw:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    LI   R7, 1
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, gui_user_buffer_valid
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L972
    LI   R5, process_table
    LI   R6, current_pid
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, _STR_104
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, gui_guard_record_fault
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, -2
    ADD  R7, R5, R0
    JMP  _L971
    JMP  _L973
_L972:
_L973:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, process_table
    LI   R8, current_pid
    LOAD R9, R8, 0
    LI   R28, 48
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, gui_guard_admit
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPNE  R5, R5, R6
    JZ   R5, _L974
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L971
    JMP  _L975
_L974:
_L975:
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, gpu_hw_set_owner
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ; switch value is in R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L976
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 5
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    LI   R28, gpu_put_pixel
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L976
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 4
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 5
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L976
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 4
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    LI   R28, 3
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 5
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L976
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 5
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    ADD  R4, R16, R0
    LI   R28, gpu_draw_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L976
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L971
_L976:
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L971
_L971:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

kmemset:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
_L978:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L979
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L978
_L979:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L977
_L977:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kmemcpy:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
_L981:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L982
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L981
_L982:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L980
_L980:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kmemcmp:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
_L984:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L985
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L986
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L983
    JMP  _L987
_L986:
_L987:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L984
_L985:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L983
_L983:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrlen:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 0
    STORE R5, R29, 3
_L989:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L990
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L989
_L990:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L988
_L988:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrcpy:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 4
_L992:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JZ   R8, _L993
    JMP  _L992
_L993:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L991
_L991:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrncpy:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
_L995:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R6, 0
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L996
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L995
_L996:
_L997:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L998
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L997
_L998:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L994
_L994:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrcmp:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
_L1000:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    CMPEQ  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1001
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1000
_L1001:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L999
_L999:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrncmp:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1003:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1006
    JMP  _L1004
_L1005:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1003
_L1004:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LOAD R11, R9, 0
    CMPNE  R6, R6, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 5
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R12, R12, R14
    LOAD R14, R12, 0
    ADD  R12, R14, R0
    LI   R14, 0
    CMPEQ  R12, R12, R14
    OR   R6, R6, R12
    CMPNE R6, R6, R0
    JZ   R6, _L1007
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LOAD R11, R9, 0
    SUB  R6, R6, R11
    ADD  R7, R6, R0
    JMP  _L1002
    JMP  _L1008
_L1007:
_L1008:
    JMP  _L1005
_L1006:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1002
_L1002:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kmemmove:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1010
_L1012:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L1013
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1012
_L1013:
    JMP  _L1011
_L1010:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
_L1014:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L1015
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    SUB  R6, R6, R28
    STORE R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    SUB  R8, R8, R28
    STORE R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1014
_L1015:
_L1011:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1009
_L1009:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

kstrchr:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
_L1017:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1020
    JMP  _L1018
_L1019:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1017
_L1018:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L1021
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1016
    JMP  _L1022
_L1021:
_L1022:
    JMP  _L1019
_L1020:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L1023
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R8, R0
    JMP  _L1024
_L1023:
    LI   R7, 0
    ADD  R6, R7, R0
_L1024:
    ADD  R7, R6, R0
    JMP  _L1016
_L1016:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

memory_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, blocks
    LI   R6, 0
    LI   R28, 3
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 4096
    STORE R7, R5, 0
    LI   R5, blocks
    LI   R6, 0
    LI   R28, 3
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 12288
    STORE R7, R5, 0
    LI   R5, blocks
    LI   R6, 0
    LI   R28, 3
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, block_count
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L1025:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

kmalloc:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1027
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1026
    JMP  _L1028
_L1027:
_L1028:
    LI   R5, block_count
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLE  R5, R6, R5
    JZ   R5, _L1029
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1026
    JMP  _L1030
_L1029:
_L1030:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1031:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, block_count
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1034
    JMP  _L1032
_L1033:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1031
_L1032:
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    LI   R7, blocks
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 3
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPLE  R7, R10, R7
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1035
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    STORE R7, R29, 5
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 2
    MUL  R7, R7, R8
    CMPLT  R5, R7, R5
    LI   R7, block_count
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 64
    CMPLT  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1037
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, blocks
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 3
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, block_count
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1039:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    ADD  R6, R6, R7
    CMPLT  R5, R6, R5
    JZ   R5, _L1042
    JMP  _L1040
_L1041:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1039
_L1040:
    LI   R5, blocks
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, blocks
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    SUB  R8, R8, R9
    LI   R28, 3
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1041
_L1042:
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    ADD  R6, R6, R7
    LI   R28, 3
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 6
    ADD  R6, R29, R28
    STORE R6, R5, 0
    LI   R5, block_count
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1038
_L1037:
_L1038:
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1026
    JMP  _L1036
_L1035:
_L1036:
    JMP  _L1033
_L1034:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1026
_L1026:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

kfree:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1044
    JMP  _L1043
    JMP  _L1045
_L1044:
_L1045:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1046:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, block_count
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1049
    JMP  _L1047
_L1048:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1046
_L1047:
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPEQ  R5, R5, R8
    LI   R8, blocks
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 3
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    CMPNE R5, R5, R0
    CMPNE R10, R10, R0
    AND   R5, R5, R10
    JZ   R5, _L1050
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R6, blocks
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1052
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    LI   R28, 3
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, blocks
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 3
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R10, R6, R9
    STORE R10, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1054:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, block_count
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1057
    JMP  _L1055
_L1056:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1054
_L1055:
    LI   R5, blocks
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, blocks
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    ADD  R8, R8, R9
    LI   R28, 3
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1056
_L1057:
    LI   R5, block_count
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1053
_L1052:
_L1053:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, block_count
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R6, blocks
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1058
    LI   R5, blocks
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, blocks
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    ADD  R9, R9, R10
    LI   R28, 3
    MUL  R9, R9, R28
    ADD  R8, R8, R9
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R10, R7, R9
    STORE R10, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    STORE R7, R5, 0
_L1060:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, block_count
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1063
    JMP  _L1061
_L1062:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1060
_L1061:
    LI   R5, blocks
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, blocks
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    ADD  R8, R8, R9
    LI   R28, 3
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1062
_L1063:
    LI   R5, block_count
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1059
_L1058:
_L1059:
    JMP  _L1043
    JMP  _L1051
_L1050:
_L1051:
    JMP  _L1048
_L1049:
_L1043:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

mouse_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 800
    LI   R8, 2
    DIV  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 600
    LI   R8, 2
    DIV  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1064:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

mouse_move:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1066
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1067
_L1066:
_L1067:
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 800
    CMPLE  R5, R6, R5
    JZ   R5, _L1068
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 800
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1069
_L1068:
_L1069:
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1070
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1071
_L1070:
_L1071:
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 600
    CMPLE  R5, R6, R5
    JZ   R5, _L1072
    LI   R5, mouse
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 600
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1073
_L1072:
_L1073:
    LI   R5, mouse
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L1065:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

mouse_button:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1075
    LI   R5, mouse
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SHL  R7, R7, R9
    OR   R9, R6, R7
    STORE R9, R5, 0
    JMP  _L1076
_L1075:
    LI   R5, mouse
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SHL  R7, R7, R9
    LI   R28, -1
    XOR  R7, R7, R28
    AND  R9, R6, R7
    STORE R9, R5, 0
_L1076:
    LI   R5, mouse
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L1074:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

draw_cursor:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, mouse
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    ADD  R9, R9, R10
    LI   R10, mouse
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 5
    ADD  R10, R10, R11
    LI   R11, 4294967295
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, mouse
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 5
    ADD  R9, R9, R10
    LI   R10, mouse
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    ADD  R10, R10, R11
    LI   R11, 4294967295
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 5
    ADD  R5, R5, R6
    LI   R6, mouse
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 10
    ADD  R6, R6, R7
    LI   R7, mouse
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    ADD  R7, R7, R8
    LI   R8, mouse
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 5
    ADD  R8, R8, R9
    LI   R9, 4294967295
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1077:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

nic_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, mmio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1088
_L1088:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

nic_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mmio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1089:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

ip_to_str:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 3
    STORE R7, R5, 0
_L1091:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L1094
    JMP  _L1092
_L1093:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1091
_L1092:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    MUL  R6, R6, R7
    SHR  R5, R5, R6
    STORE R5, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 100
    CMPLE  R5, R6, R5
    JZ   R5, _L1095
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 100
    DIV  R10, R10, R11
    ADD  R9, R9, R10
    STORE R9, R6, 0
    JMP  _L1096
_L1095:
_L1096:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPLE  R5, R6, R5
    JZ   R5, _L1097
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    DIV  R10, R10, R11
    LI   R11, 10
    DIV  R12, R10, R11
    MUL  R12, R12, R11
    SUB  R10, R10, R12
    ADD  R9, R9, R10
    STORE R9, R6, 0
    JMP  _L1098
_L1097:
_L1098:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    DIV  R12, R10, R11
    MUL  R12, R12, R11
    SUB  R10, R10, R12
    ADD  R9, R9, R10
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1099
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 46
    STORE R9, R6, 0
    JMP  _L1100
_L1099:
_L1100:
    JMP  _L1093
_L1094:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
_L1090:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

inet_checksum:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1102:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1105
    JMP  _L1103
_L1104:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1102
_L1103:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 8
    SHL  R8, R8, R10
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 5
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 1
    ADD  R12, R12, R13
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    OR  R8, R8, R12
    ADD  R12, R6, R8
    STORE R12, R5, 0
    JMP  _L1104
_L1105:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L1106
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    SUB  R9, R9, R10
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L1107
_L1106:
_L1107:
_L1108:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    SHR  R5, R5, R6
    JZ   R5, _L1109
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 65535
    AND  R7, R7, R8
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1108
_L1109:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, -1
    XOR  R5, R5, R28
    ADD  R7, R5, R0
    JMP  _L1101
_L1101:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

network_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, net
    LI   R6, 0
    LI   R7, net
    LI   R7, 14
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1111:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1114
    JMP  _L1112
_L1113:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1111
_L1112:
    LI   R5, arp_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 7
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1113
_L1114:
    LI   R5, net
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3232235620
    STORE R7, R5, 0
    LI   R5, net
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3232235521
    STORE R7, R5, 0
    LI   R5, net
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 4294967040
    STORE R7, R5, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 2
    STORE R8, R6, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 72
    STORE R8, R6, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 2
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 66
    STORE R8, R6, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 10
    STORE R8, R6, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 4
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R5, net
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 5
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R5, 81
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 88
    LI   R6, net
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 80
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, nic_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, net
    LI   R28, 9
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 2
    AND  R7, R7, R8
    JZ   R7, _L1115
    LI   R8, 1
    ADD  R7, R8, R0
    JMP  _L1116
_L1115:
    LI   R8, 0
    ADD  R7, R8, R0
_L1116:
    STORE R7, R5, 0
    LI   R5, net
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ip_to_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_105
    LI   R28, 4
    ADD  R6, R29, R28
    LI   R7, net
    LI   R28, 9
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    JZ   R8, _L1117
    LI   R9, _STR_106
    ADD  R8, R9, R0
    JMP  _L1118
_L1117:
    LI   R9, _STR_107
    ADD  R8, R9, R0
_L1118:
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R8, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1110:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

net_is_up:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 80
    ADD  R1, R5, R0
    LI   R28, nic_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    AND  R5, R5, R6
    LI   R6, 0
    CMPNE  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1119
_L1119:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

net_status:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, net
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ip_to_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, net
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 22
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ip_to_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_108
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_109
    LI   R28, 2
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_110
    LI   R28, 22
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_111
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, net_is_up
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    JZ   R6, _L1121
    LI   R7, _STR_106
    ADD  R6, R7, R0
    JMP  _L1122
_L1121:
    LI   R7, _STR_107
    ADD  R6, R7, R0
_L1122:
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_112
    LI   R6, net
    LI   R28, 10
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, net
    LI   R28, 11
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_113
    LI   R6, net
    LI   R28, 12
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, net
    LI   R28, 13
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1120:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

arp_learn:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 5
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1124:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1127
    JMP  _L1125
_L1126:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1124
_L1125:
    LI   R5, arp_table
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 7
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1128
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1127
    JMP  _L1129
_L1128:
_L1129:
    LI   R5, arp_table
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPEQ  R5, R5, R8
    JZ   R5, _L1130
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1127
    JMP  _L1131
_L1130:
_L1131:
    JMP  _L1126
_L1127:
    LI   R5, arp_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, arp_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 7
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, arp_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 6
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1123:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

arp_lookup:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1133:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1136
    JMP  _L1134
_L1135:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1133
_L1134:
    LI   R5, arp_table
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 8
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 7
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, arp_table
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 8
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1137
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, arp_table
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 8
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R10, 6
    ADD  R1, R6, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1132
    JMP  _L1138
_L1137:
_L1138:
    JMP  _L1135
_L1136:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 255
    LI   R8, 6
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1132
_L1132:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

eth_send:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1518
    LI   R8, 14
    SUB  R7, R7, R8
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1140
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1139
    JMP  _L1141
_L1140:
_L1141:
    LI   R28, 1526
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 80
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, nic_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 1526
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    CMPEQ R5, R5, R0
    JZ   R5, _L1142
    LI   R5, net
    LI   R28, 12
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1139
    JMP  _L1143
_L1142:
_L1143:
    LI   R28, 1526
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    AND  R5, R5, R6
    JZ   R5, _L1144
    LI   R5, net
    LI   R28, 12
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1139
    JMP  _L1145
_L1144:
_L1145:
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 6
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 6
    ADD  R5, R5, R6
    LI   R6, net
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 6
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 12
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 13
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 14
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1524
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 14
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R5, 82
    LI   R28, 1524
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1525
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1146:
    LI   R28, 1525
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 1524
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1149
    JMP  _L1147
_L1148:
    LI   R28, 1525
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1146
_L1147:
    LI   R5, 83
    LI   R28, 6
    ADD  R6, R29, R28
    LI   R28, 1525
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1148
_L1149:
    LI   R5, 84
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, net
    LI   R28, 10
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1524
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1139
_L1139:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

eth_recv:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 80
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, nic_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    AND  R5, R5, R6
    CMPEQ R5, R5, R0
    JZ   R5, _L1151
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1150
    JMP  _L1152
_L1151:
_L1152:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 85
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, nic_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R5, R6
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLT  R6, R8, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1153
    LI   R5, 87
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, net
    LI   R28, 13
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1150
    JMP  _L1154
_L1153:
_L1154:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1155:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1158
    JMP  _L1156
_L1157:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1155
_L1156:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 86
    ADD  R1, R9, R0
    LI   R28, -4
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    STORE R8, R30, 3
    LI   R28, nic_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LOAD R8, R30, 3
    LI   R28, 4
    ADD  R30, R30, R28
    ADD  R9, R7, R0  ; sonuç = R7
    LI   R10, 255
    AND  R9, R9, R10
    STORE R9, R6, 0
    JMP  _L1157
_L1158:
    LI   R5, 87
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, nic_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, net
    LI   R28, 11
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1150
_L1150:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

ip_send:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 0
    STORE R5, R29, 1532
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1518
    LI   R8, 14
    SUB  R7, R7, R8
    LI   R8, 20
    SUB  R7, R7, R8
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1160
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1159
    JMP  _L1161
_L1160:
_L1161:
    LI   R28, 1530
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 20
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 69
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 1530
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 1530
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 64
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 64
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LI   R8, 20
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, inet_checksum
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 10
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 1531
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 11
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 1531
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LI   R6, 20
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1524
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, arp_lookup
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1524
    ADD  R5, R29, R28
    LI   R6, 2048
    LI   R28, 6
    ADD  R7, R29, R28
    LI   R8, 20
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, eth_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1159
_L1159:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

ping:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1536
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ip_to_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, net_is_up
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1163
    LI   R5, _STR_114
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1162
    JMP  _L1164
_L1163:
_L1164:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 8
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 2
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 3
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 4
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 5
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 6
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 7
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 8
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 72
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 9
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 73
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 10
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 76
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 11
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 65
    STORE R7, R5, 0
    LI   R28, 1533
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R28, 3
    ADD  R8, R29, R28
    LI   R8, 12
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, inet_checksum
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 2
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 1533
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 3
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 1533
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, _STR_115
    LI   R28, 1536
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R28, 3
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R9, R29, R28
    LI   R9, 12
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, ip_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1534
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1165:
    LI   R28, 1534
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10000
    CMPLT  R5, R5, R6
    JZ   R5, _L1168
    JMP  _L1166
_L1167:
    LI   R28, 1534
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1165
_L1166:
    LI   R28, 1535
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 15
    ADD  R7, R29, R28
    LI   R8, 1518
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, eth_recv
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 1535
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 14
    LI   R7, 20
    ADD  R6, R6, R7
    LI   R7, 8
    ADD  R6, R6, R7
    CMPLE  R5, R6, R5
    JZ   R5, _L1169
    LI   R28, 15
    ADD  R5, R29, R28
    LI   R6, 14
    ADD  R5, R5, R6
    STORE R5, R29, 1556
    LI   R28, 1556
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 20
    ADD  R5, R5, R6
    STORE R5, R29, 1557
    LI   R28, 1557
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    JZ   R6, _L1171
    LI   R5, _STR_116
    LI   R28, 1536
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1162
    JMP  _L1172
_L1171:
_L1172:
    JMP  _L1170
_L1169:
_L1170:
    JMP  _L1167
_L1168:
    LI   R5, _STR_117
    LI   R28, 1536
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1162
_L1162:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

udp_send:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 512
    CMPLT  R5, R6, R5
    JZ   R5, _L1174
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1173
    JMP  _L1175
_L1174:
_L1175:
    LI   R28, 527
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 2
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 3
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 4
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 527
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 5
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 527
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 255
    AND  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 6
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 7
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LI   R6, 8
    ADD  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 17
    LI   R28, 7
    ADD  R8, R29, R28
    LI   R28, 527
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R10, R0
    LI   R28, ip_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1173
_L1173:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

dns_encode_name:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R5, 0
    STORE R5, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 9
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R7, R5
    JZ   R5, _L1177
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1176
    JMP  _L1178
_L1177:
_L1178:
_L1179:
    LI   R5, 1
    JZ   R5, _L1180
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 46
    CMPEQ  R5, R5, R6
    LI   R28, 9
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1181
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    STORE R5, R29, 10
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R5, R6
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 63
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1183
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1185
    JMP  _L1180
    JMP  _L1186
_L1185:
_L1186:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    STORE R7, R5, 0
    JMP  _L1179
    JMP  _L1184
_L1183:
_L1184:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLE  R5, R8, R5
    JZ   R5, _L1187
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1176
    JMP  _L1188
_L1187:
_L1188:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 10
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1189:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1192
    JMP  _L1190
_L1191:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1189
_L1190:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    ADD  R8, R8, R9
    LOAD R10, R8, 0
    STORE R10, R5, 0
    JMP  _L1191
_L1192:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R28, 10
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    ADD  R9, R6, R7
    STORE R9, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R9, 1
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1193
    JMP  _L1180
    JMP  _L1194
_L1193:
_L1194:
    JMP  _L1182
_L1181:
_L1182:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1179
_L1180:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLE  R5, R7, R5
    JZ   R5, _L1195
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1176
    JMP  _L1196
_L1195:
_L1196:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1176
_L1176:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

dns_resolve:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 1028
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1198
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1199
_L1198:
_L1199:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 1037
    LI   R28, 1033
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1034
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1035
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1036
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 1
    SUB  R13, R0, R13
    STORE R13, R11, 0
    STORE R13, R9, 0
    STORE R13, R7, 0
    STORE R13, R5, 0
    LI   R28, 1033
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1200:
    LI   R28, 1037
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1201
    LI   R28, 1033
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1033
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 1037
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1200
_L1201:
    LI   R28, 1037
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 46
    CMPEQ  R5, R5, R6
    JZ   R5, _L1202
    LI   R28, 1034
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1204:
    LI   R28, 1037
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1205
    LI   R28, 1034
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1034
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 1037
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1204
_L1205:
    JMP  _L1203
_L1202:
_L1203:
    LI   R28, 1034
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 46
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1206
    LI   R28, 1035
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1208:
    LI   R28, 1037
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1209
    LI   R28, 1035
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1035
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 1037
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1208
_L1209:
    JMP  _L1207
_L1206:
_L1207:
    LI   R28, 1035
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 46
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1210
    LI   R28, 1036
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1212:
    LI   R28, 1037
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1213
    LI   R28, 1036
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1036
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 1037
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1212
_L1213:
    JMP  _L1211
_L1210:
_L1211:
    LI   R28, 1036
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 1037
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1033
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1033
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 255
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1034
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1034
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 255
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1035
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1035
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 255
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1036
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 1036
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 255
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1214
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 1033
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 24
    SHL  R7, R7, R8
    LI   R28, 1034
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHL  R8, R8, R9
    OR  R7, R7, R8
    LI   R28, 1035
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    OR  R7, R7, R8
    LI   R28, 1036
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    OR  R7, R7, R9
    STORE R7, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1215
_L1214:
_L1215:
    LI   R5, net
    LI   R28, 9
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1216
    LI   R5, _STR_118
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1217
_L1216:
_L1217:
    LI   R28, 1032
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, net
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    JZ   R8, _L1218
    LI   R9, net
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R8, R10, R0
    JMP  _L1219
_L1218:
    LI   R9, 8
    LI   R10, 24
    SHL  R9, R9, R10
    LI   R10, 8
    LI   R11, 16
    SHL  R10, R10, R11
    OR  R9, R9, R10
    LI   R10, 8
    LI   R11, 8
    SHL  R10, R10, R11
    OR  R9, R9, R10
    LI   R10, 8
    OR  R9, R9, R10
    ADD  R8, R9, R0
_L1219:
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 171
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 205
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 1029
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LI   R28, 1028
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R11, 512
    LI   R28, 1028
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    SUB  R11, R11, R13
    LI   R13, 4
    SUB  R11, R11, R13
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, dns_encode_name
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 1029
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1220
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1221
_L1220:
_L1221:
    LI   R28, 1028
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1029
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 1028
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 1032
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 5300
    LI   R8, 53
    LI   R28, 4
    ADD  R9, R29, R28
    LI   R28, 1028
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, udp_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1222
    LI   R5, _STR_119
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1223
_L1222:
_L1223:
    LI   R28, 1030
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1224:
    LI   R28, 1030
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 512
    CMPLT  R5, R5, R6
    JZ   R5, _L1227
    JMP  _L1225
_L1226:
    LI   R28, 1030
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1224
_L1225:
    LI   R28, 1031
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 516
    ADD  R7, R29, R28
    LI   R28, 516
    ADD  R8, R29, R28
    LI   R8, 512
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, eth_recv
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 1031
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R5, R6
    JZ   R5, _L1228
    JMP  _L1226
    JMP  _L1229
_L1228:
_L1229:
    LI   R28, 1031
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 14
    LI   R7, 20
    ADD  R6, R6, R7
    LI   R7, 8
    ADD  R6, R6, R7
    LI   R7, 12
    ADD  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1230
    JMP  _L1226
    JMP  _L1231
_L1230:
_L1231:
    LI   R28, 516
    ADD  R5, R29, R28
    LI   R6, 14
    ADD  R5, R5, R6
    LI   R6, 20
    ADD  R5, R5, R6
    STORE R5, R29, 1038
    LI   R28, 1038
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    ADD  R5, R5, R6
    STORE R5, R29, 1039
    LI   R28, 1038
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    SHL  R6, R6, R7
    LI   R28, 1038
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    OR  R6, R6, R9
    STORE R6, R29, 1040
    LI   R28, 1039
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    SHL  R6, R6, R7
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    OR  R6, R6, R9
    STORE R6, R29, 1041
    LI   R28, 1040
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 53
    CMPNE  R5, R5, R6
    JZ   R5, _L1232
    JMP  _L1226
    JMP  _L1233
_L1232:
_L1233:
    LI   R28, 1041
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 43981
    CMPNE  R5, R5, R6
    JZ   R5, _L1234
    JMP  _L1226
    JMP  _L1235
_L1234:
_L1235:
    LI   R28, 1042
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 6
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    LI   R28, 1039
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 7
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    OR  R8, R8, R11
    STORE R8, R5, 0
    LI   R28, 1042
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1236
    LI   R5, _STR_120
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1237
_L1236:
_L1237:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 12
    STORE R7, R5, 0
_L1238:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 1031
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 14
    LI   R8, 20
    ADD  R7, R7, R8
    LI   R8, 8
    ADD  R7, R7, R8
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R28, 1039
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1043
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R9, 0
    CMPNE  R7, R7, R9
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1239
    LI   R28, 1039
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1043
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R8, 192
    AND  R6, R6, R8
    LI   R8, 192
    CMPEQ  R6, R6, R8
    JZ   R6, _L1240
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1241
_L1240:
_L1241:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1043
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 1
    ADD  R8, R8, R10
    ADD  R10, R6, R8
    STORE R10, R5, 0
    JMP  _L1238
_L1239:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L1242:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    ADD  R5, R5, R6
    LI   R28, 1031
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 14
    LI   R8, 20
    ADD  R7, R7, R8
    LI   R8, 8
    ADD  R7, R7, R8
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1243
    LI   R28, 1039
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1043
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R8, 192
    AND  R6, R6, R8
    LI   R8, 192
    CMPEQ  R6, R6, R8
    JZ   R6, _L1244
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1245
_L1244:
_L1246:
    LI   R28, 1039
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1043
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    JZ   R8, _L1247
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1043
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 1
    ADD  R8, R8, R10
    ADD  R10, R6, R8
    STORE R10, R5, 0
    JMP  _L1246
_L1247:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L1245:
    LI   R28, 1044
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1043
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 8
    SHL  R8, R8, R10
    LI   R28, 1039
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 1043
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 1
    ADD  R12, R12, R13
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    OR  R8, R8, R12
    STORE R8, R5, 0
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1045
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1043
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 8
    SHL  R8, R8, R10
    LI   R28, 1039
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 1043
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 1
    ADD  R12, R12, R13
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    OR  R8, R8, R12
    STORE R8, R5, 0
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 1044
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPEQ  R5, R5, R6
    LI   R28, 1045
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 4
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1248
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 1039
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1043
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 24
    SHL  R8, R8, R10
    LI   R28, 1039
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 1043
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 1
    ADD  R12, R12, R13
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 16
    SHL  R11, R11, R12
    OR  R8, R8, R11
    LI   R28, 1039
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 1043
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R14, 2
    ADD  R13, R13, R14
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 8
    SHL  R12, R12, R13
    OR  R8, R8, R12
    LI   R28, 1039
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 1043
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R14, R15, R0
    LI   R15, 3
    ADD  R14, R14, R15
    ADD  R13, R13, R14
    LOAD R14, R13, 0
    OR  R8, R8, R14
    STORE R8, R5, 0
    LI   R5, _STR_121
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1039
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1043
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LOAD R11, R9, 0
    LI   R28, 1039
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 1043
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    ADD  R14, R15, R0
    LI   R15, 1
    ADD  R14, R14, R15
    ADD  R13, R13, R14
    LOAD R14, R13, 0
    LI   R28, 1039
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    LI   R28, 1043
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    ADD  R17, R18, R0
    LI   R18, 2
    ADD  R17, R17, R18
    ADD  R16, R16, R17
    LOAD R17, R16, 0
    LI   R28, 1039
    ADD  R18, R29, R28
    LOAD R19, R18, 0
    LI   R28, 1043
    ADD  R20, R29, R28
    LOAD R21, R20, 0
    ADD  R20, R21, R0
    LI   R21, 3
    ADD  R20, R20, R21
    ADD  R19, R19, R20
    LOAD R20, R19, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R11, R0
    ADD  R4, R14, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1197
    JMP  _L1249
_L1248:
_L1249:
    LI   R28, 1043
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1045
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L1242
_L1243:
    JMP  _L1226
_L1227:
    LI   R5, _STR_122
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1197
_L1197:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

parse_url:
    LI   R28, -40
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 8
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 80
    STORE R7, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 104
    CMPEQ  R6, R6, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 116
    CMPEQ  R8, R8, R9
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 2
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 116
    CMPEQ  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 3
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 112
    CMPEQ  R10, R10, R11
    CMPNE R6, R6, R0
    CMPNE R10, R10, R0
    AND   R6, R6, R10
    LI   R28, 8
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R12, 4
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 58
    CMPEQ  R11, R11, R12
    CMPNE R6, R6, R0
    CMPNE R11, R11, R0
    AND   R6, R6, R11
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 5
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 47
    CMPEQ  R12, R12, R13
    CMPNE R6, R6, R0
    CMPNE R12, R12, R0
    AND   R6, R6, R12
    LI   R28, 8
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R14, 6
    ADD  R13, R13, R14
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R14, 47
    CMPEQ  R13, R13, R14
    CMPNE R6, R6, R0
    CMPNE R13, R13, R0
    AND   R6, R6, R13
    JZ   R6, _L1251
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 7
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1252
_L1251:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 104
    CMPEQ  R6, R6, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 116
    CMPEQ  R8, R8, R9
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 2
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 116
    CMPEQ  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 3
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 112
    CMPEQ  R10, R10, R11
    CMPNE R6, R6, R0
    CMPNE R10, R10, R0
    AND   R6, R6, R10
    LI   R28, 8
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R12, 4
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 115
    CMPEQ  R11, R11, R12
    CMPNE R6, R6, R0
    CMPNE R11, R11, R0
    AND   R6, R6, R11
    LI   R28, 8
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 5
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 58
    CMPEQ  R12, R12, R13
    CMPNE R6, R6, R0
    CMPNE R12, R12, R0
    AND   R6, R6, R12
    LI   R28, 8
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R14, 6
    ADD  R13, R13, R14
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R14, 47
    CMPEQ  R13, R13, R14
    CMPNE R6, R6, R0
    CMPNE R13, R13, R0
    AND   R6, R6, R13
    LI   R28, 8
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    LI   R15, 7
    ADD  R14, R14, R15
    LOAD R15, R14, 0
    ADD  R14, R15, R0
    LI   R15, 47
    CMPEQ  R14, R14, R15
    CMPNE R6, R6, R0
    CMPNE R14, R14, R0
    AND   R6, R6, R14
    JZ   R6, _L1253
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 443
    STORE R7, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1254
_L1253:
_L1254:
_L1252:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1255:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 47
    CMPNE  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 58
    CMPNE  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1258
    JMP  _L1256
_L1257:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1255
_L1256:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 1
    ADD  R12, R10, R11
    STORE R12, R9, 0
    ADD  R9, R10, R0
    LOAD R10, R9, 0
    STORE R10, R6, 0
    JMP  _L1257
_L1258:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 58
    CMPEQ  R5, R5, R6
    JZ   R5, _L1259
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1261:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1262
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1261
_L1262:
    JMP  _L1260
_L1259:
_L1260:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 47
    CMPEQ  R5, R5, R6
    JZ   R5, _L1263
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1265:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1268
    JMP  _L1266
_L1267:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1265
_L1266:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 1
    ADD  R12, R10, R11
    STORE R12, R9, 0
    ADD  R9, R10, R0
    LOAD R10, R9, 0
    STORE R10, R6, 0
    JMP  _L1267
_L1268:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    JMP  _L1264
_L1263:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 47
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
_L1264:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPNE  R6, R6, R7
    JZ   R6, _L1269
    LI   R7, 0
    ADD  R6, R7, R0
    JMP  _L1270
_L1269:
    LI   R7, 1
    SUB  R7, R0, R7
    ADD  R6, R7, R0
_L1270:
    ADD  R7, R6, R0
    JMP  _L1250
_L1250:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 40
    ADD  R30, R30, R28
    JALR R0, R31, 0

http_get:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLE  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1272
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1273
_L1272:
_L1273:
    LI   R5, net
    LI   R28, 9
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1274
    LI   R5, _STR_123
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1275
_L1274:
_L1275:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R28, 5
    ADD  R8, R29, R28
    LI   R8, 128
    LI   R28, 901
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 133
    ADD  R10, R29, R28
    LI   R28, 133
    ADD  R11, R29, R28
    LI   R11, 256
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, parse_url
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1276
    LI   R5, _STR_124
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1277
_L1276:
_L1277:
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 902
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, dns_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1278
    LI   R5, _STR_125
    LI   R28, 5
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1279
_L1278:
_L1279:
    LI   R28, 903
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 902
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 901
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 10080
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    ADD  R3, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, tcp_connect
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 903
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1280
    LI   R5, _STR_126
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1281
_L1280:
_L1281:
    LI   R28, 904
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_127
    STORE R5, R29, 908
    LI   R5, _STR_128
    STORE R5, R29, 909
    LI   R5, _STR_129
    STORE R5, R29, 910
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 908
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1282:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1285
    JMP  _L1283
_L1284:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1282
_L1283:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 911
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1284
_L1285:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 133
    ADD  R7, R29, R28
    STORE R7, R5, 0
_L1286:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1289
    JMP  _L1287
_L1288:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1286
_L1287:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 911
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1288
_L1289:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 909
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1290:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1293
    JMP  _L1291
_L1292:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1290
_L1291:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 911
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1292
_L1293:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    STORE R7, R5, 0
_L1294:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1297
    JMP  _L1295
_L1296:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1294
_L1295:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 911
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1296
_L1297:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 910
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1298:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1301
    JMP  _L1299
_L1300:
    LI   R28, 911
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1298
_L1299:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 911
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1300
_L1301:
    LI   R28, 389
    ADD  R5, R29, R28
    LI   R28, 904
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 903
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 389
    ADD  R7, R29, R28
    LI   R28, 904
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, tcp_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1302
    LI   R5, _STR_130
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 903
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_close
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1271
    JMP  _L1303
_L1302:
_L1303:
    LI   R28, 905
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 907
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1304:
    LI   R28, 907
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2000
    CMPLT  R5, R5, R6
    LI   R28, 905
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1307
    JMP  _L1305
_L1306:
    LI   R28, 907
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1304
_L1305:
    LI   R28, 906
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 903
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 905
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 4
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 1
    SUB  R11, R11, R12
    LI   R28, 905
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    SUB  R11, R11, R13
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, tcp_recv
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 906
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1308
    JMP  _L1307
    JMP  _L1309
_L1308:
_L1309:
    LI   R28, 906
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1310
    LI   R28, 905
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 906
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 907
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1311
_L1310:
_L1311:
    JMP  _L1306
_L1307:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 905
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    LI   R28, 903
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_close
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_131
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 905
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 905
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1271
_L1271:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

http_get_print:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R28, 3
    ADD  R8, R29, R28
    LI   R8, 2048
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, http_get
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 2051
    LI   R28, 2051
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1313
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1312
    JMP  _L1314
_L1313:
_L1314:
    LI   R28, 3
    ADD  R5, R29, R28
    STORE R5, R29, 2052
    LI   R28, 2053
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    STORE R7, R5, 0
_L1315:
    LI   R28, 2053
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R28, 2051
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LI   R8, 3
    SUB  R6, R6, R8
    CMPLT  R5, R5, R6
    JZ   R5, _L1318
    JMP  _L1316
_L1317:
    LI   R28, 2053
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1315
_L1316:
    LI   R28, 2053
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 13
    CMPEQ  R6, R6, R7
    LI   R28, 2053
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 10
    CMPEQ  R8, R8, R9
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 2053
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 2
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 13
    CMPEQ  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    LI   R28, 2053
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 3
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    CMPEQ  R10, R10, R11
    CMPNE R6, R6, R0
    CMPNE R10, R10, R0
    AND   R6, R6, R10
    JZ   R6, _L1319
    LI   R28, 2052
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2053
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 4
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1318
    JMP  _L1320
_L1319:
_L1320:
    JMP  _L1317
_L1318:
    LI   R5, _STR_132
    LI   R28, 2052
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2051
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1312
_L1312:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

perms_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1322:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R5, R6
    JZ   R5, _L1325
    JMP  _L1323
_L1324:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1322
_L1323:
    LI   R5, perms
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1324
_L1325:
_L1321:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

perms_register:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1327:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R5, R6
    JZ   R5, _L1330
    JMP  _L1328
_L1329:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1327
_L1328:
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, perms
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 35
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R9, R0
    ADD  R2, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R8, 0
    CMPEQ  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1331
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1326
    JMP  _L1332
_L1331:
_L1332:
    JMP  _L1329
_L1330:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1333:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R5, R6
    JZ   R5, _L1336
    JMP  _L1334
_L1335:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1333
_L1334:
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1337
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, perms
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 35
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 0
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R10, 32
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    JMP  _L1326
    JMP  _L1338
_L1337:
_L1338:
    JMP  _L1335
_L1336:
_L1326:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

check_permission:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1340
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L1339
    JMP  _L1341
_L1340:
_L1341:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1342:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R5, R6
    JZ   R5, _L1345
    JMP  _L1343
_L1344:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1342
_L1343:
    LI   R5, perms
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 35
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, perms
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 35
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R9, R0
    ADD  R2, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    LI   R8, 0
    CMPEQ  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L1346
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, perms
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 35
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 32
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    CMPEQ  R5, R5, R8
    LI   R8, perms
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 35
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 33
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    AND  R8, R8, R11
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    JZ   R5, _L1348
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L1339
    JMP  _L1349
_L1348:
_L1349:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1339
    JMP  _L1347
_L1346:
_L1347:
    JMP  _L1344
_L1345:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1339
_L1339:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_port_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, mmio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 255
    AND  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1350
_L1350:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_port_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mmio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1351:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 103
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, rtc_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_133
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1352:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 103
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, rtc_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 96
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 97
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 98
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 99
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 100
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 101
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 6
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 2000
    LI   R8, 102
    ADD  R1, R8, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, rtc_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, 103
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, rtc_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 59
    CMPLT  R5, R6, R5
    JZ   R5, _L1354
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1355
_L1354:
_L1355:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 59
    CMPLT  R5, R6, R5
    JZ   R5, _L1356
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1357
_L1356:
_L1357:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 23
    CMPLT  R5, R6, R5
    JZ   R5, _L1358
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1359
_L1358:
_L1359:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 6
    CMPLT  R5, R6, R5
    JZ   R5, _L1360
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1361
_L1360:
_L1361:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 31
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1362
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L1363
_L1362:
_L1363:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 12
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1364
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L1365
_L1364:
_L1365:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 6
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2000
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 2099
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1366
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 6
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 2025
    STORE R7, R5, 0
    JMP  _L1367
_L1366:
_L1367:
_L1353:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_timestamp:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 0
    STORE R5, R29, 10
    LI   R5, 31
    STORE R5, R29, 11
    LI   R5, 28
    STORE R5, R29, 12
    LI   R5, 31
    STORE R5, R29, 13
    LI   R5, 30
    STORE R5, R29, 14
    LI   R5, 31
    STORE R5, R29, 15
    LI   R5, 30
    STORE R5, R29, 16
    LI   R5, 31
    STORE R5, R29, 17
    LI   R5, 31
    STORE R5, R29, 18
    LI   R5, 30
    STORE R5, R29, 19
    LI   R5, 31
    STORE R5, R29, 20
    LI   R5, 30
    STORE R5, R29, 21
    LI   R5, 31
    STORE R5, R29, 22
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, rtc_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 23
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 6
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 2000
    SUB  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 23
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 365
    MUL  R7, R7, R8
    LI   R28, 23
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 4
    DIV  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 24
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L1369:
    LI   R28, 24
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1372
    JMP  _L1370
_L1371:
    LI   R28, 24
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1369
_L1370:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 10
    ADD  R7, R29, R28
    LI   R28, 24
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    ADD  R10, R6, R9
    STORE R10, R5, 0
    JMP  _L1371
_L1372:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLT  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 4
    DIV  R8, R6, R7
    MUL  R8, R8, R7
    SUB  R6, R6, R8
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1373
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1374
_L1373:
_L1374:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 4
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 86400
    MUL  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 3600
    MUL  R6, R6, R7
    ADD  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 60
    MUL  R6, R6, R7
    ADD  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L1368
_L1368:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

rtc_format:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 29
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 29
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 6
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1000
    DIV  R9, R9, R10
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 29
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 6
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 100
    DIV  R9, R9, R10
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 29
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 6
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    DIV  R9, R9, R10
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 29
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 6
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R5, 45
    ADD  R1, R5, R0
    LI   R28, WCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, WDIGIT2
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 45
    ADD  R1, R5, R0
    LI   R28, WCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, WDIGIT2
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 32
    ADD  R1, R5, R0
    LI   R28, WCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, WDIGIT2
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 58
    ADD  R1, R5, R0
    LI   R28, WCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, WDIGIT2
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 58
    ADD  R1, R5, R0
    LI   R28, WCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, WDIGIT2
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 29
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1375:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

scheduler_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1377:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1380
    JMP  _L1378
_L1379:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1377
_L1378:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 4
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 16384
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1024
    MUL  R9, R9, R10
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, gui_guard_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1379
_L1380:
_L1376:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

scheduler:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, current_pid
    LOAD R6, R5, 0
    STORE R6, R29, 3
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1382:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1385
    JMP  _L1383
_L1384:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1382
_L1383:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 1
    CMPEQ  R5, R5, R7
    JZ   R5, _L1386
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLT  R5, R8, R5
    JZ   R5, _L1388
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, process_table
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 48
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 34
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1389
_L1388:
_L1389:
    JMP  _L1387
_L1386:
_L1387:
    JMP  _L1384
_L1385:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1390
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1392:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1395
    JMP  _L1393
_L1394:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1392
_L1393:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 3
    CMPEQ  R5, R5, R7
    JZ   R5, _L1396
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1395
    JMP  _L1397
_L1396:
_L1397:
    JMP  _L1394
_L1395:
    JMP  _L1391
_L1390:
_L1391:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, current_pid
    LOAD R7, R6, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L1398
    LI   R5, current_pid
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, context_switch
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1399
_L1398:
_L1399:
_L1381:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

context_switch:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R6, process_table
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 48
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 33
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R8, 2
    CMPEQ  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1401
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    JMP  _L1402
_L1401:
_L1402:
    LI   R5, process_table
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 2
    STORE R8, R5, 0
    LI   R5, current_pid
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, context_switches
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L1400:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

scheduler_run:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
_L1404:
    LI   R5, 1
    JZ   R5, _L1405
    LI   R28, scheduler
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1404
_L1405:
_L1403:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

process_create:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 5
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1407:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1410
    JMP  _L1408
_L1409:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1407
_L1408:
    LI   R5, process_table
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L1411
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1410
    JMP  _L1412
_L1411:
_L1412:
    JMP  _L1409
_L1410:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1413
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1406
    JMP  _L1414
_L1413:
_L1414:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16384
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1024
    MUL  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, 0
    LI   R8, 48
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, memset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 32
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 44
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 31
    LI   R28, 32
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R7, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 10
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, gui_guard_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1406
_L1406:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

process_run_now:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1416
    JMP  _L1415
    JMP  _L1417
_L1416:
_L1417:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 44
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1418
    JMP  _L1415
    JMP  _L1419
_L1418:
_L1419:
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 2
    STORE R8, R5, 0
    LI   R5, current_pid
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, context_switches
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 44
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JALR R31, R7, 0
    ADD  R7, R7, R0
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L1420
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1421
_L1420:
_L1421:
_L1415:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

process_kill:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1423
    LI   R5, process_table
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1424
_L1423:
_L1424:
_L1422:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

get_current_pid:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, current_pid
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1425
_L1425:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_help:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_134
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_135
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_136
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_137
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_138
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_139
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_140
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_141
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_142
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_143
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_144
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_145
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_146
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_147
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_148
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_149
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_150
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_151
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_152
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_153
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_154
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_155
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_156
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_157
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_158
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_159
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_160
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_161
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_162
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_163
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_164
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_165
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_166
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_167
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1432
_L1432:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_ps:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_168
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_169
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 387
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1434:
    LI   R28, 387
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1437
    JMP  _L1435
_L1436:
    LI   R28, 387
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1434
_L1435:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 387
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L1438
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 387
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 48
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ; switch value is in R7
    LI   R28, 388
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_170
    STORE R7, R5, 0
    JMP  _L1440
    LI   R28, 388
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_171
    STORE R7, R5, 0
    JMP  _L1440
    LI   R28, 388
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_172
    STORE R7, R5, 0
    JMP  _L1440
    LI   R28, 388
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_173
    STORE R7, R5, 0
    JMP  _L1440
    LI   R28, 388
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_174
    STORE R7, R5, 0
_L1440:
    LI   R5, _STR_175
    LI   R28, 387
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 388
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 387
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 48
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 34
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R28, 2
    ADD  R13, R29, R28
    LI   R28, 387
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 48
    MUL  R15, R15, R28
    ADD  R13, R13, R15
    LI   R28, 35
    ADD  R13, R13, R28
    LOAD R15, R13, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R12, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1439
_L1438:
_L1439:
    JMP  _L1436
_L1437:
    LI   R5, _STR_176
    LI   R28, 386
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1433
_L1433:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_kill:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, process_kill
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_177
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1441
_L1441:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_clear:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 4278196787
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1442
_L1442:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_gui:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_178
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1444
    LI   R28, 3
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, sys_gui_status
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1446
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1443
    JMP  _L1447
_L1446:
_L1447:
    LI   R5, _STR_179
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    JZ   R7, _L1448
    LI   R8, _STR_180
    ADD  R7, R8, R0
    JMP  _L1449
_L1448:
    LI   R8, _STR_181
    ADD  R7, R8, R0
_L1449:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_182
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 3
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_183
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 4096
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_184
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1443
    JMP  _L1445
_L1444:
_L1445:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_185
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1450
    LI   R28, sys_gui_reset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1443
    JMP  _L1451
_L1450:
_L1451:
    LI   R5, _STR_186
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1443
_L1443:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

cmd_perf:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_187
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_188
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_189
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1452
_L1452:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

simple_atoi:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 0
    STORE R5, R29, 3
    LI   R5, 1
    STORE R5, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 45
    CMPEQ  R5, R5, R6
    JZ   R5, _L1454
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1455
_L1454:
_L1455:
_L1456:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 57
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1457
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 10
    MUL  R7, R7, R8
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 1
    ADD  R11, R9, R10
    STORE R11, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 48
    SUB  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1456
_L1457:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    MUL  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L1453
_L1453:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

split_args:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 5
_L1459:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLT  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1460
_L1461:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPEQ  R5, R5, R6
    JZ   R5, _L1462
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1461
_L1462:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1463
    JMP  _L1460
    JMP  _L1464
_L1463:
_L1464:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
_L1465:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 32
    CMPNE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1466
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1465
_L1466:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1467
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1468
_L1467:
_L1468:
    JMP  _L1459
_L1460:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1458
_L1458:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

shell_main:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_190
    LI   R6, current_uid
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, auth_username
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_191
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1470:
    LI   R5, 1
    JZ   R5, _L1471
    LI   R28, shell_prompt
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1470
_L1471:
_L1469:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

shell_prompt:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 0
    STORE R5, R29, 2
    LI   R5, _STR_192
    LI   R6, current_uid
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, auth_username
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1473:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1474
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, KGETCHAR
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPEQ  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 13
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1475
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, command_buffer
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1474
    JMP  _L1476
_L1475:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPEQ  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1477
    LI   R5, _STR_33
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1478
_L1477:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLE  R5, R6, R5
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 127
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1479
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, KPUTCHAR
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, command_buffer
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L1480
_L1479:
_L1480:
_L1478:
_L1476:
    JMP  _L1473
_L1474:
    LI   R5, command_buffer
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1481
    LI   R5, history
    LI   R6, history_idx
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 10
    DIV  R8, R6, R7
    MUL  R8, R8, R7
    SUB  R6, R6, R8
    LI   R28, 64
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R6, command_buffer
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, history_idx
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1482
_L1481:
_L1482:
    LI   R5, command_buffer
    ADD  R1, R5, R0
    LI   R28, shell_parse_command
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1472:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

shell_parse_command:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 64
    LI   R9, 1
    SUB  R8, R8, R9
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 64
    LI   R7, 1
    SUB  R6, R6, R7
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1484
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1485
_L1484:
_L1485:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_193
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1486
    LI   R28, cmd_help
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1487
_L1486:
_L1487:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_194
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1488
    LI   R28, cmd_ps
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1489
_L1488:
_L1489:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_195
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1490
    LI   R28, cmd_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1491
_L1490:
_L1491:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_196
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1492
    LI   R28, cmd_perf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1493
_L1492:
_L1493:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_197
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1494
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 4
    ADD  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, cmd_gui
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1495
_L1494:
_L1495:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1496
    LI   R5, _STR_8
    ADD  R1, R5, R0
    LI   R28, app_launch
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1498
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1499
_L1498:
    LI   R6, 0
    ADD  R5, R6, R0
_L1499:
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1497
_L1496:
_L1497:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_10
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1500
    LI   R5, _STR_10
    ADD  R1, R5, R0
    LI   R28, app_launch
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1502
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1503
_L1502:
    LI   R6, 0
    ADD  R5, R6, R0
_L1503:
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1501
_L1500:
_L1501:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_12
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1504
    LI   R5, _STR_12
    ADD  R1, R5, R0
    LI   R28, app_launch
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1506
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1507
_L1506:
    LI   R6, 0
    ADD  R5, R6, R0
_L1507:
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1505
_L1504:
_L1505:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_198
    LI   R7, 5
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1508
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 5
    ADD  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 72
    LI   R28, 72
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, cmd_kill
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1509
_L1508:
_L1509:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_199
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1510
    LI   R28, 73
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 4
    ADD  R6, R6, R7
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 73
    ADD  R7, R29, R28
    LI   R28, 67
    ADD  R8, R29, R28
    LI   R9, 2
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, split_args
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_200
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1512
    LI   R28, app_list
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1513
_L1512:
_L1513:
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_201
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1514
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, app_launch
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1516
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1517
_L1516:
    LI   R6, 0
    ADD  R5, R6, R0
_L1517:
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1515
_L1514:
_L1515:
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_202
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1518
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, app_install
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1520
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1521
_L1520:
    LI   R6, 0
    ADD  R5, R6, R0
_L1521:
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1519
_L1518:
_L1519:
    LI   R5, _STR_203
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1511
_L1510:
_L1511:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_204
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1522
    LI   R28, fs_list
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1523
_L1522:
_L1523:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_205
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1524
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 4
    ADD  R5, R5, R6
    LI   R28, 137
    ADD  R6, R29, R28
    LI   R7, 256
    LI   R8, current_uid
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R9, R0
    LI   R28, fs_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 394
    LI   R28, 394
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1526
    LI   R5, _STR_206
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 4
    ADD  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1527
_L1526:
_L1527:
    LI   R28, 137
    ADD  R5, R29, R28
    LI   R28, 394
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, _STR_132
    LI   R28, 137
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1525
_L1524:
_L1525:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_207
    LI   R7, 6
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1528
    LI   R28, 395
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 6
    ADD  R6, R6, R7
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 395
    ADD  R7, R29, R28
    LI   R28, 67
    ADD  R8, R29, R28
    LI   R9, 2
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, split_args
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLT  R5, R5, R6
    JZ   R5, _L1530
    LI   R5, _STR_208
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1531
_L1530:
_L1531:
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 67
    ADD  R7, R29, R28
    LI   R8, 1
    LI   R28, 1
    MUL  R8, R8, R28
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    LI   R28, 67
    ADD  R9, R29, R28
    LI   R10, 1
    LI   R28, 1
    MUL  R10, R10, R28
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    ADD  R1, R10, R0
    LI   R28, -4
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    STORE R8, R30, 3
    LI   R28, kstrlen
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LOAD R8, R30, 3
    LI   R28, 4
    ADD  R30, R30, R28
    ADD  R9, R7, R0  ; sonuç = R7
    LI   R10, current_uid
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, fs_create
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1529
_L1528:
_L1529:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_209
    LI   R7, 3
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1532
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 3
    ADD  R5, R5, R6
    LI   R6, current_uid
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, fs_delete
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1534
    LI   R5, _STR_210
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 3
    ADD  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1535
_L1534:
_L1535:
    LI   R5, _STR_211
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 3
    ADD  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1533
_L1532:
_L1533:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_212
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1536
    LI   R5, _STR_213
    LI   R6, current_uid
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, auth_username
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, current_uid
    LOAD R8, R7, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R8, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1537
_L1536:
_L1537:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_214
    LI   R7, 7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1538
    LI   R5, current_uid
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 7
    ADD  R7, R7, R8
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, auth_set_password
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_215
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1539
_L1538:
_L1539:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_216
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1540
    LI   R5, _STR_217
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, login_prompt
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1542
    LI   R5, _STR_218
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1544:
    LI   R5, 1
    JZ   R5, _L1545
    JMP  _L1544
_L1545:
    JMP  _L1543
_L1542:
_L1543:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1541
_L1540:
_L1541:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_219
    LI   R7, 6
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1546
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 6
    ADD  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    LI   R28, wm_set_theme
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1547
_L1546:
_L1547:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_220
    LI   R7, 6
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1548
    LI   R28, 459
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 6
    ADD  R6, R6, R7
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 459
    ADD  R7, R29, R28
    LI   R28, 67
    ADD  R8, R29, R28
    LI   R9, 2
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, split_args
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLT  R5, R5, R6
    JZ   R5, _L1550
    LI   R5, _STR_221
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1551
_L1550:
_L1551:
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 1
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, mouse_move
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_run
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_222
    LI   R6, mouse
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, mouse
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1549
_L1548:
_L1549:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_223
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1552
    LI   R5, 0
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, mouse_button
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_run
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_224
    LI   R6, mouse
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, mouse
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, mouse_button
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wm_run
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1553
_L1552:
_L1553:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_225
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, _STR_226
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1554
    LI   R5, _STR_227
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1556:
    LI   R5, 1
    JZ   R5, _L1557
    JMP  _L1556
_L1557:
    JMP  _L1555
_L1554:
_L1555:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_228
    LI   R7, 6
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1558
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 6
    ADD  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 523
    LI   R28, 523
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 9
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, signal_deliver
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_229
    LI   R28, 523
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1559
_L1558:
_L1559:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_230
    LI   R7, 7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1560
    LI   R28, 524
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 7
    ADD  R6, R6, R7
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 524
    ADD  R7, R29, R28
    LI   R28, 67
    ADD  R8, R29, R28
    LI   R9, 2
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, split_args
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLT  R5, R5, R6
    JZ   R5, _L1562
    LI   R5, _STR_231
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1563
_L1562:
_L1563:
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 0
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 588
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 589
    LI   R28, 588
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 589
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, signal_deliver
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_232
    LI   R28, 589
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 588
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1561
_L1560:
_L1561:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_233
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1564
    LI   R28, 590
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, rtc_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 590
    ADD  R5, R29, R28
    LI   R28, 597
    ADD  R6, R29, R28
    LI   R28, 597
    ADD  R7, R29, R28
    LI   R7, 32
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, rtc_format
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 629
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 630
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sys_gettime
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_234
    LI   R28, 597
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_235
    LI   R28, 630
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 629
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 10
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1565
_L1564:
_L1565:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_236
    LI   R7, 6
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1566
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 6
    ADD  R5, R5, R6
    ADD  R1, R5, R0
    LI   R28, simple_atoi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 631
    LI   R28, 631
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, sys_alarm
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 631
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1568
    LI   R5, _STR_237
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1569
_L1568:
    LI   R5, _STR_238
    LI   R28, 631
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1569:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1567
_L1566:
_L1567:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_239
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1570
    LI   R5, _STR_240
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, sys_yield
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_241
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1571
_L1570:
_L1571:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_242
    LI   R7, 5
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1572
    LI   R28, 632
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LI   R7, 5
    ADD  R6, R6, R7
    LI   R7, 64
    LI   R8, 1
    SUB  R7, R7, R8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 632
    ADD  R7, R29, R28
    LI   R28, 67
    ADD  R8, R29, R28
    LI   R9, 3
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, split_args
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_243
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1574
    LI   R28, wifi_scan
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, wifi_print_scan
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1575
_L1574:
_L1575:
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_178
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1576
    LI   R28, wifi_status
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1577
_L1576:
_L1577:
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_244
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1578
    LI   R28, wifi_disconnect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1579
_L1578:
_L1579:
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPLE  R5, R6, R5
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, _STR_245
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1580
    LI   R28, 71
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLE  R5, R6, R5
    JZ   R5, _L1582
    LI   R28, 67
    ADD  R6, R29, R28
    LI   R7, 2
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R5, R7, R0
    JMP  _L1583
_L1582:
    LI   R6, _STR_68
    ADD  R5, R6, R0
_L1583:
    STORE R5, R29, 696
    LI   R28, 67
    ADD  R5, R29, R28
    LI   R6, 1
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R28, 696
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, wifi_connect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1581
_L1580:
_L1581:
    LI   R5, _STR_246
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1573
_L1572:
_L1573:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_247
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1584
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 4
    ADD  R5, R5, R6
    LI   R6, _STR_248
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1586
    LI   R28, 699
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, get_current_pid
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 699
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 699
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 697
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 698
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, pipe_create
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1588
    LI   R5, _STR_249
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1589
_L1588:
_L1589:
    LI   R28, 698
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_250
    LI   R8, 19
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, pipe_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 700
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 697
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 701
    ADD  R9, R29, R28
    LI   R28, 701
    ADD  R10, R29, R28
    LI   R10, 64
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, pipe_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 701
    ADD  R5, R29, R28
    LI   R28, 700
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R6, R7
    JZ   R6, _L1590
    LI   R7, 0
    ADD  R6, R7, R0
    JMP  _L1591
_L1590:
    LI   R28, 700
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R8, R0
_L1591:
    LI   R28, 1
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_251
    LI   R28, 701
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 697
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, pipe_close
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 698
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, pipe_close
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1587
_L1586:
_L1587:
    LI   R5, _STR_252
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1585
_L1584:
_L1585:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_253
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1592
    LI   R28, syslog_dump
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1483
    JMP  _L1593
_L1592:
_L1593:
    LI   R5, _STR_254
    LI   R28, 3
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1483
_L1483:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

valid_mask:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLE  R5, R6, R5
    JZ   R5, _L1595
    LI   R5, 4294967295
    ADD  R7, R5, R0
    JMP  _L1594
    JMP  _L1596
_L1595:
_L1596:
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1597
    LI   R6, 0
    ADD  R5, R6, R0
    JMP  _L1598
_L1597:
    LI   R6, 1
    LI   R7, active_cores
    LOAD R8, R7, 0
    SHL  R6, R6, R8
    LI   R8, 1
    SUB  R6, R6, R8
    ADD  R5, R6, R0
_L1598:
    ADD  R7, R5, R0
    JMP  _L1594
_L1594:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_init:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, active_cores
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1600
    LI   R5, active_cores
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L1601
_L1600:
_L1601:
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R6, R5
    JZ   R5, _L1602
    LI   R5, active_cores
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L1603
_L1602:
_L1603:
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R6, R5
    JZ   R5, _L1604
    LI   R5, active_cores
    LOAD R6, R5, 0
    LI   R7, 32
    STORE R7, R5, 0
    JMP  _L1605
_L1604:
_L1605:
    LI   R5, stats
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, stats
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, active_cores
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, stats
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, stats
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, stats
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, stats
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, active_core
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1606:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPLT  R5, R5, R6
    JZ   R5, _L1609
    JMP  _L1607
_L1608:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1606
_L1607:
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, active_cores
    LOAD R10, R9, 0
    CMPLT  R8, R8, R10
    JZ   R8, _L1610
    LI   R10, 1
    ADD  R9, R10, R0
    JMP  _L1611
_L1610:
    LI   R10, 0
    ADD  R9, R10, R0
_L1611:
    STORE R9, R5, 0
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1608
_L1609:
_L1599:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_online_count:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, active_cores
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1612
_L1612:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_online_mask:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, valid_mask
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1613
_L1613:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_core_online:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, active_cores
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    LI   R7, cores
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 6
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R9, 0
    CMPNE  R7, R7, R9
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L1614
_L1614:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_current_core:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, active_core
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1615
_L1615:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_set_current_core:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1617
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1616
    JMP  _L1618
_L1617:
_L1618:
    LI   R5, active_core
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1616
_L1616:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_pick_core:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, valid_mask
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    AND  R5, R5, R6
    STORE R5, R29, 4
    LI   R5, 32
    STORE R5, R29, 5
    LI   R5, 4294967295
    STORE R5, R29, 6
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1620
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1619
    JMP  _L1621
_L1620:
_L1621:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1622:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, active_cores
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1625
    JMP  _L1623
_L1624:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1622
_L1623:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SHL  R6, R6, R8
    AND  R5, R5, R6
    LI   R7, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L1626
    JMP  _L1624
    JMP  _L1627
_L1626:
_L1627:
    LI   R5, cores
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    JZ   R5, _L1628
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, cores
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 6
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 3
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    JMP  _L1629
_L1628:
_L1629:
    JMP  _L1624
_L1625:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    CMPEQ  R5, R5, R6
    JZ   R5, _L1630
    LI   R6, 1
    SUB  R6, R0, R6
    ADD  R5, R6, R0
    JMP  _L1631
_L1630:
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R7, R0
_L1631:
    ADD  R7, R5, R0
    JMP  _L1619
_L1619:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_dispatch:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1633
    JMP  _L1632
    JMP  _L1634
_L1633:
_L1634:
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPNE  R5, R5, R8
    JZ   R5, _L1635
    LI   R5, stats
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1636
_L1635:
_L1636:
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R5, 0
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R5, 0
    LI   R5, stats
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L1632:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_account_tick:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1638
    JMP  _L1637
    JMP  _L1639
_L1638:
_L1639:
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L1640
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    SUB  R9, R7, R8
    STORE R9, R5, 0
    JMP  _L1641
_L1640:
_L1641:
_L1637:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_send_ipi:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 31
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1643
    JMP  _L1642
    JMP  _L1644
_L1643:
_L1644:
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    SUB  R9, R9, R10
    SHL  R8, R8, R9
    OR   R9, R7, R8
    STORE R9, R5, 0
    LI   R5, stats
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L1642:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_handle_ipi:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1646
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1645
    JMP  _L1647
_L1646:
_L1647:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, cores
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 6
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 4
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    LI   R5, cores
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 6
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPNE  R5, R5, R6
    JZ   R5, _L1648
    LI   R5, stats
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1649
_L1648:
_L1649:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1645
_L1645:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_get_core_info:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    CMPEQ R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, smp_core_online
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1651
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1650
    JMP  _L1652
_L1651:
_L1652:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, cores
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 6
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1650
_L1650:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

smp_get_stats:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    CMPEQ R5, R5, R0
    JZ   R5, _L1654
    JMP  _L1653
    JMP  _L1655
_L1654:
_L1655:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, stats
    STORE R7, R5, 0
_L1653:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

snd_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mmio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1656:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

snd_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, mmio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1657
_L1657:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 64
    LI   R6, 2
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 68
    LI   R6, 200
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_255
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1658:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_beep:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 64
    LI   R6, 2
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 65
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 255
    AND  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 66
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    SHR  R6, R6, R7
    LI   R7, 255
    AND  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 67
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 64
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1659:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_stop:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 64
    LI   R6, 2
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1660:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_is_playing:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 69
    ADD  R1, R5, R0
    LI   R28, snd_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 1
    AND  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1661
_L1661:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_set_volume:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 68
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, snd_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1662:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_play_note:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 5
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPLT  R5, R5, R6
    JZ   R5, _L1664
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    JMP  _L1665
_L1664:
_L1665:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R6, R5
    JZ   R5, _L1666
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    STORE R7, R5, 0
    JMP  _L1667
_L1666:
_L1667:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 4
    SUB  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1668
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SHL  R7, R7, R9
    STORE R7, R5, 0
    JMP  _L1669
_L1668:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1670
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    SUB  R8, R0, R8
    SHR  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1671
_L1670:
_L1671:
_L1669:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 65535
    CMPLT  R5, R6, R5
    JZ   R5, _L1672
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 65535
    STORE R7, R5, 0
    JMP  _L1673
_L1672:
_L1673:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 20
    CMPLT  R5, R5, R6
    JZ   R5, _L1674
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 20
    STORE R7, R5, 0
    JMP  _L1675
_L1674:
_L1675:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1663:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_sfx:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R5, 262
    LI   R6, 120
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 330
    LI   R6, 120
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 392
    LI   R6, 200
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1677
    LI   R5, 200
    LI   R6, 300
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1677
    LI   R5, 440
    LI   R6, 80
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 523
    LI   R6, 80
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1677
    LI   R5, 800
    LI   R6, 30
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1677
    JMP  _L1677
_L1677:
_L1676:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

sound_play_melody:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1679:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L1682
    JMP  _L1680
_L1681:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1679
_L1680:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 1
    CMPEQ  R5, R5, R7
    JZ   R5, _L1683
    LI   R28, sound_stop
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1684
_L1683:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 2
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R10, R0
    LI   R28, sound_beep
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1684:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 100
    MUL  R5, R5, R7
    STORE R5, R29, 4
_L1685:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1686
    JMP  _L1685
_L1686:
    JMP  _L1681
_L1682:
    LI   R28, sound_stop
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1678:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

spin_init:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1687:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

spin_lock:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
_L1693:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    LI   R8, 1
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, ATOMIC_CAS
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1694
    JMP  _L1693
_L1694:
    LI   R28, MEMORY_BARRIER
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1692:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

spin_unlock:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, MEMORY_BARRIER
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, ATOMIC_STORE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1695:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

spin_trylock:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    LI   R8, 1
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, ATOMIC_CAS
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1696
_L1696:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

ipi_send:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, smp_send_ipi
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1697:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

slog_vformat:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
_L1699:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1700
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 37
    CMPNE  R5, R5, R6
    JZ   R5, _L1701
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1699
    JMP  _L1702
_L1701:
_L1702:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    STORE R5, R29, 7
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1704
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, _STR_261
    STORE R7, R5, 0
    JMP  _L1705
_L1704:
_L1705:
_L1706:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1707
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1706
_L1707:
    JMP  _L1703
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    STORE R5, R29, 8
    LI   R5, 0
    STORE R5, R29, 25
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1708
    LI   R5, 45
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    SUB  R7, R0, R7
    STORE R7, R5, 0
    JMP  _L1709
_L1708:
_L1709:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1710
    LI   R5, 48
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
    JMP  _L1711
_L1710:
_L1711:
_L1712:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1713
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 25
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 8
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 10
    DIV  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1712
_L1713:
_L1714:
    LI   R28, 25
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L1715
    LI   R28, 9
    ADD  R5, R29, R28
    LI   R28, 25
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R1, R7, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1714
_L1715:
    JMP  _L1703
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    STORE R5, R29, 26
    LI   R5, 0
    STORE R5, R29, 43
    LI   R28, 26
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1716
    LI   R5, 48
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
    JMP  _L1717
_L1716:
_L1717:
_L1718:
    LI   R28, 26
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1719
    LI   R28, 27
    ADD  R5, R29, R28
    LI   R28, 43
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 48
    LI   R28, 26
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 10
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    SUB  R9, R9, R11
    ADD  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 26
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 10
    DIV  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1718
_L1719:
_L1720:
    LI   R28, 43
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L1721
    LI   R28, 27
    ADD  R5, R29, R28
    LI   R28, 43
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R1, R7, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1720
_L1721:
    JMP  _L1703
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    STORE R5, R29, 44
    LI   R5, 0
    STORE R5, R29, 61
    LI   R5, _STR_262
    STORE R5, R29, 62
    LI   R5, 48
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 120
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 44
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1722
    LI   R5, 48
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
    JMP  _L1723
_L1722:
_L1723:
_L1724:
    LI   R28, 44
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1725
    LI   R28, 45
    ADD  R5, R29, R28
    LI   R28, 61
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 62
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 44
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 15
    AND  R10, R10, R11
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    STORE R10, R5, 0
    LI   R28, 44
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    SHR  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1724
_L1725:
_L1726:
    LI   R28, 61
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JZ   R6, _L1727
    LI   R28, 45
    ADD  R5, R29, R28
    LI   R28, 61
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R1, R7, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1726
_L1727:
    JMP  _L1703
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
    LI   R5, 37
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
    LI   R5, 63
    ADD  R1, R5, R0
    LI   R28, SPUT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1703
_L1703:
    JMP  _L1699
_L1700:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1698
_L1698:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

slog_strncpy:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 5
_L1729:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L1730
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R10, R10, R12
    LOAD R12, R10, 0
    STORE R12, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1729
_L1730:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
_L1728:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

syslog_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, slog_head
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, slog_total
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, 1
    LI   R6, _STR_263
    LI   R7, _STR_264
    LI   R8, 128
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, klog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1731:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

klog:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLT  R5, R6, R5
    JZ   R5, _L1733
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    STORE R7, R5, 0
    JMP  _L1734
_L1733:
_L1734:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, slog_buf
    LI   R8, slog_head
    LOAD R9, R8, 0
    LI   R28, 94
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, total_ticks
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    JZ   R9, _L1735
    LI   R28, 3
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R11, R0
    JMP  _L1736
_L1735:
    LI   R10, _STR_265
    ADD  R9, R10, R0
_L1736:
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 2
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    LI   R10, 12
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, slog_strncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, va_start
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 80
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, slog_vformat
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, va_end
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, slog_head
    LOAD R6, R5, 0
    LI   R7, slog_head
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    LI   R8, 128
    DIV  R9, R7, R8
    MUL  R9, R9, R8
    SUB  R7, R7, R9
    STORE R7, R5, 0
    LI   R5, slog_total
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLE  R5, R6, R5
    JZ   R5, _L1737
    LI   R5, _STR_266
    LI   R6, level_str
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 2
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    LI   R28, 5
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 14
    ADD  R13, R13, R28
    LOAD R14, R13, 0
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R11, R0
    ADD  R4, R14, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1738
_L1737:
_L1738:
_L1732:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

print_entry:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, _STR_267
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, level_str
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 5
    CMPLT  R9, R9, R10
    JZ   R9, _L1740
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R9, R11, R0
    JMP  _L1741
_L1740:
    LI   R10, 4
    ADD  R9, R10, R0
_L1741:
    LI   R28, 1
    MUL  R9, R9, R28
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 2
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    LI   R28, 2
    ADD  R12, R29, R28
    LI   R28, 14
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1739:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

syslog_dump:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLT  R5, R5, R6
    JZ   R5, _L1743
    LI   R6, slog_total
    LOAD R7, R6, 0
    ADD  R5, R7, R0
    JMP  _L1744
_L1743:
    LI   R6, 128
    ADD  R5, R6, R0
_L1744:
    STORE R5, R29, 2
    LI   R5, _STR_268
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    CMPEQ  R8, R8, R9
    JZ   R8, _L1745
    LI   R9, 115
    ADD  R8, R9, R0
    JMP  _L1746
_L1745:
    LI   R9, 115
    ADD  R8, R9, R0
_L1746:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1747
    JMP  _L1742
    JMP  _L1748
_L1747:
_L1748:
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLE  R5, R5, R6
    JZ   R5, _L1749
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1750
_L1749:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, slog_head
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L1750:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1751:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1754
    JMP  _L1752
_L1753:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1751
_L1752:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 128
    DIV  R8, R5, R7
    MUL  R8, R8, R7
    SUB  R5, R5, R8
    STORE R5, R29, 5
    LI   R5, slog_buf
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 94
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, print_entry
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1753
_L1754:
    LI   R5, _STR_269
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1742:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

syslog_dump_last:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLT  R5, R5, R6
    JZ   R5, _L1756
    LI   R6, slog_total
    LOAD R7, R6, 0
    ADD  R5, R7, R0
    JMP  _L1757
_L1756:
    LI   R6, 128
    ADD  R5, R6, R0
_L1757:
    STORE R5, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L1758
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1759
_L1758:
_L1759:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R5, R6
    JZ   R5, _L1760
    JMP  _L1755
    JMP  _L1761
_L1760:
_L1761:
    LI   R5, _STR_270
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, slog_head
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    LI   R9, 128
    DIV  R10, R7, R9
    MUL  R10, R10, R9
    SUB  R7, R7, R10
    LI   R9, 128
    ADD  R7, R7, R9
    LI   R9, 128
    DIV  R10, R7, R9
    MUL  R10, R10, R9
    SUB  R7, R7, R10
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1762:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1765
    JMP  _L1763
_L1764:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1762
_L1763:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 128
    DIV  R8, R5, R7
    MUL  R8, R8, R7
    SUB  R5, R5, R8
    STORE R5, R29, 6
    LI   R5, slog_buf
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 94
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, print_entry
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1764
_L1765:
_L1755:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

syslog_dump_level:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLT  R5, R5, R6
    JZ   R5, _L1767
    LI   R6, slog_total
    LOAD R7, R6, 0
    ADD  R5, R7, R0
    JMP  _L1768
_L1767:
    LI   R6, 128
    ADD  R5, R6, R0
_L1768:
    STORE R5, R29, 3
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLE  R5, R5, R6
    JZ   R5, _L1769
    LI   R6, 0
    ADD  R5, R6, R0
    JMP  _L1770
_L1769:
    LI   R6, slog_head
    LOAD R7, R6, 0
    ADD  R5, R7, R0
_L1770:
    STORE R5, R29, 4
    LI   R5, _STR_271
    LI   R6, level_str
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 5
    CMPLT  R7, R7, R8
    JZ   R7, _L1771
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R9, R0
    JMP  _L1772
_L1771:
    LI   R8, 4
    ADD  R7, R8, R0
_L1772:
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1773:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1776
    JMP  _L1774
_L1775:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1773
_L1774:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 128
    DIV  R8, R5, R7
    MUL  R8, R8, R7
    SUB  R5, R5, R8
    STORE R5, R29, 6
    LI   R5, slog_buf
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 94
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLE  R5, R8, R5
    JZ   R5, _L1777
    LI   R5, slog_buf
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 94
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, print_entry
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1778
_L1777:
_L1778:
    JMP  _L1775
_L1776:
_L1766:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

syslog_count:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, slog_total
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 128
    CMPLT  R5, R5, R6
    JZ   R5, _L1780
    LI   R6, slog_total
    LOAD R7, R6, 0
    ADD  R5, R7, R0
    JMP  _L1781
_L1780:
    LI   R6, 128
    ADD  R5, R6, R0
_L1781:
    ADD  R7, R5, R0
    JMP  _L1779
_L1779:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_next_isn:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, tcp_isn_seed
    LOAD R6, R5, 0
    LI   R7, tcp_isn_seed
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 13
    SHL  R7, R7, R8
    XOR  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, tcp_isn_seed
    LOAD R6, R5, 0
    LI   R7, tcp_isn_seed
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 17
    SHR  R7, R7, R8
    XOR  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, tcp_isn_seed
    LOAD R6, R5, 0
    LI   R7, tcp_isn_seed
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 5
    SHL  R7, R7, R8
    XOR  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, tcp_isn_seed
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1782
_L1782:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

alloc_conn:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1784:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1787
    JMP  _L1785
_L1786:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1784
_L1785:
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2059
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1788
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L1783
    JMP  _L1789
_L1788:
_L1789:
    JMP  _L1786
_L1787:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1783
_L1783:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

conn_id:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R6, conns
    SUB  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1790
_L1790:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_checksum:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    SHR  R7, R7, R8
    LI   R8, 65535
    AND  R7, R7, R8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 65535
    AND  R7, R7, R8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    SHR  R7, R7, R8
    LI   R8, 65535
    AND  R7, R7, R8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 65535
    AND  R7, R7, R8
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 6
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1792:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    ADD  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1795
    JMP  _L1793
_L1794:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1792
_L1793:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    ADD  R8, R10, R0
    LI   R10, 8
    SHL  R8, R8, R10
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 7
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 1
    ADD  R12, R12, R13
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    OR  R8, R8, R12
    ADD  R12, R6, R8
    STORE R12, R5, 0
    JMP  _L1794
_L1795:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L1796
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 5
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 1
    SUB  R9, R9, R10
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L1797
_L1796:
_L1797:
_L1798:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    SHR  R5, R5, R6
    JZ   R5, _L1799
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 65535
    AND  R7, R7, R8
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L1798
_L1799:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, -1
    XOR  R5, R5, R28
    ADD  R7, R5, R0
    JMP  _L1791
_L1791:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_build_segment:
    LI   R28, -40
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R5, 20
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    STORE R5, R29, 8
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L1801
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1800
    JMP  _L1802
_L1801:
_L1802:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 4
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 3
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 4
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 4
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 5
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 6
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 7
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 5
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 7
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 9
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 7
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 16
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 10
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 7
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 11
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 7
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 12
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 5
    LI   R9, 4
    SHL  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 13
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 14
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 8
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 15
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 8
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 17
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 18
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 19
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1803
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 20
    ADD  R5, R5, R6
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1804
_L1803:
_L1804:
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 6
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 8
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    ADD  R3, R12, R0
    ADD  R4, R14, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, tcp_checksum
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 9
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 17
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R28, 9
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1800
_L1800:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 40
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_send_segment:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 6
    ADD  R12, R29, R28
    LI   R28, 6
    ADD  R13, R29, R28
    LI   R13, 1518
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, tcp_build_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 1524
    LI   R28, 1524
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1806
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1805
    JMP  _L1807
_L1806:
_L1807:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 6
    LI   R28, 6
    ADD  R8, R29, R28
    LI   R28, 1524
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R10, R0
    LI   R28, ip_send
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1805
_L1805:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1809:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1812
    JMP  _L1810
_L1811:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1809
_L1810:
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R7, 0
    LI   R8, 2060
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L1811
_L1812:
    LI   R5, _STR_272
    LI   R6, 8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1808:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_connect:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, alloc_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 5
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1814
    LI   R5, _STR_273
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1813
    JMP  _L1815
_L1814:
_L1815:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, tcp_next_isn
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1024
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1033
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2058
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1816
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1813
    JMP  _L1817
_L1816:
_L1817:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R5, _STR_274
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 24
    SHR  R6, R6, R7
    LI   R7, 255
    AND  R6, R6, R7
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHR  R8, R8, R9
    LI   R9, 255
    AND  R8, R8, R9
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 255
    AND  R9, R9, R10
    LI   R28, 3
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, conn_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1813
_L1813:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_listen:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, alloc_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1819
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1818
    JMP  _L1820
_L1819:
_L1820:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    LI   R8, 1
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 2
    STORE R8, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, net
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1024
    STORE R8, R6, 0
    LI   R5, _STR_275
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, conn_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1818
_L1818:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_accept:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_get_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1822
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1821
    JMP  _L1823
_L1822:
_L1823:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 3
    CMPEQ  R6, R6, R7
    JZ   R6, _L1824
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1821
    JMP  _L1825
_L1824:
_L1825:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1821
_L1821:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_send:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_get_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 5
    LI   R5, 0
    STORE R5, R29, 6
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 3
    CMPNE  R7, R7, R8
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L1827
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L1826
    JMP  _L1828
_L1827:
_L1828:
_L1829:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1830
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 7
    LI   R5, 1518
    LI   R6, 20
    SUB  R5, R5, R6
    LI   R6, 20
    SUB  R5, R5, R6
    STORE R5, R29, 8
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L1831
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L1832
_L1831:
_L1832:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    LI   R8, 8
    OR  R7, R7, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 6
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LI   R28, 7
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R11, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1833
    JMP  _L1830
    JMP  _L1834
_L1833:
_L1834:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R10, R7, R9
    STORE R10, R6, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L1829
_L1830:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1826
_L1826:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_recv:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_get_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 5
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2058
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 0
    CMPEQ  R7, R7, R8
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L1836
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1835
    JMP  _L1837
_L1836:
_L1837:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2058
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    CMPLT  R7, R7, R10
    JZ   R7, _L1838
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R11, R0
    JMP  _L1839
_L1838:
    LI   R28, 5
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 2058
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R9, R12, R0
_L1839:
    STORE R9, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1034
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R1, R6, R0
    ADD  R2, R9, R0
    ADD  R3, R11, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2058
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R10, R7, R9
    STORE R10, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2058
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R7, R6
    JZ   R6, _L1840
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1034
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1034
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 2058
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R13, R0
    LI   R28, kmemmove
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1841
_L1840:
_L1841:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L1835
_L1835:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_close:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, tcp_get_conn
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1843
    JMP  _L1842
    JMP  _L1844
_L1843:
_L1844:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 3
    CMPEQ  R6, R6, R7
    JZ   R6, _L1845
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R8, 16
    OR  R7, R7, R8
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 4
    STORE R8, R6, 0
    LI   R5, _STR_276
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1846
_L1845:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
_L1846:
_L1842:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_poll:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
_L1848:
    LI   R28, 1520
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R8, 1518
    ADD  R1, R7, R0
    ADD  R2, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, eth_recv
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPLT  R5, R7, R5
    JZ   R5, _L1849
    LI   R28, 1520
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 14
    LI   R7, 20
    ADD  R6, R6, R7
    LI   R7, 20
    ADD  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L1850
    JMP  _L1848
    JMP  _L1851
_L1850:
_L1851:
    LI   R28, 1522
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R8, 14
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 1522
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 9
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 6
    CMPNE  R6, R6, R7
    JZ   R6, _L1852
    JMP  _L1848
    JMP  _L1853
_L1852:
_L1853:
    LI   R28, 1524
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1522
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 12
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHL  R8, R8, R9
    LI   R28, 1522
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 13
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 16
    SHL  R10, R10, R11
    OR  R8, R8, R10
    LI   R28, 1522
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R12, 14
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 8
    SHL  R11, R11, R12
    OR  R8, R8, R11
    LI   R28, 1522
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 15
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    OR  R8, R8, R13
    STORE R8, R5, 0
    LI   R28, 1523
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1522
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 20
    ADD  R7, R7, R8
    STORE R7, R5, 0
    LI   R28, 1525
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 0
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    LI   R28, 1523
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 1
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    OR  R8, R8, R11
    STORE R8, R5, 0
    LI   R28, 1526
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 2
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 8
    SHL  R8, R8, R9
    LI   R28, 1523
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 3
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    OR  R8, R8, R11
    STORE R8, R5, 0
    LI   R28, 1527
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 4
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHL  R8, R8, R9
    LI   R28, 1523
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 5
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 16
    SHL  R10, R10, R11
    OR  R8, R8, R10
    LI   R28, 1523
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R12, 6
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 8
    SHL  R11, R11, R12
    OR  R8, R8, R11
    LI   R28, 1523
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 7
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    OR  R8, R8, R13
    STORE R8, R5, 0
    LI   R28, 1528
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 8
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 24
    SHL  R8, R8, R9
    LI   R28, 1523
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 9
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 16
    SHL  R10, R10, R11
    OR  R8, R8, R10
    LI   R28, 1523
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R12, 10
    ADD  R11, R11, R12
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R12, 8
    SHL  R11, R11, R12
    OR  R8, R8, R11
    LI   R28, 1523
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R13, 11
    ADD  R12, R12, R13
    LOAD R13, R12, 0
    OR  R8, R8, R13
    STORE R8, R5, 0
    LI   R28, 1529
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 13
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R28, 1530
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1523
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 12
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 4
    SHR  R8, R8, R9
    LI   R9, 4
    MUL  R8, R8, R9
    STORE R8, R5, 0
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1520
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 14
    SUB  R7, R7, R8
    LI   R8, 20
    SUB  R7, R7, R8
    LI   R28, 1530
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    SUB  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1854
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1855
_L1854:
_L1855:
    LI   R28, 1521
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1856:
    LI   R28, 1521
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1859
    JMP  _L1857
_L1858:
    LI   R28, 1521
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1856
_L1857:
    LI   R5, conns
    LI   R28, 1521
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    STORE R5, R29, 1532
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L1860
    JMP  _L1858
    JMP  _L1861
_L1860:
_L1861:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    CMPEQ  R6, R6, R7
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 1524
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 1532
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 4
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 1525
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    CMPEQ  R10, R10, R12
    CMPNE R6, R6, R0
    CMPNE R10, R10, R0
    AND   R6, R6, R10
    LI   R28, 1532
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R28, 1526
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    CMPEQ  R12, R12, R14
    CMPNE R6, R6, R0
    CMPNE R12, R12, R0
    AND   R6, R6, R12
    LI   R28, 1529
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R14, 2
    LI   R15, 16
    OR  R14, R14, R15
    AND  R13, R13, R14
    LI   R14, 2
    LI   R15, 16
    OR  R14, R14, R15
    CMPEQ  R13, R13, R14
    CMPNE R6, R6, R0
    CMPNE R13, R13, R0
    AND   R6, R6, R13
    JZ   R6, _L1862
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1527
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    ADD  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1528
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 3
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_277
    LI   R28, 1521
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1859
    JMP  _L1863
_L1862:
_L1863:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 2
    CMPEQ  R6, R6, R7
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 1526
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 1529
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 2
    AND  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    LI   R28, 1529
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 16
    AND  R9, R9, R10
    CMPEQ R9, R9, R0
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    JZ   R6, _L1864
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1524
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1525
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1527
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 1
    ADD  R8, R8, R9
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, tcp_next_isn
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1532
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 5
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    STORE R10, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    LI   R8, 16
    OR  R7, R7, R8
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 3
    STORE R8, R6, 0
    LI   R5, _STR_278
    LI   R28, 1521
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1526
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1859
    JMP  _L1865
_L1864:
_L1865:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 3
    CMPEQ  R6, R6, R7
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 1524
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 1532
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 4
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 1525
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    CMPEQ  R10, R10, R12
    CMPNE R6, R6, R0
    CMPNE R10, R10, R0
    AND   R6, R6, R10
    LI   R28, 1532
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R28, 1526
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    CMPEQ  R12, R12, R14
    CMPNE R6, R6, R0
    CMPNE R12, R12, R0
    AND   R6, R6, R12
    JZ   R6, _L1866
    LI   R28, 1529
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    AND  R5, R5, R6
    LI   R28, 1528
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 6
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    CMPLT  R6, R9, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1868
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1528
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    JMP  _L1869
_L1868:
_L1869:
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R28, 1527
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 7
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    CMPEQ  R6, R6, R9
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1870
    LI   R5, 1024
    LI   R28, 1532
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2058
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    SUB  R5, R5, R8
    STORE R5, R29, 1533
    LI   R28, 1531
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 1533
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1872
    LI   R28, 1531
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R8, R0
    JMP  _L1873
_L1872:
    LI   R28, 1533
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R8, R0
_L1873:
    STORE R6, R29, 1534
    LI   R28, 1534
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L1874
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1034
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 2058
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R6, R6, R9
    LI   R28, 1523
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 1530
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 1534
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R9, R0
    ADD  R3, R12, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2058
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1534
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R10, R7, R9
    STORE R10, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 1534
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R10, R7, R9
    STORE R10, R6, 0
    JMP  _L1875
_L1874:
_L1875:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1871
_L1870:
_L1871:
    LI   R28, 1529
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L1876
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 6
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    LI   R8, 16
    OR  R7, R7, R8
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 7
    STORE R8, R6, 0
    JMP  _L1877
_L1876:
_L1877:
    JMP  _L1859
    JMP  _L1867
_L1866:
_L1867:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 7
    CMPEQ  R6, R6, R7
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 1524
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 1529
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 16
    AND  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    JZ   R6, _L1878
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R5, _STR_279
    LI   R28, 1521
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1859
    JMP  _L1879
_L1878:
_L1879:
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 4
    CMPEQ  R6, R6, R7
    LI   R28, 1532
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 1524
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R6, R6, R0
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    LI   R28, 1529
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 16
    AND  R9, R9, R10
    CMPNE R6, R6, R0
    CMPNE R9, R9, R0
    AND   R6, R6, R9
    JZ   R6, _L1880
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 5
    STORE R8, R6, 0
    LI   R28, 1529
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L1882
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16
    LI   R8, 0
    LI   R9, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, tcp_send_segment
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 1532
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    JMP  _L1883
_L1882:
_L1883:
    JMP  _L1859
    JMP  _L1881
_L1880:
_L1881:
    JMP  _L1858
_L1859:
    JMP  _L1848
_L1849:
_L1847:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_status:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 0
    STORE R5, R29, 3
    LI   R5, _STR_280
    STORE R5, R29, 4
    LI   R5, _STR_281
    STORE R5, R29, 5
    LI   R5, _STR_282
    STORE R5, R29, 6
    LI   R5, _STR_283
    STORE R5, R29, 7
    LI   R5, _STR_284
    STORE R5, R29, 8
    LI   R5, _STR_285
    STORE R5, R29, 9
    LI   R5, _STR_286
    STORE R5, R29, 10
    LI   R5, _STR_287
    STORE R5, R29, 11
    LI   R5, _STR_288
    STORE R5, R29, 12
    LI   R5, _STR_289
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1885:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L1888
    JMP  _L1886
_L1887:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1885
_L1886:
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    STORE R5, R29, 260
    LI   R28, 260
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2059
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    JZ   R6, _L1889
    JMP  _L1887
    JMP  _L1890
_L1889:
_L1890:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, _STR_290
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 260
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 3
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 260
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 4
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    LI   R28, 4
    ADD  R14, R29, R28
    LI   R28, 260
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    LI   R28, 0
    ADD  R16, R16, R28
    LOAD R17, R16, 0
    ADD  R16, R17, R0
    LI   R17, 8
    CMPLE  R16, R16, R17
    JZ   R16, _L1891
    LI   R28, 260
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 0
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R16, R19, R0
    JMP  _L1892
_L1891:
    LI   R17, 0
    ADD  R16, R17, R0
_L1892:
    LI   R28, 1
    MUL  R16, R16, R28
    ADD  R14, R14, R16
    LOAD R16, R14, 0
    LI   R28, 260
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 2058
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    LI   R28, 260
    ADD  R20, R29, R28
    LOAD R21, R20, 0
    LI   R28, 5
    ADD  R21, R21, R28
    LOAD R22, R21, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    ADD  R4, R13, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1887
_L1888:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L1893
    LI   R5, _STR_291
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1894
_L1893:
_L1894:
_L1884:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

tcp_get_conn:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L1896
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1895
    JMP  _L1897
_L1896:
_L1897:
    LI   R5, conns
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2060
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2059
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L1898
    LI   R8, conns
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 2060
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    ADD  R7, R8, R0
    JMP  _L1899
_L1898:
    LI   R8, 0
    ADD  R7, R8, R0
_L1899:
    ADD  R7, R7, R0
    JMP  _L1895
_L1895:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

uart_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 18
    LI   R6, 3
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1900:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

uart_putchar:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 16
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, MMIO_WRITE
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1901:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

uart_getchar:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 17
    ADD  R1, R5, R0
    LI   R28, MMIO_READ
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 255
    AND  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1902
_L1902:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

uart_puts:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
_L1904:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1905
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1904
_L1905:
_L1903:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

print_uint:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, _STR_262
    STORE R5, R29, 4
    LI   R5, 63
    STORE R5, R29, 324
    LI   R28, 260
    ADD  R5, R29, R28
    LI   R28, 324
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1907
    LI   R5, 48
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1906
    JMP  _L1908
_L1907:
_L1908:
_L1909:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R28, 324
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPLT  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1910
    LI   R28, 260
    ADD  R5, R29, R28
    LI   R28, 324
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    SUB  R7, R7, R28
    STORE R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 3
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    DIV  R12, R9, R11
    MUL  R12, R12, R11
    SUB  R9, R9, R12
    LI   R28, 1
    MUL  R9, R9, R28
    ADD  R8, R8, R9
    LOAD R10, R8, 0
    STORE R10, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    DIV  R9, R6, R8
    STORE R9, R5, 0
    JMP  _L1909
_L1910:
    LI   R28, 260
    ADD  R5, R29, R28
    LI   R28, 324
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R1, R5, R0
    LI   R28, uart_puts
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1906:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

print_int:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1912
    LI   R5, 45
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    SUB  R7, R0, R7
    STORE R7, R5, 0
    JMP  _L1913
_L1912:
_L1913:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 10
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1911:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

kprintf:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, va_start
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1915:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L1916
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 37
    CMPNE  R5, R5, R6
    JZ   R5, _L1917
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPEQ  R5, R5, R6
    JZ   R5, _L1919
    LI   R5, 13
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1920
_L1919:
_L1920:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1915
    JMP  _L1918
_L1917:
_L1918:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, print_int
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    LI   R6, 10
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    LI   R6, 16
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    LI   R6, 16
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, uart_puts
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 108
    CMPEQ  R5, R5, R6
    JZ   R5, _L1922
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 100
    CMPEQ  R5, R5, R6
    JZ   R5, _L1924
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, print_int
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1925
_L1924:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    LI   R6, 16
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1925:
    JMP  _L1923
_L1922:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 100
    CMPEQ  R5, R5, R6
    JZ   R5, _L1926
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    ADD  R1, R5, R0
    LI   R28, print_int
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1927
_L1926:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 0 ; va_arg compatibility value
    LI   R6, 16
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, print_uint
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1927:
_L1923:
    JMP  _L1921
    LI   R5, 37
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
    LI   R5, 37
    ADD  R1, R5, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, uart_putchar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1921
_L1921:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1915
_L1916:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, va_end
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1914:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

ui_draw_crescent:
    LI   R28, -38
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    DIV  R5, R5, R6
    STORE R5, R29, 6
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 85
    MUL  R5, R5, R6
    LI   R6, 100
    DIV  R5, R5, R6
    STORE R5, R29, 7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 5
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, gpu_fill_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, 10
    DIV  R8, R8, R9
    SUB  R7, R7, R8
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 4278196787
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, gpu_fill_circle
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1928:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 38
    ADD  R30, R30, R28
    JALR R0, R31, 0

ui_boot_splash:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 4278196787
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 400
    LI   R6, 220
    LI   R7, 90
    LI   R8, 4278255360
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, ui_draw_crescent
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_34
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_292
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_34
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_293
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1929:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

ui_loading_bar:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 30
    MUL  R5, R5, R6
    LI   R6, 100
    DIV  R5, R5, R6
    STORE R5, R29, 4
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 100
    CMPLT  R5, R6, R5
    JZ   R5, _L1931
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 100
    STORE R7, R5, 0
    JMP  _L1932
_L1931:
_L1932:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L1933
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L1934
_L1933:
_L1934:
    LI   R5, _STR_294
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1935:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 30
    CMPLT  R5, R5, R6
    JZ   R5, _L1938
    JMP  _L1936
_L1937:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1935
_L1936:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L1939
    LI   R5, _STR_295
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1940
_L1939:
    LI   R5, _STR_296
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1940:
    JMP  _L1937
_L1938:
    LI   R5, _STR_297
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 200
    LI   R6, 340
    LI   R7, 400
    LI   R8, 20
    LI   R9, 4280427059
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 200
    LI   R6, 340
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 400
    MUL  R7, R7, R8
    LI   R8, 100
    DIV  R7, R7, R8
    LI   R8, 20
    LI   R9, 4278255360
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1930:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_port_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, mmio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L1941
_L1941:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_port_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mmio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1942:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

keycode_to_ascii:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 83
    CMPLE  R5, R6, R5
    JZ   R5, _L1944
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1943
    JMP  _L1945
_L1944:
_L1945:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    AND  R5, R5, R6
    JZ   R5, _L1946
    LI   R6, 1
    ADD  R5, R6, R0
    JMP  _L1947
_L1946:
    LI   R6, 0
    ADD  R5, R6, R0
_L1947:
    STORE R5, R29, 5
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 4
    CMPLE  R6, R7, R6
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 29
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1948
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    CMPEQ R7, R7, R0
    STORE R7, R5, 0
    JMP  _L1949
_L1948:
_L1949:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1950
    LI   R7, hid_shifted
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    ADD  R6, R9, R0
    JMP  _L1951
_L1950:
    LI   R7, hid_unshifted
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    ADD  R6, R9, R0
_L1951:
    ADD  R7, R6, R0
    JMP  _L1943
_L1943:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

key_was_pressed:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1953:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 6
    CMPLT  R5, R5, R6
    JZ   R5, _L1956
    JMP  _L1954
_L1955:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1953
_L1954:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    CMPEQ  R6, R6, R9
    JZ   R6, _L1957
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L1952
    JMP  _L1958
_L1957:
_L1958:
    JMP  _L1955
_L1956:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1952
_L1952:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

key_is_pressed:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1960:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 6
    CMPLT  R5, R5, R6
    JZ   R5, _L1963
    JMP  _L1961
_L1962:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1960
_L1961:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    CMPEQ  R6, R6, R9
    JZ   R6, _L1964
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L1959
    JMP  _L1965
_L1964:
_L1965:
    JMP  _L1962
_L1963:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1959
_L1959:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

ctrl_combo:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    CMPLE  R5, R6, R5
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 29
    CMPLE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1967
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    SUB  R5, R5, R6
    LI   R6, 1
    ADD  R5, R5, R6
    ADD  R7, R5, R0
    JMP  _L1966
    JMP  _L1968
_L1967:
_L1968:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 42
    CMPEQ  R5, R5, R6
    JZ   R5, _L1969
    LI   R5, 8
    ADD  R7, R5, R0
    JMP  _L1966
    JMP  _L1970
_L1969:
_L1970:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 40
    CMPEQ  R5, R5, R6
    JZ   R5, _L1971
    LI   R5, 10
    ADD  R7, R5, R0
    JMP  _L1966
    JMP  _L1972
_L1971:
_L1972:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L1966
_L1966:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R6, 0
    LI   R7, g_usb_hid
    LI   R7, 32
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 59
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, usb_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 48
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, usb_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    CMPEQ R5, R5, R0
    JZ   R5, _L1974
    LI   R5, _STR_298
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1975
_L1974:
    LI   R5, _STR_299
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, g_usb_hid
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
_L1975:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    AND  R5, R5, R6
    JZ   R5, _L1976
    LI   R5, g_usb_hid
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, g_usb_hid
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3
    STORE R7, R5, 0
    LI   R5, g_usb_hid
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, _STR_300
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1977
_L1976:
_L1977:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 4
    AND  R5, R5, R6
    JZ   R5, _L1978
    LI   R5, g_usb_hid
    LI   R28, 5
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, g_usb_hid
    LI   R28, 5
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 3
    STORE R7, R5, 0
    LI   R5, g_usb_hid
    LI   R28, 5
    ADD  R5, R5, R28
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 2
    STORE R7, R5, 0
    LI   R5, _STR_301
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1979
_L1978:
_L1979:
_L1973:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_reset:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 59
    LI   R6, 2
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, usb_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, g_usb_hid
    LI   R28, 9
    ADD  R5, R5, R28
    LI   R6, 0
    LI   R7, g_usb_hid
    LI   R28, 9
    ADD  R7, R7, R28
    LI   R7, 16
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, g_usb_hid
    LI   R28, 25
    ADD  R5, R5, R28
    LI   R6, 0
    LI   R7, g_usb_hid
    LI   R28, 25
    ADD  R7, R7, R28
    LI   R7, 4
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, g_usb_hid
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, usb_hid_init
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1980:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_process_kbd:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, g_usb_hid
    LI   R28, 9
    ADD  R5, R5, R28
    STORE R5, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    STORE R7, R29, 4
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R7, 57
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, key_is_pressed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 7
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, 57
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, key_was_pressed
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    CMPEQ R6, R6, R0
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L1982
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 13
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    XOR  R9, R7, R8
    STORE R9, R6, 0
    JMP  _L1983
_L1982:
_L1983:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L1984:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 6
    CMPLT  R5, R5, R6
    JZ   R5, _L1987
    JMP  _L1985
_L1986:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L1984
_L1985:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    ADD  R6, R6, R7
    LOAD R8, R6, 0
    STORE R8, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L1988
    JMP  _L1986
    JMP  _L1989
_L1988:
_L1989:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 57
    CMPEQ  R5, R5, R6
    JZ   R5, _L1990
    JMP  _L1986
    JMP  _L1991
_L1990:
_L1991:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, key_was_pressed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    CMPEQ R5, R5, R0
    JZ   R5, _L1992
    LI   R5, 0
    STORE R5, R29, 7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L1994
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R8, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, ctrl_combo
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L1995
_L1994:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 3
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 13
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R8, R0
    ADD  R2, R10, R0
    ADD  R3, R13, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, keycode_to_ascii
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
_L1995:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L1996
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, keyboard_feed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L1997
_L1996:
_L1997:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 15
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 50
    STORE R8, R6, 0
    JMP  _L1993
_L1992:
_L1993:
    JMP  _L1986
_L1987:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 15
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 2
    ADD  R8, R8, R9
    LOAD R9, R8, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 15
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R1, R8, R0
    ADD  R2, R11, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, key_is_pressed
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    CMPEQ R7, R7, R0
    CMPNE R6, R6, R0
    CMPNE R7, R7, R0
    AND   R6, R6, R7
    JZ   R6, _L1998
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 15
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    JMP  _L1999
_L1998:
_L1999:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 2
    ADD  R9, R9, R10
    LOAD R10, R9, 0
    LI   R10, 6
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kmemcpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L1981:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_process_mouse:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, g_usb_hid
    LI   R28, 25
    ADD  R5, R5, R28
    STORE R5, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    STORE R7, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    STORE R7, R29, 5
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 2
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    STORE R7, R29, 6
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 3
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    STORE R7, R29, 7
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2001:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 3
    CMPLT  R5, R5, R6
    JZ   R5, _L2004
    JMP  _L2002
_L2003:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2001
_L2002:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    SHR  R5, R5, R7
    LI   R7, 1
    AND  R5, R5, R7
    STORE R5, R29, 9
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    SHR  R6, R6, R8
    LI   R8, 1
    AND  R6, R6, R8
    STORE R6, R29, 10
    LI   R28, 9
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 10
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPNE  R5, R5, R7
    JZ   R5, _L2005
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mouse_button
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2006
_L2005:
_L2006:
    JMP  _L2003
_L2004:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L2007
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mouse_move
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2008
_L2007:
_L2008:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPNE  R5, R5, R6
    JZ   R5, _L2009
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JMP  _L2010
_L2009:
_L2010:
_L2000:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_poll:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
_L2012:
    LI   R5, 1
    JZ   R5, _L2013
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 49
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, usb_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2014
    JMP  _L2013
    JMP  _L2015
_L2014:
_L2015:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2016:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2019
    JMP  _L2017
_L2018:
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2016
_L2017:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 11
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 50
    LI   R28, 11
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    ADD  R1, R8, R0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, usb_port_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    LI   R9, 255
    AND  R8, R8, R9
    STORE R8, R5, 0
    JMP  _L2018
_L2019:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPEQ  R5, R5, R6
    JZ   R5, _L2020
    LI   R5, g_usb_hid
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    JZ   R6, _L2022
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, usb_hid_process_kbd
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2023
_L2022:
    LI   R5, g_usb_hid
    LI   R28, 30
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L2023:
    JMP  _L2021
_L2020:
    LI   R28, 10
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 2
    CMPEQ  R5, R5, R6
    JZ   R5, _L2024
    LI   R5, g_usb_hid
    LI   R28, 5
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    JZ   R6, _L2026
    LI   R28, 2
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, usb_hid_process_mouse
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2027
_L2026:
    LI   R5, g_usb_hid
    LI   R28, 31
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
_L2027:
    JMP  _L2025
_L2024:
_L2025:
_L2021:
    LI   R5, 58
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, usb_port_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, g_usb_hid
    LI   R28, 29
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R5, g_usb_hid
    LI   R28, 29
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    DIV  R7, R5, R6
    MUL  R7, R7, R6
    SUB  R5, R5, R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2028
    JMP  _L2013
    JMP  _L2029
_L2028:
_L2029:
    JMP  _L2012
_L2013:
_L2011:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_hid_tick:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R28, 9
    ADD  R5, R5, R28
    STORE R5, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 15
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    JZ   R6, _L2031
    JMP  _L2030
    JMP  _L2032
_L2031:
_L2032:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    JZ   R6, _L2033
    JMP  _L2030
    JMP  _L2034
_L2033:
_L2034:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    SUB  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    JZ   R6, _L2035
    LI   R5, 0
    STORE R5, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 1
    AND  R6, R6, R7
    JZ   R6, _L2037
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 15
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, ctrl_combo
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    JMP  _L2038
_L2037:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 15
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 0
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    LI   R28, 2
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    LI   R28, 13
    ADD  R14, R14, R28
    LOAD R15, R14, 0
    ADD  R1, R9, R0
    ADD  R2, R12, R0
    ADD  R3, R15, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, keycode_to_ascii
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
_L2038:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L2039
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, keyboard_feed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2040
_L2039:
_L2040:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 14
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 3
    STORE R8, R6, 0
    JMP  _L2036
_L2035:
_L2036:
_L2030:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_kbd_connected:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R28, 1
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2041
_L2041:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_mouse_connected:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R28, 5
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2042
_L2042:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_kbd_modifier:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R28, 9
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2043
_L2043:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_kbd_key_pressed:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, g_usb_hid
    LI   R28, 9
    ADD  R5, R5, R28
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, key_is_pressed
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2044
_L2044:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

usb_mouse_buttons:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, g_usb_hid
    LI   R28, 25
    ADD  R5, R5, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2045
_L2045:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

node_by_id:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 64
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L2065
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2064
    JMP  _L2066
_L2065:
_L2066:
    LI   R5, nodes
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L2067
    LI   R8, nodes
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 38
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    ADD  R7, R8, R0
    JMP  _L2068
_L2067:
    LI   R8, 0
    ADD  R7, R8, R0
_L2068:
    ADD  R7, R7, R0
    JMP  _L2064
_L2064:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

alloc_node:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2070:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R5, R6
    JZ   R5, _L2073
    JMP  _L2071
_L2072:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2070
_L2071:
    LI   R5, nodes
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2074
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2069
    JMP  _L2075
_L2074:
_L2075:
    JMP  _L2072
_L2073:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2069
_L2069:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

node_path:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R5, 0
    STORE R5, R29, 261
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 262
_L2077:
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R28, 261
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2078
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, node_by_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 265
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2079
    JMP  _L2078
    JMP  _L2080
_L2079:
_L2080:
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 261
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 32
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 265
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    LI   R10, 32
    ADD  R1, R5, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 265
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L2077
_L2078:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 47
    STORE R8, R6, 0
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R28, 263
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 261
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
_L2081:
    LI   R28, 263
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2084
    JMP  _L2082
_L2083:
    LI   R28, 263
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2081
_L2082:
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 263
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 32
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, kstrlen
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 266
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 266
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R7, 1
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPLE  R5, R8, R5
    JZ   R5, _L2085
    JMP  _L2084
    JMP  _L2086
_L2085:
_L2086:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 264
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R28, 263
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 32
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 264
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R9, R9, R11
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 266
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R9, R6, R8
    STORE R9, R5, 0
    LI   R28, 263
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    LI   R28, 264
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    CMPLT  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2087
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 264
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 47
    STORE R9, R6, 0
    JMP  _L2088
_L2087:
_L2088:
    JMP  _L2083
_L2084:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 264
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    CMPEQ  R5, R5, R6
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 0
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 47
    CMPEQ  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L2089
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    JMP  _L2090
_L2089:
_L2090:
_L2076:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

find_child:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2092:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R5, R6
    JZ   R5, _L2095
    JMP  _L2093
_L2094:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2092
_L2093:
    LI   R5, nodes
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, nodes
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 38
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    LI   R9, nodes
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 38
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 3
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    LI   R28, 3
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R1, R11, R0
    ADD  R2, R13, R0
    LI   R28, -4
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    STORE R8, R30, 3
    LI   R28, kstrcmp
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LOAD R8, R30, 3
    LI   R28, 4
    ADD  R30, R30, R28
    ADD  R9, R7, R0  ; sonuç = R7
    LI   R10, 0
    CMPEQ  R9, R9, R10
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L2096
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2091
    JMP  _L2097
_L2096:
_L2097:
    JMP  _L2094
_L2095:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2091
_L2091:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

resolve_path_id:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    STORE R6, R29, 35
    LI   R5, 0
    STORE R5, R29, 36
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 47
    CMPEQ  R5, R5, R6
    JZ   R5, _L2099
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2100
_L2099:
_L2100:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2101
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2098
    JMP  _L2102
_L2101:
_L2102:
_L2103:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    JZ   R6, _L2104
    LI   R5, 0
    STORE R5, R29, 37
_L2105:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 35
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 47
    CMPNE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2106
    LI   R28, 37
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 32
    LI   R7, 1
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    JZ   R5, _L2107
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 37
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R28, 35
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L2108
_L2107:
_L2108:
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2105
_L2106:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R28, 37
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 47
    CMPEQ  R5, R5, R6
    JZ   R5, _L2109
    LI   R28, 35
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2110
_L2109:
_L2110:
    LI   R28, 37
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2111
    JMP  _L2103
    JMP  _L2112
_L2111:
_L2112:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_296
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2113
    JMP  _L2103
    JMP  _L2114
_L2113:
_L2114:
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, _STR_302
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2115
    LI   R28, 36
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, node_by_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 38
    LI   R28, 36
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 38
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 38
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R10, 0
    CMPLE  R9, R10, R9
    CMPNE R7, R7, R0
    CMPNE R9, R9, R0
    AND   R7, R7, R9
    JZ   R7, _L2117
    LI   R28, 38
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R8, R11, R0
    JMP  _L2118
_L2117:
    LI   R9, 0
    ADD  R8, R9, R0
_L2118:
    STORE R8, R5, 0
    JMP  _L2103
    JMP  _L2116
_L2115:
_L2116:
    LI   R28, 36
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 36
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    ADD  R1, R8, R0
    ADD  R2, R9, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, find_child
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 36
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2119
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2098
    JMP  _L2120
_L2119:
_L2120:
    JMP  _L2103
_L2104:
    LI   R28, 36
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2098
_L2098:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2122:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R5, R6
    JZ   R5, _L2125
    JMP  _L2123
_L2124:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2122
_L2123:
    LI   R5, nodes
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2124
_L2125:
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 35
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, nodes
    LI   R6, 0
    LI   R28, 38
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, _STR_303
    LI   R8, 32
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_304
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_305
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_306
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_307
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_308
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_309
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_310
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_311
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_312
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, vfs_mkdir
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_313
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2121:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_resolve:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 47
    CMPEQ  R6, R6, R7
    JZ   R6, _L2127
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2128
_L2127:
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, node_path
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 133
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrlen
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 133
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 2
    SUB  R6, R6, R7
    CMPLT  R5, R5, R6
    LI   R28, 5
    ADD  R6, R29, R28
    LI   R28, 133
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 47
    CMPNE  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2129
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 133
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 47
    STORE R9, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 133
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    ADD  R7, R7, R8
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 133
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2130
_L2129:
_L2130:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 133
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 133
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    SUB  R9, R9, R11
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2128:
_L2126:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_find:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 3
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2132
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R7, R0
    LI   R28, -1
    ADD  R30, R30, R28
    STORE R5, R30, 0
    LI   R28, node_by_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LI   R28, 1
    ADD  R30, R30, R28
    ADD  R6, R7, R0  ; sonuç = R7
    ADD  R5, R6, R0
    JMP  _L2133
_L2132:
    LI   R6, 0
    ADD  R5, R6, R0
_L2133:
    ADD  R7, R5, R0
    JMP  _L2131
_L2131:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_mkdir:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2135
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2134
    JMP  _L2136
_L2135:
_L2136:
    LI   R28, 263
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, kstrlen
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 132
    ADD  R5, R29, R28
    LI   R28, 4
    ADD  R6, R29, R28
    LI   R7, 128
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 263
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
_L2137:
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L2140
    JMP  _L2138
_L2139:
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2137
_L2138:
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R28, 264
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 47
    CMPEQ  R5, R5, R7
    JZ   R5, _L2141
    LI   R28, 132
    ADD  R5, R29, R28
    LI   R28, 264
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2140
    JMP  _L2142
_L2141:
_L2142:
    JMP  _L2139
_L2140:
    LI   R28, 260
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LI   R28, 264
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R9, 1
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 264
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2143
    LI   R28, 261
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 260
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LI   R8, 1
    ADD  R7, R7, R8
    STORE R7, R5, 0
    JMP  _L2144
_L2143:
    LI   R28, 261
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 132
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
_L2144:
    LI   R28, 261
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2145
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2134
    JMP  _L2146
_L2145:
_L2146:
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, alloc_node
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2147
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2134
    JMP  _L2148
_L2147:
_L2148:
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, nodes
    LI   R28, 262
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 38
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    STORE R7, R5, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 262
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 1
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 261
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 35
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 36
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 37
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R28, 265
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R28, 260
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 32
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 262
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2134
_L2134:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_rmdir:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R6, nodes
    LI   R28, 131
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 38
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R8, 0
    CMPNE  R6, R6, R8
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L2150
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2149
    JMP  _L2151
_L2150:
_L2151:
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2152:
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R5, R6
    JZ   R5, _L2155
    JMP  _L2153
_L2154:
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2152
_L2153:
    LI   R5, nodes
    LI   R28, 132
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, nodes
    LI   R28, 132
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 38
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 131
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L2156
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2149
    JMP  _L2157
_L2156:
_L2157:
    JMP  _L2154
_L2155:
    LI   R5, nodes
    LI   R28, 131
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 131
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L2158
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L2159
_L2158:
_L2159:
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2149
_L2149:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_chdir:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R6, nodes
    LI   R28, 131
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 38
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R6, R8, R0
    LI   R8, 0
    CMPNE  R6, R6, R8
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L2161
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2160
    JMP  _L2162
_L2161:
_L2162:
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    LI   R28, 131
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2160
_L2160:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_getcwd:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, vfs_cwd_id
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, node_path
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2163:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_create:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LI   R6, _STR_68
    LI   R7, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R9, R0
    LI   R28, fs_create
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2164
_L2164:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_delete:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LI   R6, 0
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, fs_delete
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2165
_L2165:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_read:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, fs_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2166
_L2166:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_write:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 5
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 5
    ADD  R5, R29, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, fs_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2167
_L2167:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_ls:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 0
    STORE R5, R29, 133
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2169
    LI   R5, _STR_314
    LI   R28, 3
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2168
    JMP  _L2170
_L2169:
_L2170:
    LI   R5, _STR_315
    LI   R28, 3
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2171:
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 64
    CMPLT  R5, R5, R6
    JZ   R5, _L2174
    JMP  _L2172
_L2173:
    LI   R28, 132
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2171
_L2172:
    LI   R5, nodes
    LI   R28, 132
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, nodes
    LI   R28, 132
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 38
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    LI   R28, 131
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R7, R7, R10
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L2175
    LI   R5, _STR_316
    LI   R6, nodes
    LI   R28, 132
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 38
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    LI   R9, nodes
    LI   R28, 132
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 38
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    ADD  R9, R11, R0
    LI   R11, 0
    CMPEQ  R9, R9, R11
    JZ   R9, _L2177
    LI   R11, _STR_303
    ADD  R10, R11, R0
    JMP  _L2178
_L2177:
    LI   R11, _STR_68
    ADD  R10, R11, R0
_L2178:
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 133
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2176
_L2175:
_L2176:
    JMP  _L2173
_L2174:
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    LI   R28, 133
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 0
    CMPEQ  R6, R6, R7
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2179
    LI   R28, fs_list
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2180
_L2179:
_L2180:
_L2168:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_exists:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2182
    LI   R5, 1
    ADD  R7, R5, R0
    JMP  _L2181
    JMP  _L2183
_L2182:
_L2183:
    LI   R28, 3
    ADD  R5, R29, R28
    ADD  R1, R5, R0
    LI   R28, fs_exists
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2181
_L2181:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_is_dir:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LI   R8, 128
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    LI   R28, vfs_resolve
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, resolve_path_id
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 131
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2185
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2184
    JMP  _L2186
_L2185:
_L2186:
    LI   R5, nodes
    LI   R28, 131
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, 0
    CMPEQ  R5, R5, R7
    ADD  R7, R5, R0
    JMP  _L2184
_L2184:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_find_by_id:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 64
    CMPLE  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L2188
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2187
    JMP  _L2189
_L2188:
_L2189:
    LI   R5, nodes
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 38
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L2190
    LI   R8, nodes
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 38
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    ADD  R7, R8, R0
    JMP  _L2191
_L2190:
    LI   R8, 0
    ADD  R7, R8, R0
_L2191:
    ADD  R7, R7, R0
    JMP  _L2187
_L2187:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_node_abs_path:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, node_path
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2192:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_node_abs_path_by_id:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2194
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 47
    STORE R8, R6, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    JMP  _L2193
    JMP  _L2195
_L2194:
_L2195:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, node_path
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2193:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

resolve_path:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 0
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    JZ   R5, _L2201
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R7, R9, R0
    JMP  _L2202
_L2201:
    LI   R8, _STR_317
    ADD  R7, R8, R0
_L2202:
    ADD  R7, R7, R0
    JMP  _L2200
_L2200:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

hwrite:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, hostio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L2204
    LI   R7, 0
    ADD  R6, R7, R0
    JMP  _L2205
_L2204:
    LI   R7, 1
    SUB  R7, R0, R7
    ADD  R6, R7, R0
_L2205:
    ADD  R7, R6, R0
    JMP  _L2203
_L2203:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

hread:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, hostio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    CMPEQ  R5, R5, R7
    JZ   R5, _L2207
    LI   R7, 0
    ADD  R6, R7, R0
    JMP  _L2208
_L2207:
    LI   R7, 1
    SUB  R7, R0, R7
    ADD  R6, R7, R0
_L2208:
    ADD  R7, R6, R0
    JMP  _L2206
_L2206:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_persist_save:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, _STR_318
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2209
_L2209:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_persist_load:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2210
_L2210:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_persist_auto_load:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, vfs_persist_load
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2212
    JMP  _L2211
    JMP  _L2213
_L2212:
_L2213:
    LI   R5, _STR_319
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2211:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

vfs_persist_info:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R5, _STR_320
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2214:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

wreg_read:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, mmio_read
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    ADD  R7, R5, R0
    JMP  _L2215
_L2215:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

wreg_write:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, mmio_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2216:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

fnv1a:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R5, 2166136261
    STORE R5, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2218:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    JZ   R8, _L2221
    JMP  _L2219
_L2220:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2218
_L2219:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    XOR  R11, R6, R10
    STORE R11, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 16777619
    MUL  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2220
_L2221:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2217
_L2217:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_ip_str:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 0
    STORE R5, R29, 4
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 3
    STORE R7, R5, 0
_L2223:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2226
    JMP  _L2224
_L2225:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2223
_L2224:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 8
    MUL  R6, R6, R7
    SHR  R5, R5, R6
    STORE R5, R29, 6
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 100
    CMPLE  R5, R6, R5
    JZ   R5, _L2227
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 100
    DIV  R10, R10, R11
    ADD  R9, R9, R10
    STORE R9, R6, 0
    JMP  _L2228
_L2227:
_L2228:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 10
    CMPLE  R5, R6, R5
    JZ   R5, _L2229
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    DIV  R10, R10, R11
    LI   R11, 10
    DIV  R12, R10, R11
    MUL  R12, R12, R11
    SUB  R10, R10, R12
    ADD  R9, R9, R10
    STORE R9, R6, 0
    JMP  _L2230
_L2229:
_L2230:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 48
    LI   R28, 6
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 10
    DIV  R12, R10, R11
    MUL  R12, R12, R11
    SUB  R10, R10, R12
    ADD  R9, R9, R10
    STORE R9, R6, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R6, R5
    JZ   R5, _L2231
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 1
    ADD  R10, R8, R9
    STORE R10, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 46
    STORE R9, R6, 0
    JMP  _L2232
_L2231:
_L2232:
    JMP  _L2225
_L2226:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R6, R6, R8
    LOAD R8, R6, 0
    LI   R9, 0
    STORE R9, R6, 0
_L2222:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R6, 0
    LI   R7, wifi
    LI   R7, 683
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, kmemset
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R6, 1
    LI   R7, 16
    OR  R6, R6, R7
    LI   R7, 32
    OR  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R6, 160
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R6, 20
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 99
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 160
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 101
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 20
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 103
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, 1
    LI   R6, _STR_321
    LI   R7, _STR_322
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, slog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_323
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_324
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_325
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2233:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_scan:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R28, 103
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2235
    LI   R5, _STR_326
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2234
    JMP  _L2236
_L2235:
_L2236:
    LI   R5, _STR_327
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R6, 1
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 106
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2237:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, wifi
    LI   R28, 106
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 16
    CMPLT  R7, R7, R8
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L2240
    JMP  _L2238
_L2239:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2237
_L2238:
    LI   R5, 112
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 107
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 576
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, 33
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 107
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 576
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, wifi
    LI   R28, 107
    ADD  R5, R5, R28
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 576
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 34
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    JMP  _L2239
_L2240:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, wifi
    LI   R28, 106
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, 1
    LI   R6, _STR_321
    LI   R7, _STR_328
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, slog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_329
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2234
_L2234:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_print_scan:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R28, 106
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2242
    LI   R5, _STR_330
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2241
    JMP  _L2243
_L2242:
_L2243:
    LI   R5, _STR_331
    LI   R6, _STR_332
    LI   R7, _STR_333
    LI   R8, _STR_334
    LI   R9, _STR_335
    LI   R10, _STR_336
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_337
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2244:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, wifi
    LI   R28, 106
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L2247
    JMP  _L2245
_L2246:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2244
_L2245:
    LI   R5, _STR_338
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, wifi
    LI   R28, 107
    ADD  R8, R8, R28
    LI   R28, 2
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 576
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    LI   R11, wifi
    LI   R28, 107
    ADD  R11, R11, R28
    LI   R28, 2
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 576
    MUL  R13, R13, R28
    ADD  R11, R11, R13
    LI   R28, 33
    ADD  R11, R11, R28
    LOAD R13, R11, 0
    LI   R14, wifi
    LI   R28, 107
    ADD  R14, R14, R28
    LI   R28, 2
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    LI   R28, 576
    MUL  R16, R16, R28
    ADD  R14, R14, R16
    LI   R28, 34
    ADD  R14, R14, R28
    LOAD R16, R14, 0
    LI   R17, wifi
    LI   R28, 107
    ADD  R17, R17, R28
    LI   R28, 2
    ADD  R18, R29, R28
    LOAD R19, R18, 0
    LI   R28, 576
    MUL  R19, R19, R28
    ADD  R17, R17, R19
    LI   R28, 35
    ADD  R17, R17, R28
    LOAD R19, R17, 0
    JZ   R19, _L2248
    LI   R20, _STR_339
    ADD  R19, R20, R0
    JMP  _L2249
_L2248:
    LI   R20, _STR_340
    ADD  R19, R20, R0
_L2249:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    ADD  R4, R13, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2246
_L2247:
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2241:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_connect:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 5
    LI   R5, wifi
    LI   R28, 103
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2251
    LI   R5, _STR_341
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2250
    JMP  _L2252
_L2251:
_L2252:
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    JZ   R6, _L2253
    LI   R28, wifi_disconnect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2254
_L2253:
_L2254:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2255:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, wifi
    LI   R28, 106
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    CMPLT  R5, R5, R7
    JZ   R5, _L2258
    JMP  _L2256
_L2257:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2255
_L2256:
    LI   R5, wifi
    LI   R28, 107
    ADD  R5, R5, R28
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 576
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, kstrcmp
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L2259
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2258
    JMP  _L2260
_L2259:
_L2260:
    JMP  _L2257
_L2258:
    LI   R5, _STR_342
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R11, 0
    ADD  R10, R10, R11
    LOAD R11, R10, 0
    CMPNE R8, R8, R0
    CMPNE R11, R11, R0
    AND   R8, R8, R11
    JZ   R8, _L2261
    LI   R11, _STR_343
    ADD  R10, R11, R0
    JMP  _L2262
_L2261:
    LI   R11, _STR_344
    ADD  R10, R11, R0
_L2262:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R10, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R8, 0
    ADD  R7, R7, R8
    LOAD R8, R7, 0
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    JZ   R5, _L2263
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R1, R6, R0
    LI   R28, fnv1a
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    STORE R5, R29, 7
    LI   R5, 112
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 112
    LI   R6, 1
    LI   R7, 2
    OR  R6, R6, R7
    LI   R7, 16
    OR  R6, R6, R7
    LI   R7, 32
    OR  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2264
_L2263:
    LI   R5, 112
    LI   R6, 1
    LI   R7, 2
    OR  R6, R6, R7
    LI   R7, 16
    OR  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2264:
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2265
    LI   R5, wifi
    LI   R28, 107
    ADD  R5, R5, R28
    LI   R28, 5
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 576
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    STORE R7, R29, 8
    LI   R5, 112
    LI   R28, 8
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 98
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 8
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, wifi
    LI   R28, 100
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, wifi
    LI   R28, 107
    ADD  R7, R7, R28
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 576
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 34
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    STORE R9, R5, 0
    JMP  _L2266
_L2265:
    LI   R5, 112
    LI   R6, 36
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 98
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 36
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 100
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 65
    SUB  R7, R0, R7
    STORE R7, R5, 0
_L2266:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 104
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 105
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 112
    ADD  R1, R7, R0
    LI   R28, -2
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, wreg_read
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LI   R28, 2
    ADD  R30, R30, R28
    ADD  R7, R7, R0  ; sonuç = R7
    STORE R7, R5, 0
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 16
    AND  R5, R5, R6
    JZ   R5, _L2267
    LI   R5, _STR_345
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 3
    LI   R6, _STR_321
    LI   R7, _STR_346
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, slog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2250
    JMP  _L2268
_L2267:
_L2268:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L2269
    LI   R5, wifi
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 33
    LI   R10, 1
    SUB  R9, R9, R10
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    JZ   R6, _L2271
    LI   R5, wifi
    LI   R28, 33
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R9, 65
    LI   R10, 1
    SUB  R9, R9, R10
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2272
_L2271:
_L2272:
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 1
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 104
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 9
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, wifi_ip_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 105
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 29
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, wifi_ip_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_347
    LI   R6, wifi
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_348
    LI   R6, wifi
    LI   R28, 98
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, wifi
    LI   R28, 99
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_349
    LI   R6, wifi
    LI   R28, 100
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_350
    LI   R28, 9
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_351
    LI   R28, 29
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_352
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    LI   R6, _STR_321
    LI   R7, _STR_353
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, slog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    ADD  R7, R5, R0
    JMP  _L2250
    JMP  _L2270
_L2269:
_L2270:
    LI   R5, _STR_354
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2250
_L2250:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_disconnect:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2274
    LI   R5, _STR_355
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2273
    JMP  _L2275
_L2274:
_L2275:
    LI   R5, 112
    LI   R6, 1
    LI   R7, 4
    OR  R6, R6, R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, wreg_write
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 104
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 105
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, wifi
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    LI   R28, 33
    MUL  R7, R7, R28
    ADD  R6, R6, R7
    LOAD R7, R6, 0
    LI   R8, 0
    STORE R8, R6, 0
    LI   R5, wifi
    LI   R28, 100
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_356
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    LI   R6, _STR_321
    LI   R7, _STR_357
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    LI   R28, slog
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2273:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_status:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, _STR_358
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_359
    LI   R6, wifi
    LI   R28, 103
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    JZ   R7, _L2277
    LI   R8, _STR_360
    ADD  R7, R8, R0
    JMP  _L2278
_L2277:
    LI   R8, _STR_361
    ADD  R7, R8, R0
_L2278:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_362
    LI   R6, wifi
    LI   R28, 102
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    JZ   R7, _L2279
    LI   R8, _STR_363
    ADD  R7, R8, R0
    JMP  _L2280
_L2279:
    LI   R8, _STR_364
    ADD  R7, R8, R0
_L2280:
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    JZ   R6, _L2281
    LI   R5, wifi
    LI   R28, 104
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, wifi_ip_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, wifi
    LI   R28, 105
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 22
    ADD  R7, R29, R28
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    LI   R28, wifi_ip_str
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_365
    LI   R6, wifi
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_366
    LI   R6, wifi
    LI   R28, 98
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, wifi
    LI   R28, 99
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_367
    LI   R6, wifi
    LI   R28, 100
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_368
    LI   R6, wifi
    LI   R28, 101
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_369
    LI   R28, 2
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_370
    LI   R28, 22
    ADD  R6, R29, R28
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_371
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2282
_L2281:
_L2282:
    LI   R5, _STR_372
    LI   R6, wifi
    LI   R28, 106
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R1, R5, R0
    ADD  R2, R7, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_373
    ADD  R1, R5, R0
    LI   R28, KPRINT
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2276:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_is_up:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R28, 102
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2283
_L2283:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wifi_rssi:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, wifi
    LI   R28, 100
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2284
_L2284:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

theme_accent:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, current_theme
    LOAD R6, R5, 0
    ; switch value is in R6
    LI   R5, 4280449023
    ADD  R7, R5, R0
    JMP  _L2285
    LI   R5, 4282664004
    ADD  R7, R5, R0
    JMP  _L2285
    LI   R5, 4278242406
    ADD  R7, R5, R0
    JMP  _L2285
_L2286:
_L2285:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_init:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2288:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2291
    JMP  _L2289
_L2290:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2288
_L2289:
    LI   R5, windows
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2290
_L2291:
    LI   R5, window_count
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, focused_win
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
    LI   R5, current_theme
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, _STR_374
    LI   R6, 8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2287:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

desktop_welcome_screen:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 4279246912
    ADD  R1, R5, R0
    LI   R28, gpu_clear
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 400
    LI   R6, 150
    LI   R7, 60
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, theme_accent
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, ui_draw_crescent
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 150
    LI   R6, 250
    LI   R7, 500
    LI   R8, 80
    LI   R9, 4280299600
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_32
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_34
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_375
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, _STR_34
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, draw_taskbar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2292:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_create_window:
    LI   R28, -39
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    STORE R4, R29, 5
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2294:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2297
    JMP  _L2295
_L2296:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2294
_L2295:
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2298
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 5
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 4293848814
    STORE R8, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 40
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, theme_accent
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 5
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 6
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R10, windows
    LI   R28, 7
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 41
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 5
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R10, 32
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    ADD  R3, R10, R0
    LI   R28, kstrncpy
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 39
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    LI   R5, windows
    LI   R28, 7
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, focused_win
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2300
    LI   R5, windows
    LI   R6, focused_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2301
_L2300:
_L2301:
    LI   R5, focused_win
    LOAD R6, R5, 0
    LI   R28, 7
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, window_count
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2293
    JMP  _L2299
_L2298:
_L2299:
    JMP  _L2296
_L2297:
    LI   R5, _STR_376
    LI   R6, 8
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2293
_L2293:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 39
    ADD  R30, R30, R28
    JALR R0, R31, 0

draw_window_frame:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 39
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    OR   R5, R5, R7
    CMPNE R5, R5, R0
    JZ   R5, _L2303
    JMP  _L2302
    JMP  _L2304
_L2303:
_L2304:
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R11, 24
    LI   R28, 2
    ADD  R12, R29, R28
    LI   R28, 40
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 24
    ADD  R7, R7, R8
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 3
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, 24
    SUB  R10, R10, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LI   R28, 4
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 2
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LI   R28, 1
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    LI   R13, 4278190080
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R12, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 2
    ADD  R8, R29, R28
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R7, R7, R9
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 2
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LI   R28, 1
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 2
    ADD  R12, R29, R28
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 4278190080
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    LI   R28, 2
    ADD  R11, R29, R28
    LI   R28, 1
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 2
    ADD  R12, R29, R28
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 4278190080
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 2
    ADD  R6, R29, R28
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R7, R29, R28
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R28, 2
    ADD  R9, R29, R28
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 2
    ADD  R10, R29, R28
    LI   R28, 2
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R9, R9, R11
    LI   R28, 2
    ADD  R11, R29, R28
    LI   R28, 1
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 2
    ADD  R12, R29, R28
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R11, R11, R13
    LI   R13, 4278190080
    ADD  R1, R5, R0
    ADD  R2, R8, R0
    ADD  R3, R9, R0
    ADD  R4, R11, R0
    LI   R28, gpu_draw_line
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2302:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

draw_taskbar:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 10
    STORE R5, R29, 3
    LI   R5, 0
    LI   R6, 600
    LI   R7, 30
    SUB  R6, R6, R7
    LI   R7, 800
    LI   R8, 30
    LI   R9, 4279308561
    ADD  R1, R5, R0
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2306:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2309
    JMP  _L2307
_L2308:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2306
_L2307:
    LI   R5, windows
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L2310
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 600
    LI   R8, 26
    SUB  R7, R7, R8
    LI   R8, 100
    LI   R9, 22
    LI   R10, windows
    LI   R28, 2
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 41
    MUL  R12, R12, R28
    ADD  R10, R10, R12
    LI   R28, 38
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    JZ   R12, _L2312
    LI   R28, -8
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    STORE R8, R30, 3
    STORE R9, R30, 4
    STORE R10, R30, 5
    STORE R11, R30, 6
    STORE R12, R30, 7
    LI   R28, theme_accent
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LOAD R8, R30, 3
    LOAD R9, R30, 4
    LOAD R10, R30, 5
    LOAD R11, R30, 6
    LOAD R12, R30, 7
    LI   R28, 8
    ADD  R30, R30, R28
    ADD  R13, R7, R0  ; sonuç = R7
    ADD  R12, R13, R0
    JMP  _L2313
_L2312:
    LI   R13, 4281545523
    ADD  R12, R13, R0
_L2313:
    ADD  R1, R6, R0
    ADD  R2, R7, R0
    ADD  R3, R8, R0
    ADD  R4, R9, R0
    LI   R28, gpu_draw_rect
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 110
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2311
_L2310:
_L2311:
    JMP  _L2308
_L2309:
_L2305:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_render:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2315:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2318
    JMP  _L2316
_L2317:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2315
_L2316:
    LI   R5, windows
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    ADD  R1, R5, R0
    LI   R28, draw_window_frame
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2317
_L2318:
    LI   R28, draw_taskbar
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, draw_cursor
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R28, gpu_present
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2314:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_run:
    LI   R28, -34
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 2
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 3
    LI   R5, 1
    SUB  R5, R0, R5
    STORE R5, R29, 4
    LI   R5, mouse
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    LI   R6, mouse
    LI   R28, 0
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPEQ  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    CMPEQ  R7, R7, R9
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    LI   R8, mouse
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 4
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    CMPEQ  R8, R8, R10
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    JZ   R5, _L2320
    JMP  _L2319
    JMP  _L2321
_L2320:
_L2321:
    LI   R5, mouse
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    LI   R9, mouse
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    ADD  R3, R10, R0
    LI   R28, wm_mouse_event
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, mouse
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R5, mouse
    LI   R28, 4
    ADD  R5, R5, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, mouse
    LI   R28, 2
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, wm_render
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2319:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 34
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_click:
    LI   R28, -36
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
_L2323:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2326
    JMP  _L2324
_L2325:
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2323
_L2324:
    LI   R5, windows
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R7, windows
    LI   R28, 4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 41
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LI   R28, 39
    ADD  R7, R7, R28
    LOAD R9, R7, 0
    ADD  R7, R9, R0
    CMPEQ R7, R7, R0
    CMPNE R5, R5, R0
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R9, windows
    LI   R28, 4
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 41
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    CMPLE  R8, R11, R8
    CMPNE R5, R5, R0
    CMPNE R8, R8, R0
    AND   R5, R5, R8
    LI   R28, 2
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R11, windows
    LI   R28, 4
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 41
    MUL  R13, R13, R28
    ADD  R11, R11, R13
    LI   R28, 0
    ADD  R11, R11, R28
    LOAD R13, R11, 0
    ADD  R11, R13, R0
    LI   R13, windows
    LI   R28, 4
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    LI   R28, 41
    MUL  R15, R15, R28
    ADD  R13, R13, R15
    LI   R28, 2
    ADD  R13, R13, R28
    LOAD R15, R13, 0
    ADD  R11, R11, R15
    CMPLE  R10, R10, R11
    CMPNE R5, R5, R0
    CMPNE R10, R10, R0
    AND   R5, R5, R10
    LI   R28, 3
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    ADD  R13, R14, R0
    LI   R14, windows
    LI   R28, 4
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    LI   R28, 41
    MUL  R16, R16, R28
    ADD  R14, R14, R16
    LI   R28, 1
    ADD  R14, R14, R28
    LOAD R16, R14, 0
    CMPLE  R13, R16, R13
    CMPNE R5, R5, R0
    CMPNE R13, R13, R0
    AND   R5, R5, R13
    LI   R28, 3
    ADD  R15, R29, R28
    LOAD R16, R15, 0
    ADD  R15, R16, R0
    LI   R16, windows
    LI   R28, 4
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    LI   R28, 41
    MUL  R18, R18, R28
    ADD  R16, R16, R18
    LI   R28, 1
    ADD  R16, R16, R28
    LOAD R18, R16, 0
    ADD  R16, R18, R0
    LI   R18, windows
    LI   R28, 4
    ADD  R19, R29, R28
    LOAD R20, R19, 0
    LI   R28, 41
    MUL  R20, R20, R28
    ADD  R18, R18, R20
    LI   R28, 3
    ADD  R18, R18, R28
    LOAD R20, R18, 0
    ADD  R16, R16, R20
    CMPLE  R15, R15, R16
    CMPNE R5, R5, R0
    CMPNE R15, R15, R0
    AND   R5, R5, R15
    JZ   R5, _L2327
    LI   R5, focused_win
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2329
    LI   R5, windows
    LI   R6, focused_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2330
_L2329:
_L2330:
    LI   R5, windows
    LI   R28, 4
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 1
    STORE R8, R5, 0
    LI   R5, focused_win
    LOAD R6, R5, 0
    LI   R28, 4
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R7, R6, R0
    JMP  _L2322
    JMP  _L2328
_L2327:
_L2328:
    JMP  _L2325
_L2326:
    LI   R5, 1
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L2322
_L2322:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 36
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_set_theme:
    LI   R28, -35
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    LI   R28, 2
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R7, 2
    CMPLT  R6, R7, R6
    OR   R5, R5, R6
    CMPNE R5, R5, R0
    JZ   R5, _L2332
    LI   R5, _STR_377
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    JMP  _L2331
    JMP  _L2333
_L2332:
_L2333:
    LI   R5, current_theme
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
_L2334:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 8
    CMPLT  R5, R5, R6
    JZ   R5, _L2337
    JMP  _L2335
_L2336:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    ADD  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2334
_L2335:
    LI   R5, windows
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 37
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    JZ   R7, _L2338
    LI   R5, windows
    LI   R28, 3
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 40
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, -3
    ADD  R30, R30, R28
    STORE R5, R30, 0
    STORE R6, R30, 1
    STORE R7, R30, 2
    LI   R28, theme_accent
    JALR R31, R28, 0
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    LOAD R7, R30, 2
    LI   R28, 3
    ADD  R30, R30, R28
    ADD  R8, R7, R0  ; sonuç = R7
    STORE R8, R5, 0
    JMP  _L2339
_L2338:
_L2339:
    JMP  _L2336
_L2337:
    LI   R5, _STR_378
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
_L2331:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    ADD  R30, R30, R28
    JALR R0, R31, 0

wm_mouse_event:
    LI   R28, -37
    ADD  R30, R30, R28
    STORE R31, R30, 0
    STORE R29, R30, 1
    ADD  R29, R30, R0
    STORE R1, R29, 2
    STORE R2, R29, 3
    STORE R3, R29, 4
    LI   R28, 4
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 1
    AND  R5, R5, R6
    STORE R5, R29, 5
    LI   R28, 5
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L2341
    LI   R5, drag_win
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
    LI   R5, resize_win
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R7, R0, R7
    STORE R7, R5, 0
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2340
    JMP  _L2342
_L2341:
_L2342:
    LI   R5, drag_win
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2343
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, drag_offset_x
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 7
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, drag_offset_y
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 8
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2345
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L2346
_L2345:
_L2346:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLT  R5, R5, R6
    JZ   R5, _L2347
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 0
    STORE R7, R5, 0
    JMP  _L2348
_L2347:
_L2348:
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, windows
    LI   R7, drag_win
    LOAD R8, R7, 0
    LI   R28, 41
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 2
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R5, R5, R8
    LI   R8, 800
    CMPLT  R5, R8, R5
    JZ   R5, _L2349
    LI   R28, 7
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 800
    LI   R8, windows
    LI   R9, drag_win
    LOAD R10, R9, 0
    LI   R28, 41
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 2
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    JMP  _L2350
_L2349:
_L2350:
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, windows
    LI   R7, drag_win
    LOAD R8, R7, 0
    LI   R28, 41
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    LI   R28, 3
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    ADD  R5, R5, R8
    LI   R8, 600
    LI   R9, 30
    SUB  R8, R8, R9
    CMPLT  R5, R8, R5
    JZ   R5, _L2351
    LI   R28, 8
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 600
    LI   R8, 30
    SUB  R7, R7, R8
    LI   R8, windows
    LI   R9, drag_win
    LOAD R10, R9, 0
    LI   R28, 41
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 3
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    JMP  _L2352
_L2351:
_L2352:
    LI   R5, windows
    LI   R6, drag_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 7
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R6, drag_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 8
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2340
    JMP  _L2344
_L2343:
_L2344:
    LI   R5, resize_win
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2353
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, prev_mx
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 9
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, prev_my
    LOAD R7, R6, 0
    SUB  R5, R5, R7
    STORE R5, R29, 10
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 9
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    STORE R5, R29, 11
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 10
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    STORE R5, R29, 12
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 80
    CMPLT  R5, R5, R6
    JZ   R5, _L2355
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 80
    STORE R7, R5, 0
    JMP  _L2356
_L2355:
_L2356:
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 48
    CMPLT  R5, R5, R6
    JZ   R5, _L2357
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 48
    STORE R7, R5, 0
    JMP  _L2358
_L2357:
_L2358:
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 0
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 11
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    LI   R8, 800
    CMPLT  R5, R8, R5
    JZ   R5, _L2359
    LI   R28, 11
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 800
    LI   R8, windows
    LI   R9, resize_win
    LOAD R10, R9, 0
    LI   R28, 41
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 0
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    JMP  _L2360
_L2359:
_L2360:
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 1
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    ADD  R5, R7, R0
    LI   R28, 12
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R5, R5, R8
    LI   R8, 600
    LI   R9, 30
    SUB  R8, R8, R9
    CMPLT  R5, R8, R5
    JZ   R5, _L2361
    LI   R28, 12
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 600
    LI   R8, 30
    SUB  R7, R7, R8
    LI   R8, windows
    LI   R9, resize_win
    LOAD R10, R9, 0
    LI   R28, 41
    MUL  R10, R10, R28
    ADD  R8, R8, R10
    LI   R28, 1
    ADD  R8, R8, R28
    LOAD R10, R8, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    JMP  _L2362
_L2361:
_L2362:
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 2
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 11
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, windows
    LI   R6, resize_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 3
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R28, 12
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    STORE R9, R5, 0
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2340
    JMP  _L2354
_L2353:
_L2354:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 8
    LI   R8, 1
    SUB  R7, R7, R8
    STORE R7, R5, 0
_L2363:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    JZ   R5, _L2366
    JMP  _L2364
_L2365:
    LI   R28, 6
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R7, 1
    SUB  R8, R6, R7
    STORE R8, R5, 0
    JMP  _L2363
_L2364:
    LI   R5, windows
    LI   R28, 6
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    STORE R5, R29, 13
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 37
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    CMPEQ R6, R6, R0
    LI   R28, 13
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    LI   R28, 39
    ADD  R8, R8, R28
    LOAD R9, R8, 0
    OR   R6, R6, R9
    CMPNE R6, R6, R0
    JZ   R6, _L2367
    JMP  _L2365
    JMP  _L2368
_L2367:
_L2368:
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 13
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    LI   R28, 2
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 13
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 0
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 13
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 2
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R10, R10, R13
    CMPLT  R8, R10, R8
    OR   R5, R5, R8
    CMPNE R5, R5, R0
    JZ   R5, _L2369
    JMP  _L2365
    JMP  _L2370
_L2369:
_L2370:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 13
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    CMPLT  R5, R5, R8
    LI   R28, 3
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R8, R9, R0
    LI   R28, 13
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    LI   R28, 1
    ADD  R10, R10, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    LI   R28, 13
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    LI   R28, 3
    ADD  R12, R12, R28
    LOAD R13, R12, 0
    ADD  R10, R10, R13
    CMPLT  R8, R10, R8
    OR   R5, R5, R8
    CMPNE R5, R5, R0
    JZ   R5, _L2371
    JMP  _L2365
    JMP  _L2372
_L2371:
_L2372:
    LI   R5, focused_win
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R6, 0
    CMPLE  R5, R6, R5
    LI   R6, focused_win
    LOAD R7, R6, 0
    ADD  R6, R7, R0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    CMPNE  R6, R6, R8
    CMPNE R5, R5, R0
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L2373
    LI   R5, windows
    LI   R6, focused_win
    LOAD R7, R6, 0
    LI   R28, 41
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, 38
    ADD  R5, R5, R28
    LOAD R7, R5, 0
    LI   R8, 0
    STORE R8, R5, 0
    JMP  _L2374
_L2373:
_L2374:
    LI   R28, 13
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    LI   R28, 38
    ADD  R6, R6, R28
    LOAD R7, R6, 0
    LI   R8, 1
    STORE R8, R6, 0
    LI   R5, focused_win
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R28, 2
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 13
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 0
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 13
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 2
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    ADD  R7, R7, R10
    LI   R10, 12
    SUB  R7, R7, R10
    CMPLE  R5, R7, R5
    LI   R28, 3
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R9, R10, R0
    LI   R28, 13
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    LI   R28, 1
    ADD  R11, R11, R28
    LOAD R12, R11, 0
    ADD  R11, R12, R0
    LI   R28, 13
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    LI   R28, 3
    ADD  R13, R13, R28
    LOAD R14, R13, 0
    ADD  R11, R11, R14
    LI   R14, 12
    SUB  R11, R11, R14
    CMPLE  R9, R11, R9
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L2375
    LI   R5, resize_win
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2340
    JMP  _L2376
_L2375:
_L2376:
    LI   R28, 3
    ADD  R5, R29, R28
    LOAD R6, R5, 0
    ADD  R5, R6, R0
    LI   R28, 13
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    LI   R28, 1
    ADD  R7, R7, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R8, 24
    ADD  R7, R7, R8
    CMPLT  R5, R5, R7
    JZ   R5, _L2377
    LI   R5, drag_win
    LOAD R6, R5, 0
    LI   R28, 6
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, drag_offset_x
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 13
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 0
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    LI   R5, drag_offset_y
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    ADD  R7, R8, R0
    LI   R28, 13
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    LI   R28, 1
    ADD  R9, R9, R28
    LOAD R10, R9, 0
    SUB  R7, R7, R10
    STORE R7, R5, 0
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    JMP  _L2340
    JMP  _L2378
_L2377:
_L2378:
    JMP  _L2340
    JMP  _L2365
_L2366:
    LI   R5, prev_mx
    LOAD R6, R5, 0
    LI   R28, 2
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
    LI   R5, prev_my
    LOAD R6, R5, 0
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L2340:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 37
    ADD  R30, R30, R28
    JALR R0, R31, 0


; cc.c global data (one Oxalyn word per scalar element)
apps:
    .zero 64
app_count:
    .zero 1
users:
    .zero 80
current_uid:
    .word -1
files:
    .zero 2328
file_count:
    .zero 1
framebuffer:
    .word 32768
fb_w:
    .word 800
fb_h:
    .word 600
font8x8:
    .zero 8
    .word 24
    .word 60
    .word 60
    .word 24
    .word 24
    .zero 1
    .word 24
    .zero 1
    .word 54
    .word 54
    .zero 6
    .word 54
    .word 54
    .word 127
    .word 54
    .word 127
    .word 54
    .word 54
    .zero 1
    .word 12
    .word 62
    .word 3
    .word 30
    .word 48
    .word 31
    .word 12
    .zero 2
    .word 99
    .word 51
    .word 24
    .word 12
    .word 102
    .word 99
    .zero 1
    .word 28
    .word 54
    .word 28
    .word 110
    .word 59
    .word 51
    .word 110
    .zero 1
    .word 6
    .word 6
    .word 3
    .zero 5
    .word 24
    .word 12
    .word 6
    .word 6
    .word 6
    .word 12
    .word 24
    .zero 1
    .word 6
    .word 12
    .word 24
    .word 24
    .word 24
    .word 12
    .word 6
    .zero 2
    .word 102
    .word 60
    .word 255
    .word 60
    .word 102
    .zero 3
    .word 12
    .word 12
    .word 63
    .word 12
    .word 12
    .zero 7
    .word 12
    .word 12
    .word 6
    .zero 3
    .word 63
    .zero 9
    .word 12
    .word 12
    .zero 1
    .word 96
    .word 48
    .word 24
    .word 12
    .word 6
    .word 3
    .word 1
    .zero 1
    .word 62
    .word 99
    .word 115
    .word 123
    .word 111
    .word 103
    .word 62
    .zero 1
    .word 12
    .word 14
    .word 12
    .word 12
    .word 12
    .word 12
    .word 63
    .zero 1
    .word 30
    .word 51
    .word 48
    .word 28
    .word 6
    .word 51
    .word 63
    .zero 1
    .word 30
    .word 51
    .word 48
    .word 28
    .word 48
    .word 51
    .word 30
    .zero 1
    .word 56
    .word 60
    .word 54
    .word 51
    .word 127
    .word 48
    .word 120
    .zero 1
    .word 63
    .word 3
    .word 31
    .word 48
    .word 48
    .word 51
    .word 30
    .zero 1
    .word 28
    .word 6
    .word 3
    .word 31
    .word 51
    .word 51
    .word 30
    .zero 1
    .word 63
    .word 51
    .word 48
    .word 24
    .word 12
    .word 12
    .word 12
    .zero 1
    .word 30
    .word 51
    .word 51
    .word 30
    .word 51
    .word 51
    .word 30
    .zero 1
    .word 30
    .word 51
    .word 51
    .word 62
    .word 48
    .word 24
    .word 14
    .zero 2
    .word 12
    .word 12
    .zero 2
    .word 12
    .word 12
    .zero 2
    .word 12
    .word 12
    .zero 2
    .word 12
    .word 12
    .word 6
    .word 24
    .word 12
    .word 6
    .word 3
    .word 6
    .word 12
    .word 24
    .zero 3
    .word 63
    .zero 2
    .word 63
    .zero 2
    .word 6
    .word 12
    .word 24
    .word 48
    .word 24
    .word 12
    .word 6
    .zero 1
    .word 30
    .word 51
    .word 48
    .word 24
    .word 12
    .zero 1
    .word 12
    .zero 1
    .word 62
    .word 99
    .word 123
    .word 123
    .word 123
    .word 3
    .word 30
    .zero 1
    .word 12
    .word 30
    .word 51
    .word 51
    .word 63
    .word 51
    .word 51
    .zero 1
    .word 63
    .word 102
    .word 102
    .word 62
    .word 102
    .word 102
    .word 63
    .zero 1
    .word 60
    .word 102
    .word 3
    .word 3
    .word 3
    .word 102
    .word 60
    .zero 1
    .word 31
    .word 54
    .word 102
    .word 102
    .word 102
    .word 54
    .word 31
    .zero 1
    .word 127
    .word 70
    .word 22
    .word 30
    .word 22
    .word 70
    .word 127
    .zero 1
    .word 127
    .word 70
    .word 22
    .word 30
    .word 22
    .word 6
    .word 15
    .zero 1
    .word 60
    .word 102
    .word 3
    .word 3
    .word 115
    .word 102
    .word 124
    .zero 1
    .word 51
    .word 51
    .word 51
    .word 63
    .word 51
    .word 51
    .word 51
    .zero 1
    .word 30
    .word 12
    .word 12
    .word 12
    .word 12
    .word 12
    .word 30
    .zero 1
    .word 120
    .word 48
    .word 48
    .word 48
    .word 51
    .word 51
    .word 30
    .zero 1
    .word 103
    .word 102
    .word 54
    .word 30
    .word 54
    .word 102
    .word 103
    .zero 1
    .word 15
    .word 6
    .word 6
    .word 6
    .word 70
    .word 102
    .word 127
    .zero 1
    .word 99
    .word 119
    .word 127
    .word 127
    .word 107
    .word 99
    .word 99
    .zero 1
    .word 99
    .word 103
    .word 111
    .word 123
    .word 115
    .word 99
    .word 99
    .zero 1
    .word 28
    .word 54
    .word 99
    .word 99
    .word 99
    .word 54
    .word 28
    .zero 1
    .word 63
    .word 102
    .word 102
    .word 62
    .word 6
    .word 6
    .word 15
    .zero 1
    .word 30
    .word 51
    .word 51
    .word 51
    .word 59
    .word 30
    .word 56
    .zero 1
    .word 63
    .word 102
    .word 102
    .word 62
    .word 54
    .word 102
    .word 103
    .zero 1
    .word 30
    .word 51
    .word 7
    .word 14
    .word 56
    .word 51
    .word 30
    .zero 1
    .word 63
    .word 45
    .word 12
    .word 12
    .word 12
    .word 12
    .word 30
    .zero 1
    .word 51
    .word 51
    .word 51
    .word 51
    .word 51
    .word 51
    .word 63
    .zero 1
    .word 51
    .word 51
    .word 51
    .word 51
    .word 51
    .word 30
    .word 12
    .zero 1
    .word 99
    .word 99
    .word 99
    .word 107
    .word 127
    .word 119
    .word 99
    .zero 1
    .word 99
    .word 99
    .word 54
    .word 28
    .word 28
    .word 54
    .word 99
    .zero 1
    .word 51
    .word 51
    .word 51
    .word 30
    .word 12
    .word 12
    .word 30
    .zero 1
    .word 127
    .word 99
    .word 49
    .word 24
    .word 76
    .word 102
    .word 127
    .zero 1
    .word 30
    .word 6
    .word 6
    .word 6
    .word 6
    .word 6
    .word 30
    .zero 1
    .word 3
    .word 6
    .word 12
    .word 24
    .word 48
    .word 96
    .word 64
    .zero 1
    .word 30
    .word 24
    .word 24
    .word 24
    .word 24
    .word 24
    .word 30
    .zero 1
    .word 8
    .word 28
    .word 54
    .word 99
    .zero 11
    .word 255
    .word 12
    .word 12
    .word 24
    .zero 7
    .word 30
    .word 48
    .word 62
    .word 51
    .word 110
    .zero 1
    .word 7
    .word 6
    .word 6
    .word 62
    .word 102
    .word 102
    .word 59
    .zero 3
    .word 30
    .word 51
    .word 3
    .word 51
    .word 30
    .zero 1
    .word 56
    .word 48
    .word 48
    .word 62
    .word 51
    .word 51
    .word 110
    .zero 3
    .word 30
    .word 51
    .word 63
    .word 3
    .word 30
    .zero 1
    .word 28
    .word 54
    .word 6
    .word 15
    .word 6
    .word 6
    .word 15
    .zero 3
    .word 110
    .word 51
    .word 51
    .word 62
    .word 48
    .word 31
    .word 7
    .word 6
    .word 54
    .word 110
    .word 102
    .word 102
    .word 103
    .zero 1
    .word 12
    .zero 1
    .word 14
    .word 12
    .word 12
    .word 12
    .word 30
    .zero 1
    .word 48
    .zero 1
    .word 48
    .word 48
    .word 48
    .word 51
    .word 51
    .word 30
    .word 7
    .word 6
    .word 102
    .word 54
    .word 30
    .word 54
    .word 103
    .zero 1
    .word 14
    .word 12
    .word 12
    .word 12
    .word 12
    .word 12
    .word 30
    .zero 3
    .word 51
    .word 127
    .word 127
    .word 107
    .word 99
    .zero 3
    .word 31
    .word 51
    .word 51
    .word 51
    .word 51
    .zero 3
    .word 30
    .word 51
    .word 51
    .word 51
    .word 30
    .zero 3
    .word 59
    .word 102
    .word 102
    .word 62
    .word 6
    .word 15
    .zero 2
    .word 110
    .word 51
    .word 51
    .word 62
    .word 48
    .word 120
    .zero 2
    .word 59
    .word 110
    .word 102
    .word 6
    .word 15
    .zero 3
    .word 62
    .word 3
    .word 30
    .word 48
    .word 31
    .zero 1
    .word 8
    .word 12
    .word 62
    .word 12
    .word 12
    .word 44
    .word 24
    .zero 3
    .word 51
    .word 51
    .word 51
    .word 51
    .word 110
    .zero 3
    .word 51
    .word 51
    .word 51
    .word 30
    .word 12
    .zero 3
    .word 99
    .word 107
    .word 127
    .word 127
    .word 54
    .zero 3
    .word 99
    .word 54
    .word 28
    .word 54
    .word 99
    .zero 3
    .word 51
    .word 51
    .word 51
    .word 62
    .word 48
    .word 31
    .zero 2
    .word 63
    .word 25
    .word 12
    .word 38
    .word 63
    .zero 1
    .word 56
    .word 12
    .word 12
    .word 7
    .word 12
    .word 12
    .word 56
    .zero 1
    .word 24
    .word 24
    .word 24
    .zero 1
    .word 24
    .word 24
    .word 24
    .zero 1
    .word 7
    .word 12
    .word 12
    .word 56
    .word 12
    .word 12
    .word 7
    .zero 1
    .word 110
    .word 59
    .zero 14
cmd_queue:
    .zero 17664
cmd_head:
    .zero 1
sprites:
    .zero 261
tile_strips:
    .zero 258
gpu_ring:
    .word 196608
ring_head:
    .zero 1
current_owner:
    .zero 1
gpu_ready:
    .zero 1
key_buf:
    .zero 258
pipes:
    .zero 2088
queues:
    .zero 8608
RTC_DAY_NAMES:
    .word _STR_61
    .word _STR_62
    .word _STR_63
    .word _STR_64
    .word _STR_65
    .word _STR_66
    .word _STR_67
RTC_MONTH_NAMES:
    .word _STR_68
    .word _STR_69
    .word _STR_70
    .word _STR_71
    .word _STR_72
    .word _STR_73
    .word _STR_74
    .word _STR_75
    .word _STR_76
    .word _STR_77
    .word _STR_78
    .word _STR_79
    .word _STR_80
syscalls_handled:
    .zero 1
alarm_table:
    .zero 16
alarm_table_init:
    .zero 1
blocks:
    .zero 192
block_count:
    .zero 1
mouse:
    .zero 5
net:
    .zero 14
arp_table:
    .zero 64
perms:
    .zero 1120
process_table:
    .zero 384
current_pid:
    .zero 1
context_switches:
    .zero 1
command_buffer:
    .zero 64
history:
    .zero 640
history_idx:
    .zero 1
cores:
    .zero 192
stats:
    .zero 6
active_cores:
    .zero 1
active_core:
    .zero 1
total_ticks:
    .zero 1
slog_buf:
    .zero 12032
slog_head:
    .zero 1
slog_total:
    .zero 1
level_str:
    .word _STR_256
    .word _STR_257
    .word _STR_258
    .word _STR_259
    .word _STR_260
    .zero 251
conns:
    .zero 16480
tcp_isn_seed:
    .word 2882343476
g_usb_hid:
    .zero 32
hid_unshifted:
    .zero 4
    .word 97
    .word 98
    .word 99
    .word 100
    .word 101
    .word 102
    .word 103
    .word 104
    .word 105
    .word 106
    .word 107
    .word 108
    .word 109
    .word 110
    .word 111
    .word 112
    .word 113
    .word 114
    .word 115
    .word 116
    .word 117
    .word 118
    .word 119
    .word 120
    .word 121
    .word 122
    .word 49
    .word 50
    .word 51
    .word 52
    .word 53
    .word 54
    .word 55
    .word 56
    .word 57
    .word 48
    .word 10
    .word 27
    .word 8
    .word 9
    .word 32
    .word 45
    .word 61
    .word 91
    .word 93
    .word 92
    .zero 1
    .word 59
    .word 39
    .word 96
    .word 44
    .word 46
    .word 47
    .zero 26
hid_shifted:
    .zero 4
    .word 65
    .word 66
    .word 67
    .word 68
    .word 69
    .word 70
    .word 71
    .word 72
    .word 73
    .word 74
    .word 75
    .word 76
    .word 77
    .word 78
    .word 79
    .word 80
    .word 81
    .word 82
    .word 83
    .word 84
    .word 85
    .word 86
    .word 87
    .word 88
    .word 89
    .word 90
    .word 33
    .word 64
    .word 35
    .word 36
    .word 37
    .word 94
    .word 38
    .word 42
    .word 40
    .word 41
    .word 10
    .word 27
    .word 8
    .word 9
    .word 32
    .word 95
    .word 43
    .word 123
    .word 125
    .word 124
    .zero 1
    .word 58
    .word 34
    .word 126
    .word 60
    .word 62
    .word 63
    .zero 26
nodes:
    .zero 2432
vfs_cwd_id:
    .zero 1
wifi:
    .zero 683
windows:
    .zero 328
window_count:
    .zero 1
focused_win:
    .word -1
current_theme:
    .zero 1
drag_win:
    .word -1
drag_offset_x:
    .zero 1
drag_offset_y:
    .zero 1
resize_win:
    .word -1
prev_mx:
    .zero 1
prev_my:
    .zero 1
_STR_0:
    .word 72
    .word 101
    .word 108
    .word 108
    .word 111
    .word 32
    .word 102
    .word 114
    .word 111
    .word 109
    .word 32
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 33
    .word 10
    .word 0
_STR_1:
    .word 67
    .word 111
    .word 117
    .word 110
    .word 116
    .word 58
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_2:
    .word 71
    .word 114
    .word 97
    .word 112
    .word 104
    .word 105
    .word 99
    .word 115
    .word 32
    .word 100
    .word 101
    .word 109
    .word 111
    .word 32
    .word 115
    .word 116
    .word 97
    .word 114
    .word 116
    .word 105
    .word 110
    .word 103
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_3:
    .word 83
    .word 104
    .word 97
    .word 112
    .word 101
    .word 115
    .word 32
    .word 100
    .word 114
    .word 97
    .word 119
    .word 110
    .word 32
    .word 116
    .word 111
    .word 32
    .word 102
    .word 114
    .word 97
    .word 109
    .word 101
    .word 98
    .word 117
    .word 102
    .word 102
    .word 101
    .word 114
    .word 10
    .word 0
_STR_4:
    .word 67
    .word 97
    .word 108
    .word 99
    .word 32
    .word 68
    .word 101
    .word 109
    .word 111
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 43
    .word 32
    .word 37
    .word 100
    .word 32
    .word 61
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_5:
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 100
    .word 32
    .word 42
    .word 32
    .word 37
    .word 100
    .word 32
    .word 61
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_6:
    .word 80
    .word 97
    .word 105
    .word 110
    .word 116
    .word 32
    .word 109
    .word 111
    .word 100
    .word 101
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 117
    .word 115
    .word 101
    .word 32
    .word 39
    .word 109
    .word 111
    .word 117
    .word 115
    .word 101
    .word 32
    .word 60
    .word 100
    .word 120
    .word 62
    .word 32
    .word 60
    .word 100
    .word 121
    .word 62
    .word 39
    .word 32
    .word 116
    .word 104
    .word 101
    .word 110
    .word 32
    .word 39
    .word 99
    .word 108
    .word 105
    .word 99
    .word 107
    .word 39
    .word 32
    .word 98
    .word 101
    .word 102
    .word 111
    .word 114
    .word 101
    .word 32
    .word 114
    .word 117
    .word 110
    .word 110
    .word 105
    .word 110
    .word 103
    .word 32
    .word 112
    .word 97
    .word 105
    .word 110
    .word 116
    .word 32
    .word 97
    .word 103
    .word 97
    .word 105
    .word 110
    .word 10
    .word 0
_STR_7:
    .word 77
    .word 117
    .word 115
    .word 105
    .word 99
    .word 32
    .word 109
    .word 111
    .word 100
    .word 101
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 100
    .word 111
    .word 45
    .word 114
    .word 101
    .word 45
    .word 109
    .word 105
    .word 32
    .word 100
    .word 101
    .word 109
    .word 111
    .word 32
    .word 43
    .word 32
    .word 102
    .word 97
    .word 110
    .word 102
    .word 97
    .word 114
    .word 101
    .word 10
    .word 0
_STR_8:
    .word 104
    .word 101
    .word 108
    .word 108
    .word 111
    .word 0
_STR_9:
    .word 72
    .word 101
    .word 108
    .word 108
    .word 111
    .word 32
    .word 87
    .word 111
    .word 114
    .word 108
    .word 100
    .word 0
_STR_10:
    .word 99
    .word 111
    .word 117
    .word 110
    .word 116
    .word 101
    .word 114
    .word 0
_STR_11:
    .word 67
    .word 111
    .word 117
    .word 110
    .word 116
    .word 32
    .word 48
    .word 45
    .word 57
    .word 0
_STR_12:
    .word 103
    .word 114
    .word 97
    .word 112
    .word 104
    .word 105
    .word 99
    .word 115
    .word 0
_STR_13:
    .word 71
    .word 114
    .word 97
    .word 112
    .word 104
    .word 105
    .word 99
    .word 115
    .word 32
    .word 100
    .word 101
    .word 109
    .word 111
    .word 0
_STR_14:
    .word 99
    .word 97
    .word 108
    .word 99
    .word 0
_STR_15:
    .word 67
    .word 97
    .word 108
    .word 99
    .word 117
    .word 108
    .word 97
    .word 116
    .word 111
    .word 114
    .word 32
    .word 100
    .word 101
    .word 109
    .word 111
    .word 0
_STR_16:
    .word 112
    .word 97
    .word 105
    .word 110
    .word 116
    .word 0
_STR_17:
    .word 80
    .word 97
    .word 105
    .word 110
    .word 116
    .word 32
    .word 40
    .word 49
    .word 32
    .word 102
    .word 114
    .word 97
    .word 109
    .word 101
    .word 41
    .word 0
_STR_18:
    .word 109
    .word 117
    .word 115
    .word 105
    .word 99
    .word 0
_STR_19:
    .word 66
    .word 101
    .word 101
    .word 112
    .word 32
    .word 115
    .word 121
    .word 110
    .word 116
    .word 104
    .word 32
    .word 40
    .word 115
    .word 116
    .word 117
    .word 98
    .word 41
    .word 0
_STR_20:
    .word 65
    .word 118
    .word 97
    .word 105
    .word 108
    .word 97
    .word 98
    .word 108
    .word 101
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 115
    .word 58
    .word 10
    .word 0
_STR_21:
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 10
    .word 0
_STR_22:
    .word 32
    .word 32
    .word 91
    .word 37
    .word 115
    .word 93
    .word 32
    .word 37
    .word 115
    .word 32
    .word 45
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_23:
    .word 120
    .word 0
_STR_24:
    .word 32
    .word 0
_STR_25:
    .word 69
    .word 114
    .word 114
    .word 111
    .word 114
    .word 58
    .word 32
    .word 39
    .word 37
    .word 115
    .word 39
    .word 32
    .word 105
    .word 115
    .word 32
    .word 110
    .word 111
    .word 116
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 101
    .word 100
    .word 32
    .word 40
    .word 116
    .word 114
    .word 121
    .word 58
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 32
    .word 37
    .word 115
    .word 41
    .word 10
    .word 0
_STR_26:
    .word 69
    .word 114
    .word 114
    .word 111
    .word 114
    .word 58
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 32
    .word 116
    .word 97
    .word 98
    .word 108
    .word 101
    .word 32
    .word 102
    .word 117
    .word 108
    .word 108
    .word 10
    .word 0
_STR_27:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 76
    .word 97
    .word 117
    .word 110
    .word 99
    .word 104
    .word 101
    .word 100
    .word 32
    .word 37
    .word 115
    .word 32
    .word 40
    .word 80
    .word 73
    .word 68
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_28:
    .word 69
    .word 114
    .word 114
    .word 111
    .word 114
    .word 58
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 32
    .word 39
    .word 37
    .word 115
    .word 39
    .word 32
    .word 110
    .word 111
    .word 116
    .word 32
    .word 102
    .word 111
    .word 117
    .word 110
    .word 100
    .word 10
    .word 0
_STR_29:
    .word 91
    .word 79
    .word 75
    .word 93
    .word 32
    .word 37
    .word 115
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 101
    .word 100
    .word 10
    .word 0
_STR_30:
    .word 114
    .word 111
    .word 111
    .word 116
    .word 0
_STR_31:
    .word 103
    .word 117
    .word 101
    .word 115
    .word 116
    .word 0
_STR_32:
    .word 10
    .word 0
_STR_33:
    .word 8
    .word 32
    .word 8
    .word 0
_STR_34:
    .word 43
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 43
    .word 10
    .word 0
_STR_35:
    .word 124
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 32
    .word 76
    .word 79
    .word 71
    .word 73
    .word 78
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 124
    .word 10
    .word 0
_STR_36:
    .word 43
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 43
    .word 10
    .word 10
    .word 0
_STR_37:
    .word 85
    .word 115
    .word 101
    .word 114
    .word 110
    .word 97
    .word 109
    .word 101
    .word 58
    .word 32
    .word 0
_STR_38:
    .word 80
    .word 97
    .word 115
    .word 115
    .word 119
    .word 111
    .word 114
    .word 100
    .word 58
    .word 32
    .word 0
_STR_39:
    .word 10
    .word 91
    .word 79
    .word 75
    .word 93
    .word 32
    .word 76
    .word 111
    .word 103
    .word 105
    .word 110
    .word 32
    .word 115
    .word 117
    .word 99
    .word 99
    .word 101
    .word 115
    .word 115
    .word 102
    .word 117
    .word 108
    .word 46
    .word 32
    .word 87
    .word 101
    .word 108
    .word 99
    .word 111
    .word 109
    .word 101
    .word 44
    .word 32
    .word 37
    .word 115
    .word 33
    .word 10
    .word 0
_STR_40:
    .word 10
    .word 91
    .word 70
    .word 65
    .word 73
    .word 76
    .word 93
    .word 32
    .word 65
    .word 117
    .word 116
    .word 104
    .word 101
    .word 110
    .word 116
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 32
    .word 102
    .word 97
    .word 105
    .word 108
    .word 101
    .word 100
    .word 46
    .word 10
    .word 0
_STR_41:
    .word 10
    .word 91
    .word 83
    .word 69
    .word 67
    .word 85
    .word 82
    .word 73
    .word 84
    .word 89
    .word 93
    .word 32
    .word 84
    .word 111
    .word 111
    .word 32
    .word 109
    .word 97
    .word 110
    .word 121
    .word 32
    .word 102
    .word 97
    .word 105
    .word 108
    .word 101
    .word 100
    .word 32
    .word 108
    .word 111
    .word 103
    .word 105
    .word 110
    .word 32
    .word 97
    .word 116
    .word 116
    .word 101
    .word 109
    .word 112
    .word 116
    .word 115
    .word 46
    .word 10
    .word 0
_STR_42:
    .word 63
    .word 0
_STR_43:
    .word 91
    .word 70
    .word 83
    .word 93
    .word 32
    .word 67
    .word 114
    .word 101
    .word 97
    .word 116
    .word 101
    .word 100
    .word 32
    .word 37
    .word 115
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 98
    .word 121
    .word 116
    .word 101
    .word 115
    .word 41
    .word 10
    .word 0
_STR_44:
    .word 80
    .word 101
    .word 114
    .word 109
    .word 105
    .word 115
    .word 115
    .word 105
    .word 111
    .word 110
    .word 32
    .word 100
    .word 101
    .word 110
    .word 105
    .word 101
    .word 100
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_45:
    .word 70
    .word 105
    .word 108
    .word 101
    .word 115
    .word 58
    .word 10
    .word 0
_STR_46:
    .word 32
    .word 32
    .word 37
    .word 115
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 66
    .word 41
    .word 10
    .word 0
_STR_47:
    .word 32
    .word 32
    .word 40
    .word 101
    .word 109
    .word 112
    .word 116
    .word 121
    .word 41
    .word 10
    .word 0
_STR_48:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 75
    .word 111
    .word 109
    .word 117
    .word 116
    .word 32
    .word 107
    .word 117
    .word 121
    .word 114
    .word 117
    .word 196
    .word 159
    .word 117
    .word 32
    .word 104
    .word 97
    .word 122
    .word 196
    .word 177
    .word 114
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 121
    .word 117
    .word 118
    .word 97
    .word 41
    .word 10
    .word 0
_STR_49:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 75
    .word 117
    .word 121
    .word 114
    .word 117
    .word 107
    .word 32
    .word 100
    .word 111
    .word 108
    .word 117
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 111
    .word 116
    .word 111
    .word 109
    .word 97
    .word 116
    .word 105
    .word 107
    .word 32
    .word 102
    .word 108
    .word 117
    .word 115
    .word 104
    .word 10
    .word 0
_STR_50:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 83
    .word 67
    .word 82
    .word 79
    .word 76
    .word 76
    .word 58
    .word 32
    .word 100
    .word 120
    .word 61
    .word 37
    .word 100
    .word 32
    .word 100
    .word 121
    .word 61
    .word 37
    .word 100
    .word 32
    .word 40
    .word 115
    .word 105
    .word 109
    .word 117
    .word 108
    .word 97
    .word 116
    .word 101
    .word 100
    .word 41
    .word 10
    .word 0
_STR_51:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 70
    .word 76
    .word 73
    .word 80
    .word 58
    .word 32
    .word 104
    .word 61
    .word 37
    .word 100
    .word 32
    .word 118
    .word 61
    .word 37
    .word 100
    .word 32
    .word 40
    .word 104
    .word 119
    .word 32
    .word 109
    .word 111
    .word 100
    .word 101
    .word 32
    .word 111
    .word 110
    .word 108
    .word 121
    .word 41
    .word 10
    .word 0
_STR_52:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 66
    .word 105
    .word 108
    .word 105
    .word 110
    .word 109
    .word 101
    .word 121
    .word 101
    .word 110
    .word 32
    .word 107
    .word 111
    .word 109
    .word 117
    .word 116
    .word 58
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_53:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 83
    .word 112
    .word 114
    .word 105
    .word 116
    .word 101
    .word 32
    .word 37
    .word 100
    .word 32
    .word 121
    .word 117
    .word 107
    .word 108
    .word 101
    .word 110
    .word 100
    .word 105
    .word 32
    .word 40
    .word 37
    .word 100
    .word 120
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_54:
    .word 91
    .word 71
    .word 80
    .word 85
    .word 95
    .word 67
    .word 77
    .word 68
    .word 93
    .word 32
    .word 84
    .word 105
    .word 108
    .word 101
    .word 32
    .word 115
    .word 101
    .word 114
    .word 105
    .word 116
    .word 32
    .word 37
    .word 100
    .word 32
    .word 121
    .word 117
    .word 107
    .word 108
    .word 101
    .word 110
    .word 100
    .word 105
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 107
    .word 97
    .word 114
    .word 111
    .word 41
    .word 10
    .word 0
_STR_55:
    .word 91
    .word 71
    .word 85
    .word 73
    .word 95
    .word 71
    .word 85
    .word 65
    .word 82
    .word 68
    .word 93
    .word 32
    .word 37
    .word 115
    .word 32
    .word 40
    .word 102
    .word 97
    .word 117
    .word 108
    .word 116
    .word 32
    .word 37
    .word 117
    .word 47
    .word 37
    .word 117
    .word 41
    .word 10
    .word 0
_STR_56:
    .word 91
    .word 71
    .word 85
    .word 73
    .word 95
    .word 71
    .word 85
    .word 65
    .word 82
    .word 68
    .word 93
    .word 32
    .word 71
    .word 85
    .word 73
    .word 32
    .word 107
    .word 97
    .word 114
    .word 97
    .word 110
    .word 116
    .word 105
    .word 110
    .word 97
    .word 121
    .word 97
    .word 32
    .word 97
    .word 108
    .word 105
    .word 110
    .word 100
    .word 105
    .word 59
    .word 32
    .word 107
    .word 101
    .word 114
    .word 110
    .word 101
    .word 108
    .word 32
    .word 99
    .word 97
    .word 108
    .word 105
    .word 115
    .word 109
    .word 97
    .word 121
    .word 97
    .word 32
    .word 100
    .word 101
    .word 118
    .word 97
    .word 109
    .word 32
    .word 101
    .word 100
    .word 105
    .word 121
    .word 111
    .word 114
    .word 10
    .word 0
_STR_57:
    .word 103
    .word 101
    .word 99
    .word 101
    .word 114
    .word 115
    .word 105
    .word 122
    .word 32
    .word 99
    .word 105
    .word 122
    .word 105
    .word 109
    .word 32
    .word 105
    .word 115
    .word 116
    .word 101
    .word 103
    .word 105
    .word 0
_STR_58:
    .word 71
    .word 85
    .word 73
    .word 32
    .word 112
    .word 105
    .word 107
    .word 115
    .word 101
    .word 108
    .word 32
    .word 105
    .word 115
    .word 116
    .word 101
    .word 103
    .word 105
    .word 32
    .word 99
    .word 111
    .word 107
    .word 32
    .word 98
    .word 117
    .word 121
    .word 117
    .word 107
    .word 0
_STR_59:
    .word 71
    .word 85
    .word 73
    .word 32
    .word 99
    .word 105
    .word 122
    .word 105
    .word 109
    .word 32
    .word 107
    .word 111
    .word 116
    .word 97
    .word 115
    .word 105
    .word 32
    .word 97
    .word 115
    .word 105
    .word 108
    .word 100
    .word 105
    .word 0
_STR_60:
    .word 91
    .word 73
    .word 80
    .word 67
    .word 93
    .word 32
    .word 66
    .word 97
    .word 115
    .word 108
    .word 97
    .word 100
    .word 105
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 98
    .word 111
    .word 114
    .word 117
    .word 44
    .word 32
    .word 37
    .word 100
    .word 32
    .word 107
    .word 117
    .word 121
    .word 114
    .word 117
    .word 107
    .word 41
    .word 10
    .word 0
_STR_61:
    .word 80
    .word 97
    .word 122
    .word 0
_STR_62:
    .word 80
    .word 122
    .word 116
    .word 0
_STR_63:
    .word 83
    .word 97
    .word 108
    .word 0
_STR_64:
    .word 67
    .word 97
    .word 114
    .word 0
_STR_65:
    .word 80
    .word 101
    .word 114
    .word 0
_STR_66:
    .word 67
    .word 117
    .word 109
    .word 0
_STR_67:
    .word 67
    .word 109
    .word 116
    .word 0
_STR_68:
    .word 0
_STR_69:
    .word 79
    .word 99
    .word 97
    .word 0
_STR_70:
    .word 83
    .word 117
    .word 98
    .word 0
_STR_71:
    .word 77
    .word 97
    .word 114
    .word 0
_STR_72:
    .word 78
    .word 105
    .word 115
    .word 0
_STR_73:
    .word 77
    .word 97
    .word 121
    .word 0
_STR_74:
    .word 72
    .word 97
    .word 122
    .word 0
_STR_75:
    .word 84
    .word 101
    .word 109
    .word 0
_STR_76:
    .word 65
    .word 103
    .word 117
    .word 0
_STR_77:
    .word 69
    .word 121
    .word 108
    .word 0
_STR_78:
    .word 69
    .word 107
    .word 105
    .word 0
_STR_79:
    .word 75
    .word 97
    .word 115
    .word 0
_STR_80:
    .word 65
    .word 114
    .word 97
    .word 0
_STR_81:
    .word 77
    .word 101
    .word 109
    .word 111
    .word 114
    .word 121
    .word 32
    .word 77
    .word 97
    .word 110
    .word 97
    .word 103
    .word 101
    .word 114
    .word 0
_STR_82:
    .word 83
    .word 99
    .word 104
    .word 101
    .word 100
    .word 117
    .word 108
    .word 101
    .word 114
    .word 0
_STR_83:
    .word 73
    .word 110
    .word 112
    .word 117
    .word 116
    .word 32
    .word 40
    .word 107
    .word 101
    .word 121
    .word 98
    .word 111
    .word 97
    .word 114
    .word 100
    .word 47
    .word 109
    .word 111
    .word 117
    .word 115
    .word 101
    .word 47
    .word 85
    .word 83
    .word 66
    .word 32
    .word 72
    .word 73
    .word 68
    .word 41
    .word 0
_STR_84:
    .word 65
    .word 117
    .word 116
    .word 104
    .word 32
    .word 43
    .word 32
    .word 80
    .word 101
    .word 114
    .word 109
    .word 105
    .word 115
    .word 115
    .word 105
    .word 111
    .word 110
    .word 115
    .word 0
_STR_85:
    .word 70
    .word 105
    .word 108
    .word 101
    .word 115
    .word 121
    .word 115
    .word 116
    .word 101
    .word 109
    .word 32
    .word 40
    .word 82
    .word 65
    .word 77
    .word 41
    .word 0
_STR_86:
    .word 65
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 115
    .word 0
_STR_87:
    .word 87
    .word 105
    .word 110
    .word 100
    .word 111
    .word 119
    .word 32
    .word 77
    .word 97
    .word 110
    .word 97
    .word 103
    .word 101
    .word 114
    .word 32
    .word 43
    .word 32
    .word 78
    .word 101
    .word 116
    .word 119
    .word 111
    .word 114
    .word 107
    .word 32
    .word 43
    .word 32
    .word 87
    .word 105
    .word 70
    .word 105
    .word 0
_STR_88:
    .word 10
    .word 91
    .word 79
    .word 75
    .word 93
    .word 32
    .word 66
    .word 111
    .word 111
    .word 116
    .word 32
    .word 99
    .word 111
    .word 109
    .word 112
    .word 108
    .word 101
    .word 116
    .word 101
    .word 33
    .word 10
    .word 10
    .word 0
_STR_89:
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 32
    .word 118
    .word 49
    .word 46
    .word 48
    .word 32
    .word 45
    .word 32
    .word 79
    .word 120
    .word 97
    .word 108
    .word 121
    .word 110
    .word 45
    .word 54
    .word 52
    .word 32
    .word 79
    .word 83
    .word 10
    .word 0
_STR_90:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 75
    .word 101
    .word 114
    .word 110
    .word 101
    .word 108
    .word 32
    .word 105
    .word 110
    .word 105
    .word 116
    .word 105
    .word 97
    .word 108
    .word 105
    .word 122
    .word 101
    .word 100
    .word 32
    .word 115
    .word 117
    .word 99
    .word 99
    .word 101
    .word 115
    .word 115
    .word 102
    .word 117
    .word 108
    .word 108
    .word 121
    .word 10
    .word 0
_STR_91:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 77
    .word 101
    .word 109
    .word 111
    .word 114
    .word 121
    .word 58
    .word 32
    .word 53
    .word 49
    .word 50
    .word 32
    .word 75
    .word 66
    .word 32
    .word 119
    .word 111
    .word 114
    .word 100
    .word 45
    .word 97
    .word 100
    .word 100
    .word 114
    .word 101
    .word 115
    .word 115
    .word 101
    .word 100
    .word 10
    .word 0
_STR_92:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 80
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 101
    .word 115
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 109
    .word 97
    .word 120
    .word 10
    .word 0
_STR_93:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 71
    .word 80
    .word 85
    .word 58
    .word 32
    .word 37
    .word 100
    .word 120
    .word 37
    .word 100
    .word 32
    .word 102
    .word 114
    .word 97
    .word 109
    .word 101
    .word 98
    .word 117
    .word 102
    .word 102
    .word 101
    .word 114
    .word 32
    .word 114
    .word 101
    .word 97
    .word 100
    .word 121
    .word 10
    .word 0
_STR_94:
    .word 84
    .word 111
    .word 111
    .word 32
    .word 109
    .word 97
    .word 110
    .word 121
    .word 32
    .word 102
    .word 97
    .word 105
    .word 108
    .word 101
    .word 100
    .word 32
    .word 108
    .word 111
    .word 103
    .word 105
    .word 110
    .word 32
    .word 97
    .word 116
    .word 116
    .word 101
    .word 109
    .word 112
    .word 116
    .word 115
    .word 0
_STR_95:
    .word 70
    .word 97
    .word 105
    .word 108
    .word 101
    .word 100
    .word 32
    .word 116
    .word 111
    .word 32
    .word 99
    .word 114
    .word 101
    .word 97
    .word 116
    .word 101
    .word 32
    .word 115
    .word 104
    .word 101
    .word 108
    .word 108
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 0
_STR_96:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 83
    .word 104
    .word 101
    .word 108
    .word 108
    .word 32
    .word 115
    .word 112
    .word 97
    .word 119
    .word 110
    .word 101
    .word 100
    .word 32
    .word 40
    .word 80
    .word 73
    .word 68
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_97:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 83
    .word 116
    .word 97
    .word 114
    .word 116
    .word 105
    .word 110
    .word 103
    .word 32
    .word 115
    .word 99
    .word 104
    .word 101
    .word 100
    .word 117
    .word 108
    .word 101
    .word 114
    .word 46
    .word 46
    .word 46
    .word 10
    .word 10
    .word 0
_STR_98:
    .word 10
    .word 91
    .word 80
    .word 65
    .word 78
    .word 73
    .word 67
    .word 93
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_99:
    .word 91
    .word 80
    .word 65
    .word 78
    .word 73
    .word 67
    .word 93
    .word 32
    .word 83
    .word 121
    .word 115
    .word 116
    .word 101
    .word 109
    .word 32
    .word 104
    .word 97
    .word 108
    .word 116
    .word 101
    .word 100
    .word 46
    .word 10
    .word 0
_STR_100:
    .word 91
    .word 84
    .word 82
    .word 65
    .word 80
    .word 93
    .word 32
    .word 73
    .word 108
    .word 108
    .word 101
    .word 103
    .word 97
    .word 108
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 114
    .word 117
    .word 99
    .word 116
    .word 105
    .word 111
    .word 110
    .word 32
    .word 97
    .word 116
    .word 32
    .word 48
    .word 120
    .word 37
    .word 120
    .word 10
    .word 0
_STR_101:
    .word 91
    .word 84
    .word 82
    .word 65
    .word 80
    .word 93
    .word 32
    .word 85
    .word 110
    .word 107
    .word 110
    .word 111
    .word 119
    .word 110
    .word 32
    .word 116
    .word 114
    .word 97
    .word 112
    .word 32
    .word 37
    .word 117
    .word 32
    .word 40
    .word 116
    .word 118
    .word 97
    .word 108
    .word 61
    .word 48
    .word 120
    .word 37
    .word 108
    .word 108
    .word 120
    .word 41
    .word 10
    .word 0
_STR_102:
    .word 103
    .word 101
    .word 99
    .word 101
    .word 114
    .word 115
    .word 105
    .word 122
    .word 32
    .word 102
    .word 114
    .word 97
    .word 109
    .word 101
    .word 98
    .word 117
    .word 102
    .word 102
    .word 101
    .word 114
    .word 32
    .word 121
    .word 97
    .word 122
    .word 109
    .word 97
    .word 32
    .word 105
    .word 115
    .word 116
    .word 101
    .word 103
    .word 105
    .word 0
_STR_103:
    .word 91
    .word 71
    .word 85
    .word 73
    .word 95
    .word 71
    .word 85
    .word 65
    .word 82
    .word 68
    .word 93
    .word 32
    .word 71
    .word 85
    .word 73
    .word 32
    .word 121
    .word 101
    .word 116
    .word 107
    .word 105
    .word 115
    .word 105
    .word 32
    .word 121
    .word 101
    .word 110
    .word 105
    .word 100
    .word 101
    .word 110
    .word 32
    .word 101
    .word 116
    .word 107
    .word 105
    .word 110
    .word 108
    .word 101
    .word 115
    .word 116
    .word 105
    .word 114
    .word 105
    .word 108
    .word 100
    .word 105
    .word 10
    .word 0
_STR_104:
    .word 103
    .word 101
    .word 99
    .word 101
    .word 114
    .word 115
    .word 105
    .word 122
    .word 32
    .word 71
    .word 85
    .word 73
    .word 32
    .word 107
    .word 111
    .word 109
    .word 117
    .word 116
    .word 32
    .word 97
    .word 100
    .word 114
    .word 101
    .word 115
    .word 105
    .word 0
_STR_105:
    .word 91
    .word 78
    .word 69
    .word 84
    .word 93
    .word 32
    .word 78
    .word 73
    .word 67
    .word 32
    .word 104
    .word 97
    .word 122
    .word 105
    .word 114
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 73
    .word 80
    .word 58
    .word 32
    .word 37
    .word 115
    .word 44
    .word 32
    .word 108
    .word 105
    .word 110
    .word 107
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_106:
    .word 121
    .word 117
    .word 107
    .word 97
    .word 114
    .word 105
    .word 0
_STR_107:
    .word 97
    .word 115
    .word 97
    .word 103
    .word 105
    .word 0
_STR_108:
    .word 78
    .word 73
    .word 67
    .word 32
    .word 68
    .word 117
    .word 114
    .word 117
    .word 109
    .word 117
    .word 58
    .word 10
    .word 0
_STR_109:
    .word 32
    .word 32
    .word 73
    .word 80
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_110:
    .word 32
    .word 32
    .word 71
    .word 97
    .word 116
    .word 101
    .word 119
    .word 97
    .word 121
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_111:
    .word 32
    .word 32
    .word 76
    .word 105
    .word 110
    .word 107
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_112:
    .word 32
    .word 32
    .word 84
    .word 88
    .word 58
    .word 32
    .word 37
    .word 117
    .word 32
    .word 112
    .word 97
    .word 107
    .word 101
    .word 116
    .word 32
    .word 32
    .word 82
    .word 88
    .word 58
    .word 32
    .word 37
    .word 117
    .word 32
    .word 112
    .word 97
    .word 107
    .word 101
    .word 116
    .word 10
    .word 0
_STR_113:
    .word 32
    .word 32
    .word 72
    .word 97
    .word 116
    .word 97
    .word 108
    .word 97
    .word 114
    .word 32
    .word 84
    .word 88
    .word 58
    .word 32
    .word 37
    .word 117
    .word 32
    .word 32
    .word 82
    .word 88
    .word 58
    .word 32
    .word 37
    .word 117
    .word 10
    .word 0
_STR_114:
    .word 112
    .word 105
    .word 110
    .word 103
    .word 58
    .word 32
    .word 108
    .word 105
    .word 110
    .word 107
    .word 32
    .word 97
    .word 115
    .word 97
    .word 103
    .word 105
    .word 10
    .word 0
_STR_115:
    .word 80
    .word 73
    .word 78
    .word 71
    .word 32
    .word 37
    .word 115
    .word 32
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_116:
    .word 89
    .word 97
    .word 110
    .word 105
    .word 116
    .word 32
    .word 97
    .word 108
    .word 105
    .word 110
    .word 100
    .word 105
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_117:
    .word 112
    .word 105
    .word 110
    .word 103
    .word 58
    .word 32
    .word 122
    .word 97
    .word 109
    .word 97
    .word 110
    .word 32
    .word 97
    .word 115
    .word 105
    .word 109
    .word 105
    .word 32
    .word 40
    .word 37
    .word 115
    .word 41
    .word 10
    .word 0
_STR_118:
    .word 91
    .word 68
    .word 78
    .word 83
    .word 93
    .word 32
    .word 65
    .word 103
    .word 32
    .word 98
    .word 97
    .word 103
    .word 108
    .word 105
    .word 32
    .word 100
    .word 101
    .word 103
    .word 105
    .word 108
    .word 10
    .word 0
_STR_119:
    .word 91
    .word 68
    .word 78
    .word 83
    .word 93
    .word 32
    .word 71
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 101
    .word 109
    .word 101
    .word 100
    .word 105
    .word 10
    .word 0
_STR_120:
    .word 91
    .word 68
    .word 78
    .word 83
    .word 93
    .word 32
    .word 75
    .word 97
    .word 121
    .word 105
    .word 116
    .word 32
    .word 121
    .word 111
    .word 107
    .word 10
    .word 0
_STR_121:
    .word 91
    .word 68
    .word 78
    .word 83
    .word 93
    .word 32
    .word 37
    .word 115
    .word 32
    .word 45
    .word 62
    .word 32
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 10
    .word 0
_STR_122:
    .word 91
    .word 68
    .word 78
    .word 83
    .word 93
    .word 32
    .word 90
    .word 97
    .word 109
    .word 97
    .word 110
    .word 32
    .word 97
    .word 115
    .word 105
    .word 109
    .word 105
    .word 10
    .word 0
_STR_123:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 65
    .word 103
    .word 32
    .word 98
    .word 97
    .word 103
    .word 108
    .word 105
    .word 32
    .word 100
    .word 101
    .word 103
    .word 105
    .word 108
    .word 10
    .word 0
_STR_124:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 71
    .word 101
    .word 99
    .word 101
    .word 114
    .word 115
    .word 105
    .word 122
    .word 32
    .word 85
    .word 82
    .word 76
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_125:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 68
    .word 78
    .word 83
    .word 32
    .word 98
    .word 97
    .word 115
    .word 97
    .word 114
    .word 105
    .word 115
    .word 105
    .word 122
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_126:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 84
    .word 67
    .word 80
    .word 32
    .word 98
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 98
    .word 97
    .word 115
    .word 97
    .word 114
    .word 105
    .word 115
    .word 105
    .word 122
    .word 10
    .word 0
_STR_127:
    .word 71
    .word 69
    .word 84
    .word 32
    .word 0
_STR_128:
    .word 32
    .word 72
    .word 84
    .word 84
    .word 80
    .word 47
    .word 49
    .word 46
    .word 48
    .word 13
    .word 10
    .word 72
    .word 111
    .word 115
    .word 116
    .word 58
    .word 32
    .word 0
_STR_129:
    .word 13
    .word 10
    .word 67
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 105
    .word 111
    .word 110
    .word 58
    .word 32
    .word 99
    .word 108
    .word 111
    .word 115
    .word 101
    .word 13
    .word 10
    .word 13
    .word 10
    .word 0
_STR_130:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 73
    .word 115
    .word 116
    .word 101
    .word 107
    .word 32
    .word 103
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 101
    .word 109
    .word 101
    .word 100
    .word 105
    .word 10
    .word 0
_STR_131:
    .word 91
    .word 72
    .word 84
    .word 84
    .word 80
    .word 93
    .word 32
    .word 37
    .word 115
    .word 32
    .word 45
    .word 62
    .word 32
    .word 37
    .word 100
    .word 32
    .word 98
    .word 121
    .word 116
    .word 101
    .word 32
    .word 97
    .word 108
    .word 105
    .word 110
    .word 100
    .word 105
    .word 10
    .word 0
_STR_132:
    .word 37
    .word 115
    .word 10
    .word 0
_STR_133:
    .word 91
    .word 82
    .word 84
    .word 67
    .word 93
    .word 32
    .word 66
    .word 97
    .word 115
    .word 108
    .word 97
    .word 100
    .word 105
    .word 10
    .word 0
_STR_134:
    .word 65
    .word 118
    .word 97
    .word 105
    .word 108
    .word 97
    .word 98
    .word 108
    .word 101
    .word 32
    .word 99
    .word 111
    .word 109
    .word 109
    .word 97
    .word 110
    .word 100
    .word 115
    .word 58
    .word 10
    .word 0
_STR_135:
    .word 32
    .word 32
    .word 104
    .word 101
    .word 108
    .word 112
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 116
    .word 104
    .word 105
    .word 115
    .word 32
    .word 104
    .word 101
    .word 108
    .word 112
    .word 10
    .word 0
_STR_136:
    .word 32
    .word 32
    .word 112
    .word 115
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 76
    .word 105
    .word 115
    .word 116
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 101
    .word 115
    .word 10
    .word 0
_STR_137:
    .word 32
    .word 32
    .word 107
    .word 105
    .word 108
    .word 108
    .word 32
    .word 60
    .word 80
    .word 73
    .word 68
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 75
    .word 105
    .word 108
    .word 108
    .word 32
    .word 97
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 32
    .word 40
    .word 83
    .word 73
    .word 71
    .word 84
    .word 69
    .word 82
    .word 77
    .word 41
    .word 10
    .word 0
_STR_138:
    .word 32
    .word 32
    .word 107
    .word 105
    .word 108
    .word 108
    .word 57
    .word 32
    .word 60
    .word 80
    .word 73
    .word 68
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 70
    .word 111
    .word 114
    .word 99
    .word 101
    .word 45
    .word 107
    .word 105
    .word 108
    .word 108
    .word 32
    .word 40
    .word 83
    .word 73
    .word 71
    .word 75
    .word 73
    .word 76
    .word 76
    .word 41
    .word 10
    .word 0
_STR_139:
    .word 32
    .word 32
    .word 115
    .word 105
    .word 103
    .word 110
    .word 97
    .word 108
    .word 32
    .word 60
    .word 80
    .word 73
    .word 68
    .word 62
    .word 32
    .word 60
    .word 83
    .word 73
    .word 71
    .word 62
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 101
    .word 110
    .word 100
    .word 32
    .word 115
    .word 105
    .word 103
    .word 110
    .word 97
    .word 108
    .word 32
    .word 110
    .word 117
    .word 109
    .word 98
    .word 101
    .word 114
    .word 32
    .word 116
    .word 111
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 10
    .word 0
_STR_140:
    .word 32
    .word 32
    .word 99
    .word 108
    .word 101
    .word 97
    .word 114
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 67
    .word 108
    .word 101
    .word 97
    .word 114
    .word 32
    .word 115
    .word 99
    .word 114
    .word 101
    .word 101
    .word 110
    .word 10
    .word 0
_STR_141:
    .word 32
    .word 32
    .word 112
    .word 101
    .word 114
    .word 102
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 112
    .word 101
    .word 114
    .word 102
    .word 111
    .word 114
    .word 109
    .word 97
    .word 110
    .word 99
    .word 101
    .word 32
    .word 99
    .word 111
    .word 117
    .word 110
    .word 116
    .word 101
    .word 114
    .word 115
    .word 10
    .word 0
_STR_142:
    .word 32
    .word 32
    .word 103
    .word 117
    .word 105
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 71
    .word 85
    .word 73
    .word 32
    .word 103
    .word 117
    .word 97
    .word 114
    .word 100
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 101
    .word 10
    .word 0
_STR_143:
    .word 32
    .word 32
    .word 103
    .word 117
    .word 105
    .word 32
    .word 114
    .word 101
    .word 115
    .word 101
    .word 116
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 82
    .word 101
    .word 45
    .word 101
    .word 110
    .word 97
    .word 98
    .word 108
    .word 101
    .word 32
    .word 116
    .word 104
    .word 105
    .word 115
    .word 32
    .word 112
    .word 114
    .word 111
    .word 99
    .word 101
    .word 115
    .word 115
    .word 32
    .word 71
    .word 85
    .word 73
    .word 10
    .word 0
_STR_144:
    .word 32
    .word 32
    .word 116
    .word 105
    .word 109
    .word 101
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 99
    .word 117
    .word 114
    .word 114
    .word 101
    .word 110
    .word 116
    .word 32
    .word 82
    .word 84
    .word 67
    .word 32
    .word 100
    .word 97
    .word 116
    .word 101
    .word 47
    .word 116
    .word 105
    .word 109
    .word 101
    .word 32
    .word 43
    .word 32
    .word 117
    .word 112
    .word 116
    .word 105
    .word 109
    .word 101
    .word 10
    .word 0
_STR_145:
    .word 32
    .word 32
    .word 97
    .word 108
    .word 97
    .word 114
    .word 109
    .word 32
    .word 60
    .word 109
    .word 115
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 101
    .word 116
    .word 32
    .word 83
    .word 73
    .word 71
    .word 65
    .word 76
    .word 82
    .word 77
    .word 32
    .word 105
    .word 110
    .word 32
    .word 60
    .word 109
    .word 115
    .word 62
    .word 32
    .word 109
    .word 115
    .word 32
    .word 40
    .word 48
    .word 61
    .word 99
    .word 97
    .word 110
    .word 99
    .word 101
    .word 108
    .word 41
    .word 10
    .word 0
_STR_146:
    .word 32
    .word 32
    .word 121
    .word 105
    .word 101
    .word 108
    .word 100
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 86
    .word 111
    .word 108
    .word 117
    .word 110
    .word 116
    .word 97
    .word 114
    .word 105
    .word 108
    .word 121
    .word 32
    .word 121
    .word 105
    .word 101
    .word 108
    .word 100
    .word 32
    .word 67
    .word 80
    .word 85
    .word 32
    .word 115
    .word 108
    .word 105
    .word 99
    .word 101
    .word 10
    .word 0
_STR_147:
    .word 32
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 108
    .word 105
    .word 115
    .word 116
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 76
    .word 105
    .word 115
    .word 116
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 115
    .word 10
    .word 0
_STR_148:
    .word 32
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 114
    .word 117
    .word 110
    .word 32
    .word 60
    .word 110
    .word 97
    .word 109
    .word 101
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 76
    .word 97
    .word 117
    .word 110
    .word 99
    .word 104
    .word 32
    .word 97
    .word 110
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 10
    .word 0
_STR_149:
    .word 32
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 32
    .word 60
    .word 110
    .word 97
    .word 109
    .word 101
    .word 62
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 73
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 32
    .word 97
    .word 110
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 99
    .word 97
    .word 116
    .word 105
    .word 111
    .word 110
    .word 10
    .word 0
_STR_150:
    .word 32
    .word 32
    .word 104
    .word 101
    .word 108
    .word 108
    .word 111
    .word 124
    .word 99
    .word 111
    .word 117
    .word 110
    .word 116
    .word 101
    .word 114
    .word 124
    .word 103
    .word 114
    .word 97
    .word 112
    .word 104
    .word 105
    .word 99
    .word 115
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 114
    .word 116
    .word 99
    .word 117
    .word 116
    .word 115
    .word 32
    .word 102
    .word 111
    .word 114
    .word 32
    .word 39
    .word 97
    .word 112
    .word 112
    .word 32
    .word 114
    .word 117
    .word 110
    .word 32
    .word 60
    .word 110
    .word 97
    .word 109
    .word 101
    .word 62
    .word 39
    .word 10
    .word 0
_STR_151:
    .word 32
    .word 32
    .word 108
    .word 115
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 76
    .word 105
    .word 115
    .word 116
    .word 32
    .word 102
    .word 105
    .word 108
    .word 101
    .word 115
    .word 10
    .word 0
_STR_152:
    .word 32
    .word 32
    .word 99
    .word 97
    .word 116
    .word 32
    .word 60
    .word 102
    .word 105
    .word 108
    .word 101
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 80
    .word 114
    .word 105
    .word 110
    .word 116
    .word 32
    .word 97
    .word 32
    .word 102
    .word 105
    .word 108
    .word 101
    .word 10
    .word 0
_STR_153:
    .word 32
    .word 32
    .word 119
    .word 114
    .word 105
    .word 116
    .word 101
    .word 32
    .word 60
    .word 102
    .word 105
    .word 108
    .word 101
    .word 62
    .word 32
    .word 60
    .word 116
    .word 101
    .word 120
    .word 116
    .word 62
    .word 32
    .word 32
    .word 45
    .word 32
    .word 67
    .word 114
    .word 101
    .word 97
    .word 116
    .word 101
    .word 47
    .word 111
    .word 118
    .word 101
    .word 114
    .word 119
    .word 114
    .word 105
    .word 116
    .word 101
    .word 32
    .word 97
    .word 32
    .word 102
    .word 105
    .word 108
    .word 101
    .word 10
    .word 0
_STR_154:
    .word 32
    .word 32
    .word 114
    .word 109
    .word 32
    .word 60
    .word 102
    .word 105
    .word 108
    .word 101
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 68
    .word 101
    .word 108
    .word 101
    .word 116
    .word 101
    .word 32
    .word 97
    .word 32
    .word 102
    .word 105
    .word 108
    .word 101
    .word 10
    .word 0
_STR_155:
    .word 32
    .word 32
    .word 119
    .word 104
    .word 111
    .word 97
    .word 109
    .word 105
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 99
    .word 117
    .word 114
    .word 114
    .word 101
    .word 110
    .word 116
    .word 32
    .word 117
    .word 115
    .word 101
    .word 114
    .word 10
    .word 0
_STR_156:
    .word 32
    .word 32
    .word 112
    .word 97
    .word 115
    .word 115
    .word 119
    .word 100
    .word 32
    .word 60
    .word 110
    .word 101
    .word 119
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 67
    .word 104
    .word 97
    .word 110
    .word 103
    .word 101
    .word 32
    .word 121
    .word 111
    .word 117
    .word 114
    .word 32
    .word 112
    .word 97
    .word 115
    .word 115
    .word 119
    .word 111
    .word 114
    .word 100
    .word 10
    .word 0
_STR_157:
    .word 32
    .word 32
    .word 108
    .word 111
    .word 103
    .word 111
    .word 117
    .word 116
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 76
    .word 111
    .word 103
    .word 32
    .word 111
    .word 117
    .word 116
    .word 32
    .word 97
    .word 110
    .word 100
    .word 32
    .word 114
    .word 101
    .word 45
    .word 97
    .word 117
    .word 116
    .word 104
    .word 101
    .word 110
    .word 116
    .word 105
    .word 99
    .word 97
    .word 116
    .word 101
    .word 10
    .word 0
_STR_158:
    .word 32
    .word 32
    .word 116
    .word 104
    .word 101
    .word 109
    .word 101
    .word 32
    .word 60
    .word 48
    .word 124
    .word 49
    .word 124
    .word 50
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 103
    .word 114
    .word 101
    .word 101
    .word 110
    .word 32
    .word 124
    .word 32
    .word 98
    .word 108
    .word 117
    .word 101
    .word 32
    .word 124
    .word 32
    .word 100
    .word 97
    .word 114
    .word 107
    .word 10
    .word 0
_STR_159:
    .word 32
    .word 32
    .word 109
    .word 111
    .word 117
    .word 115
    .word 101
    .word 32
    .word 60
    .word 100
    .word 120
    .word 62
    .word 32
    .word 60
    .word 100
    .word 121
    .word 62
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 77
    .word 111
    .word 118
    .word 101
    .word 32
    .word 115
    .word 105
    .word 109
    .word 117
    .word 108
    .word 97
    .word 116
    .word 101
    .word 100
    .word 32
    .word 99
    .word 117
    .word 114
    .word 115
    .word 111
    .word 114
    .word 10
    .word 0
_STR_160:
    .word 32
    .word 32
    .word 99
    .word 108
    .word 105
    .word 99
    .word 107
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 105
    .word 109
    .word 117
    .word 108
    .word 97
    .word 116
    .word 101
    .word 100
    .word 32
    .word 108
    .word 101
    .word 102
    .word 116
    .word 32
    .word 99
    .word 108
    .word 105
    .word 99
    .word 107
    .word 32
    .word 97
    .word 116
    .word 32
    .word 99
    .word 117
    .word 114
    .word 115
    .word 111
    .word 114
    .word 10
    .word 0
_STR_161:
    .word 32
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 115
    .word 99
    .word 97
    .word 110
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 99
    .word 97
    .word 110
    .word 32
    .word 102
    .word 111
    .word 114
    .word 32
    .word 110
    .word 101
    .word 97
    .word 114
    .word 98
    .word 121
    .word 32
    .word 87
    .word 105
    .word 70
    .word 105
    .word 32
    .word 110
    .word 101
    .word 116
    .word 119
    .word 111
    .word 114
    .word 107
    .word 115
    .word 10
    .word 0
_STR_162:
    .word 32
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 60
    .word 115
    .word 115
    .word 105
    .word 100
    .word 62
    .word 32
    .word 91
    .word 112
    .word 115
    .word 107
    .word 93
    .word 32
    .word 45
    .word 32
    .word 67
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 116
    .word 111
    .word 32
    .word 97
    .word 32
    .word 87
    .word 105
    .word 70
    .word 105
    .word 32
    .word 110
    .word 101
    .word 116
    .word 119
    .word 111
    .word 114
    .word 107
    .word 10
    .word 0
_STR_163:
    .word 32
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 100
    .word 105
    .word 115
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 68
    .word 105
    .word 115
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 102
    .word 114
    .word 111
    .word 109
    .word 32
    .word 87
    .word 105
    .word 70
    .word 105
    .word 10
    .word 0
_STR_164:
    .word 32
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 83
    .word 104
    .word 111
    .word 119
    .word 32
    .word 73
    .word 110
    .word 116
    .word 101
    .word 108
    .word 32
    .word 65
    .word 67
    .word 32
    .word 57
    .word 53
    .word 54
    .word 48
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 10
    .word 0
_STR_165:
    .word 32
    .word 32
    .word 105
    .word 112
    .word 99
    .word 32
    .word 112
    .word 105
    .word 112
    .word 101
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 68
    .word 101
    .word 109
    .word 111
    .word 58
    .word 32
    .word 73
    .word 80
    .word 67
    .word 32
    .word 112
    .word 105
    .word 112
    .word 101
    .word 32
    .word 98
    .word 101
    .word 116
    .word 119
    .word 101
    .word 101
    .word 110
    .word 32
    .word 116
    .word 119
    .word 111
    .word 32
    .word 116
    .word 97
    .word 115
    .word 107
    .word 115
    .word 10
    .word 0
_STR_166:
    .word 32
    .word 32
    .word 115
    .word 121
    .word 115
    .word 108
    .word 111
    .word 103
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 68
    .word 117
    .word 109
    .word 112
    .word 32
    .word 107
    .word 101
    .word 114
    .word 110
    .word 101
    .word 108
    .word 32
    .word 115
    .word 121
    .word 115
    .word 108
    .word 111
    .word 103
    .word 32
    .word 114
    .word 105
    .word 110
    .word 103
    .word 32
    .word 98
    .word 117
    .word 102
    .word 102
    .word 101
    .word 114
    .word 10
    .word 0
_STR_167:
    .word 32
    .word 32
    .word 114
    .word 101
    .word 98
    .word 111
    .word 111
    .word 116
    .word 32
    .word 124
    .word 32
    .word 115
    .word 104
    .word 117
    .word 116
    .word 100
    .word 111
    .word 119
    .word 110
    .word 32
    .word 32
    .word 32
    .word 32
    .word 45
    .word 32
    .word 72
    .word 97
    .word 108
    .word 116
    .word 32
    .word 116
    .word 104
    .word 101
    .word 32
    .word 115
    .word 121
    .word 115
    .word 116
    .word 101
    .word 109
    .word 10
    .word 0
_STR_168:
    .word 80
    .word 73
    .word 68
    .word 32
    .word 32
    .word 83
    .word 116
    .word 97
    .word 116
    .word 101
    .word 32
    .word 32
    .word 32
    .word 80
    .word 114
    .word 105
    .word 111
    .word 114
    .word 105
    .word 116
    .word 121
    .word 32
    .word 32
    .word 84
    .word 105
    .word 99
    .word 107
    .word 115
    .word 10
    .word 0
_STR_169:
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 10
    .word 0
_STR_170:
    .word 82
    .word 69
    .word 65
    .word 68
    .word 89
    .word 32
    .word 0
_STR_171:
    .word 82
    .word 85
    .word 78
    .word 32
    .word 32
    .word 32
    .word 0
_STR_172:
    .word 66
    .word 76
    .word 79
    .word 67
    .word 75
    .word 32
    .word 0
_STR_173:
    .word 90
    .word 79
    .word 77
    .word 66
    .word 73
    .word 69
    .word 0
_STR_174:
    .word 63
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 0
_STR_175:
    .word 37
    .word 100
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 115
    .word 32
    .word 32
    .word 37
    .word 100
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_176:
    .word 10
    .word 67
    .word 117
    .word 114
    .word 114
    .word 101
    .word 110
    .word 116
    .word 32
    .word 80
    .word 73
    .word 68
    .word 58
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_177:
    .word 75
    .word 105
    .word 108
    .word 108
    .word 101
    .word 100
    .word 32
    .word 80
    .word 73
    .word 68
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_178:
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 0
_STR_179:
    .word 71
    .word 85
    .word 73
    .word 58
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_180:
    .word 69
    .word 78
    .word 65
    .word 66
    .word 76
    .word 69
    .word 68
    .word 0
_STR_181:
    .word 81
    .word 85
    .word 65
    .word 82
    .word 65
    .word 78
    .word 84
    .word 73
    .word 78
    .word 69
    .word 68
    .word 0
_STR_182:
    .word 70
    .word 97
    .word 117
    .word 108
    .word 116
    .word 115
    .word 58
    .word 32
    .word 32
    .word 37
    .word 117
    .word 47
    .word 37
    .word 117
    .word 10
    .word 0
_STR_183:
    .word 79
    .word 112
    .word 115
    .word 58
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 117
    .word 47
    .word 37
    .word 117
    .word 10
    .word 0
_STR_184:
    .word 80
    .word 105
    .word 120
    .word 101
    .word 108
    .word 115
    .word 58
    .word 32
    .word 32
    .word 37
    .word 108
    .word 108
    .word 117
    .word 47
    .word 37
    .word 108
    .word 108
    .word 117
    .word 10
    .word 0
_STR_185:
    .word 114
    .word 101
    .word 115
    .word 101
    .word 116
    .word 0
_STR_186:
    .word 85
    .word 115
    .word 97
    .word 103
    .word 101
    .word 58
    .word 32
    .word 103
    .word 117
    .word 105
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 32
    .word 124
    .word 32
    .word 103
    .word 117
    .word 105
    .word 32
    .word 114
    .word 101
    .word 115
    .word 101
    .word 116
    .word 10
    .word 0
_STR_187:
    .word 84
    .word 105
    .word 99
    .word 107
    .word 115
    .word 58
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 117
    .word 10
    .word 0
_STR_188:
    .word 67
    .word 111
    .word 110
    .word 116
    .word 101
    .word 120
    .word 116
    .word 32
    .word 115
    .word 119
    .word 105
    .word 116
    .word 99
    .word 104
    .word 101
    .word 115
    .word 58
    .word 32
    .word 37
    .word 117
    .word 10
    .word 0
_STR_189:
    .word 83
    .word 121
    .word 115
    .word 99
    .word 97
    .word 108
    .word 108
    .word 115
    .word 58
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 37
    .word 117
    .word 10
    .word 0
_STR_190:
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 32
    .word 118
    .word 49
    .word 46
    .word 48
    .word 32
    .word 83
    .word 104
    .word 101
    .word 108
    .word 108
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 108
    .word 111
    .word 103
    .word 103
    .word 101
    .word 100
    .word 32
    .word 105
    .word 110
    .word 32
    .word 97
    .word 115
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_191:
    .word 84
    .word 121
    .word 112
    .word 101
    .word 32
    .word 39
    .word 104
    .word 101
    .word 108
    .word 112
    .word 39
    .word 32
    .word 102
    .word 111
    .word 114
    .word 32
    .word 97
    .word 118
    .word 97
    .word 105
    .word 108
    .word 97
    .word 98
    .word 108
    .word 101
    .word 32
    .word 99
    .word 111
    .word 109
    .word 109
    .word 97
    .word 110
    .word 100
    .word 115
    .word 10
    .word 10
    .word 0
_STR_192:
    .word 37
    .word 115
    .word 64
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 62
    .word 32
    .word 0
_STR_193:
    .word 104
    .word 101
    .word 108
    .word 112
    .word 0
_STR_194:
    .word 112
    .word 115
    .word 0
_STR_195:
    .word 99
    .word 108
    .word 101
    .word 97
    .word 114
    .word 0
_STR_196:
    .word 112
    .word 101
    .word 114
    .word 102
    .word 0
_STR_197:
    .word 103
    .word 117
    .word 105
    .word 32
    .word 0
_STR_198:
    .word 107
    .word 105
    .word 108
    .word 108
    .word 32
    .word 0
_STR_199:
    .word 97
    .word 112
    .word 112
    .word 32
    .word 0
_STR_200:
    .word 108
    .word 105
    .word 115
    .word 116
    .word 0
_STR_201:
    .word 114
    .word 117
    .word 110
    .word 0
_STR_202:
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 0
_STR_203:
    .word 85
    .word 115
    .word 97
    .word 103
    .word 101
    .word 58
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 108
    .word 105
    .word 115
    .word 116
    .word 32
    .word 124
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 114
    .word 117
    .word 110
    .word 32
    .word 60
    .word 110
    .word 97
    .word 109
    .word 101
    .word 62
    .word 32
    .word 124
    .word 32
    .word 97
    .word 112
    .word 112
    .word 32
    .word 105
    .word 110
    .word 115
    .word 116
    .word 97
    .word 108
    .word 108
    .word 32
    .word 60
    .word 110
    .word 97
    .word 109
    .word 101
    .word 62
    .word 10
    .word 0
_STR_204:
    .word 108
    .word 115
    .word 0
_STR_205:
    .word 99
    .word 97
    .word 116
    .word 32
    .word 0
_STR_206:
    .word 99
    .word 97
    .word 116
    .word 58
    .word 32
    .word 99
    .word 97
    .word 110
    .word 110
    .word 111
    .word 116
    .word 32
    .word 114
    .word 101
    .word 97
    .word 100
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_207:
    .word 119
    .word 114
    .word 105
    .word 116
    .word 101
    .word 32
    .word 0
_STR_208:
    .word 85
    .word 115
    .word 97
    .word 103
    .word 101
    .word 58
    .word 32
    .word 119
    .word 114
    .word 105
    .word 116
    .word 101
    .word 32
    .word 60
    .word 102
    .word 105
    .word 108
    .word 101
    .word 62
    .word 32
    .word 60
    .word 116
    .word 101
    .word 120
    .word 116
    .word 62
    .word 10
    .word 0
_STR_209:
    .word 114
    .word 109
    .word 32
    .word 0
_STR_210:
    .word 114
    .word 109
    .word 58
    .word 32
    .word 99
    .word 97
    .word 110
    .word 110
    .word 111
    .word 116
    .word 32
    .word 114
    .word 101
    .word 109
    .word 111
    .word 118
    .word 101
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_211:
    .word 82
    .word 101
    .word 109
    .word 111
    .word 118
    .word 101
    .word 100
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_212:
    .word 119
    .word 104
    .word 111
    .word 97
    .word 109
    .word 105
    .word 0
_STR_213:
    .word 37
    .word 115
    .word 32
    .word 40
    .word 117
    .word 105
    .word 100
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_214:
    .word 112
    .word 97
    .word 115
    .word 115
    .word 119
    .word 100
    .word 32
    .word 0
_STR_215:
    .word 91
    .word 79
    .word 75
    .word 93
    .word 32
    .word 80
    .word 97
    .word 115
    .word 115
    .word 119
    .word 111
    .word 114
    .word 100
    .word 32
    .word 117
    .word 112
    .word 100
    .word 97
    .word 116
    .word 101
    .word 100
    .word 10
    .word 0
_STR_216:
    .word 108
    .word 111
    .word 103
    .word 111
    .word 117
    .word 116
    .word 0
_STR_217:
    .word 76
    .word 111
    .word 103
    .word 103
    .word 105
    .word 110
    .word 103
    .word 32
    .word 111
    .word 117
    .word 116
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_218:
    .word 91
    .word 83
    .word 69
    .word 67
    .word 85
    .word 82
    .word 73
    .word 84
    .word 89
    .word 93
    .word 32
    .word 72
    .word 97
    .word 108
    .word 116
    .word 105
    .word 110
    .word 103
    .word 46
    .word 10
    .word 0
_STR_219:
    .word 116
    .word 104
    .word 101
    .word 109
    .word 101
    .word 32
    .word 0
_STR_220:
    .word 109
    .word 111
    .word 117
    .word 115
    .word 101
    .word 32
    .word 0
_STR_221:
    .word 85
    .word 115
    .word 97
    .word 103
    .word 101
    .word 58
    .word 32
    .word 109
    .word 111
    .word 117
    .word 115
    .word 101
    .word 32
    .word 60
    .word 100
    .word 120
    .word 62
    .word 32
    .word 60
    .word 100
    .word 121
    .word 62
    .word 10
    .word 0
_STR_222:
    .word 67
    .word 117
    .word 114
    .word 115
    .word 111
    .word 114
    .word 32
    .word 97
    .word 116
    .word 32
    .word 40
    .word 37
    .word 100
    .word 44
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_223:
    .word 99
    .word 108
    .word 105
    .word 99
    .word 107
    .word 0
_STR_224:
    .word 67
    .word 108
    .word 105
    .word 99
    .word 107
    .word 32
    .word 97
    .word 116
    .word 32
    .word 40
    .word 37
    .word 100
    .word 44
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_225:
    .word 114
    .word 101
    .word 98
    .word 111
    .word 111
    .word 116
    .word 0
_STR_226:
    .word 115
    .word 104
    .word 117
    .word 116
    .word 100
    .word 111
    .word 119
    .word 110
    .word 0
_STR_227:
    .word 83
    .word 121
    .word 115
    .word 116
    .word 101
    .word 109
    .word 32
    .word 104
    .word 97
    .word 108
    .word 116
    .word 101
    .word 100
    .word 46
    .word 32
    .word 40
    .word 78
    .word 111
    .word 32
    .word 114
    .word 101
    .word 97
    .word 108
    .word 32
    .word 112
    .word 111
    .word 119
    .word 101
    .word 114
    .word 47
    .word 114
    .word 101
    .word 115
    .word 101
    .word 116
    .word 32
    .word 108
    .word 105
    .word 110
    .word 101
    .word 32
    .word 111
    .word 110
    .word 32
    .word 79
    .word 120
    .word 97
    .word 108
    .word 121
    .word 110
    .word 45
    .word 54
    .word 52
    .word 32
    .word 121
    .word 101
    .word 116
    .word 46
    .word 41
    .word 10
    .word 0
_STR_228:
    .word 107
    .word 105
    .word 108
    .word 108
    .word 57
    .word 32
    .word 0
_STR_229:
    .word 83
    .word 73
    .word 71
    .word 75
    .word 73
    .word 76
    .word 76
    .word 32
    .word 103
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 45
    .word 62
    .word 32
    .word 80
    .word 73
    .word 68
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_230:
    .word 115
    .word 105
    .word 103
    .word 110
    .word 97
    .word 108
    .word 32
    .word 0
_STR_231:
    .word 75
    .word 117
    .word 108
    .word 108
    .word 97
    .word 110
    .word 105
    .word 109
    .word 58
    .word 32
    .word 115
    .word 105
    .word 103
    .word 110
    .word 97
    .word 108
    .word 32
    .word 60
    .word 80
    .word 73
    .word 68
    .word 62
    .word 32
    .word 60
    .word 83
    .word 73
    .word 71
    .word 78
    .word 79
    .word 62
    .word 10
    .word 0
_STR_232:
    .word 83
    .word 105
    .word 110
    .word 121
    .word 97
    .word 108
    .word 32
    .word 37
    .word 100
    .word 32
    .word 103
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 45
    .word 62
    .word 32
    .word 80
    .word 73
    .word 68
    .word 32
    .word 37
    .word 100
    .word 10
    .word 0
_STR_233:
    .word 116
    .word 105
    .word 109
    .word 101
    .word 0
_STR_234:
    .word 84
    .word 97
    .word 114
    .word 105
    .word 104
    .word 47
    .word 83
    .word 97
    .word 97
    .word 116
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_235:
    .word 67
    .word 97
    .word 108
    .word 105
    .word 115
    .word 109
    .word 97
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 117
    .word 32
    .word 115
    .word 110
    .word 32
    .word 40
    .word 37
    .word 117
    .word 32
    .word 116
    .word 105
    .word 99
    .word 107
    .word 44
    .word 32
    .word 37
    .word 117
    .word 32
    .word 109
    .word 115
    .word 47
    .word 116
    .word 105
    .word 99
    .word 107
    .word 41
    .word 10
    .word 0
_STR_236:
    .word 97
    .word 108
    .word 97
    .word 114
    .word 109
    .word 32
    .word 0
_STR_237:
    .word 91
    .word 65
    .word 76
    .word 65
    .word 82
    .word 77
    .word 93
    .word 32
    .word 65
    .word 108
    .word 97
    .word 114
    .word 109
    .word 32
    .word 105
    .word 112
    .word 116
    .word 97
    .word 108
    .word 32
    .word 101
    .word 100
    .word 105
    .word 108
    .word 100
    .word 105
    .word 10
    .word 0
_STR_238:
    .word 91
    .word 65
    .word 76
    .word 65
    .word 82
    .word 77
    .word 93
    .word 32
    .word 37
    .word 117
    .word 32
    .word 109
    .word 115
    .word 32
    .word 115
    .word 111
    .word 110
    .word 114
    .word 97
    .word 32
    .word 83
    .word 73
    .word 71
    .word 65
    .word 76
    .word 82
    .word 77
    .word 32
    .word 103
    .word 101
    .word 108
    .word 101
    .word 99
    .word 101
    .word 107
    .word 10
    .word 0
_STR_239:
    .word 121
    .word 105
    .word 101
    .word 108
    .word 100
    .word 0
_STR_240:
    .word 91
    .word 89
    .word 73
    .word 69
    .word 76
    .word 68
    .word 93
    .word 32
    .word 67
    .word 80
    .word 85
    .word 32
    .word 100
    .word 105
    .word 108
    .word 105
    .word 109
    .word 108
    .word 101
    .word 114
    .word 105
    .word 32
    .word 103
    .word 101
    .word 114
    .word 105
    .word 32
    .word 118
    .word 101
    .word 114
    .word 105
    .word 108
    .word 105
    .word 121
    .word 111
    .word 114
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_241:
    .word 91
    .word 89
    .word 73
    .word 69
    .word 76
    .word 68
    .word 93
    .word 32
    .word 84
    .word 101
    .word 107
    .word 114
    .word 97
    .word 114
    .word 32
    .word 99
    .word 97
    .word 108
    .word 105
    .word 115
    .word 105
    .word 121
    .word 111
    .word 114
    .word 10
    .word 0
_STR_242:
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 0
_STR_243:
    .word 115
    .word 99
    .word 97
    .word 110
    .word 0
_STR_244:
    .word 100
    .word 105
    .word 115
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 0
_STR_245:
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 0
_STR_246:
    .word 75
    .word 117
    .word 108
    .word 108
    .word 97
    .word 110
    .word 105
    .word 109
    .word 58
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 115
    .word 99
    .word 97
    .word 110
    .word 32
    .word 124
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 60
    .word 115
    .word 115
    .word 105
    .word 100
    .word 62
    .word 32
    .word 91
    .word 112
    .word 115
    .word 107
    .word 93
    .word 32
    .word 124
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 100
    .word 105
    .word 115
    .word 99
    .word 111
    .word 110
    .word 110
    .word 101
    .word 99
    .word 116
    .word 32
    .word 124
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 10
    .word 0
_STR_247:
    .word 105
    .word 112
    .word 99
    .word 32
    .word 0
_STR_248:
    .word 112
    .word 105
    .word 112
    .word 101
    .word 0
_STR_249:
    .word 91
    .word 73
    .word 80
    .word 67
    .word 93
    .word 32
    .word 66
    .word 111
    .word 114
    .word 117
    .word 32
    .word 111
    .word 108
    .word 117
    .word 115
    .word 116
    .word 117
    .word 114
    .word 117
    .word 108
    .word 97
    .word 109
    .word 97
    .word 100
    .word 105
    .word 10
    .word 0
_STR_250:
    .word 77
    .word 101
    .word 114
    .word 104
    .word 97
    .word 98
    .word 97
    .word 32
    .word 73
    .word 80
    .word 67
    .word 32
    .word 98
    .word 111
    .word 114
    .word 117
    .word 115
    .word 117
    .word 33
    .word 0
_STR_251:
    .word 91
    .word 73
    .word 80
    .word 67
    .word 93
    .word 32
    .word 66
    .word 111
    .word 114
    .word 117
    .word 32
    .word 121
    .word 97
    .word 122
    .word 105
    .word 108
    .word 100
    .word 105
    .word 47
    .word 111
    .word 107
    .word 117
    .word 110
    .word 100
    .word 117
    .word 58
    .word 32
    .word 34
    .word 37
    .word 115
    .word 34
    .word 10
    .word 0
_STR_252:
    .word 75
    .word 117
    .word 108
    .word 108
    .word 97
    .word 110
    .word 105
    .word 109
    .word 58
    .word 32
    .word 105
    .word 112
    .word 99
    .word 32
    .word 112
    .word 105
    .word 112
    .word 101
    .word 10
    .word 0
_STR_253:
    .word 115
    .word 121
    .word 115
    .word 108
    .word 111
    .word 103
    .word 0
_STR_254:
    .word 85
    .word 110
    .word 107
    .word 110
    .word 111
    .word 119
    .word 110
    .word 32
    .word 99
    .word 111
    .word 109
    .word 109
    .word 97
    .word 110
    .word 100
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_255:
    .word 91
    .word 83
    .word 78
    .word 68
    .word 93
    .word 32
    .word 66
    .word 97
    .word 115
    .word 108
    .word 97
    .word 100
    .word 105
    .word 10
    .word 0
_STR_256:
    .word 68
    .word 66
    .word 71
    .word 0
_STR_257:
    .word 73
    .word 78
    .word 70
    .word 0
_STR_258:
    .word 87
    .word 82
    .word 78
    .word 0
_STR_259:
    .word 69
    .word 82
    .word 82
    .word 0
_STR_260:
    .word 80
    .word 78
    .word 75
    .word 0
_STR_261:
    .word 40
    .word 110
    .word 117
    .word 108
    .word 108
    .word 41
    .word 0
_STR_262:
    .word 48
    .word 49
    .word 50
    .word 51
    .word 52
    .word 53
    .word 54
    .word 55
    .word 56
    .word 57
    .word 97
    .word 98
    .word 99
    .word 100
    .word 101
    .word 102
    .word 0
_STR_263:
    .word 83
    .word 89
    .word 83
    .word 76
    .word 79
    .word 71
    .word 0
_STR_264:
    .word 83
    .word 121
    .word 115
    .word 108
    .word 111
    .word 103
    .word 32
    .word 116
    .word 97
    .word 109
    .word 112
    .word 111
    .word 110
    .word 32
    .word 104
    .word 97
    .word 122
    .word 105
    .word 114
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 115
    .word 108
    .word 111
    .word 116
    .word 41
    .word 0
_STR_265:
    .word 63
    .word 63
    .word 0
_STR_266:
    .word 91
    .word 37
    .word 115
    .word 93
    .word 91
    .word 37
    .word 115
    .word 93
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_267:
    .word 91
    .word 84
    .word 37
    .word 48
    .word 53
    .word 117
    .word 93
    .word 91
    .word 37
    .word 115
    .word 93
    .word 91
    .word 37
    .word 115
    .word 93
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_268:
    .word 61
    .word 61
    .word 61
    .word 32
    .word 83
    .word 89
    .word 83
    .word 76
    .word 79
    .word 71
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 103
    .word 105
    .word 114
    .word 105
    .word 37
    .word 99
    .word 41
    .word 32
    .word 61
    .word 61
    .word 61
    .word 10
    .word 0
_STR_269:
    .word 61
    .word 61
    .word 61
    .word 32
    .word 83
    .word 89
    .word 83
    .word 76
    .word 79
    .word 71
    .word 32
    .word 83
    .word 79
    .word 78
    .word 85
    .word 32
    .word 61
    .word 61
    .word 61
    .word 10
    .word 0
_STR_270:
    .word 61
    .word 61
    .word 61
    .word 32
    .word 83
    .word 111
    .word 110
    .word 32
    .word 37
    .word 100
    .word 32
    .word 115
    .word 121
    .word 115
    .word 108
    .word 111
    .word 103
    .word 32
    .word 103
    .word 105
    .word 114
    .word 105
    .word 115
    .word 105
    .word 32
    .word 61
    .word 61
    .word 61
    .word 10
    .word 0
_STR_271:
    .word 61
    .word 61
    .word 61
    .word 32
    .word 83
    .word 89
    .word 83
    .word 76
    .word 79
    .word 71
    .word 32
    .word 62
    .word 61
    .word 32
    .word 37
    .word 115
    .word 32
    .word 61
    .word 61
    .word 61
    .word 10
    .word 0
_STR_272:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 66
    .word 97
    .word 115
    .word 108
    .word 97
    .word 116
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 121
    .word 117
    .word 118
    .word 97
    .word 41
    .word 10
    .word 0
_STR_273:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 89
    .word 117
    .word 118
    .word 97
    .word 32
    .word 100
    .word 111
    .word 108
    .word 117
    .word 10
    .word 0
_STR_274:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 83
    .word 89
    .word 78
    .word 32
    .word 103
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 45
    .word 62
    .word 32
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 46
    .word 37
    .word 117
    .word 58
    .word 37
    .word 117
    .word 10
    .word 0
_STR_275:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 68
    .word 105
    .word 110
    .word 108
    .word 101
    .word 110
    .word 105
    .word 121
    .word 111
    .word 114
    .word 58
    .word 32
    .word 112
    .word 111
    .word 114
    .word 116
    .word 32
    .word 37
    .word 117
    .word 10
    .word 0
_STR_276:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 70
    .word 73
    .word 78
    .word 32
    .word 103
    .word 111
    .word 110
    .word 100
    .word 101
    .word 114
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 40
    .word 99
    .word 111
    .word 110
    .word 110
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_277:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 75
    .word 85
    .word 82
    .word 85
    .word 76
    .word 68
    .word 85
    .word 32
    .word 40
    .word 99
    .word 111
    .word 110
    .word 110
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_278:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 75
    .word 65
    .word 66
    .word 85
    .word 76
    .word 32
    .word 69
    .word 68
    .word 73
    .word 76
    .word 68
    .word 73
    .word 32
    .word 40
    .word 99
    .word 111
    .word 110
    .word 110
    .word 32
    .word 37
    .word 100
    .word 44
    .word 32
    .word 112
    .word 111
    .word 114
    .word 116
    .word 32
    .word 37
    .word 117
    .word 41
    .word 10
    .word 0
_STR_279:
    .word 91
    .word 84
    .word 67
    .word 80
    .word 93
    .word 32
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 107
    .word 97
    .word 112
    .word 97
    .word 116
    .word 105
    .word 108
    .word 100
    .word 105
    .word 32
    .word 40
    .word 99
    .word 111
    .word 110
    .word 110
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_280:
    .word 75
    .word 65
    .word 80
    .word 65
    .word 76
    .word 73
    .word 0
_STR_281:
    .word 83
    .word 89
    .word 78
    .word 95
    .word 71
    .word 79
    .word 78
    .word 68
    .word 0
_STR_282:
    .word 83
    .word 89
    .word 78
    .word 95
    .word 65
    .word 76
    .word 73
    .word 78
    .word 68
    .word 0
_STR_283:
    .word 75
    .word 85
    .word 82
    .word 85
    .word 76
    .word 68
    .word 85
    .word 0
_STR_284:
    .word 70
    .word 73
    .word 78
    .word 95
    .word 66
    .word 75
    .word 49
    .word 0
_STR_285:
    .word 70
    .word 73
    .word 78
    .word 95
    .word 66
    .word 75
    .word 50
    .word 0
_STR_286:
    .word 75
    .word 65
    .word 80
    .word 95
    .word 66
    .word 69
    .word 75
    .word 76
    .word 0
_STR_287:
    .word 83
    .word 79
    .word 78
    .word 95
    .word 65
    .word 67
    .word 75
    .word 0
_STR_288:
    .word 90
    .word 77
    .word 78
    .word 95
    .word 66
    .word 75
    .word 76
    .word 0
_STR_289:
    .word 84
    .word 67
    .word 80
    .word 32
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 108
    .word 97
    .word 114
    .word 105
    .word 58
    .word 10
    .word 0
_STR_290:
    .word 32
    .word 32
    .word 91
    .word 37
    .word 100
    .word 93
    .word 32
    .word 112
    .word 111
    .word 114
    .word 116
    .word 61
    .word 37
    .word 117
    .word 45
    .word 62
    .word 37
    .word 117
    .word 32
    .word 32
    .word 100
    .word 117
    .word 114
    .word 117
    .word 109
    .word 61
    .word 37
    .word 115
    .word 32
    .word 32
    .word 114
    .word 120
    .word 61
    .word 37
    .word 100
    .word 32
    .word 32
    .word 116
    .word 120
    .word 95
    .word 110
    .word 120
    .word 116
    .word 61
    .word 37
    .word 117
    .word 10
    .word 0
_STR_291:
    .word 32
    .word 32
    .word 40
    .word 97
    .word 107
    .word 116
    .word 105
    .word 102
    .word 32
    .word 98
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 121
    .word 111
    .word 107
    .word 41
    .word 10
    .word 0
_STR_292:
    .word 124
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 32
    .word 118
    .word 49
    .word 46
    .word 48
    .word 32
    .word 32
    .word 40
    .word 79
    .word 120
    .word 97
    .word 108
    .word 121
    .word 110
    .word 45
    .word 54
    .word 52
    .word 41
    .word 32
    .word 32
    .word 32
    .word 32
    .word 124
    .word 10
    .word 0
_STR_293:
    .word 91
    .word 42
    .word 93
    .word 32
    .word 73
    .word 110
    .word 105
    .word 116
    .word 105
    .word 97
    .word 108
    .word 105
    .word 122
    .word 105
    .word 110
    .word 103
    .word 32
    .word 107
    .word 101
    .word 114
    .word 110
    .word 101
    .word 108
    .word 32
    .word 115
    .word 117
    .word 98
    .word 115
    .word 121
    .word 115
    .word 116
    .word 101
    .word 109
    .word 115
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_294:
    .word 13
    .word 91
    .word 0
_STR_295:
    .word 35
    .word 0
_STR_296:
    .word 46
    .word 0
_STR_297:
    .word 93
    .word 32
    .word 37
    .word 100
    .word 37
    .word 37
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_298:
    .word 91
    .word 85
    .word 83
    .word 66
    .word 32
    .word 72
    .word 73
    .word 68
    .word 93
    .word 32
    .word 85
    .word 121
    .word 97
    .word 114
    .word 196
    .word 177
    .word 58
    .word 32
    .word 67
    .word 111
    .word 110
    .word 116
    .word 114
    .word 111
    .word 108
    .word 108
    .word 101
    .word 114
    .word 32
    .word 104
    .word 101
    .word 110
    .word 195
    .word 188
    .word 122
    .word 32
    .word 104
    .word 97
    .word 122
    .word 196
    .word 177
    .word 114
    .word 32
    .word 100
    .word 101
    .word 196
    .word 159
    .word 105
    .word 108
    .word 32
    .word 40
    .word 115
    .word 116
    .word 97
    .word 116
    .word 117
    .word 115
    .word 61
    .word 48
    .word 120
    .word 37
    .word 120
    .word 41
    .word 10
    .word 0
_STR_299:
    .word 91
    .word 85
    .word 83
    .word 66
    .word 32
    .word 72
    .word 73
    .word 68
    .word 93
    .word 32
    .word 67
    .word 111
    .word 110
    .word 116
    .word 114
    .word 111
    .word 108
    .word 108
    .word 101
    .word 114
    .word 32
    .word 104
    .word 97
    .word 122
    .word 196
    .word 177
    .word 114
    .word 10
    .word 0
_STR_300:
    .word 91
    .word 85
    .word 83
    .word 66
    .word 32
    .word 72
    .word 73
    .word 68
    .word 93
    .word 32
    .word 75
    .word 108
    .word 97
    .word 118
    .word 121
    .word 101
    .word 32
    .word 98
    .word 97
    .word 196
    .word 159
    .word 108
    .word 97
    .word 110
    .word 100
    .word 196
    .word 177
    .word 10
    .word 0
_STR_301:
    .word 91
    .word 85
    .word 83
    .word 66
    .word 32
    .word 72
    .word 73
    .word 68
    .word 93
    .word 32
    .word 77
    .word 111
    .word 117
    .word 115
    .word 101
    .word 32
    .word 98
    .word 97
    .word 196
    .word 159
    .word 108
    .word 97
    .word 110
    .word 100
    .word 196
    .word 177
    .word 10
    .word 0
_STR_302:
    .word 46
    .word 46
    .word 0
_STR_303:
    .word 47
    .word 0
_STR_304:
    .word 47
    .word 98
    .word 105
    .word 110
    .word 0
_STR_305:
    .word 47
    .word 101
    .word 116
    .word 99
    .word 0
_STR_306:
    .word 47
    .word 104
    .word 111
    .word 109
    .word 101
    .word 0
_STR_307:
    .word 47
    .word 104
    .word 111
    .word 109
    .word 101
    .word 47
    .word 114
    .word 111
    .word 111
    .word 116
    .word 0
_STR_308:
    .word 47
    .word 104
    .word 111
    .word 109
    .word 101
    .word 47
    .word 103
    .word 117
    .word 101
    .word 115
    .word 116
    .word 0
_STR_309:
    .word 47
    .word 116
    .word 109
    .word 112
    .word 0
_STR_310:
    .word 47
    .word 100
    .word 101
    .word 118
    .word 0
_STR_311:
    .word 47
    .word 118
    .word 97
    .word 114
    .word 0
_STR_312:
    .word 47
    .word 118
    .word 97
    .word 114
    .word 47
    .word 108
    .word 111
    .word 103
    .word 0
_STR_313:
    .word 91
    .word 86
    .word 70
    .word 83
    .word 93
    .word 32
    .word 68
    .word 105
    .word 122
    .word 105
    .word 110
    .word 32
    .word 97
    .word 103
    .word 97
    .word 99
    .word 105
    .word 32
    .word 104
    .word 97
    .word 122
    .word 105
    .word 114
    .word 10
    .word 0
_STR_314:
    .word 108
    .word 115
    .word 58
    .word 32
    .word 121
    .word 111
    .word 108
    .word 32
    .word 98
    .word 117
    .word 108
    .word 117
    .word 110
    .word 97
    .word 109
    .word 97
    .word 100
    .word 105
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_315:
    .word 37
    .word 115
    .word 58
    .word 10
    .word 0
_STR_316:
    .word 32
    .word 32
    .word 37
    .word 115
    .word 37
    .word 115
    .word 10
    .word 0
_STR_317:
    .word 111
    .word 120
    .word 97
    .word 108
    .word 121
    .word 110
    .word 95
    .word 118
    .word 102
    .word 115
    .word 46
    .word 98
    .word 105
    .word 110
    .word 0
_STR_318:
    .word 91
    .word 80
    .word 69
    .word 82
    .word 83
    .word 73
    .word 83
    .word 84
    .word 93
    .word 32
    .word 75
    .word 97
    .word 121
    .word 105
    .word 116
    .word 32
    .word 100
    .word 101
    .word 115
    .word 116
    .word 101
    .word 107
    .word 108
    .word 101
    .word 110
    .word 109
    .word 105
    .word 121
    .word 111
    .word 114
    .word 32
    .word 40
    .word 100
    .word 111
    .word 110
    .word 97
    .word 110
    .word 105
    .word 109
    .word 32
    .word 109
    .word 111
    .word 100
    .word 117
    .word 41
    .word 10
    .word 0
_STR_319:
    .word 91
    .word 80
    .word 69
    .word 82
    .word 83
    .word 73
    .word 83
    .word 84
    .word 93
    .word 32
    .word 75
    .word 97
    .word 121
    .word 105
    .word 116
    .word 108
    .word 105
    .word 32
    .word 100
    .word 117
    .word 114
    .word 117
    .word 109
    .word 32
    .word 121
    .word 111
    .word 107
    .word 44
    .word 32
    .word 116
    .word 101
    .word 109
    .word 105
    .word 122
    .word 32
    .word 86
    .word 70
    .word 83
    .word 32
    .word 98
    .word 97
    .word 115
    .word 108
    .word 97
    .word 116
    .word 105
    .word 108
    .word 100
    .word 105
    .word 10
    .word 0
_STR_320:
    .word 91
    .word 80
    .word 69
    .word 82
    .word 83
    .word 73
    .word 83
    .word 84
    .word 93
    .word 32
    .word 66
    .word 105
    .word 108
    .word 103
    .word 105
    .word 32
    .word 100
    .word 101
    .word 115
    .word 116
    .word 101
    .word 107
    .word 108
    .word 101
    .word 110
    .word 109
    .word 105
    .word 121
    .word 111
    .word 114
    .word 10
    .word 0
_STR_321:
    .word 119
    .word 105
    .word 102
    .word 105
    .word 0
_STR_322:
    .word 73
    .word 110
    .word 116
    .word 101
    .word 108
    .word 32
    .word 65
    .word 67
    .word 32
    .word 57
    .word 53
    .word 54
    .word 48
    .word 32
    .word 104
    .word 97
    .word 122
    .word 105
    .word 114
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 49
    .word 54
    .word 48
    .word 32
    .word 77
    .word 72
    .word 122
    .word 32
    .word 86
    .word 72
    .word 84
    .word 49
    .word 54
    .word 48
    .word 44
    .word 32
    .word 87
    .word 80
    .word 65
    .word 50
    .word 45
    .word 67
    .word 67
    .word 77
    .word 80
    .word 0
_STR_323:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 73
    .word 110
    .word 116
    .word 101
    .word 108
    .word 32
    .word 87
    .word 105
    .word 114
    .word 101
    .word 108
    .word 101
    .word 115
    .word 115
    .word 45
    .word 65
    .word 67
    .word 32
    .word 57
    .word 53
    .word 54
    .word 48
    .word 32
    .word 121
    .word 117
    .word 107
    .word 108
    .word 101
    .word 110
    .word 100
    .word 105
    .word 10
    .word 0
_STR_324:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 56
    .word 48
    .word 50
    .word 46
    .word 49
    .word 49
    .word 97
    .word 99
    .word 32
    .word 124
    .word 32
    .word 49
    .word 54
    .word 48
    .word 32
    .word 77
    .word 72
    .word 122
    .word 32
    .word 124
    .word 32
    .word 50
    .word 120
    .word 50
    .word 32
    .word 77
    .word 85
    .word 45
    .word 77
    .word 73
    .word 77
    .word 79
    .word 32
    .word 124
    .word 32
    .word 87
    .word 80
    .word 65
    .word 50
    .word 45
    .word 80
    .word 83
    .word 75
    .word 10
    .word 0
_STR_325:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 77
    .word 97
    .word 107
    .word 115
    .word 46
    .word 32
    .word 80
    .word 72
    .word 89
    .word 32
    .word 104
    .word 105
    .word 122
    .word 105
    .word 58
    .word 32
    .word 49
    .word 55
    .word 51
    .word 51
    .word 32
    .word 77
    .word 98
    .word 112
    .word 115
    .word 32
    .word 40
    .word 53
    .word 32
    .word 71
    .word 72
    .word 122
    .word 32
    .word 86
    .word 72
    .word 84
    .word 49
    .word 54
    .word 48
    .word 41
    .word 10
    .word 0
_STR_326:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 72
    .word 97
    .word 116
    .word 97
    .word 58
    .word 32
    .word 111
    .word 110
    .word 99
    .word 101
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 95
    .word 105
    .word 110
    .word 105
    .word 116
    .word 40
    .word 41
    .word 32
    .word 99
    .word 97
    .word 103
    .word 105
    .word 114
    .word 10
    .word 0
_STR_327:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 53
    .word 32
    .word 71
    .word 72
    .word 122
    .word 32
    .word 98
    .word 97
    .word 110
    .word 116
    .word 32
    .word 116
    .word 97
    .word 114
    .word 97
    .word 110
    .word 196
    .word 177
    .word 121
    .word 111
    .word 114
    .word 32
    .word 40
    .word 107
    .word 97
    .word 110
    .word 97
    .word 108
    .word 32
    .word 51
    .word 54
    .word 45
    .word 49
    .word 55
    .word 55
    .word 44
    .word 32
    .word 49
    .word 54
    .word 48
    .word 32
    .word 77
    .word 72
    .word 122
    .word 41
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_328:
    .word 84
    .word 97
    .word 114
    .word 97
    .word 109
    .word 97
    .word 32
    .word 116
    .word 97
    .word 109
    .word 97
    .word 109
    .word 108
    .word 97
    .word 110
    .word 100
    .word 105
    .word 0
_STR_329:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 84
    .word 97
    .word 114
    .word 97
    .word 109
    .word 97
    .word 32
    .word 116
    .word 97
    .word 109
    .word 97
    .word 109
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 37
    .word 100
    .word 32
    .word 97
    .word 103
    .word 108
    .word 97
    .word 114
    .word 32
    .word 98
    .word 117
    .word 108
    .word 117
    .word 110
    .word 100
    .word 117
    .word 10
    .word 0
_STR_330:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 76
    .word 105
    .word 115
    .word 116
    .word 101
    .word 32
    .word 98
    .word 111
    .word 115
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 111
    .word 110
    .word 99
    .word 101
    .word 32
    .word 39
    .word 119
    .word 105
    .word 102
    .word 105
    .word 32
    .word 115
    .word 99
    .word 97
    .word 110
    .word 39
    .word 32
    .word 99
    .word 97
    .word 108
    .word 105
    .word 115
    .word 116
    .word 105
    .word 114
    .word 10
    .word 0
_STR_331:
    .word 10
    .word 37
    .word 45
    .word 52
    .word 115
    .word 32
    .word 37
    .word 45
    .word 51
    .word 51
    .word 115
    .word 32
    .word 37
    .word 45
    .word 56
    .word 115
    .word 32
    .word 37
    .word 45
    .word 54
    .word 115
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_332:
    .word 78
    .word 111
    .word 0
_STR_333:
    .word 83
    .word 83
    .word 73
    .word 68
    .word 0
_STR_334:
    .word 75
    .word 97
    .word 110
    .word 97
    .word 108
    .word 0
_STR_335:
    .word 82
    .word 83
    .word 83
    .word 73
    .word 0
_STR_336:
    .word 71
    .word 117
    .word 118
    .word 101
    .word 110
    .word 108
    .word 105
    .word 107
    .word 0
_STR_337:
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 32
    .word 32
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 45
    .word 10
    .word 0
_STR_338:
    .word 91
    .word 37
    .word 50
    .word 100
    .word 93
    .word 32
    .word 37
    .word 45
    .word 51
    .word 51
    .word 115
    .word 32
    .word 32
    .word 67
    .word 72
    .word 37
    .word 45
    .word 53
    .word 100
    .word 32
    .word 32
    .word 37
    .word 52
    .word 100
    .word 32
    .word 100
    .word 66
    .word 109
    .word 32
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_339:
    .word 87
    .word 80
    .word 65
    .word 50
    .word 0
_STR_340:
    .word 65
    .word 67
    .word 73
    .word 75
    .word 0
_STR_341:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 72
    .word 97
    .word 116
    .word 97
    .word 58
    .word 32
    .word 111
    .word 110
    .word 99
    .word 101
    .word 32
    .word 119
    .word 105
    .word 102
    .word 105
    .word 95
    .word 105
    .word 110
    .word 105
    .word 116
    .word 40
    .word 41
    .word 10
    .word 0
_STR_342:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 196
    .word 177
    .word 121
    .word 111
    .word 114
    .word 58
    .word 32
    .word 34
    .word 37
    .word 115
    .word 34
    .word 37
    .word 115
    .word 46
    .word 46
    .word 46
    .word 10
    .word 0
_STR_343:
    .word 32
    .word 40
    .word 87
    .word 80
    .word 65
    .word 50
    .word 45
    .word 80
    .word 83
    .word 75
    .word 41
    .word 0
_STR_344:
    .word 32
    .word 40
    .word 97
    .word 99
    .word 105
    .word 107
    .word 32
    .word 97
    .word 103
    .word 41
    .word 0
_STR_345:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 72
    .word 65
    .word 84
    .word 65
    .word 58
    .word 32
    .word 75
    .word 105
    .word 109
    .word 108
    .word 105
    .word 107
    .word 32
    .word 100
    .word 111
    .word 103
    .word 114
    .word 117
    .word 108
    .word 97
    .word 109
    .word 97
    .word 32
    .word 98
    .word 97
    .word 115
    .word 97
    .word 114
    .word 105
    .word 115
    .word 105
    .word 122
    .word 33
    .word 10
    .word 0
_STR_346:
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 98
    .word 97
    .word 115
    .word 97
    .word 114
    .word 105
    .word 115
    .word 105
    .word 122
    .word 0
_STR_347:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 100
    .word 196
    .word 177
    .word 33
    .word 32
    .word 83
    .word 83
    .word 73
    .word 68
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_348:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 75
    .word 97
    .word 110
    .word 97
    .word 108
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 77
    .word 72
    .word 122
    .word 41
    .word 10
    .word 0
_STR_349:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 82
    .word 83
    .word 83
    .word 73
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 100
    .word 66
    .word 109
    .word 10
    .word 0
_STR_350:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 73
    .word 80
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_351:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 71
    .word 97
    .word 116
    .word 101
    .word 119
    .word 97
    .word 121
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_352:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 71
    .word 117
    .word 118
    .word 101
    .word 110
    .word 108
    .word 105
    .word 107
    .word 58
    .word 32
    .word 87
    .word 80
    .word 65
    .word 50
    .word 45
    .word 67
    .word 67
    .word 77
    .word 80
    .word 32
    .word 40
    .word 65
    .word 69
    .word 83
    .word 45
    .word 49
    .word 50
    .word 56
    .word 41
    .word 10
    .word 0
_STR_353:
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 100
    .word 196
    .word 177
    .word 0
_STR_354:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 90
    .word 97
    .word 109
    .word 97
    .word 110
    .word 32
    .word 97
    .word 115
    .word 105
    .word 109
    .word 105
    .word 32
    .word 226
    .word 128
    .word 148
    .word 32
    .word 121
    .word 97
    .word 110
    .word 105
    .word 116
    .word 32
    .word 121
    .word 111
    .word 107
    .word 10
    .word 0
_STR_355:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 90
    .word 97
    .word 116
    .word 101
    .word 110
    .word 32
    .word 98
    .word 97
    .word 103
    .word 108
    .word 196
    .word 177
    .word 32
    .word 100
    .word 101
    .word 103
    .word 105
    .word 108
    .word 10
    .word 0
_STR_356:
    .word 91
    .word 87
    .word 73
    .word 70
    .word 73
    .word 93
    .word 32
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 107
    .word 101
    .word 115
    .word 105
    .word 108
    .word 100
    .word 105
    .word 10
    .word 0
_STR_357:
    .word 66
    .word 97
    .word 103
    .word 108
    .word 97
    .word 110
    .word 116
    .word 105
    .word 32
    .word 107
    .word 101
    .word 115
    .word 105
    .word 108
    .word 100
    .word 105
    .word 0
_STR_358:
    .word 10
    .word 61
    .word 61
    .word 61
    .word 32
    .word 73
    .word 110
    .word 116
    .word 101
    .word 108
    .word 32
    .word 65
    .word 67
    .word 32
    .word 57
    .word 53
    .word 54
    .word 48
    .word 32
    .word 68
    .word 117
    .word 114
    .word 117
    .word 109
    .word 32
    .word 82
    .word 97
    .word 112
    .word 111
    .word 114
    .word 117
    .word 32
    .word 61
    .word 61
    .word 61
    .word 10
    .word 0
_STR_359:
    .word 83
    .word 117
    .word 114
    .word 117
    .word 99
    .word 117
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_360:
    .word 121
    .word 117
    .word 107
    .word 108
    .word 101
    .word 110
    .word 100
    .word 105
    .word 0
_STR_361:
    .word 89
    .word 85
    .word 75
    .word 76
    .word 69
    .word 78
    .word 77
    .word 69
    .word 68
    .word 73
    .word 0
_STR_362:
    .word 68
    .word 117
    .word 114
    .word 117
    .word 109
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_363:
    .word 66
    .word 65
    .word 196
    .word 158
    .word 76
    .word 73
    .word 0
_STR_364:
    .word 98
    .word 97
    .word 103
    .word 108
    .word 105
    .word 32
    .word 100
    .word 101
    .word 103
    .word 105
    .word 108
    .word 0
_STR_365:
    .word 83
    .word 83
    .word 73
    .word 68
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_366:
    .word 75
    .word 97
    .word 110
    .word 97
    .word 108
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 77
    .word 72
    .word 122
    .word 32
    .word 86
    .word 72
    .word 84
    .word 41
    .word 10
    .word 0
_STR_367:
    .word 82
    .word 83
    .word 83
    .word 73
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 100
    .word 66
    .word 109
    .word 10
    .word 0
_STR_368:
    .word 84
    .word 88
    .word 32
    .word 71
    .word 117
    .word 99
    .word 32
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 100
    .word 66
    .word 109
    .word 10
    .word 0
_STR_369:
    .word 73
    .word 80
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_370:
    .word 71
    .word 87
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 58
    .word 32
    .word 37
    .word 115
    .word 10
    .word 0
_STR_371:
    .word 71
    .word 117
    .word 118
    .word 101
    .word 110
    .word 108
    .word 105
    .word 107
    .word 58
    .word 32
    .word 87
    .word 80
    .word 65
    .word 50
    .word 45
    .word 67
    .word 67
    .word 77
    .word 80
    .word 47
    .word 65
    .word 69
    .word 83
    .word 10
    .word 0
_STR_372:
    .word 65
    .word 80
    .word 32
    .word 108
    .word 105
    .word 115
    .word 116
    .word 101
    .word 115
    .word 105
    .word 58
    .word 32
    .word 37
    .word 100
    .word 32
    .word 97
    .word 103
    .word 32
    .word 40
    .word 115
    .word 111
    .word 110
    .word 32
    .word 116
    .word 97
    .word 114
    .word 97
    .word 109
    .word 97
    .word 41
    .word 10
    .word 0
_STR_373:
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 61
    .word 10
    .word 10
    .word 0
_STR_374:
    .word 91
    .word 87
    .word 77
    .word 93
    .word 32
    .word 87
    .word 105
    .word 110
    .word 100
    .word 111
    .word 119
    .word 32
    .word 109
    .word 97
    .word 110
    .word 97
    .word 103
    .word 101
    .word 114
    .word 32
    .word 114
    .word 101
    .word 97
    .word 100
    .word 121
    .word 32
    .word 40
    .word 37
    .word 100
    .word 32
    .word 115
    .word 108
    .word 111
    .word 116
    .word 115
    .word 41
    .word 10
    .word 0
_STR_375:
    .word 124
    .word 32
    .word 32
    .word 32
    .word 32
    .word 32
    .word 72
    .word 73
    .word 76
    .word 65
    .word 76
    .word 95
    .word 66
    .word 73
    .word 83
    .word 32
    .word 109
    .word 97
    .word 115
    .word 97
    .word 117
    .word 115
    .word 116
    .word 117
    .word 110
    .word 101
    .word 32
    .word 104
    .word 111
    .word 115
    .word 103
    .word 101
    .word 108
    .word 100
    .word 105
    .word 110
    .word 105
    .word 122
    .word 32
    .word 32
    .word 32
    .word 124
    .word 10
    .word 0
_STR_376:
    .word 69
    .word 114
    .word 114
    .word 111
    .word 114
    .word 58
    .word 32
    .word 110
    .word 111
    .word 32
    .word 102
    .word 114
    .word 101
    .word 101
    .word 32
    .word 119
    .word 105
    .word 110
    .word 100
    .word 111
    .word 119
    .word 32
    .word 115
    .word 108
    .word 111
    .word 116
    .word 115
    .word 32
    .word 40
    .word 109
    .word 97
    .word 120
    .word 32
    .word 37
    .word 100
    .word 41
    .word 10
    .word 0
_STR_377:
    .word 69
    .word 114
    .word 114
    .word 111
    .word 114
    .word 58
    .word 32
    .word 116
    .word 104
    .word 101
    .word 109
    .word 101
    .word 32
    .word 109
    .word 117
    .word 115
    .word 116
    .word 32
    .word 98
    .word 101
    .word 32
    .word 48
    .word 32
    .word 40
    .word 103
    .word 114
    .word 101
    .word 101
    .word 110
    .word 41
    .word 44
    .word 32
    .word 49
    .word 32
    .word 40
    .word 98
    .word 108
    .word 117
    .word 101
    .word 41
    .word 32
    .word 111
    .word 114
    .word 32
    .word 50
    .word 32
    .word 40
    .word 100
    .word 97
    .word 114
    .word 107
    .word 41
    .word 10
    .word 0
_STR_378:
    .word 91
    .word 79
    .word 75
    .word 93
    .word 32
    .word 84
    .word 104
    .word 101
    .word 109
    .word 101
    .word 32
    .word 97
    .word 112
    .word 112
    .word 108
    .word 105
    .word 101
    .word 100
    .word 10
    .word 0
