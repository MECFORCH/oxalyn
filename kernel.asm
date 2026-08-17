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
    ADD  R7, R6, R0
    JMP  _L10
_L10:
    LOAD R31, R29, 0
    LOAD R29, R29, 1
    LI   R28, 35
    JALR R0, R31, 0
mmio_write:
    LI   R28, -36
    STORE R2, R29, 3
    LI   R28, 3
    ADD  R7, R29, R28
    LOAD R8, R7, 0
    STORE R8, R5, 0
_L11:
    LI   R28, 36
prog_hello:
    LI   R28, -34
    LI   R5, _STR_0
    ADD  R1, R5, R0
    LI   R28, printf
    JALR R31, R28, 0
    ADD  R5, R7, R0  ; sonuç = R7
    LI   R5, 0
    LI   R28, sys_exit
_L120:
    LI   R28, 34
prog_counter:
    LI   R7, 0
    STORE R7, R5, 0
_L122:
    LI   R6, 10
    CMPLT  R5, R5, R6
    JZ   R5, _L125
    JMP  _L123
_L124:
    LI   R7, 1
    ADD  R8, R6, R7
    JMP  _L122
_L123:
    LI   R5, _STR_1
    ADD  R6, R29, R28
    LOAD R7, R6, 0
    ADD  R2, R7, R0
    LI   R5, 500
    LI   R28, sys_sleep
    JMP  _L124
_L125:
_L121:
prog_graphics:
    LI   R5, _STR_2
    LI   R5, 4278196787
    LI   R28, gpu_clear
    LI   R5, 100
    LI   R6, 100
    LI   R7, 200
    LI   R8, 150
    LI   R9, 4294901760
    ADD  R2, R6, R0
    ADD  R3, R7, R0
    ADD  R4, R8, R0
    LI   R28, gpu_draw_rect
    LI   R5, 400
    LI   R6, 300
    LI   R7, 50
    LI   R8, 4278255360
    LI   R28, gpu_draw_circle
    LI   R5, 10
    LI   R7, 790
    LI   R8, 590
    LI   R9, 4278190335
    LI   R28, gpu_draw_line
    LI   R5, _STR_3
_L126:
prog_calc:
    LI   R5, 5
    STORE R5, R29, 2
    LI   R5, 3
    STORE R5, R29, 3
    LI   R5, _STR_4
    ADD  R8, R29, R28
    LOAD R9, R8, 0
    ADD  R10, R29, R28
    LOAD R11, R10, 0
    ADD  R10, R11, R0
    ADD  R11, R29, R28
    LOAD R12, R11, 0
    ADD  R10, R10, R12
    ADD  R3, R9, R0
    ADD  R4, R10, R0
    LI   R5, _STR_5
    MUL  R10, R10, R12
_L127:
prog_paint:
    LI   R5, _STR_6
    LI   R5, 4294967295
    LI   R5, mouse
    ADD  R5, R5, R28
    LI   R6, 1
    AND  R5, R5, R6
    JZ   R5, _L129
    LI   R28, 0
    LI   R7, mouse
    LI   R28, 1
    ADD  R7, R7, R28
    LI   R9, 4278190080
    ADD  R1, R6, R0
    ADD  R2, R8, R0
    LI   R28, gpu_put_pixel
    JMP  _L130
_L129:
_L130:
    LI   R28, draw_cursor
_L128:
prog_music:
    LI   R5, 262
    LI   R5, 200
    LI   R5, 294
    STORE R5, R29, 4
    STORE R5, R29, 5
    LI   R5, 330
    STORE R5, R29, 6
    STORE R5, R29, 7
    LI   R5, 349
    STORE R5, R29, 8
    STORE R5, R29, 9
    LI   R5, 392
    STORE R5, R29, 10
    STORE R5, R29, 11
    LI   R5, 440
    STORE R5, R29, 12
    STORE R5, R29, 13
    LI   R5, 494
    STORE R5, R29, 14
    STORE R5, R29, 15
    LI   R5, 523
    STORE R5, R29, 16
    STORE R5, R29, 17
    LI   R5, 1
    STORE R5, R29, 18
    LI   R5, 150
    STORE R5, R29, 19
    STORE R5, R29, 20
    LI   R5, 120
    STORE R5, R29, 21
    STORE R5, R29, 22
    STORE R5, R29, 23
    STORE R5, R29, 24
    STORE R5, R29, 25
    STORE R5, R29, 26
    LI   R5, 240
    STORE R5, R29, 27
    STORE R5, R29, 28
    LI   R5, 480
    STORE R5, R29, 29
    STORE R5, R29, 30
    STORE R5, R29, 31
    LI   R5, _STR_7
    LI   R5, 220
    LI   R28, sound_set_volume
    LI   R28, sound_sfx
    LI   R28, sound_play_melody
_L131:
apps_init:
    LI   R5, app_count
    LI   R5, apps
    LI   R6, app_count
    LI   R8, 1
    ADD  R9, R7, R8
    STORE R9, R6, 0
    LI   R28, 4
    MUL  R7, R7, R28
    ADD  R5, R5, R7
    LI   R28, -4
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
    STORE R7, R7, 3
    LI   R8, _STR_10
    LI   R7, _STR_11
    LI   R7, prog_counter
    LI   R8, _STR_12
    LI   R7, _STR_13
    LI   R7, prog_graphics
    LI   R8, _STR_14
    LI   R7, _STR_15
    LI   R7, prog_calc
    LI   R8, _STR_16
    LI   R7, _STR_17
    LI   R7, prog_paint
    LI   R8, _STR_18
    LI   R7, _STR_19
    LI   R7, prog_music
_L132:
app_list:
    LI   R5, _STR_20
    LI   R5, _STR_21
_L134:
    CMPLT  R5, R5, R7
    JZ   R5, _L137
    JMP  _L135
_L136:
    JMP  _L134
_L135:
    LI   R5, _STR_22
    LI   R6, apps
    MUL  R8, R8, R28
    ADD  R6, R6, R8
    ADD  R6, R6, R28
    LOAD R8, R6, 0
    JZ   R8, _L138
    LI   R9, _STR_23
    ADD  R8, R9, R0
    JMP  _L139
_L138:
    LI   R9, _STR_24
_L139:
    LI   R9, apps
    MUL  R11, R11, R28
    ADD  R9, R9, R11
    ADD  R9, R9, R28
    LOAD R11, R9, 0
    LI   R12, apps
    ADD  R13, R29, R28
    LOAD R14, R13, 0
    MUL  R14, R14, R28
    ADD  R12, R12, R14
    ADD  R12, R12, R28
    LOAD R14, R12, 0
    ADD  R3, R11, R0
    ADD  R4, R14, R0
    JMP  _L136
_L137:
_L133:
app_launch:
_L141:
    JZ   R5, _L144
    JMP  _L142
_L143:
    JMP  _L141
_L142:
    LOAD R7, R5, 0
    ADD  R1, R7, R0
    ADD  R2, R9, R0
    LI   R28, kstrcmp
    LI   R6, 0
    CMPEQ  R5, R5, R6
    JZ   R5, _L145
    ADD  R5, R7, R0
    CMPEQ R5, R5, R0
    JZ   R5, _L147
    LI   R5, _STR_25
    SUB  R5, R0, R5
    ADD  R7, R5, R0
    JMP  _L140
    JMP  _L148
_L147:
_L148:
    LI   R7, apps
    MUL  R9, R9, R28
    ADD  R7, R7, R9
    LOAD R9, R7, 0
    LI   R10, 5
    ADD  R1, R9, R0
    ADD  R2, R10, R0
    LI   R28, -2
    STORE R5, R30, 0
    STORE R6, R30, 1
    LI   R28, process_create
    LOAD R5, R30, 0
    LOAD R6, R30, 1
    ADD  R7, R7, R0  ; sonuç = R7
    JZ   R5, _L149
    LI   R5, _STR_26
    JMP  _L150
_L149:
_L150:
    LI   R5, _STR_27
    JMP  _L146
_L145:
_L146:
    JMP  _L143
_L144:
    LI   R5, _STR_28
_L140:
app_install:
_L152:
    JZ   R5, _L155
    JMP  _L153
_L154:
    JMP  _L152
_L153:
    JZ   R5, _L156
    LI   R5, _STR_29
    JMP  _L151
    JMP  _L157
_L156:
_L157:
    JMP  _L154
_L155:
_L151:
auth_init:
_L164:
    LI   R6, 4
    JZ   R5, _L167
    JMP  _L165
_L166:
    JMP  _L164
_L165:
    LI   R5, users
    LI   R28, 20
    LI   R28, 19
    LI   R8, 0
    JMP  _L166
_L167:
    MUL  R6, R6, R28
    ADD  R5, R5, R6
    LI   R7, _STR_30
    LI   R8, 16
    LI   R9, 1
    SUB  R8, R8, R9
    ADD  R3, R8, R0
    LI   R28, kstrncpy
    LI   R28, 16
    LI   R28, simple_hash
    LI   R28, 17
    LI   R28, 18
    LI   R7, _STR_31
_L163:
simple_hash:
    LI   R5, 2166136261
_L169:
    LI   R6, 16
    CMPNE R5, R5, R0
    CMPNE R9, R9, R0
    AND   R5, R5, R9
    JZ   R5, _L172
    JMP  _L170
_L171:
    JMP  _L169
_L170:
    ADD  R9, R29, R28
    LOAD R10, R9, 0
    ADD  R8, R8, R10
    LOAD R10, R8, 0
    XOR  R11, R6, R10
    STORE R11, R5, 0
    LI   R7, 16777619
    MUL  R8, R6, R7
    JMP  _L171
_L172:
    JMP  _L168
_L168:
read_line:
    LI   R28, -37
    STORE R3, R29, 4
_L174:
    LI   R28, 5
    ADD  R6, R7, R0
    SUB  R6, R6, R7
    JZ   R5, _L175
    LI   R28, 6
    LI   R28, KGETCHAR
    JZ   R5, _L176
    JMP  _L175
    JMP  _L177
_L176:
_L177:
    LI   R7, 13
    CMPEQ  R6, R6, R7
    OR   R5, R5, R6
    JZ   R5, _L178
    LI   R5, _STR_32
    JMP  _L179
_L178:
_L179:
    LI   R6, 8
    CMPLT  R6, R7, R6
    CMPNE R6, R6, R0
    AND   R5, R5, R6
    JZ   R5, _L180
    LI   R5, _STR_33
    SUB  R8, R6, R7
    JMP  _L174
    JMP  _L181
_L180:
_L181:
    LI   R6, 32
    CMPLE  R5, R6, R5
    LI   R7, 127
    CMPLT  R6, R6, R7
    JZ   R5, _L182
    JZ   R6, _L184
    LI   R7, 42
    JMP  _L185
_L184:
    ADD  R6, R8, R0
_L185:
    LI   R28, KPUTCHAR
    ADD  R10, R8, R9
    STORE R10, R7, 0
    STORE R10, R6, 0
    JMP  _L183
_L182:
_L183:
_L175:
_L186:
    CMPLT  R5, R6, R5
    ADD  R7, R7, R8
    ADD  R7, R8, R0
    LI   R8, 32
    CMPEQ  R7, R7, R8
    LI   R11, 1
    SUB  R10, R10, R11
    ADD  R9, R9, R10
    ADD  R9, R10, R0
    LI   R10, 13
    CMPEQ  R9, R9, R10
    OR   R7, R7, R9
    CMPNE R7, R7, R0
    AND   R5, R5, R7
    JZ   R5, _L187
    SUB  R8, R8, R28
    LI   R9, 0
    JMP  _L186
_L187:
_L173:
    LI   R28, 37
login_prompt:
    STORE R5, R29, 34
_L189:
    LI   R6, 3
    JZ   R5, _L190
    LI   R5, _STR_34
    LI   R5, _STR_35
    LI   R5, _STR_36
    LI   R5, _STR_37
    LI   R28, read_line
    LI   R5, _STR_38
_L191:
    JZ   R5, _L194
    JMP  _L192
_L193:
    JMP  _L191
_L192:
    JZ   R5, _L195
    JMP  _L193
    JMP  _L196
_L195:
_L196:
    LI   R6, users
    ADD  R1, R8, R0
    LI   R28, -3
    STORE R7, R30, 2
    LOAD R7, R30, 2
    ADD  R8, R7, R0  ; sonuç = R7
    CMPEQ  R6, R6, R8
    JZ   R5, _L197
    LI   R5, current_uid
    LI   R7, users
    STORE R9, R5, 0
    LI   R5, _STR_39
    JMP  _L188
    JMP  _L198
_L197:
_L198:
_L194:
    LI   R5, _STR_40
    JMP  _L189
_L190:
    LI   R5, _STR_41
_L188:
auth_username:
_L200:
    JZ   R5, _L203
    JMP  _L201
_L202:
    JMP  _L200
_L201:
    ADD  R7, R9, R0
    CMPEQ  R7, R7, R10
    JZ   R5, _L204
    ADD  R7, R7, R0
    JMP  _L199
    JMP  _L205
_L204:
_L205:
    JMP  _L202
_L203:
    LI   R5, _STR_42
_L199:
auth_set_password:
_L207:
    JZ   R5, _L210
    JMP  _L208
_L209:
    JMP  _L207
_L208:
    JZ   R5, _L211
    JMP  _L206
    JMP  _L212
_L211:
_L212:
    JMP  _L209
_L210:
_L206:
fs_init:
_L225:
    JZ   R5, _L228
    JMP  _L226
_L227:
    JMP  _L225
_L226:
    LI   R5, files
    LI   R28, 4131
    LI   R28, 4130
    JMP  _L227
_L228:
    LI   R5, file_count
_L224:
find_file:
_L230:
    JZ   R5, _L233
    JMP  _L231
_L232:
    JMP  _L230
_L231:
    LI   R7, files
    ADD  R2, R11, R0
    JZ   R5, _L234
    JMP  _L229
    JMP  _L235
_L234:
_L235:
    JMP  _L232
_L233:
_L229:
fs_exists:
    LI   R28, find_file
    JMP  _L236
_L236:
fs_create:
    LI   R28, -38
    STORE R4, R29, 5
    JZ   R5, _L238
    ADD  R3, R10, R0
    ADD  R4, R12, R0
    LI   R28, fs_write
    JMP  _L237
    JMP  _L239
_L238:
_L239:
    LI   R28, 7
_L240:
    JZ   R5, _L243
    JMP  _L241
_L242:
    JMP  _L240
_L241:
    JZ   R5, _L244
    JMP  _L243
    JMP  _L245
_L244:
_L245:
    JMP  _L242
_L243:
    JZ   R5, _L246
    LI   R5, -1
    JMP  _L247
_L246:
_L247:
    LI   R6, 4096
    JZ   R5, _L248
    LI   R7, 4096
    JMP  _L249
_L248:
_L249:
    LI   R10, files
    MUL  R12, R12, R28
    ADD  R10, R10, R28
    LOAD R12, R10, 0
    LI   R10, 32
    JZ   R5, _L250
    LI   R28, 32
    LI   R28, kmemcpy
    JMP  _L251
_L250:
_L251:
    LI   R28, 4128
    LI   R28, 4129
    LI   R10, 2
    OR  R9, R9, R10
    LI   R28, perms_register
    LI   R5, _STR_43
_L237:
    LI   R28, 38
fs_write:
    JZ   R5, _L253
    LI   R28, fs_create
    JMP  _L252
    JMP  _L254
_L253:
_L254:
    LI   R9, 2
    LI   R28, check_permission
    JZ   R5, _L255
    LI   R5, _STR_44
    LI   R5, -3
    JMP  _L256
_L255:
_L256:
    JZ   R5, _L257
    JMP  _L258
_L257:
_L258:
    JZ   R5, _L259
    JMP  _L260
_L259:
_L260:
_L252:
fs_read:
    JZ   R5, _L262
    LI   R5, -2
    JMP  _L261
    JMP  _L263
_L262:
_L263:
    JZ   R5, _L264
    JMP  _L265
_L264:
_L265:
    LI   R8, files
    MUL  R10, R10, R28
    ADD  R8, R8, R28
    CMPLT  R7, R7, R10
    JZ   R7, _L266
    ADD  R9, R11, R0
    JMP  _L267
_L266:
    ADD  R9, R12, R0
_L267:
_L261:
fs_delete:
    JZ   R5, _L269
    JMP  _L268
    JMP  _L270
_L269:
_L270:
    JZ   R5, _L271
    JMP  _L272
_L271:
_L272:
_L268:
fs_count:
    JMP  _L273
_L273:
fs_list:
    LI   R5, _STR_45
_L275:
    JZ   R5, _L278
    JMP  _L276
_L277:
    JMP  _L275
_L276:
    JZ   R7, _L279
    LI   R5, _STR_46
    LI   R6, files
    LI   R9, files
    JMP  _L280
_L279:
_L280:
    JMP  _L277
_L278:
    JZ   R5, _L281
    LI   R5, _STR_47
    JMP  _L282
_L281:
_L282:
_L274:
ensure_fb:
_L293:
abs_i:
    JZ   R5, _L295
    SUB  R6, R0, R6
    JMP  _L296
_L295:
_L296:
    JMP  _L294
_L294:
gpu_put_pixel_local:
    LI   R7, fb_w
    CMPLE  R6, R8, R6
    CMPLT  R7, R7, R8
    OR   R5, R5, R7
    LI   R8, fb_h
    CMPLE  R7, R9, R7
    JZ   R5, _L298
    JMP  _L297
    JMP  _L299
_L298:
_L299:
    LI   R5, framebuffer
    LI   R8, fb_w
    MUL  R7, R7, R9
    ADD  R7, R7, R10
    ADD  R6, R6, R7
    LOAD R9, R6, 0
    STORE R11, R6, 0
_L297:
gpu_save_frame_raw:
_L300:
platform_framebuffer:
    LI   R28, ensure_fb
    JMP  _L301
_L301:
gpu_init:
    LI   R28, gpu_hw_init
_L302:
gpu_clear:
_L304:
    LI   R6, fb_w
    LI   R7, fb_h
    MUL  R6, R6, R8
    JZ   R5, _L307
    JMP  _L305
_L306:
    JMP  _L304
_L305:
    JMP  _L306
_L307:
    LI   R28, gpu_hw_clear
_L303:
gpu_put_pixel:
    LI   R28, gpu_put_pixel_local
    LI   R28, gpu_hw_pixel
_L308:
gpu_draw_line:
    LI   R28, -39
    STORE R6, R29, 7
    STORE R6, R29, 8
    STORE R6, R29, 9
    STORE R6, R29, 10
    SUB  R5, R5, R7
    LI   R28, abs_i
    JZ   R5, _L310
    JMP  _L311
_L310:
    SUB  R7, R0, R7
_L311:
    STORE R6, R29, 13
    JZ   R5, _L312
    JMP  _L313
_L312:
_L313:
    STORE R6, R29, 14
    LI   R28, 11
    LI   R28, 12
_L314:
    JZ   R5, _L315
    CMPEQ  R5, R5, R7
    CMPEQ  R7, R7, R9
    JZ   R5, _L316
    JMP  _L315
    JMP  _L317
_L316:
_L317:
    LI   R5, 2
    LI   R28, 15
    MUL  R5, R5, R7
    JZ   R5, _L318
    SUB  R9, R6, R8
    LI   R28, 13
    ADD  R9, R6, R8
    JMP  _L319
_L318:
_L319:
    JZ   R5, _L320
    LI   R28, 14
    JMP  _L321
_L320:
_L321:
    JMP  _L314
_L315:
    LI   R28, 8
    LI   R28, 9
    LI   R28, 10
    LI   R28, gpu_hw_line
_L309:
    LI   R28, 39
gpu_draw_rect:
_L323:
    JZ   R5, _L326
    JMP  _L324
_L325:
    JMP  _L323
_L324:
_L327:
    JZ   R5, _L330
    JMP  _L328
_L329:
    JMP  _L327
_L328:
    JMP  _L329
_L330:
    JMP  _L325
_L326:
    LI   R28, gpu_hw_rect
_L322:
gpu_draw_circle:
    LI   R6, 2
    SUB  R5, R5, R6
_L332:
    CMPLE  R5, R5, R7
    JZ   R5, _L333
    SUB  R7, R7, R9
    JZ   R5, _L334
    LI   R7, 4
    LI   R9, 6
    ADD  R9, R6, R7
    JMP  _L335
_L334:
    SUB  R8, R8, R10
    MUL  R7, R7, R8
    LI   R9, 10
_L335:
    JMP  _L332
_L333:
    LI   R28, gpu_hw_circle
_L331:
gpu_fill_circle:
_L337:
    JZ   R5, _L340
    JMP  _L338
_L339:
    JMP  _L337
_L338:
_L341:
    MUL  R8, R8, R10
    CMPLE  R5, R5, R8
    JZ   R5, _L342
    JMP  _L341
_L342:
_L343:
    CMPLE  R5, R5, R6
    JZ   R5, _L346
    JMP  _L344
_L345:
    JMP  _L343
_L344:
    JMP  _L345
_L346:
    JMP  _L339
_L340:
    LI   R28, gpu_hw_fill_circle
_L336:
gpu_present:
    LI   R28, MEMORY_BARRIER
    LI   R28, gpu_hw_present
_L347:
gpu_put_pixel_alpha:
    JZ   R5, _L349
    JMP  _L348
    JMP  _L350
_L349:
_L350:
    LI   R8, 24
    SHR  R7, R7, R8
    LI   R8, 255
    AND  R7, R7, R8
    LI   R6, 255
    JZ   R5, _L351
    JMP  _L352
_L351:
_L352:
    JZ   R5, _L353
    JMP  _L354
_L353:
_L354:
    LI   R8, 8
    LI   R7, framebuffer
    LI   R10, fb_w
    MUL  R9, R9, R11
    ADD  R9, R9, R12
    ADD  R8, R8, R9
    LOAD R11, R8, 0
    LI   R10, 255
    SUB  R10, R10, R12
    MUL  R9, R9, R10
    DIV  R7, R7, R10
    LI   R10, 4278190080
    ADD  R11, R12, R0
    LI   R12, 16
    SHL  R11, R11, R12
    OR  R10, R10, R11
    LI   R12, 8
    OR  R10, R10, R12
_L348:
gpu_draw_rounded_rect:
    LI   R28, -40
    SUB  R9, R9, R10
    LI   R12, 2
    MUL  R12, R12, R14
    SUB  R11, R11, R12
    ADD  R4, R11, R0
    SUB  R5, R5, R8
    ADD  R12, R29, R28
    LOAD R13, R12, 0
    ADD  R12, R13, R0
    LI   R13, 2
    ADD  R14, R29, R28
    LOAD R15, R14, 0
    MUL  R13, R13, R15
    SUB  R12, R12, R13
_L356:
    JZ   R5, _L359
    JMP  _L357
_L358:
    JMP  _L356
_L357:
_L360:
    JZ   R5, _L363
    JMP  _L361
_L362:
    JMP  _L360
_L361:
    JZ   R5, _L364
    SUB  R8, R8, R11
    ADD  R3, R12, R0
    ADD  R5, R5, R9
    SUB  R9, R9, R12
    ADD  R3, R13, R0
    ADD  R8, R8, R12
    ADD  R9, R9, R13
    ADD  R3, R14, R0
    JMP  _L365
_L364:
_L365:
    JMP  _L362
_L363:
    JMP  _L358
_L359:
_L355:
    LI   R28, 40
gpu_min3:
    STORE R6, R29, 5
    JZ   R5, _L367
    JMP  _L368
_L367:
_L368:
    JZ   R5, _L369
    JMP  _L370
_L369:
_L370:
    JMP  _L366
_L366:
gpu_max3:
    CMPLT  R5, R7, R5
    JZ   R5, _L372
    JMP  _L373
_L372:
_L373:
    JZ   R5, _L374
    JMP  _L375
_L374:
_L375:
    JMP  _L371
_L371:
gpu_fill_triangle:
    LI   R28, -41
    LI   R28, gpu_min3
    LI   R28, gpu_max3
_L377:
    JZ   R5, _L380
    JMP  _L378
_L379:
    JMP  _L377
_L378:
_L381:
    JZ   R5, _L384
    JMP  _L382
_L383:
    JMP  _L381
_L382:
    CMPLE  R6, R7, R6
    CMPLE  R6, R6, R7
    CMPLE  R7, R7, R8
    AND   R6, R6, R7
    JZ   R5, _L385
    JMP  _L386
_L385:
_L386:
    JMP  _L383
_L384:
    JMP  _L379
_L380:
_L376:
    LI   R28, 41
gpu_draw_char:
    LI   R7, 96
    JZ   R5, _L388
    JMP  _L387
    JMP  _L389
_L388:
_L389:
    LI   R7, font8x8
_L390:
    JZ   R5, _L393
    JMP  _L391
_L392:
    JMP  _L390
_L391:
    STORE R8, R29, 13
_L394:
    JZ   R5, _L397
    JMP  _L395
_L396:
    JMP  _L394
_L395:
    LI   R6, 128
    SHR  R6, R6, R8
    JZ   R5, _L398
_L400:
    JZ   R5, _L403
    JMP  _L401
_L402:
    JMP  _L400
_L401:
_L404:
    JZ   R5, _L407
    JMP  _L405
_L406:
    JMP  _L404
_L405:
    ADD  R5, R5, R8
    ADD  R8, R8, R11
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
gpu_draw_string:
    LI   R5, 8
_L409:
    JZ   R6, _L410
    JZ   R5, _L411
    LI   R7, 8
    JMP  _L412
_L411:
    LI   R28, gpu_draw_char
_L412:
    JMP  _L409
_L410:
_L408:
gpu_cmd_init:
    LI   R5, cmd_head
_L437:
    JZ   R5, _L440
    JMP  _L438
_L439:
    JMP  _L437
_L438:
    LI   R5, sprites
    LI   R28, 4101
    LI   R28, 4100
    JMP  _L439
_L440:
_L441:
    JZ   R5, _L444
    JMP  _L442
_L443:
    JMP  _L441
_L442:
    LI   R5, tile_strips
    LI   R28, 16386
    LI   R28, 16385
    JMP  _L443
_L444:
    LI   R5, _STR_48
    LI   R6, 256
    LI   R28, KPRINT
_L436:
gpu_cmd_push:
    JZ   R5, _L446
    LI   R5, _STR_49
    LI   R28, gpu_cmd_flush
    JMP  _L447
_L446:
_L447:
    LI   R5, cmd_queue
    LI   R6, cmd_head
    LI   R28, 69
    LI   R8, 69
    JMP  _L445
_L445:
gpu_cmd_reset:
_L448:
gpu_cmd_pending:
    JMP  _L449
_L449:
blit_sprite_pixel:
    JZ   R5, _L451
    JMP  _L450
    JMP  _L452
_L451:
_L452:
    LI   R9, 8
    SHR  R7, R7, R9
    LI   R8, 16777215
    LI   R9, 24
    SHL  R8, R8, R9
    OR  R7, R7, R8
    LI   R28, gpu_put_pixel_alpha
_L450:
draw_tile:
    JZ   R5, _L454
    JMP  _L453
    JMP  _L455
_L454:
_L455:
    LI   R7, tile_strips
    CMPEQ R6, R6, R0
    LI   R28, 16384
    CMPLE  R7, R10, R7
    OR   R6, R6, R7
    JZ   R6, _L456
    JMP  _L457
_L456:
_L457:
    LI   R10, 8
_L458:
    JZ   R5, _L461
    JMP  _L459
_L460:
    JMP  _L458
_L459:
_L462:
    JZ   R5, _L465
    JMP  _L463
_L464:
    JMP  _L462
_L463:
_L466:
    JZ   R5, _L469
    JMP  _L467
_L468:
    JMP  _L466
_L467:
_L470:
    JZ   R5, _L473
    JMP  _L471
_L472:
    JMP  _L470
_L471:
    JMP  _L472
_L473:
    JMP  _L468
_L469:
    JMP  _L464
_L465:
    JMP  _L460
_L461:
_L453:
gpu_cmd_flush:
_L475:
    JZ   R5, _L478
    JMP  _L476
_L477:
    JMP  _L475
_L476:
    ; switch value is in R7
    JMP  _L479
    ADD  R15, R15, R28
    LOAD R16, R15, 0
    ADD  R17, R29, R28
    LOAD R18, R17, 0
    ADD  R18, R18, R28
    LOAD R19, R18, 0
    ADD  R4, R16, R0
    LI   R7, 14
    LI   R9, 255
    CMPLT  R8, R8, R9
    CMPNE R8, R8, R0
    AND   R6, R6, R8
    JZ   R6, _L480
    LI   R7, 16777215
    AND  R6, R6, R7
    OR  R6, R6, R8
    STORE R6, R29, 6
_L482:
    JZ   R5, _L485
    JMP  _L483
_L484:
    JMP  _L482
_L483:
_L486:
    JZ   R5, _L489
    JMP  _L487
_L488:
    JMP  _L486
_L487:
    JMP  _L488
_L489:
    JMP  _L484
_L485:
    JMP  _L481
_L480:
_L481:
    STORE R7, R29, 7
    STORE R7, R29, 8
    STORE R7, R29, 9
    STORE R7, R29, 10
    STORE R7, R29, 11
    SUB  R9, R9, R11
    ADD  R11, R11, R13
    LI   R13, 1
    SUB  R11, R11, R13
    LI   R28, gpu_fill_circle
    LI   R28, gpu_draw_string
    JZ   R6, _L490
    JMP  _L491
_L490:
_L491:
    LI   R7, sprites
    JZ   R6, _L492
    JMP  _L493
_L492:
_L493:
_L494:
    LI   R28, 4097
    CMPLT  R5, R5, R8
    JZ   R5, _L497
    JMP  _L495
_L496:
    JMP  _L494
_L495:
_L498:
    LI   R28, 4096
    JZ   R5, _L501
    JMP  _L499
_L500:
    JMP  _L498
_L499:
    JZ   R7, _L502
    LI   R10, 1
    JMP  _L503
_L502:
_L503:
    STORE R7, R29, 17
    JZ   R7, _L504
    JMP  _L505
_L504:
_L505:
    STORE R7, R29, 18
    MUL  R8, R8, R11
    LOAD R11, R7, 0
    STORE R11, R29, 19
    LI   R28, 4098
    LI   R28, 4099
    LI   R10, 16777215
    AND  R9, R9, R10
    JZ   R6, _L506
    JMP  _L500
    JMP  _L507
_L506:
_L507:
_L508:
    JZ   R5, _L511
    JMP  _L509
_L510:
    JMP  _L508
_L509:
_L512:
    JZ   R5, _L515
    JMP  _L513
_L514:
    JMP  _L512
_L513:
    MUL  R7, R7, R10
    ADD  R6, R6, R10
    ADD  R11, R11, R28
    ADD  R14, R14, R28
    MUL  R12, R12, R15
    ADD  R11, R11, R12
    ADD  R11, R11, R15
    ADD  R15, R29, R28
    ADD  R3, R16, R0
    ADD  R4, R19, R0
    LI   R28, blit_sprite_pixel
    JMP  _L514
_L515:
    JMP  _L510
_L511:
_L501:
    JMP  _L496
_L497:
    LI   R28, draw_tile
_L516:
    JZ   R5, _L519
    JMP  _L517
_L518:
    JMP  _L516
_L517:
    LI   R28, 21
_L520:
    JZ   R5, _L523
    JMP  _L521
_L522:
    JMP  _L520
_L521:
    LI   R13, 4
    DIV  R12, R12, R13
    MUL  R9, R9, R12
    ADD  R13, R13, R28
    ADD  R9, R9, R14
    ADD  R9, R9, R15
    LOAD R14, R7, 0
    STORE R14, R29, 22
    LI   R28, 22
    JMP  _L522
_L523:
    JMP  _L518
_L519:
    LI   R5, _STR_50
    LI   R5, _STR_51
    LI   R28, gpu_present
    LI   R5, _STR_52
_L479:
    JMP  _L477
_L478:
_L474:
gcmd_clear:
    LI   R28, gpu_cmd_push
_L524:
gcmd_pixel:
    LI   R7, 2
_L525:
gcmd_line:
    LI   R7, 3
_L526:
gcmd_rect:
    LI   R7, 255
_L527:
gcmd_rect_border:
    LI   R7, 5
_L528:
gcmd_circle:
    LI   R7, 6
_L529:
gcmd_fill_circle:
    LI   R7, 7
_L530:
gcmd_string:
    LI   R7, 10
    LI   R9, 63
    LI   R7, 63
    LI   R28, 64
    STORE R8, R6, 0
_L531:
gcmd_sprite:
_L532:
gcmd_tile:
    LI   R7, 9
_L533:
gcmd_scroll:
    LI   R7, 12
_L534:
gcmd_flip:
_L535:
gcmd_present:
    LI   R7, 15
_L536:
gpu_sprite_load:
    JZ   R5, _L538
    JMP  _L537
    JMP  _L539
_L538:
_L539:
    LI   R6, 64
    LI   R7, 64
    MUL  R6, R6, R7
    JZ   R5, _L540
    JMP  _L541
_L540:
_L541:
    LI   R11, 4
    MUL  R10, R10, R11
    LI   R5, _STR_53
_L537:
gpu_sprite_set_color_key:
    LI   R6, sprites
    JZ   R5, _L543
    JMP  _L542
    JMP  _L544
_L543:
_L544:
_L542:
gpu_sprite_free:
    JZ   R5, _L546
    JMP  _L545
    JMP  _L547
_L546:
_L547:
_L545:
gpu_tile_load_strip:
    JZ   R5, _L549
    JMP  _L548
    JMP  _L550
_L549:
_L550:
    LI   R5, _STR_54
_L548:
gpu_tile_draw_map:
_L552:
    JZ   R5, _L555
    JMP  _L553
_L554:
    JMP  _L552
_L553:
_L556:
    JZ   R5, _L559
    JMP  _L557
_L558:
    JMP  _L556
_L557:
    ADD  R13, R14, R0
    ADD  R12, R12, R13
    ADD  R14, R15, R0
    ADD  R15, R16, R0
    ADD  R16, R29, R28
    LOAD R17, R16, 0
    MUL  R15, R15, R17
    ADD  R14, R14, R15
    JMP  _L558
_L559:
    JMP  _L554
_L555:
_L551:
ring_words:
    LI   R5, gpu_ring
    JMP  _L560
_L560:
ring_word:
    LI   R28, ring_words
_L561:
color_component:
    SHR  R5, R5, R7
    AND  R5, R5, R7
    JMP  _L562
_L562:
gpu_hw_doorbell:
    LI   R5, 230
    LI   R6, ring_head
    LI   R28, MMIO_WRITE
    LI   R5, 232
_L563:
gpu_hw_packet:
    LI   R5, gpu_ready
    JZ   R5, _L565
    JMP  _L564
    JMP  _L566
_L565:
_L566:
    LI   R5, ring_head
    LI   R7, 8192
    CMPLE  R5, R7, R5
    JZ   R5, _L567
    LI   R5, 227
    JMP  _L568
_L567:
_L568:
    LI   R28, ring_word
    LI   R8, 4
    LI   R7, current_owner
_L569:
    JZ   R5, _L572
    JMP  _L570
_L571:
    JMP  _L569
_L570:
    JMP  _L571
_L572:
    LI   R28, gpu_hw_doorbell
_L564:
gpu_hw_init:
    LI   R7, 224
    LI   R28, MMIO_READ
    LI   R8, 1196446976
    LI   R5, current_owner
    JZ   R5, _L574
    JMP  _L573
    JMP  _L575
_L574:
_L575:
_L576:
    LI   R6, 8192
    JZ   R5, _L579
    JMP  _L577
_L578:
    JMP  _L576
_L577:
    JMP  _L578
_L579:
    LI   R5, 228
    LI   R6, 24576
    LI   R5, 229
    LI   R5, 238
    LI   R5, 239
    LI   R6, 800
    LI   R6, 600
    LI   R5, 241
    LI   R5, 242
_L573:
gpu_hw_available:
    JMP  _L580
_L580:
gpu_hw_set_owner:
_L581:
gpu_hw_clear:
    STORE R6, R29, 3
    LI   R5, 261
    LI   R28, gpu_hw_packet
_L582:
gpu_hw_pixel:
    LI   R5, 256
_L583:
gpu_hw_line:
    STORE R6, R29, 11
    LI   R5, 257
_L584:
gpu_hw_rect:
    LI   R5, 258
_L585:
gpu_hw_circle:
    LI   R5, 259
_L586:
gpu_hw_fill_circle:
    LI   R5, 260
_L587:
gpu_hw_present:
_L588:
abs_coord:
    JZ   R5, _L597
    JMP  _L598
_L597:
_L598:
    JMP  _L596
_L596:
gui_user_buffer_valid:
    JZ   R5, _L600
    JMP  _L599
    JMP  _L601
_L600:
_L601:
    STORE R6, R29, 4
    LI   R7, 32767
    JZ   R5, _L602
    JMP  _L603
_L602:
_L603:
    LI   R6, 32768
    SUB  R6, R6, R8
    JZ   R5, _L604
    JMP  _L605
_L604:
_L605:
_L599:
coord_reasonable:
    CMPLE  R6, R6, R8
    JMP  _L606
_L606:
request_valid:
    JZ   R5, _L608
    JMP  _L607
    JMP  _L609
_L608:
_L609:
    ; switch value is in R6
    LI   R7, 800
    LI   R8, 600
    JMP  _L610
    LI   R7, 600
    JZ   R5, _L611
    JMP  _L612
_L611:
_L612:
    LI   R28, coord_reasonable
    LI   R28, -1
    ADD  R6, R7, R0  ; sonuç = R7
    LI   R8, 800
    JZ   R5, _L613
    JMP  _L614
_L613:
_L614:
    LI   R28, abs_coord
    CMPLT  R7, R8, R7
    JZ   R7, _L615
    JMP  _L616
_L615:
_L616:
    JZ   R5, _L617
    JMP  _L618
_L617:
_L618:
    JZ   R5, _L619
    JMP  _L620
_L619:
_L620:
_L610:
_L607:
gui_guard_init:
    JZ   R5, _L622
    JMP  _L621
    JMP  _L623
_L622:
_L623:
    LI   R28, 42
    LI   R28, 43
_L621:
gui_guard_enabled:
    CMPNE  R6, R6, R7
    JMP  _L624
_L624:
gui_guard_record_fault:
    JZ   R5, _L626
    JMP  _L625
    JMP  _L627
_L626:
_L627:
    JZ   R5, _L628
    JMP  _L629
_L628:
_L629:
    JZ   R6, _L630
    LI   R5, _STR_55
    LI   R10, 3
    JMP  _L631
_L630:
_L631:
    JZ   R5, _L632
    LI   R5, _STR_56
    JMP  _L633
_L632:
_L633:
_L625:
gui_guard_admit:
    LI   R28, gui_guard_enabled
    JZ   R5, _L635
    JMP  _L634
    JMP  _L636
_L635:
_L636:
    LI   R28, request_valid
    JZ   R5, _L637
    LI   R6, _STR_57
    LI   R28, gui_guard_record_fault
    JMP  _L638
_L637:
_L638:
    LI   R28, gui_guard_admit_pixels
    CMPNE  R5, R5, R6
    JZ   R5, _L639
    JMP  _L640
_L639:
_L640:
    JZ   R6, _L641
    JMP  _L642
_L641:
_L642:
_L634:
gui_guard_admit_pixels:
    JZ   R5, _L644
    JMP  _L643
    JMP  _L645
_L644:
_L645:
    JZ   R5, _L646
    LI   R6, _STR_58
    JMP  _L647
_L646:
_L647:
    JZ   R5, _L648
    LI   R6, _STR_59
    JMP  _L649
_L648:
_L649:
_L643:
gui_guard_reset:
    LI   R28, gui_guard_init
_L650:
hostio_open:
    JMP  _L656
_L656:
hostio_close:
_L657:
hostio_read:
    JMP  _L658
_L658:
hostio_write:
    JMP  _L659
_L659:
hostio_lseek:
    JMP  _L660
_L660:
keyboard_init:
    LI   R5, key_buf
    LI   R28, 256
    LI   R28, 257
_L668:
keyboard_feed:
    DIV  R7, R5, R6
    MUL  R7, R7, R6
    LI   R6, key_buf
    CMPNE  R5, R5, R7
    JZ   R5, _L670
    LI   R7, key_buf
    JMP  _L671
_L670:
_L671:
_L669:
scancode_to_ascii:
    LI   R5, 27
    LI   R5, 49
    LI   R5, 50
    LI   R5, 51
    LI   R5, 52
    LI   R5, 53
    LI   R5, 54
    LI   R5, 55
    LI   R5, 56
    LI   R5, 57
    LI   R5, 48
    LI   R5, 45
    LI   R5, 61
    LI   R5, 9
    LI   R5, 113
    LI   R5, 119
    LI   R5, 101
    LI   R5, 114
    LI   R5, 116
    LI   R5, 121
    LI   R5, 117
    LI   R5, 105
    LI   R5, 111
    LI   R5, 112
    LI   R5, 91
    LI   R5, 93
    STORE R5, R29, 32
    LI   R5, 97
    STORE R5, R29, 33
    LI   R5, 115
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
    STORE R5, R29, 45
    LI   R5, 92
    STORE R5, R29, 46
    LI   R5, 122
    STORE R5, R29, 47
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
    STORE R5, R29, 57
    LI   R5, 42
    STORE R5, R29, 58
    STORE R5, R29, 59
    LI   R5, 32
    STORE R5, R29, 60
    JZ   R5, _L673
    JMP  _L672
    JMP  _L674
_L673:
_L674:
_L672:
keyboard_irq_handler:
    LI   R28, scancode_to_ascii
    JZ   R6, _L676
    LI   R28, keyboard_feed
    JMP  _L677
_L676:
_L677:
_L675:
keyboard_has_key:
    JMP  _L678
_L678:
keyboard_getkey:
_L680:
    JZ   R5, _L681
    LI   R28, keyboard_poll
    JMP  _L680
_L681:
    LI   R9, key_buf
    STORE R10, R5, 0
    LI   R8, 256
    DIV  R9, R7, R8
    MUL  R9, R9, R8
    JMP  _L679
_L679:
keyboard_poll:
    JZ   R6, _L683
    JMP  _L684
_L683:
_L684:
_L682:
ipc_init:
_L698:
    JZ   R5, _L701
    JMP  _L699
_L700:
    JMP  _L698
_L699:
    LI   R5, pipes
    LI   R28, 261
    LI   R28, 258
    JMP  _L700
_L701:
_L702:
    JZ   R5, _L705
    JMP  _L703
_L704:
    JMP  _L702
_L703:
    LI   R5, queues
    LI   R28, 1076
    LI   R28, 1075
    JMP  _L704
_L705:
    LI   R5, _STR_60
_L697:
pipe_create:
_L707:
    JZ   R5, _L710
    JMP  _L708
_L709:
    JMP  _L707
_L708:
    JZ   R5, _L711
    LI   R28, 259
    LI   R28, 260
    LI   R9, 256
    LI   R28, kmemset
    LI   R7, 32
    MUL  R8, R8, R9
    JMP  _L706
    JMP  _L712
_L711:
_L712:
    JMP  _L709
_L710:
_L706:
pipe_write:
    LI   R28, FD_TO_PIPE
    JZ   R5, _L714
    JMP  _L713
    JMP  _L715
_L714:
_L715:
    LI   R28, FD_IS_WRITE
    JZ   R5, _L716
    JMP  _L717
_L716:
_L717:
    LI   R7, pipes
    JZ   R6, _L718
    JMP  _L719
_L718:
_L719:
_L720:
    JZ   R5, _L721
    LI   R7, 256
    DIV  R8, R6, R7
    MUL  R8, R8, R7
    CMPEQ  R5, R5, R8
    JZ   R5, _L722
    JMP  _L721
    JMP  _L723
_L722:
_L723:
    LOAD R10, R7, 0
    LI   R15, 1
    ADD  R16, R14, R15
    STORE R16, R13, 0
    STORE R14, R7, 0
    JMP  _L720
_L721:
_L713:
pipe_read:
    JZ   R5, _L725
    JMP  _L724
    JMP  _L726
_L725:
_L726:
    LI   R28, FD_IS_READ
    JZ   R5, _L727
    JMP  _L728
_L727:
_L728:
    JZ   R6, _L729
    JMP  _L730
_L729:
_L730:
_L731:
    CMPNE  R8, R8, R11
    AND   R5, R5, R8
    JZ   R5, _L732
    ADD  R11, R11, R14
    LOAD R14, R11, 0
    STORE R14, R6, 0
    LI   R10, 256
    DIV  R11, R9, R10
    MUL  R11, R11, R10
    JMP  _L731
_L732:
_L724:
pipe_close:
    JZ   R5, _L734
    JMP  _L733
    JMP  _L735
_L734:
_L735:
_L733:
pipe_available:
    JZ   R5, _L737
    JMP  _L736
    JMP  _L738
_L737:
_L738:
    JZ   R6, _L739
    JMP  _L740
_L739:
_L740:
    SUB  R6, R6, R9
    ADD  R6, R6, R9
    DIV  R10, R6, R9
    MUL  R10, R10, R9
    SUB  R6, R6, R10
_L736:
mq_create:
_L742:
    JZ   R5, _L745
    JMP  _L743
_L744:
    JMP  _L742
_L743:
    JZ   R5, _L746
    LI   R28, 1072
    LI   R28, 1073
    LI   R28, 1074
    LI   R10, queues
    LI   R10, 16
    JMP  _L741
    JMP  _L747
_L746:
_L747:
    JMP  _L744
_L745:
_L741:
mq_open:
_L749:
    JZ   R5, _L752
    JMP  _L750
_L751:
    JMP  _L749
_L750:
    LI   R7, queues
    JZ   R5, _L753
    JMP  _L748
    JMP  _L754
_L753:
_L754:
    JMP  _L751
_L752:
_L748:
mq_send:
    JZ   R5, _L756
    JMP  _L755
    JMP  _L757
_L756:
_L757:
    JZ   R6, _L758
    JMP  _L759
_L758:
_L759:
    LI   R7, 16
    JZ   R6, _L760
    JMP  _L761
_L760:
_L761:
    JZ   R5, _L762
    JMP  _L763
_L762:
_L763:
    LI   R28, 1056
    LI   R28, 65
_L755:
mq_recv:
    JZ   R5, _L765
    JMP  _L764
    JMP  _L766
_L765:
_L766:
    CMPEQ  R8, R8, R9
    OR   R6, R6, R8
    JZ   R6, _L767
    JMP  _L768
_L767:
_L768:
    SUB  R9, R7, R8
_L764:
mq_count:
    JZ   R5, _L770
    JMP  _L769
    JMP  _L771
_L770:
_L771:
_L769:
mq_destroy:
    JZ   R5, _L773
    JMP  _L772
    JMP  _L774
_L773:
_L774:
_L772:
kernel_main:
    LI   R28, uart_init
    LI   R28, memory_init
    LI   R28, scheduler_init
    LI   R28, gpu_init
    LI   R28, gpu_cmd_init
    LI   R28, ui_boot_splash
    LI   R5, _STR_81
    LI   R28, ui_loading_bar
    LI   R5, _STR_82
    LI   R6, 20
    LI   R28, keyboard_init
    LI   R28, mouse_init
    LI   R28, usb_hid_init
    LI   R5, _STR_83
    LI   R6, 35
    LI   R28, auth_init
    LI   R28, perms_init
    LI   R5, _STR_84
    LI   R6, 50
    LI   R28, fs_init
    LI   R5, _STR_85
    LI   R6, 65
    LI   R28, apps_init
    LI   R5, _STR_86
    LI   R6, 80
    LI   R28, wm_init
    LI   R28, network_init
    LI   R28, wifi_init
    LI   R5, _STR_87
    LI   R28, desktop_welcome_screen
    LI   R28, wm_render
    LI   R5, _STR_88
    LI   R5, _STR_89
    LI   R5, _STR_90
    LI   R5, _STR_91
    LI   R5, _STR_92
    LI   R5, _STR_93
    LI   R28, login_prompt
    JZ   R5, _L838
    LI   R5, _STR_94
    LI   R28, panic
    JMP  _L839
_L838:
_L839:
    LI   R7, shell_main
    LI   R9, 7
    JZ   R5, _L840
    LI   R5, _STR_95
    JMP  _L841
_L840:
_L841:
    LI   R5, _STR_96
    LI   R5, _STR_97
    LI   R28, scheduler_run
_L837:
panic:
    LI   R5, _STR_98
    LI   R5, _STR_99
_L843:
    JZ   R5, _L844
    JMP  _L843
_L844:
_L842:
trap_dispatcher:
    LI   R28, timer_interrupt_handler
    JMP  _L846
    LI   R28, ecall_handler
    LI   R5, _STR_100
    LI   R5, current_pid
    LI   R28, process_kill
    LI   R28, scheduler
    LI   R5, _STR_101
_L846:
_L845:
timer_interrupt_handler:
    LI   R5, total_ticks
    LI   R28, usb_hid_poll
    LI   R28, usb_hid_tick
    LI   R28, smp_current_core
    LI   R28, smp_handle_ipi
    LI   R28, smp_account_tick
    LI   R6, current_pid
    JZ   R5, _L849
    LI   R5, process_table
    LI   R28, 48
    LI   R28, 47
    LI   R28, 46
    JMP  _L850
_L849:
_L850:
    LI   R28, wm_run
    JZ   R5, _L851
    JMP  _L852
_L851:
_L852:
    LI   R28, signal_check
    LI   R28, alarm_tick
    JZ   R5, _L853
    LI   R8, 10
    JMP  _L854
_L853:
_L854:
_L848:
ecall_handler:
    LI   R5, syscalls_handled
    LI   R8, 2
    LI   R9, process_table
    LI   R10, current_pid
    LI   R12, 3
    LI   R13, process_table
    LI   R14, current_pid
    MUL  R15, R15, R28
    ADD  R13, R13, R15
    LOAD R15, R13, 0
    LI   R16, 4
    MUL  R16, R16, R28
    ADD  R15, R15, R16
    LI   R17, process_table
    LI   R18, current_pid
    MUL  R19, R19, R28
    ADD  R17, R17, R19
    ADD  R17, R17, R28
    LOAD R19, R17, 0
    LI   R20, 5
    MUL  R20, R20, R28
    ADD  R19, R19, R20
    LOAD R20, R19, 0
    ADD  R2, R12, R0
    ADD  R4, R20, R0
    LI   R28, syscall_handler
_L855:
syscall_handler:
    LI   R28, sys_fork
    JMP  _L857
    LI   R28, sys_exec
    LI   R28, sys_write
    LI   R28, sys_read
    LI   R7, current_pid
    LI   R28, sys_spawn
    LI   R28, sys_gpu_draw
    LI   R28, sys_kill
    LI   R28, sys_alarm
    LI   R28, sys_yield
    LI   R28, sys_gettime
    LI   R28, sys_gui_status
    LI   R28, sys_gui_reset
_L857:
    LI   R8, 7
_L856:
sys_fork:
_L859:
    JZ   R5, _L862
    JMP  _L860
_L861:
    JMP  _L859
_L860:
    LI   R28, 33
    JZ   R5, _L863
    JMP  _L862
    JMP  _L864
_L863:
_L864:
    JMP  _L861
_L862:
    JZ   R5, _L865
    JMP  _L858
    JMP  _L866
_L865:
_L866:
    LI   R7, process_table
    LI   R8, current_pid
    LI   R9, 48
    LI   R28, memcpy
    STORE R9, R7, 0
_L858:
sys_exec:
    LI   R9, 32
    LI   R28, memset
    LI   R28, gui_guard_reset
    JMP  _L867
_L867:
sys_exit:
_L868:
sys_write:
    JZ   R5, _L870
    LI   R28, gui_user_buffer_valid
    JZ   R5, _L872
    JMP  _L869
    JMP  _L873
_L872:
_L873:
_L874:
    JZ   R5, _L877
    JMP  _L875
_L876:
    JMP  _L874
_L875:
    JMP  _L876
_L877:
    JMP  _L871
_L870:
    JZ   R5, _L878
    LI   R28, platform_framebuffer
    JZ   R5, _L880
    LI   R7, _STR_102
    JMP  _L881
_L880:
_L881:
    JZ   R5, _L882
    JMP  _L883
_L882:
_L883:
_L884:
    JZ   R5, _L887
    JMP  _L885
_L886:
    JMP  _L884
_L885:
    STORE R12, R6, 0
    JMP  _L886
_L887:
    JMP  _L879
_L878:
_L879:
_L871:
_L869:
sys_read:
    JZ   R5, _L889
_L891:
    JZ   R5, _L894
    JMP  _L892
_L893:
    JMP  _L891
_L892:
    STORE R8, R30, 3
    LOAD R8, R30, 3
    ADD  R9, R7, R0  ; sonuç = R7
    JMP  _L893
_L894:
    JMP  _L888
    JMP  _L890
_L889:
_L890:
_L888:
sys_sleep:
    DIV  R8, R8, R9
    LI   R8, 3
    JMP  _L895
_L895:
sys_spawn:
    JZ   R5, _L897
    JMP  _L898
_L897:
_L898:
    JMP  _L896
_L896:
sys_kill:
    JZ   R5, _L900
    JMP  _L899
    JMP  _L901
_L900:
_L901:
    JZ   R5, _L902
    JMP  _L903
_L902:
_L903:
    LI   R28, signal_deliver
_L899:
sys_alarm:
    LI   R5, alarm_table_init
    JZ   R5, _L905
_L907:
    JZ   R5, _L910
    JMP  _L908
_L909:
    JMP  _L907
_L908:
    LI   R5, alarm_table
    SUB  R8, R0, R8
    JMP  _L909
_L910:
    JMP  _L906
_L905:
_L906:
_L911:
    JZ   R5, _L914
    JMP  _L912
_L913:
    JMP  _L911
_L912:
    JZ   R5, _L915
    JMP  _L914
    JMP  _L916
_L915:
_L916:
    JMP  _L913
_L914:
    JZ   R5, _L917
    JMP  _L904
    JMP  _L918
_L917:
_L918:
_L919:
    JZ   R5, _L922
    JMP  _L920
_L921:
    JMP  _L919
_L920:
    JZ   R5, _L923
    LI   R10, 10
    DIV  R9, R9, R10
    JMP  _L924
_L923:
_L924:
    JMP  _L921
_L922:
_L904:
alarm_tick:
    JZ   R5, _L926
    JMP  _L925
    JMP  _L927
_L926:
_L927:
_L928:
    JZ   R5, _L931
    JMP  _L929
_L930:
    JMP  _L928
_L929:
    LI   R8, alarm_table
    JZ   R5, _L932
    LI   R8, 14
    JMP  _L933
_L932:
_L933:
    JMP  _L930
_L931:
_L925:
sys_yield:
_L934:
sys_gettime:
    JZ   R6, _L936
    JMP  _L937
_L936:
_L937:
    JZ   R6, _L938
    LI   R8, 1000
    DIV  R7, R7, R8
    JMP  _L939
_L938:
_L939:
    JMP  _L935
_L935:
sys_gui_status:
    JZ   R5, _L941
    JMP  _L940
    JMP  _L942
_L941:
_L942:
_L940:
sys_gui_reset:
    LI   R5, _STR_103
    JMP  _L943
_L943:
signal_deliver:
    JZ   R5, _L945
    JMP  _L944
    JMP  _L946
_L945:
_L946:
    JZ   R5, _L947
    JMP  _L948
_L947:
_L948:
    LI   R7, 31
    JZ   R5, _L949
    JMP  _L950
_L949:
_L950:
    SHL  R8, R8, R10
    OR   R10, R7, R8
_L944:
signal_check:
    JZ   R5, _L952
    JMP  _L951
    JMP  _L953
_L952:
_L953:
    JZ   R5, _L954
    JMP  _L955
_L954:
_L955:
    JZ   R5, _L956
    JMP  _L957
_L956:
_L957:
_L958:
    LI   R6, 31
    JZ   R5, _L961
    JMP  _L959
_L960:
    JMP  _L958
_L959:
    SHL  R6, R6, R8
    JZ   R5, _L962
    JMP  _L960
    JMP  _L963
_L962:
_L963:
    XOR  R8, R8, R28
    AND  R10, R7, R8
    JZ   R5, _L965
    JMP  _L966
_L965:
_L966:
    JZ   R5, _L967
    JMP  _L968
_L967:
_L968:
    JZ   R5, _L969
    JMP  _L970
_L969:
_L970:
    JMP  _L964
_L964:
_L961:
_L951:
sys_gpu_draw:
    JZ   R5, _L972
    LI   R7, _STR_104
    JMP  _L971
    JMP  _L973
_L972:
_L973:
    LI   R11, 0
    LI   R28, gui_guard_admit
    JZ   R5, _L974
    JMP  _L975
_L974:
_L975:
    LI   R28, gpu_hw_set_owner
    JMP  _L976
_L976:
_L971:
kmemset:
_L978:
    JZ   R6, _L979
    JMP  _L978
_L979:
    JMP  _L977
_L977:
kmemcpy:
_L981:
    JZ   R6, _L982
    JMP  _L981
_L982:
    JMP  _L980
_L980:
kmemcmp:
_L984:
    JZ   R6, _L985
    JZ   R5, _L986
    JMP  _L983
    JMP  _L987
_L986:
_L987:
    JMP  _L984
_L985:
_L983:
kstrlen:
_L989:
    JZ   R6, _L990
    JMP  _L989
_L990:
    JMP  _L988
_L988:
kstrcpy:
_L992:
    JZ   R8, _L993
    JMP  _L992
_L993:
    JMP  _L991
_L991:
kstrncpy:
_L995:
    ADD  R11, R9, R10
    STORE R11, R8, 0
    JZ   R5, _L996
    JMP  _L995
_L996:
_L997:
    JZ   R6, _L998
    JMP  _L997
_L998:
    JMP  _L994
_L994:
kstrcmp:
_L1000:
    JZ   R5, _L1001
    JMP  _L1000
_L1001:
    JMP  _L999
_L999:
kstrncmp:
_L1003:
    JZ   R5, _L1006
    JMP  _L1004
_L1005:
    JMP  _L1003
_L1004:
    CMPNE  R6, R6, R11
    ADD  R12, R14, R0
    LI   R14, 0
    CMPEQ  R12, R12, R14
    OR   R6, R6, R12
    JZ   R6, _L1007
    SUB  R6, R6, R11
    JMP  _L1002
    JMP  _L1008
_L1007:
_L1008:
    JMP  _L1005
_L1006:
_L1002:
kmemmove:
    JZ   R5, _L1010
_L1012:
    JZ   R6, _L1013
    JMP  _L1012
_L1013:
    JMP  _L1011
_L1010:
_L1014:
    JZ   R6, _L1015
    SUB  R6, R6, R28
    STORE R6, R5, 0
    JMP  _L1014
_L1015:
_L1011:
    JMP  _L1009
_L1009:
kstrchr:
_L1017:
    JZ   R6, _L1020
    JMP  _L1018
_L1019:
    JMP  _L1017
_L1018:
    JZ   R5, _L1021
    JMP  _L1016
    JMP  _L1022
_L1021:
_L1022:
    JMP  _L1019
_L1020:
    JZ   R5, _L1023
    JMP  _L1024
_L1023:
_L1024:
_L1016:
memory_init:
    LI   R5, blocks
    LI   R7, 12288
    LI   R5, block_count
_L1025:
kmalloc:
    JZ   R5, _L1027
    JMP  _L1026
    JMP  _L1028
_L1027:
_L1028:
    JZ   R5, _L1029
    JMP  _L1030
_L1029:
_L1030:
_L1031:
    LI   R6, block_count
    JZ   R5, _L1034
    JMP  _L1032
_L1033:
    JMP  _L1031
_L1032:
    LI   R7, blocks
    JZ   R5, _L1035
    STORE R7, R29, 5
    LI   R7, block_count
    LI   R8, 64
    JZ   R5, _L1037
    SUB  R7, R7, R10
_L1039:
    JZ   R5, _L1042
    JMP  _L1040
_L1041:
    JMP  _L1039
_L1040:
    JMP  _L1041
_L1042:
    JMP  _L1038
_L1037:
_L1038:
    JMP  _L1036
_L1035:
_L1036:
    JMP  _L1033
_L1034:
_L1026:
kfree:
    JZ   R5, _L1044
    JMP  _L1043
    JMP  _L1045
_L1044:
_L1045:
_L1046:
    JZ   R5, _L1049
    JMP  _L1047
_L1048:
    JMP  _L1046
_L1047:
    LI   R8, blocks
    CMPNE R10, R10, R0
    AND   R5, R5, R10
    JZ   R5, _L1050
    LI   R6, blocks
    SUB  R7, R7, R8
    JZ   R5, _L1052
    ADD  R10, R6, R9
_L1054:
    JZ   R5, _L1057
    JMP  _L1055
_L1056:
    JMP  _L1054
_L1055:
    JMP  _L1056
_L1057:
    JMP  _L1053
_L1052:
_L1053:
    JZ   R5, _L1058
    ADD  R10, R7, R9
_L1060:
    JZ   R5, _L1063
    JMP  _L1061
_L1062:
    JMP  _L1060
_L1061:
    JMP  _L1062
_L1063:
    JMP  _L1059
_L1058:
_L1059:
    JMP  _L1051
_L1050:
_L1051:
    JMP  _L1048
_L1049:
_L1043:
mouse_init:
_L1064:
mouse_move:
    JZ   R5, _L1066
    JMP  _L1067
_L1066:
_L1067:
    JZ   R5, _L1068
    JMP  _L1069
_L1068:
_L1069:
    JZ   R5, _L1070
    JMP  _L1071
_L1070:
_L1071:
    JZ   R5, _L1072
    JMP  _L1073
_L1072:
_L1073:
_L1065:
mouse_button:
    JZ   R6, _L1075
    SHL  R7, R7, R9
    OR   R9, R6, R7
    JMP  _L1076
_L1075:
    XOR  R7, R7, R28
    AND  R9, R6, R7
_L1076:
_L1074:
draw_cursor:
    LI   R9, mouse
    LI   R10, mouse
    LI   R11, 5
    ADD  R10, R10, R11
    LI   R11, 4294967295
    LI   R11, 10
    LI   R6, 5
    LI   R6, mouse
    LI   R8, mouse
    LI   R9, 5
    LI   R9, 4294967295
_L1077:
nic_read:
    LI   R28, mmio_read
    JMP  _L1088
_L1088:
nic_write:
    LI   R28, mmio_write
_L1089:
ip_to_str:
_L1091:
    JZ   R5, _L1094
    JMP  _L1092
_L1093:
    JMP  _L1091
_L1092:
    SHR  R5, R5, R6
    JZ   R5, _L1095
    LI   R11, 100
    DIV  R10, R10, R11
    JMP  _L1096
_L1095:
_L1096:
    JZ   R5, _L1097
    DIV  R12, R10, R11
    MUL  R12, R12, R11
    JMP  _L1098
_L1097:
_L1098:
    JZ   R5, _L1099
    LI   R9, 46
    JMP  _L1100
_L1099:
_L1100:
    JMP  _L1093
_L1094:
_L1090:
inet_checksum:
_L1102:
    JZ   R5, _L1105
    JMP  _L1103
_L1104:
    JMP  _L1102
_L1103:
    ADD  R8, R10, R0
    OR  R8, R8, R12
    ADD  R12, R6, R8
    STORE R12, R5, 0
    JMP  _L1104
_L1105:
    JZ   R5, _L1106
    JMP  _L1107
_L1106:
_L1107:
_L1108:
    JZ   R5, _L1109
    LI   R8, 65535
    LI   R9, 16
    SHR  R8, R8, R9
    JMP  _L1108
_L1109:
    XOR  R5, R5, R28
    JMP  _L1101
_L1101:
network_init:
    LI   R5, net
    LI   R7, net
_L1111:
    JZ   R5, _L1114
    JMP  _L1112
_L1113:
    JMP  _L1111
_L1112:
    LI   R5, arp_table
    JMP  _L1113
_L1114:
    LI   R7, 3232235620
    LI   R7, 3232235521
    LI   R7, 4294967040
    LI   R8, 72
    LI   R8, 66
    LI   R5, 81
    LI   R28, nic_write
    LI   R5, 88
    LI   R6, net
    LI   R7, 80
    LI   R28, nic_read
    JZ   R7, _L1115
    JMP  _L1116
_L1115:
_L1116:
    LI   R28, ip_to_str
    LI   R5, _STR_105
    JZ   R8, _L1117
    LI   R9, _STR_106
    JMP  _L1118
_L1117:
    LI   R9, _STR_107
_L1118:
_L1110:
net_is_up:
    LI   R5, 80
    JMP  _L1119
_L1119:
net_status:
    LI   R5, _STR_108
    LI   R5, _STR_109
    LI   R5, _STR_110
    LI   R5, _STR_111
    LI   R28, net_is_up
    JZ   R6, _L1121
    LI   R7, _STR_106
    JMP  _L1122
_L1121:
    LI   R7, _STR_107
_L1122:
    LI   R5, _STR_112
    LI   R8, net
    LI   R5, _STR_113
_L1120:
arp_learn:
_L1124:
    JZ   R5, _L1127
    JMP  _L1125
_L1126:
    JMP  _L1124
_L1125:
    JZ   R5, _L1128
    JMP  _L1127
    JMP  _L1129
_L1128:
_L1129:
    JZ   R5, _L1130
    JMP  _L1131
_L1130:
_L1131:
    JMP  _L1126
_L1127:
    LI   R10, 6
_L1123:
arp_lookup:
_L1133:
    JZ   R5, _L1136
    JMP  _L1134
_L1135:
    JMP  _L1133
_L1134:
    LI   R7, arp_table
    JZ   R5, _L1137
    JMP  _L1132
    JMP  _L1138
_L1137:
_L1138:
    JMP  _L1135
_L1136:
    LI   R8, 6
_L1132:
eth_send:
    LI   R7, 1518
    JZ   R5, _L1140
    JMP  _L1139
    JMP  _L1141
_L1140:
_L1141:
    LI   R28, 1526
    JZ   R5, _L1142
    JMP  _L1143
_L1142:
_L1143:
    JZ   R5, _L1144
    JMP  _L1145
_L1144:
_L1145:
    LI   R6, 6
    LI   R6, 12
    LI   R6, 13
    LI   R6, 14
    LI   R28, 1524
    LI   R5, 82
    LI   R28, 1525
_L1146:
    JZ   R5, _L1149
    JMP  _L1147
_L1148:
    JMP  _L1146
_L1147:
    LI   R5, 83
    JMP  _L1148
_L1149:
    LI   R5, 84
_L1139:
eth_recv:
    JZ   R5, _L1151
    JMP  _L1150
    JMP  _L1152
_L1151:
_L1152:
    LI   R7, 85
    CMPLT  R6, R8, R6
    JZ   R5, _L1153
    LI   R5, 87
    JMP  _L1154
_L1153:
_L1154:
_L1155:
    JZ   R5, _L1158
    JMP  _L1156
_L1157:
    JMP  _L1155
_L1156:
    LI   R9, 86
    JMP  _L1157
_L1158:
_L1150:
ip_send:
    STORE R5, R29, 1532
    LI   R8, 20
    JZ   R5, _L1160
    JMP  _L1159
    JMP  _L1161
_L1160:
_L1161:
    LI   R28, 1530
    LI   R7, 20
    LI   R28, 1532
    AND  R8, R8, R9
    LI   R28, 1531
    LI   R28, inet_checksum
    LI   R6, 11
    LI   R28, arp_lookup
    LI   R6, 2048
    LI   R28, eth_send
_L1159:
ping:
    LI   R28, 1536
    JZ   R5, _L1163
    LI   R5, _STR_114
    JMP  _L1162
    JMP  _L1164
_L1163:
_L1164:
    LI   R6, 7
    LI   R7, 72
    LI   R6, 9
    LI   R7, 73
    LI   R7, 76
    LI   R7, 65
    LI   R28, 1533
    LI   R8, 12
    LI   R5, _STR_115
    LI   R9, 12
    ADD  R4, R9, R0
    LI   R28, ip_send
    LI   R28, 1534
_L1165:
    LI   R6, 10000
    JZ   R5, _L1168
    JMP  _L1166
_L1167:
    JMP  _L1165
_L1166:
    LI   R28, 1535
    LI   R8, 1518
    LI   R28, eth_recv
    JZ   R5, _L1169
    STORE R5, R29, 1556
    LI   R28, 1556
    STORE R5, R29, 1557
    LI   R28, 1557
    JZ   R6, _L1171
    LI   R5, _STR_116
    JMP  _L1172
_L1171:
_L1172:
    JMP  _L1170
_L1169:
_L1170:
    JMP  _L1167
_L1168:
    LI   R5, _STR_117
_L1162:
udp_send:
    LI   R6, 512
    JZ   R5, _L1174
    JMP  _L1173
    JMP  _L1175
_L1174:
_L1175:
    LI   R28, 527
    LI   R7, 17
_L1173:
dns_encode_name:
    JZ   R5, _L1177
    JMP  _L1176
    JMP  _L1178
_L1177:
_L1178:
_L1179:
    JZ   R5, _L1180
    LI   R6, 46
    JZ   R5, _L1181
    JZ   R5, _L1183
    JZ   R5, _L1185
    JMP  _L1180
    JMP  _L1186
_L1185:
_L1186:
    JMP  _L1179
    JMP  _L1184
_L1183:
_L1184:
    CMPLE  R5, R8, R5
    JZ   R5, _L1187
    JMP  _L1188
_L1187:
_L1188:
_L1189:
    JZ   R5, _L1192
    JMP  _L1190
_L1191:
    JMP  _L1189
_L1190:
    JMP  _L1191
_L1192:
    JZ   R5, _L1193
    JMP  _L1194
_L1193:
_L1194:
    JMP  _L1182
_L1181:
_L1182:
_L1180:
    JZ   R5, _L1195
    JMP  _L1196
_L1195:
_L1196:
_L1176:
dns_resolve:
    STORE R5, R29, 1028
    JZ   R5, _L1198
    JMP  _L1197
    JMP  _L1199
_L1198:
_L1199:
    STORE R6, R29, 1037
    LI   R28, 1033
    LI   R28, 1034
    LI   R28, 1035
    LI   R28, 1036
    SUB  R13, R0, R13
    STORE R13, R11, 0
    STORE R13, R9, 0
    STORE R13, R7, 0
    STORE R13, R5, 0
_L1200:
    LI   R28, 1037
    LI   R6, 48
    LI   R7, 57
    JZ   R5, _L1201
    JMP  _L1200
_L1201:
    JZ   R5, _L1202
_L1204:
    JZ   R5, _L1205
    JMP  _L1204
_L1205:
    JMP  _L1203
_L1202:
_L1203:
    LI   R7, 46
    JZ   R5, _L1206
_L1208:
    JZ   R5, _L1209
    JMP  _L1208
_L1209:
    JMP  _L1207
_L1206:
_L1207:
    JZ   R5, _L1210
_L1212:
    JZ   R5, _L1213
    JMP  _L1212
_L1213:
    JMP  _L1211
_L1210:
_L1211:
    JZ   R5, _L1214
    SHL  R7, R7, R8
    OR  R7, R7, R9
    JMP  _L1215
_L1214:
_L1215:
    JZ   R5, _L1216
    LI   R5, _STR_118
    JMP  _L1217
_L1216:
_L1217:
    LI   R28, 1032
    JZ   R8, _L1218
    LI   R9, net
    JMP  _L1219
_L1218:
    LI   R10, 24
    SHL  R9, R9, R10
    LI   R11, 16
    SHL  R10, R10, R11
    LI   R11, 8
_L1219:
    LI   R28, 1028
    LI   R8, 171
    LI   R8, 205
    LI   R28, 1029
    LI   R11, 512
    LI   R28, dns_encode_name
    JZ   R5, _L1220
    JMP  _L1221
_L1220:
_L1221:
    LI   R7, 5300
    LI   R8, 53
    LI   R28, udp_send
    JZ   R5, _L1222
    LI   R5, _STR_119
    JMP  _L1223
_L1222:
_L1223:
    LI   R28, 1030
_L1224:
    JZ   R5, _L1227
    JMP  _L1225
_L1226:
    JMP  _L1224
_L1225:
    LI   R28, 1031
    LI   R28, 516
    LI   R8, 512
    JZ   R5, _L1228
    JMP  _L1226
    JMP  _L1229
_L1228:
_L1229:
    JZ   R5, _L1230
    JMP  _L1231
_L1230:
_L1231:
    STORE R5, R29, 1038
    LI   R28, 1038
    STORE R5, R29, 1039
    SHL  R6, R6, R7
    OR  R6, R6, R9
    STORE R6, R29, 1040
    LI   R28, 1039
    STORE R6, R29, 1041
    LI   R28, 1040
    LI   R6, 53
    JZ   R5, _L1232
    JMP  _L1233
_L1232:
_L1233:
    LI   R28, 1041
    LI   R6, 43981
    JZ   R5, _L1234
    JMP  _L1235
_L1234:
_L1235:
    LI   R28, 1042
    LI   R11, 7
    OR  R8, R8, R11
    JZ   R5, _L1236
    LI   R5, _STR_120
    JMP  _L1237
_L1236:
_L1237:
    LI   R28, 1043
_L1238:
    CMPNE  R7, R7, R9
    JZ   R5, _L1239
    LI   R8, 192
    AND  R6, R6, R8
    JZ   R6, _L1240
    JMP  _L1241
_L1240:
_L1241:
    ADD  R10, R6, R8
    JMP  _L1238
_L1239:
_L1242:
    JZ   R5, _L1243
    JZ   R6, _L1244
    JMP  _L1245
_L1244:
_L1246:
    JZ   R8, _L1247
    JMP  _L1246
_L1247:
_L1245:
    LI   R28, 1044
    LI   R28, 1045
    JZ   R5, _L1248
    LI   R14, 2
    ADD  R13, R13, R14
    LI   R13, 8
    SHL  R12, R12, R13
    LI   R15, 3
    OR  R8, R8, R14
    LI   R5, _STR_121
    ADD  R17, R18, R0
    LI   R18, 2
    ADD  R17, R17, R18
    ADD  R16, R16, R17
    ADD  R18, R29, R28
    ADD  R20, R29, R28
    LOAD R21, R20, 0
    ADD  R20, R21, R0
    LI   R21, 3
    ADD  R20, R20, R21
    JMP  _L1249
_L1248:
_L1249:
    JMP  _L1242
_L1243:
_L1227:
    LI   R5, _STR_122
_L1197:
parse_url:
    LI   R7, 104
    LI   R9, 116
    LI   R10, 116
    AND   R6, R6, R9
    LI   R11, 3
    LI   R11, 112
    CMPEQ  R10, R10, R11
    AND   R6, R6, R10
    LI   R12, 4
    LI   R12, 58
    CMPEQ  R11, R11, R12
    CMPNE R11, R11, R0
    AND   R6, R6, R11
    LI   R13, 5
    LI   R13, 47
    CMPEQ  R12, R12, R13
    CMPNE R12, R12, R0
    AND   R6, R6, R12
    LI   R14, 6
    LI   R14, 47
    CMPEQ  R13, R13, R14
    CMPNE R13, R13, R0
    AND   R6, R6, R13
    JZ   R6, _L1251
    JMP  _L1252
_L1251:
    LI   R12, 115
    LI   R13, 58
    LI   R15, 7
    LI   R15, 47
    CMPEQ  R14, R14, R15
    CMPNE R14, R14, R0
    AND   R6, R6, R14
    JZ   R6, _L1253
    LI   R7, 443
    JMP  _L1254
_L1253:
_L1254:
_L1252:
_L1255:
    LI   R8, 47
    CMPNE  R7, R7, R8
    LI   R8, 58
    JZ   R5, _L1258
    JMP  _L1256
_L1257:
    JMP  _L1255
_L1256:
    ADD  R12, R10, R11
    STORE R12, R9, 0
    JMP  _L1257
_L1258:
    LI   R6, 58
    JZ   R5, _L1259
_L1261:
    JZ   R5, _L1262
    JMP  _L1261
_L1262:
    JMP  _L1260
_L1259:
_L1260:
    LI   R6, 47
    JZ   R5, _L1263
_L1265:
    JZ   R5, _L1268
    JMP  _L1266
_L1267:
    JMP  _L1265
_L1266:
    JMP  _L1267
_L1268:
    JMP  _L1264
_L1263:
_L1264:
    JZ   R6, _L1269
    JMP  _L1270
_L1269:
_L1270:
    JMP  _L1250
_L1250:
http_get:
    JZ   R5, _L1272
    JMP  _L1271
    JMP  _L1273
_L1272:
_L1273:
    JZ   R5, _L1274
    LI   R5, _STR_123
    JMP  _L1275
_L1274:
_L1275:
    LI   R8, 128
    LI   R28, 901
    LI   R28, 133
    LI   R11, 256
    LI   R28, parse_url
    JZ   R5, _L1276
    LI   R5, _STR_124
    JMP  _L1277
_L1276:
_L1277:
    LI   R28, 902
    LI   R28, dns_resolve
    JZ   R5, _L1278
    LI   R5, _STR_125
    JMP  _L1279
_L1278:
_L1279:
    LI   R28, 903
    LI   R11, 10080
    LI   R28, tcp_connect
    JZ   R5, _L1280
    LI   R5, _STR_126
    JMP  _L1281
_L1280:
_L1281:
    LI   R28, 904
    LI   R5, _STR_127
    STORE R5, R29, 908
    LI   R5, _STR_128
    STORE R5, R29, 909
    LI   R5, _STR_129
    STORE R5, R29, 910
    LI   R28, 911
    LI   R28, 908
_L1282:
    JZ   R6, _L1285
    JMP  _L1283
_L1284:
    JMP  _L1282
_L1283:
    LI   R28, 389
    JMP  _L1284
_L1285:
_L1286:
    JZ   R6, _L1289
    JMP  _L1287
_L1288:
    JMP  _L1286
_L1287:
    JMP  _L1288
_L1289:
    LI   R28, 909
_L1290:
    JZ   R6, _L1293
    JMP  _L1291
_L1292:
    JMP  _L1290
_L1291:
    JMP  _L1292
_L1293:
_L1294:
    JZ   R6, _L1297
    JMP  _L1295
_L1296:
    JMP  _L1294
_L1295:
    JMP  _L1296
_L1297:
    LI   R28, 910
_L1298:
    JZ   R6, _L1301
    JMP  _L1299
_L1300:
    JMP  _L1298
_L1299:
    JMP  _L1300
_L1301:
    LI   R28, tcp_send
    JZ   R5, _L1302
    LI   R5, _STR_130
    LI   R28, tcp_close
    JMP  _L1303
_L1302:
_L1303:
    LI   R28, 905
    LI   R28, 907
_L1304:
    LI   R6, 2000
    JZ   R5, _L1307
    JMP  _L1305
_L1306:
    JMP  _L1304
_L1305:
    LI   R28, 906
    LI   R12, 1
    LI   R28, tcp_recv
    JZ   R5, _L1308
    JMP  _L1307
    JMP  _L1309
_L1308:
_L1309:
    JZ   R5, _L1310
    JMP  _L1311
_L1310:
_L1311:
    JMP  _L1306
_L1307:
    LI   R5, _STR_131
_L1271:
http_get_print:
    LI   R8, 2048
    LI   R28, http_get
    STORE R5, R29, 2051
    LI   R28, 2051
    JZ   R5, _L1313
    JMP  _L1312
    JMP  _L1314
_L1313:
_L1314:
    STORE R5, R29, 2052
    LI   R28, 2053
_L1315:
    JZ   R5, _L1318
    JMP  _L1316
_L1317:
    JMP  _L1315
_L1316:
    JZ   R6, _L1319
    LI   R28, 2052
    JMP  _L1318
    JMP  _L1320
_L1319:
_L1320:
    JMP  _L1317
_L1318:
    LI   R5, _STR_132
_L1312:
perms_init:
_L1322:
    JZ   R5, _L1325
    JMP  _L1323
_L1324:
    JMP  _L1322
_L1323:
    LI   R5, perms
    JMP  _L1324
_L1325:
_L1321:
perms_register:
_L1327:
    JZ   R5, _L1330
    JMP  _L1328
_L1329:
    JMP  _L1327
_L1328:
    LI   R7, perms
    JZ   R5, _L1331
    JMP  _L1326
    JMP  _L1332
_L1331:
_L1332:
    JMP  _L1329
_L1330:
_L1333:
    JZ   R5, _L1336
    JMP  _L1334
_L1335:
    JMP  _L1333
_L1334:
    JZ   R5, _L1337
    LI   R10, perms
    JMP  _L1338
_L1337:
_L1338:
    JMP  _L1335
_L1336:
_L1326:
check_permission:
    JZ   R5, _L1340
    JMP  _L1339
    JMP  _L1341
_L1340:
_L1341:
_L1342:
    JZ   R5, _L1345
    JMP  _L1343
_L1344:
    JMP  _L1342
_L1343:
    JZ   R5, _L1346
    LI   R6, perms
    LI   R8, perms
    AND  R8, R8, R11
    JZ   R5, _L1348
    JMP  _L1349
_L1348:
_L1349:
    JMP  _L1347
_L1346:
_L1347:
    JMP  _L1344
_L1345:
_L1339:
rtc_port_read:
    JMP  _L1350
_L1350:
rtc_port_write:
_L1351:
rtc_init:
    LI   R28, rtc_port_write
    LI   R5, _STR_133
_L1352:
rtc_read:
    LI   R28, rtc_port_read
    LI   R7, 97
    LI   R7, 98
    LI   R7, 99
    LI   R7, 100
    LI   R7, 101
    LI   R7, 2000
    LI   R8, 102
    LI   R6, 59
    JZ   R5, _L1354
    JMP  _L1355
_L1354:
_L1355:
    JZ   R5, _L1356
    JMP  _L1357
_L1356:
_L1357:
    LI   R6, 23
    JZ   R5, _L1358
    JMP  _L1359
_L1358:
_L1359:
    JZ   R5, _L1360
    JMP  _L1361
_L1360:
_L1361:
    JZ   R5, _L1362
    JMP  _L1363
_L1362:
_L1363:
    JZ   R5, _L1364
    JMP  _L1365
_L1364:
_L1365:
    LI   R7, 2099
    JZ   R5, _L1366
    LI   R7, 2025
    JMP  _L1367
_L1366:
_L1367:
_L1353:
rtc_timestamp:
    LI   R5, 31
    LI   R5, 28
    LI   R5, 30
    LI   R28, rtc_read
    LI   R28, 23
    LI   R8, 2000
    LI   R8, 365
    LI   R9, 4
    LI   R28, 24
_L1369:
    JZ   R5, _L1372
    JMP  _L1370
_L1371:
    JMP  _L1369
_L1370:
    JMP  _L1371
_L1372:
    JZ   R5, _L1373
    JMP  _L1374
_L1373:
_L1374:
    LI   R6, 86400
    MUL  R5, R5, R6
    LI   R7, 3600
    LI   R7, 60
    JMP  _L1368
_L1368:
rtc_format:
    LI   R28, 29
    LI   R8, 48
    LI   R10, 1000
    LI   R10, 100
    LI   R28, WCHAR
    LI   R28, WDIGIT2
    LI   R5, 58
_L1375:
scheduler_init:
_L1377:
    JZ   R5, _L1380
    JMP  _L1378
_L1379:
    JMP  _L1377
_L1378:
    LI   R8, 16384
    LI   R10, 1024
    JMP  _L1379
_L1380:
_L1376:
scheduler:
_L1382:
    JZ   R5, _L1385
    JMP  _L1383
_L1384:
    JMP  _L1382
_L1383:
    JZ   R5, _L1386
    CMPLT  R5, R8, R5
    JZ   R5, _L1388
    JMP  _L1389
_L1388:
_L1389:
    JMP  _L1387
_L1386:
_L1387:
    JMP  _L1384
_L1385:
    JZ   R5, _L1390
_L1392:
    JZ   R5, _L1395
    JMP  _L1393
_L1394:
    JMP  _L1392
_L1393:
    JZ   R5, _L1396
    JMP  _L1395
    JMP  _L1397
_L1396:
_L1397:
    JMP  _L1394
_L1395:
    JMP  _L1391
_L1390:
_L1391:
    JZ   R5, _L1398
    LI   R28, context_switch
    JMP  _L1399
_L1398:
_L1399:
_L1381:
context_switch:
    LI   R6, process_table
    JZ   R5, _L1401
    JMP  _L1402
_L1401:
_L1402:
    LI   R5, context_switches
_L1400:
scheduler_run:
_L1404:
    JZ   R5, _L1405
    JMP  _L1404
_L1405:
_L1403:
process_create:
_L1407:
    JZ   R5, _L1410
    JMP  _L1408
_L1409:
    JMP  _L1407
_L1408:
    JZ   R5, _L1411
    JMP  _L1410
    JMP  _L1412
_L1411:
_L1412:
    JMP  _L1409
_L1410:
    JZ   R5, _L1413
    JMP  _L1406
    JMP  _L1414
_L1413:
_L1414:
    LI   R7, 16384
    LI   R9, 1024
    LI   R28, 44
    LI   R8, 31
_L1406:
process_run_now:
    JZ   R5, _L1416
    JMP  _L1415
    JMP  _L1417
_L1416:
_L1417:
    JZ   R5, _L1418
    JMP  _L1419
_L1418:
_L1419:
    JALR R31, R7, 0
    JZ   R5, _L1420
    JMP  _L1421
_L1420:
_L1421:
_L1415:
process_kill:
    JZ   R5, _L1423
    JMP  _L1424
_L1423:
_L1424:
_L1422:
get_current_pid:
    JMP  _L1425
_L1425:
cmd_help:
    LI   R5, _STR_134
    LI   R5, _STR_135
    LI   R5, _STR_136
    LI   R5, _STR_137
    LI   R5, _STR_138
    LI   R5, _STR_139
    LI   R5, _STR_140
    LI   R5, _STR_141
    LI   R5, _STR_142
    LI   R5, _STR_143
    LI   R5, _STR_144
    LI   R5, _STR_145
    LI   R5, _STR_146
    LI   R5, _STR_147
    LI   R5, _STR_148
    LI   R5, _STR_149
    LI   R5, _STR_150
    LI   R5, _STR_151
    LI   R5, _STR_152
    LI   R5, _STR_153
    LI   R5, _STR_154
    LI   R5, _STR_155
    LI   R5, _STR_156
    LI   R5, _STR_157
    LI   R5, _STR_158
    LI   R5, _STR_159
    LI   R5, _STR_160
    LI   R5, _STR_161
    LI   R5, _STR_162
    LI   R5, _STR_163
    LI   R5, _STR_164
    LI   R5, _STR_165
    LI   R5, _STR_166
    LI   R5, _STR_167
    JMP  _L1432
_L1432:
cmd_ps:
    LI   R5, _STR_168
    LI   R5, _STR_169
    LI   R28, 387
_L1434:
    JZ   R5, _L1437
    JMP  _L1435
_L1436:
    JMP  _L1434
_L1435:
    JZ   R5, _L1438
    LI   R28, 388
    LI   R7, _STR_170
    JMP  _L1440
    LI   R7, _STR_171
    LI   R7, _STR_172
    LI   R7, _STR_173
    LI   R7, _STR_174
_L1440:
    LI   R5, _STR_175
    JMP  _L1439
_L1438:
_L1439:
    JMP  _L1436
_L1437:
    LI   R5, _STR_176
    LI   R28, 386
    JMP  _L1433
_L1433:
cmd_kill:
    LI   R5, _STR_177
    JMP  _L1441
_L1441:
cmd_clear:
    JMP  _L1442
_L1442:
cmd_gui:
    LI   R7, _STR_178
    JZ   R5, _L1444
    JZ   R5, _L1446
    JMP  _L1443
    JMP  _L1447
_L1446:
_L1447:
    LI   R5, _STR_179
    JZ   R7, _L1448
    LI   R8, _STR_180
    JMP  _L1449
_L1448:
    LI   R8, _STR_181
_L1449:
    LI   R5, _STR_182
    LI   R5, _STR_183
    LI   R8, 4096
    LI   R5, _STR_184
    JMP  _L1445
_L1444:
_L1445:
    LI   R7, _STR_185
    JZ   R5, _L1450
    JMP  _L1451
_L1450:
_L1451:
    LI   R5, _STR_186
_L1443:
cmd_perf:
    LI   R5, _STR_187
    LI   R5, _STR_188
    LI   R5, _STR_189
    JMP  _L1452
_L1452:
simple_atoi:
    LI   R6, 45
    JZ   R5, _L1454
    JMP  _L1455
_L1454:
_L1455:
_L1456:
    JZ   R5, _L1457
    JMP  _L1456
_L1457:
    JMP  _L1453
_L1453:
split_args:
_L1459:
    CMPLT  R6, R6, R8
    JZ   R5, _L1460
_L1461:
    JZ   R5, _L1462
    JMP  _L1461
_L1462:
    JZ   R5, _L1463
    JMP  _L1460
    JMP  _L1464
_L1463:
_L1464:
_L1465:
    JZ   R5, _L1466
    JMP  _L1465
_L1466:
    JZ   R6, _L1467
    JMP  _L1468
_L1467:
_L1468:
    JMP  _L1459
_L1460:
    JMP  _L1458
_L1458:
shell_main:
    LI   R5, _STR_190
    LI   R6, current_uid
    LI   R28, auth_username
    LI   R5, _STR_191
_L1470:
    JZ   R5, _L1471
    LI   R28, shell_prompt
    JMP  _L1470
_L1471:
_L1469:
shell_prompt:
    LI   R5, _STR_192
_L1473:
    JZ   R5, _L1474
    JZ   R5, _L1475
    LI   R5, command_buffer
    JMP  _L1474
    JMP  _L1476
_L1475:
    JZ   R5, _L1477
    JMP  _L1478
_L1477:
    JZ   R5, _L1479
    JMP  _L1480
_L1479:
_L1480:
_L1478:
_L1476:
    JMP  _L1473
_L1474:
    JZ   R5, _L1481
    LI   R5, history
    LI   R6, history_idx
    LI   R6, command_buffer
    LI   R5, history_idx
    JMP  _L1482
_L1481:
_L1482:
    LI   R28, shell_parse_command
_L1472:
shell_parse_command:
    JZ   R5, _L1484
    JMP  _L1483
    JMP  _L1485
_L1484:
_L1485:
    LI   R6, _STR_193
    JZ   R5, _L1486
    LI   R28, cmd_help
    JMP  _L1487
_L1486:
_L1487:
    LI   R6, _STR_194
    JZ   R5, _L1488
    LI   R28, cmd_ps
    JMP  _L1489
_L1488:
_L1489:
    LI   R6, _STR_195
    JZ   R5, _L1490
    LI   R28, cmd_clear
    JMP  _L1491
_L1490:
_L1491:
    LI   R6, _STR_196
    JZ   R5, _L1492
    LI   R28, cmd_perf
    JMP  _L1493
_L1492:
_L1493:
    LI   R6, _STR_197
    LI   R28, kstrncmp
    JZ   R5, _L1494
    LI   R28, cmd_gui
    JMP  _L1495
_L1494:
_L1495:
    LI   R6, _STR_8
    JZ   R5, _L1496
    LI   R5, _STR_8
    LI   R28, app_launch
    JZ   R5, _L1498
    JMP  _L1499
_L1498:
_L1499:
    JMP  _L1497
_L1496:
_L1497:
    LI   R6, _STR_10
    JZ   R5, _L1500
    LI   R5, _STR_10
    JZ   R5, _L1502
    JMP  _L1503
_L1502:
_L1503:
    JMP  _L1501
_L1500:
_L1501:
    LI   R6, _STR_12
    JZ   R5, _L1504
    LI   R5, _STR_12
    JZ   R5, _L1506
    JMP  _L1507
_L1506:
_L1507:
    JMP  _L1505
_L1504:
_L1505:
    LI   R6, _STR_198
    JZ   R5, _L1508
    LI   R28, simple_atoi
    STORE R5, R29, 72
    LI   R28, 72
    LI   R28, cmd_kill
    JMP  _L1509
_L1508:
_L1509:
    LI   R6, _STR_199
    JZ   R5, _L1510
    LI   R28, 73
    LI   R28, 71
    LI   R28, 67
    LI   R28, split_args
    LI   R8, _STR_200
    JZ   R5, _L1512
    LI   R28, app_list
    JMP  _L1513
_L1512:
_L1513:
    LI   R8, _STR_201
    JZ   R5, _L1514
    JZ   R5, _L1516
    JMP  _L1517
_L1516:
_L1517:
    JMP  _L1515
_L1514:
_L1515:
    LI   R8, _STR_202
    JZ   R5, _L1518
    LI   R28, app_install
    JZ   R5, _L1520
    JMP  _L1521
_L1520:
_L1521:
    JMP  _L1519
_L1518:
_L1519:
    LI   R5, _STR_203
    JMP  _L1511
_L1510:
_L1511:
    LI   R6, _STR_204
    JZ   R5, _L1522
    LI   R28, fs_list
    JMP  _L1523
_L1522:
_L1523:
    LI   R6, _STR_205
    JZ   R5, _L1524
    LI   R28, 137
    LI   R8, current_uid
    LI   R28, fs_read
    STORE R5, R29, 4234
    LI   R28, 4234
    JZ   R5, _L1526
    LI   R5, _STR_206
    JMP  _L1527
_L1526:
_L1527:
    JMP  _L1525
_L1524:
_L1525:
    LI   R6, _STR_207
    JZ   R5, _L1528
    LI   R28, 4235
    JZ   R5, _L1530
    LI   R5, _STR_208
    JMP  _L1531
_L1530:
_L1531:
    ADD  R1, R10, R0
    LI   R28, kstrlen
    LI   R10, current_uid
    JMP  _L1529
_L1528:
_L1529:
    LI   R6, _STR_209
    JZ   R5, _L1532
    LI   R28, fs_delete
    JZ   R5, _L1534
    LI   R5, _STR_210
    JMP  _L1535
_L1534:
_L1535:
    LI   R5, _STR_211
    JMP  _L1533
_L1532:
_L1533:
    LI   R6, _STR_212
    JZ   R5, _L1536
    LI   R5, _STR_213
    LI   R7, current_uid
    JMP  _L1537
_L1536:
_L1537:
    LI   R6, _STR_214
    JZ   R5, _L1538
    LI   R28, auth_set_password
    LI   R5, _STR_215
    JMP  _L1539
_L1538:
_L1539:
    LI   R6, _STR_216
    JZ   R5, _L1540
    LI   R5, _STR_217
    JZ   R5, _L1542
    LI   R5, _STR_218
_L1544:
    JZ   R5, _L1545
    JMP  _L1544
_L1545:
    JMP  _L1543
_L1542:
_L1543:
    JMP  _L1541
_L1540:
_L1541:
    LI   R6, _STR_219
    JZ   R5, _L1546
    LI   R28, wm_set_theme
    JMP  _L1547
_L1546:
_L1547:
    LI   R6, _STR_220
    JZ   R5, _L1548
    LI   R28, 4299
    JZ   R5, _L1550
    LI   R5, _STR_221
    JMP  _L1551
_L1550:
_L1551:
    LI   R28, mouse_move
    LI   R5, _STR_222
    JMP  _L1549
_L1548:
_L1549:
    LI   R6, _STR_223
    JZ   R5, _L1552
    LI   R28, mouse_button
    LI   R5, _STR_224
    JMP  _L1553
_L1552:
_L1553:
    LI   R6, _STR_225
    LI   R7, _STR_226
    JZ   R5, _L1554
    LI   R5, _STR_227
_L1556:
    JZ   R5, _L1557
    JMP  _L1556
_L1557:
    JMP  _L1555
_L1554:
_L1555:
    LI   R6, _STR_228
    JZ   R5, _L1558
    STORE R5, R29, 4363
    LI   R28, 4363
    LI   R5, _STR_229
    JMP  _L1559
_L1558:
_L1559:
    LI   R6, _STR_230
    JZ   R5, _L1560
    LI   R28, 4364
    JZ   R5, _L1562
    LI   R5, _STR_231
    JMP  _L1563
_L1562:
_L1563:
    STORE R5, R29, 4428
    STORE R5, R29, 4429
    LI   R28, 4428
    LI   R28, 4429
    LI   R5, _STR_232
    JMP  _L1561
_L1560:
_L1561:
    LI   R6, _STR_233
    JZ   R5, _L1564
    LI   R28, 4430
    LI   R28, 4437
    LI   R28, rtc_format
    LI   R28, 4469
    LI   R28, 4470
    LI   R5, _STR_234
    LI   R5, _STR_235
    JMP  _L1565
_L1564:
_L1565:
    LI   R6, _STR_236
    JZ   R5, _L1566
    STORE R5, R29, 4471
    LI   R28, 4471
    JZ   R5, _L1568
    LI   R5, _STR_237
    JMP  _L1569
_L1568:
    LI   R5, _STR_238
_L1569:
    JMP  _L1567
_L1566:
_L1567:
    LI   R6, _STR_239
    JZ   R5, _L1570
    LI   R5, _STR_240
    LI   R5, _STR_241
    JMP  _L1571
_L1570:
_L1571:
    LI   R6, _STR_242
    JZ   R5, _L1572
    LI   R28, 4472
    LI   R9, 3
    LI   R8, _STR_243
    JZ   R5, _L1574
    LI   R28, wifi_scan
    LI   R28, wifi_print_scan
    JMP  _L1575
_L1574:
_L1575:
    LI   R8, _STR_178
    JZ   R5, _L1576
    LI   R28, wifi_status
    JMP  _L1577
_L1576:
_L1577:
    LI   R8, _STR_244
    JZ   R5, _L1578
    LI   R28, wifi_disconnect
    JMP  _L1579
_L1578:
_L1579:
    LI   R8, _STR_245
    JZ   R5, _L1580
    JZ   R5, _L1582
    JMP  _L1583
_L1582:
    LI   R6, _STR_68
_L1583:
    STORE R5, R29, 4536
    LI   R28, 4536
    LI   R28, wifi_connect
    JMP  _L1581
_L1580:
_L1581:
    LI   R5, _STR_246
    JMP  _L1573
_L1572:
_L1573:
    LI   R6, _STR_247
    JZ   R5, _L1584
    LI   R6, _STR_248
    JZ   R5, _L1586
    LI   R28, 4539
    LI   R28, get_current_pid
    LI   R28, 4537
    LI   R28, 4538
    LI   R28, pipe_create
    JZ   R5, _L1588
    LI   R5, _STR_249
    JMP  _L1589
_L1588:
_L1589:
    LI   R7, _STR_250
    LI   R8, 19
    LI   R28, pipe_write
    LI   R28, 4540
    LI   R28, 4541
    LI   R10, 64
    LI   R28, pipe_read
    JZ   R6, _L1590
    JMP  _L1591
_L1590:
_L1591:
    LI   R5, _STR_251
    LI   R28, pipe_close
    JMP  _L1587
_L1586:
_L1587:
    LI   R5, _STR_252
    JMP  _L1585
_L1584:
_L1585:
    LI   R6, _STR_253
    JZ   R5, _L1592
    LI   R28, syslog_dump
    JMP  _L1593
_L1592:
_L1593:
    LI   R5, _STR_254
_L1483:
valid_mask:
    LI   R5, active_cores
    JZ   R5, _L1595
    JMP  _L1594
    JMP  _L1596
_L1595:
_L1596:
    JZ   R5, _L1597
    JMP  _L1598
_L1597:
    LI   R7, active_cores
_L1598:
_L1594:
smp_init:
    JZ   R5, _L1600
    JMP  _L1601
_L1600:
_L1601:
    JZ   R5, _L1602
    JMP  _L1603
_L1602:
_L1603:
    JZ   R5, _L1604
    JMP  _L1605
_L1604:
_L1605:
    LI   R5, stats
    LI   R5, active_core
_L1606:
    JZ   R5, _L1609
    JMP  _L1607
_L1608:
    JMP  _L1606
_L1607:
    LI   R5, cores
    LI   R9, active_cores
    CMPLT  R8, R8, R10
    JZ   R8, _L1610
    JMP  _L1611
_L1610:
    LI   R10, 0
_L1611:
    JMP  _L1608
_L1609:
_L1599:
smp_online_count:
    JMP  _L1612
_L1612:
smp_online_mask:
    LI   R28, valid_mask
    JMP  _L1613
_L1613:
smp_core_online:
    LI   R6, active_cores
    LI   R7, cores
    JMP  _L1614
_L1614:
smp_current_core:
    JMP  _L1615
_L1615:
smp_set_current_core:
    LI   R28, smp_core_online
    JZ   R5, _L1617
    JMP  _L1616
    JMP  _L1618
_L1617:
_L1618:
_L1616:
smp_pick_core:
    JZ   R5, _L1620
    JMP  _L1619
    JMP  _L1621
_L1620:
_L1621:
_L1622:
    JZ   R5, _L1625
    JMP  _L1623
_L1624:
    JMP  _L1622
_L1623:
    JZ   R5, _L1626
    JMP  _L1624
    JMP  _L1627
_L1626:
_L1627:
    JZ   R5, _L1628
    JMP  _L1629
_L1628:
_L1629:
_L1625:
    JZ   R5, _L1630
    JMP  _L1631
_L1630:
_L1631:
_L1619:
smp_dispatch:
    JZ   R5, _L1633
    JMP  _L1632
    JMP  _L1634
_L1633:
_L1634:
    CMPNE  R5, R5, R8
    JZ   R5, _L1635
    JMP  _L1636
_L1635:
_L1636:
_L1632:
smp_account_tick:
    JZ   R5, _L1638
    JMP  _L1637
    JMP  _L1639
_L1638:
_L1639:
    JZ   R5, _L1640
    JMP  _L1641
_L1640:
_L1641:
_L1637:
smp_send_ipi:
    JZ   R5, _L1643
    JMP  _L1642
    JMP  _L1644
_L1643:
_L1644:
    OR   R9, R7, R8
_L1642:
smp_handle_ipi:
    JZ   R5, _L1646
    JMP  _L1645
    JMP  _L1647
_L1646:
_L1647:
    JZ   R5, _L1648
    JMP  _L1649
_L1648:
_L1649:
_L1645:
smp_get_core_info:
    JZ   R5, _L1651
    JMP  _L1650
    JMP  _L1652
_L1651:
_L1652:
_L1650:
smp_get_stats:
    JZ   R5, _L1654
    JMP  _L1653
    JMP  _L1655
_L1654:
_L1655:
    LI   R7, stats
_L1653:
snd_write:
_L1656:
snd_read:
    JMP  _L1657
_L1657:
sound_init:
    LI   R5, 64
    LI   R28, snd_write
    LI   R5, 68
    LI   R6, 200
    LI   R5, _STR_255
_L1658:
sound_beep:
    LI   R5, 65
    LI   R5, 66
    SHR  R6, R6, R7
    LI   R5, 67
_L1659:
sound_stop:
_L1660:
sound_is_playing:
    LI   R5, 69
    LI   R28, snd_read
    JMP  _L1661
_L1661:
sound_set_volume:
_L1662:
sound_play_note:
    JZ   R5, _L1664
    JMP  _L1665
_L1664:
_L1665:
    JZ   R5, _L1666
    JMP  _L1667
_L1666:
_L1667:
    JZ   R5, _L1668
    JMP  _L1669
_L1668:
    JZ   R5, _L1670
    JMP  _L1671
_L1670:
_L1671:
_L1669:
    LI   R6, 65535
    JZ   R5, _L1672
    LI   R7, 65535
    JMP  _L1673
_L1672:
_L1673:
    JZ   R5, _L1674
    JMP  _L1675
_L1674:
_L1675:
    LI   R28, sound_beep
_L1663:
sound_sfx:
    LI   R6, 120
    JMP  _L1677
    LI   R5, 800
    LI   R6, 30
_L1677:
_L1676:
sound_play_melody:
_L1679:
    JZ   R5, _L1682
    JMP  _L1680
_L1681:
    JMP  _L1679
_L1680:
    JZ   R5, _L1683
    LI   R28, sound_stop
    JMP  _L1684
_L1683:
_L1684:
_L1685:
    JZ   R5, _L1686
    JMP  _L1685
_L1686:
    JMP  _L1681
_L1682:
_L1678:
spin_init:
_L1687:
spin_lock:
_L1693:
    LI   R28, ATOMIC_CAS
    JZ   R5, _L1694
    JMP  _L1693
_L1694:
_L1692:
spin_unlock:
    LI   R28, ATOMIC_STORE
_L1695:
spin_trylock:
    JMP  _L1696
_L1696:
ipi_send:
    LI   R28, smp_send_ipi
_L1697:
slog_vformat:
_L1699:
    JZ   R5, _L1700
    LI   R6, 37
    JZ   R5, _L1701
    LI   R28, SPUT
    JMP  _L1699
    JMP  _L1702
_L1701:
_L1702:
    LI   R5, 0 ; va_arg compatibility value
    JZ   R5, _L1704
    LI   R7, _STR_261
    JMP  _L1705
_L1704:
_L1705:
_L1706:
    JZ   R5, _L1707
    JMP  _L1706
_L1707:
    JMP  _L1703
    JZ   R5, _L1708
    JMP  _L1709
_L1708:
_L1709:
    JZ   R5, _L1710
    JMP  _L1711
_L1710:
_L1711:
_L1712:
    JZ   R6, _L1713
    LI   R28, 25
    JMP  _L1712
_L1713:
_L1714:
    JZ   R6, _L1715
    JMP  _L1714
_L1715:
    LI   R28, 26
    JZ   R5, _L1716
    JMP  _L1717
_L1716:
_L1717:
_L1718:
    JZ   R6, _L1719
    LI   R28, 27
    JMP  _L1718
_L1719:
_L1720:
    JZ   R6, _L1721
    JMP  _L1720
_L1721:
    STORE R5, R29, 61
    LI   R5, _STR_262
    STORE R5, R29, 62
    JZ   R5, _L1722
    JMP  _L1723
_L1722:
_L1723:
_L1724:
    JZ   R6, _L1725
    LI   R28, 45
    LI   R28, 61
    LI   R28, 62
    LI   R11, 15
    AND  R10, R10, R11
    SHR  R8, R6, R7
    JMP  _L1724
_L1725:
_L1726:
    JZ   R6, _L1727
    JMP  _L1726
_L1727:
    LI   R5, 37
    LI   R5, 63
_L1703:
_L1700:
    JMP  _L1698
_L1698:
slog_strncpy:
_L1729:
    JZ   R5, _L1730
    JMP  _L1729
_L1730:
_L1728:
syslog_init:
    LI   R5, slog_head
    LI   R5, slog_total
    LI   R6, _STR_263
    LI   R7, _STR_264
    LI   R28, klog
_L1731:
klog:
    JZ   R5, _L1733
    JMP  _L1734
_L1733:
_L1734:
    LI   R7, slog_buf
    LI   R8, slog_head
    LI   R28, 94
    LI   R8, total_ticks
    JZ   R9, _L1735
    JMP  _L1736
_L1735:
    LI   R10, _STR_265
_L1736:
    LI   R10, 12
    LI   R28, slog_strncpy
    LI   R28, va_start
    LI   R8, 80
    LI   R28, slog_vformat
    LI   R28, va_end
    LI   R7, slog_head
    JZ   R5, _L1737
    LI   R5, _STR_266
    LI   R6, level_str
    JMP  _L1738
_L1737:
_L1738:
_L1732:
print_entry:
    LI   R5, _STR_267
    LI   R8, level_str
    CMPLT  R9, R9, R10
    JZ   R9, _L1740
    JMP  _L1741
_L1740:
    LI   R10, 4
_L1741:
_L1739:
syslog_dump:
    JZ   R5, _L1743
    LI   R6, slog_total
    JMP  _L1744
_L1743:
_L1744:
    LI   R5, _STR_268
    JZ   R8, _L1745
    LI   R9, 115
    JMP  _L1746
_L1745:
_L1746:
    JZ   R5, _L1747
    JMP  _L1742
    JMP  _L1748
_L1747:
_L1748:
    JZ   R5, _L1749
    JMP  _L1750
_L1749:
_L1750:
_L1751:
    JZ   R5, _L1754
    JMP  _L1752
_L1753:
    JMP  _L1751
_L1752:
    LI   R7, 128
    DIV  R8, R5, R7
    LI   R5, slog_buf
    LI   R28, print_entry
    JMP  _L1753
_L1754:
    LI   R5, _STR_269
_L1742:
syslog_dump_last:
    JZ   R5, _L1756
    JMP  _L1757
_L1756:
_L1757:
    JZ   R5, _L1758
    JMP  _L1759
_L1758:
_L1759:
    JZ   R5, _L1760
    JMP  _L1755
    JMP  _L1761
_L1760:
_L1761:
    LI   R5, _STR_270
    LI   R9, 128
    DIV  R10, R7, R9
_L1762:
    JZ   R5, _L1765
    JMP  _L1763
_L1764:
    JMP  _L1762
_L1763:
    JMP  _L1764
_L1765:
_L1755:
syslog_dump_level:
    JZ   R5, _L1767
    JMP  _L1768
_L1767:
_L1768:
    JZ   R5, _L1769
    JMP  _L1770
_L1769:
    LI   R6, slog_head
_L1770:
    LI   R5, _STR_271
    LI   R8, 5
    JZ   R7, _L1771
    JMP  _L1772
_L1771:
_L1772:
_L1773:
    JZ   R5, _L1776
    JMP  _L1774
_L1775:
    JMP  _L1773
_L1774:
    JZ   R5, _L1777
    JMP  _L1778
_L1777:
_L1778:
    JMP  _L1775
_L1776:
_L1766:
syslog_count:
    JZ   R5, _L1780
    JMP  _L1781
_L1780:
_L1781:
    JMP  _L1779
_L1779:
tcp_next_isn:
    LI   R5, tcp_isn_seed
    LI   R7, tcp_isn_seed
    LI   R8, 13
    XOR  R8, R6, R7
    LI   R8, 17
    JMP  _L1782
_L1782:
alloc_conn:
_L1784:
    JZ   R5, _L1787
    JMP  _L1785
_L1786:
    JMP  _L1784
_L1785:
    LI   R5, conns
    LI   R28, 2060
    LI   R28, 2059
    JZ   R5, _L1788
    JMP  _L1783
    JMP  _L1789
_L1788:
_L1789:
    JMP  _L1786
_L1787:
_L1783:
conn_id:
    LI   R6, conns
    JMP  _L1790
_L1790:
tcp_checksum:
_L1792:
    JZ   R5, _L1795
    JMP  _L1793
_L1794:
    JMP  _L1792
_L1793:
    JMP  _L1794
_L1795:
    JZ   R5, _L1796
    JMP  _L1797
_L1796:
_L1797:
_L1798:
    JZ   R5, _L1799
    JMP  _L1798
_L1799:
    JMP  _L1791
_L1791:
tcp_build_segment:
    LI   R5, 20
    JZ   R5, _L1801
    JMP  _L1800
    JMP  _L1802
_L1801:
_L1802:
    LI   R7, 11
    LI   R7, 18
    LI   R7, 19
    JZ   R5, _L1803
    JMP  _L1804
_L1803:
_L1804:
    LI   R28, tcp_checksum
_L1800:
tcp_send_segment:
    LI   R13, 1518
    LI   R28, tcp_build_segment
    STORE R5, R29, 1524
    JZ   R5, _L1806
    JMP  _L1805
    JMP  _L1807
_L1806:
_L1807:
_L1805:
tcp_init:
_L1809:
    JZ   R5, _L1812
    JMP  _L1810
_L1811:
    JMP  _L1809
_L1810:
    LI   R8, 2060
    JMP  _L1811
_L1812:
    LI   R5, _STR_272
_L1808:
tcp_connect:
    LI   R28, alloc_conn
    JZ   R5, _L1814
    LI   R5, _STR_273
    JMP  _L1813
    JMP  _L1815
_L1814:
_L1815:
    LI   R28, tcp_next_isn
    LI   R8, 1024
    LI   R28, 2058
    LI   R28, tcp_send_segment
    JZ   R5, _L1816
    JMP  _L1817
_L1816:
_L1817:
    LI   R5, _STR_274
    LI   R7, 24
    LI   R28, conn_id
_L1813:
tcp_listen:
    JZ   R5, _L1819
    JMP  _L1818
    JMP  _L1820
_L1819:
_L1820:
    LI   R5, _STR_275
_L1818:
tcp_accept:
    LI   R28, tcp_get_conn
    JZ   R5, _L1822
    JMP  _L1821
    JMP  _L1823
_L1822:
_L1823:
    JZ   R6, _L1824
    JMP  _L1825
_L1824:
_L1825:
_L1821:
tcp_send:
    JZ   R5, _L1827
    JMP  _L1826
    JMP  _L1828
_L1827:
_L1828:
_L1829:
    JZ   R5, _L1830
    LI   R5, 1518
    JZ   R5, _L1831
    JMP  _L1832
_L1831:
_L1832:
    JZ   R5, _L1833
    JMP  _L1830
    JMP  _L1834
_L1833:
_L1834:
    JMP  _L1829
_L1830:
_L1826:
tcp_recv:
    JZ   R5, _L1836
    JMP  _L1835
    JMP  _L1837
_L1836:
_L1837:
    JZ   R7, _L1838
    JMP  _L1839
_L1838:
_L1839:
    SUB  R10, R7, R9
    JZ   R6, _L1840
    LI   R28, kmemmove
    JMP  _L1841
_L1840:
_L1841:
_L1835:
tcp_close:
    JZ   R5, _L1843
    JMP  _L1842
    JMP  _L1844
_L1843:
_L1844:
    JZ   R6, _L1845
    LI   R5, _STR_276
    JMP  _L1846
_L1845:
_L1846:
_L1842:
tcp_poll:
_L1848:
    LI   R28, 1520
    JZ   R5, _L1849
    JZ   R5, _L1850
    JMP  _L1848
    JMP  _L1851
_L1850:
_L1851:
    LI   R28, 1522
    JZ   R6, _L1852
    JMP  _L1853
_L1852:
_L1853:
    LI   R11, 13
    OR  R8, R8, R10
    LI   R12, 14
    LI   R13, 15
    OR  R8, R8, R13
    LI   R28, 1523
    LI   R28, 1527
    LI   R12, 6
    LI   R13, 7
    LI   R28, 1528
    LI   R11, 9
    LI   R12, 10
    LI   R13, 11
    LI   R28, 1529
    LI   R9, 13
    JZ   R5, _L1854
    JMP  _L1855
_L1854:
_L1855:
    LI   R28, 1521
_L1856:
    JZ   R5, _L1859
    JMP  _L1857
_L1858:
    JMP  _L1856
_L1857:
    JZ   R6, _L1860
    JMP  _L1858
    JMP  _L1861
_L1860:
_L1861:
    CMPEQ  R8, R8, R10
    CMPEQ  R10, R10, R12
    LI   R15, 16
    OR  R14, R14, R15
    AND  R13, R13, R14
    JZ   R6, _L1862
    LI   R5, _STR_277
    JMP  _L1859
    JMP  _L1863
_L1862:
_L1863:
    CMPEQ R9, R9, R0
    JZ   R6, _L1864
    LI   R5, _STR_278
    JMP  _L1865
_L1864:
_L1865:
    JZ   R6, _L1866
    CMPLT  R6, R9, R6
    JZ   R5, _L1868
    JMP  _L1869
_L1868:
_L1869:
    CMPEQ  R6, R6, R9
    JZ   R5, _L1870
    LI   R5, 1024
    STORE R5, R29, 1533
    JZ   R5, _L1872
    JMP  _L1873
_L1872:
_L1873:
    STORE R6, R29, 1534
    JZ   R5, _L1874
    JMP  _L1875
_L1874:
_L1875:
    JMP  _L1871
_L1870:
_L1871:
    JZ   R5, _L1876
    JMP  _L1877
_L1876:
_L1877:
    JMP  _L1867
_L1866:
_L1867:
    JZ   R6, _L1878
    LI   R5, _STR_279
    JMP  _L1879
_L1878:
_L1879:
    JZ   R6, _L1880
    JZ   R5, _L1882
    JMP  _L1883
_L1882:
_L1883:
    JMP  _L1881
_L1880:
_L1881:
_L1859:
_L1849:
_L1847:
tcp_status:
    LI   R5, _STR_280
    LI   R5, _STR_281
    LI   R5, _STR_282
    LI   R5, _STR_283
    LI   R5, _STR_284
    LI   R5, _STR_285
    LI   R5, _STR_286
    LI   R5, _STR_287
    LI   R5, _STR_288
    LI   R5, _STR_289
_L1885:
    JZ   R5, _L1888
    JMP  _L1886
_L1887:
    JMP  _L1885
_L1886:
    STORE R5, R29, 260
    JZ   R6, _L1889
    JMP  _L1887
    JMP  _L1890
_L1889:
_L1890:
    LI   R5, _STR_290
    ADD  R16, R16, R28
    ADD  R16, R17, R0
    LI   R17, 8
    CMPLE  R16, R16, R17
    JZ   R16, _L1891
    ADD  R16, R19, R0
    JMP  _L1892
_L1891:
    LI   R17, 0
_L1892:
    ADD  R14, R14, R16
    LOAD R16, R14, 0
    ADD  R21, R21, R28
    LOAD R22, R21, 0
    ADD  R4, R13, R0
_L1888:
    JZ   R5, _L1893
    LI   R5, _STR_291
    JMP  _L1894
_L1893:
_L1894:
_L1884:
tcp_get_conn:
    JZ   R5, _L1896
    JMP  _L1895
    JMP  _L1897
_L1896:
_L1897:
    JZ   R7, _L1898
    LI   R8, conns
    JMP  _L1899
_L1898:
_L1899:
_L1895:
uart_init:
    LI   R5, 18
_L1900:
uart_putchar:
    LI   R5, 16
_L1901:
uart_getchar:
    LI   R5, 17
    JMP  _L1902
_L1902:
uart_puts:
_L1904:
    JZ   R6, _L1905
    LI   R28, uart_putchar
    JMP  _L1904
_L1905:
_L1903:
print_uint:
    STORE R5, R29, 324
    LI   R28, 324
    JZ   R5, _L1907
    JMP  _L1906
    JMP  _L1908
_L1907:
_L1908:
_L1909:
    JZ   R5, _L1910
    SUB  R7, R7, R28
    STORE R7, R6, 0
    DIV  R12, R9, R11
    DIV  R9, R6, R8
    JMP  _L1909
_L1910:
    LI   R28, uart_puts
_L1906:
print_int:
    JZ   R5, _L1912
    JMP  _L1913
_L1912:
_L1913:
    LI   R28, print_uint
_L1911:
kprintf:
_L1915:
    JZ   R6, _L1916
    JZ   R5, _L1917
    JZ   R5, _L1919
    LI   R5, 13
    JMP  _L1920
_L1919:
_L1920:
    JMP  _L1915
    JMP  _L1918
_L1917:
_L1918:
    LI   R28, print_int
    JMP  _L1921
    LI   R6, 108
    JZ   R5, _L1922
    JZ   R5, _L1924
    JMP  _L1925
_L1924:
_L1925:
    JMP  _L1923
_L1922:
    JZ   R5, _L1926
    JMP  _L1927
_L1926:
_L1927:
_L1923:
_L1921:
_L1916:
_L1914:
ui_draw_crescent:
    DIV  R5, R5, R6
    LI   R6, 85
    LI   R10, 4278196787
_L1928:
ui_boot_splash:
    LI   R6, 220
    LI   R7, 90
    LI   R28, ui_draw_crescent
    LI   R5, _STR_292
    LI   R5, _STR_293
_L1929:
ui_loading_bar:
    JZ   R5, _L1931
    JMP  _L1932
_L1931:
_L1932:
    JZ   R5, _L1933
    JMP  _L1934
_L1933:
_L1934:
    LI   R5, _STR_294
_L1935:
    JZ   R5, _L1938
    JMP  _L1936
_L1937:
    JMP  _L1935
_L1936:
    JZ   R5, _L1939
    LI   R5, _STR_295
    JMP  _L1940
_L1939:
    LI   R5, _STR_296
_L1940:
    JMP  _L1937
_L1938:
    LI   R5, _STR_297
    LI   R6, 340
    LI   R7, 400
    LI   R9, 4280427059
    LI   R8, 400
    LI   R8, 100
    LI   R9, 4278255360
_L1930:
usb_port_read:
    JMP  _L1941
_L1941:
usb_port_write:
_L1942:
keycode_to_ascii:
    LI   R6, 83
    JZ   R5, _L1944
    JMP  _L1943
    JMP  _L1945
_L1944:
_L1945:
    JZ   R5, _L1946
    JMP  _L1947
_L1946:
_L1947:
    LI   R7, 29
    JZ   R5, _L1948
    CMPEQ R7, R7, R0
    JMP  _L1949
_L1948:
_L1949:
    JZ   R6, _L1950
    LI   R7, hid_shifted
    ADD  R6, R9, R0
    JMP  _L1951
_L1950:
    LI   R7, hid_unshifted
_L1951:
_L1943:
key_was_pressed:
_L1953:
    JZ   R5, _L1956
    JMP  _L1954
_L1955:
    JMP  _L1953
_L1954:
    JZ   R6, _L1957
    JMP  _L1952
    JMP  _L1958
_L1957:
_L1958:
    JMP  _L1955
_L1956:
_L1952:
key_is_pressed:
_L1960:
    JZ   R5, _L1963
    JMP  _L1961
_L1962:
    JMP  _L1960
_L1961:
    JZ   R6, _L1964
    JMP  _L1959
    JMP  _L1965
_L1964:
_L1965:
    JMP  _L1962
_L1963:
_L1959:
ctrl_combo:
    JZ   R5, _L1967
    JMP  _L1966
    JMP  _L1968
_L1967:
_L1968:
    LI   R6, 42
    JZ   R5, _L1969
    JMP  _L1970
_L1969:
_L1970:
    LI   R6, 40
    JZ   R5, _L1971
    JMP  _L1972
_L1971:
_L1972:
_L1966:
usb_hid_init:
    LI   R5, g_usb_hid
    LI   R7, g_usb_hid
    LI   R28, usb_port_write
    LI   R7, 48
    LI   R28, usb_port_read
    JZ   R5, _L1974
    LI   R5, _STR_298
    JMP  _L1975
_L1974:
    LI   R5, _STR_299
_L1975:
    JZ   R5, _L1976
    LI   R5, _STR_300
    JMP  _L1977
_L1976:
_L1977:
    JZ   R5, _L1978
    LI   R5, _STR_301
    JMP  _L1979
_L1978:
_L1979:
_L1973:
usb_hid_reset:
_L1980:
usb_hid_process_kbd:
    STORE R7, R29, 4
    LI   R28, key_is_pressed
    LI   R9, 57
    LI   R28, key_was_pressed
    JZ   R5, _L1982
    XOR  R9, R7, R8
    JMP  _L1983
_L1982:
_L1983:
_L1984:
    JZ   R5, _L1987
    JMP  _L1985
_L1986:
    JMP  _L1984
_L1985:
    STORE R8, R29, 6
    JZ   R5, _L1988
    JMP  _L1986
    JMP  _L1989
_L1988:
_L1989:
    LI   R6, 57
    JZ   R5, _L1990
    JMP  _L1991
_L1990:
_L1991:
    JZ   R5, _L1992
    JZ   R5, _L1994
    LI   R28, ctrl_combo
    JMP  _L1995
_L1994:
    LI   R28, keycode_to_ascii
_L1995:
    JZ   R6, _L1996
    JMP  _L1997
_L1996:
_L1997:
    LI   R8, 50
    JMP  _L1993
_L1992:
_L1993:
_L1987:
    JZ   R6, _L1998
    JMP  _L1999
_L1998:
_L1999:
_L1981:
usb_hid_process_mouse:
    STORE R7, R29, 6
_L2001:
    JZ   R5, _L2004
    JMP  _L2002
_L2003:
    JMP  _L2001
_L2002:
    JZ   R5, _L2005
    JMP  _L2006
_L2005:
_L2006:
    JMP  _L2003
_L2004:
    JZ   R5, _L2007
    JMP  _L2008
_L2007:
_L2008:
    JZ   R5, _L2009
    JMP  _L2010
_L2009:
_L2010:
_L2000:
usb_hid_poll:
_L2012:
    JZ   R5, _L2013
    LI   R7, 49
    JZ   R5, _L2014
    JMP  _L2013
    JMP  _L2015
_L2014:
_L2015:
_L2016:
    JZ   R5, _L2019
    JMP  _L2017
_L2018:
    JMP  _L2016
_L2017:
    JMP  _L2018
_L2019:
    JZ   R5, _L2020
    JZ   R6, _L2022
    LI   R28, usb_hid_process_kbd
    JMP  _L2023
_L2022:
    LI   R28, 30
_L2023:
    JMP  _L2021
_L2020:
    JZ   R5, _L2024
    JZ   R6, _L2026
    LI   R28, usb_hid_process_mouse
    JMP  _L2027
_L2026:
    LI   R28, 31
_L2027:
    JMP  _L2025
_L2024:
_L2025:
_L2021:
    JZ   R5, _L2028
    JMP  _L2029
_L2028:
_L2029:
    JMP  _L2012
_L2013:
_L2011:
usb_hid_tick:
    JZ   R6, _L2031
    JMP  _L2030
    JMP  _L2032
_L2031:
_L2032:
    JZ   R6, _L2033
    JMP  _L2034
_L2033:
_L2034:
    JZ   R6, _L2035
    JZ   R6, _L2037
    JMP  _L2038
_L2037:
    ADD  R3, R15, R0
_L2038:
    JZ   R6, _L2039
    JMP  _L2040
_L2039:
_L2040:
    JMP  _L2036
_L2035:
_L2036:
_L2030:
usb_kbd_connected:
    JMP  _L2041
_L2041:
usb_mouse_connected:
    JMP  _L2042
_L2042:
usb_kbd_modifier:
    JMP  _L2043
_L2043:
usb_kbd_key_pressed:
    JMP  _L2044
_L2044:
usb_mouse_buttons:
    JMP  _L2045
_L2045:
node_by_id:
    JZ   R5, _L2065
    JMP  _L2064
    JMP  _L2066
_L2065:
_L2066:
    LI   R5, nodes
    JZ   R7, _L2067
    LI   R8, nodes
    JMP  _L2068
_L2067:
_L2068:
_L2064:
alloc_node:
_L2070:
    JZ   R5, _L2073
    JMP  _L2071
_L2072:
    JMP  _L2070
_L2071:
    JZ   R5, _L2074
    JMP  _L2069
    JMP  _L2075
_L2074:
_L2075:
    JMP  _L2072
_L2073:
_L2069:
node_path:
    STORE R5, R29, 261
    STORE R6, R29, 262
_L2077:
    LI   R28, 262
    JZ   R5, _L2078
    LI   R28, node_by_id
    STORE R5, R29, 265
    LI   R28, 265
    JZ   R5, _L2079
    JMP  _L2078
    JMP  _L2080
_L2079:
_L2080:
    JMP  _L2077
_L2078:
    LI   R28, 264
    LI   R28, 263
_L2081:
    JZ   R5, _L2084
    JMP  _L2082
_L2083:
    JMP  _L2081
_L2082:
    STORE R5, R29, 266
    LI   R28, 266
    JZ   R5, _L2085
    JMP  _L2084
    JMP  _L2086
_L2085:
_L2086:
    JZ   R5, _L2087
    LI   R9, 47
    JMP  _L2088
_L2087:
_L2088:
    JMP  _L2083
_L2084:
    JZ   R5, _L2089
    JMP  _L2090
_L2089:
_L2090:
_L2076:
find_child:
_L2092:
    JZ   R5, _L2095
    JMP  _L2093
_L2094:
    JMP  _L2092
_L2093:
    LI   R7, nodes
    LI   R9, nodes
    ADD  R1, R11, R0
    ADD  R2, R13, R0
    JZ   R5, _L2096
    JMP  _L2091
    JMP  _L2097
_L2096:
_L2097:
    JMP  _L2094
_L2095:
_L2091:
resolve_path_id:
    STORE R6, R29, 35
    JZ   R5, _L2099
    JMP  _L2100
_L2099:
_L2100:
    JZ   R5, _L2101
    JMP  _L2098
    JMP  _L2102
_L2101:
_L2102:
_L2103:
    JZ   R6, _L2104
_L2105:
    LI   R7, 47
    JZ   R5, _L2106
    JZ   R5, _L2107
    JMP  _L2108
_L2107:
_L2108:
    JMP  _L2105
_L2106:
    JZ   R5, _L2109
    JMP  _L2110
_L2109:
_L2110:
    JZ   R5, _L2111
    JMP  _L2103
    JMP  _L2112
_L2111:
_L2112:
    LI   R6, _STR_296
    JZ   R5, _L2113
    JMP  _L2114
_L2113:
_L2114:
    LI   R6, _STR_302
    JZ   R5, _L2115
    CMPLE  R9, R10, R9
    AND   R7, R7, R9
    JZ   R7, _L2117
    ADD  R8, R11, R0
    JMP  _L2118
_L2117:
_L2118:
    JMP  _L2116
_L2115:
_L2116:
    LI   R28, find_child
    JZ   R5, _L2119
    JMP  _L2120
_L2119:
_L2120:
_L2104:
_L2098:
vfs_init:
_L2122:
    JZ   R5, _L2125
    JMP  _L2123
_L2124:
    JMP  _L2122
_L2123:
    JMP  _L2124
_L2125:
    LI   R7, _STR_303
    LI   R5, vfs_cwd_id
    LI   R5, _STR_304
    LI   R28, vfs_mkdir
    LI   R5, _STR_305
    LI   R5, _STR_306
    LI   R5, _STR_307
    LI   R5, _STR_308
    LI   R5, _STR_309
    LI   R5, _STR_310
    LI   R5, _STR_311
    LI   R5, _STR_312
    LI   R5, _STR_313
_L2121:
vfs_resolve:
    JZ   R6, _L2127
    JMP  _L2128
_L2127:
    LI   R28, node_path
    JZ   R5, _L2129
    JMP  _L2130
_L2129:
_L2130:
_L2128:
_L2126:
vfs_find:
    LI   R28, resolve_path_id
    JZ   R5, _L2132
    JMP  _L2133
_L2132:
_L2133:
    JMP  _L2131
_L2131:
vfs_mkdir:
    LI   R28, vfs_resolve
    JZ   R5, _L2135
    JMP  _L2134
    JMP  _L2136
_L2135:
_L2136:
    LI   R28, 132
_L2137:
    JZ   R5, _L2140
    JMP  _L2138
_L2139:
    JMP  _L2137
_L2138:
    JZ   R5, _L2141
    JMP  _L2140
    JMP  _L2142
_L2141:
_L2142:
    JMP  _L2139
_L2140:
    JZ   R5, _L2143
    JMP  _L2144
_L2143:
_L2144:
    JZ   R5, _L2145
    JMP  _L2146
_L2145:
_L2146:
    LI   R28, alloc_node
    JZ   R5, _L2147
    JMP  _L2148
_L2147:
_L2148:
_L2134:
vfs_rmdir:
    LI   R28, 131
    LI   R6, nodes
    CMPNE  R6, R6, R8
    JZ   R5, _L2150
    JMP  _L2149
    JMP  _L2151
_L2150:
_L2151:
_L2152:
    JZ   R5, _L2155
    JMP  _L2153
_L2154:
    JMP  _L2152
_L2153:
    JZ   R5, _L2156
    JMP  _L2157
_L2156:
_L2157:
    JMP  _L2154
_L2155:
    JZ   R5, _L2158
    JMP  _L2159
_L2158:
_L2159:
_L2149:
vfs_chdir:
    JZ   R5, _L2161
    JMP  _L2160
    JMP  _L2162
_L2161:
_L2162:
_L2160:
vfs_getcwd:
_L2163:
vfs_create:
    JMP  _L2164
_L2164:
vfs_delete:
    JMP  _L2165
_L2165:
vfs_read:
    JMP  _L2166
_L2166:
vfs_write:
    JMP  _L2167
_L2167:
vfs_ls:
    STORE R5, R29, 133
    JZ   R5, _L2169
    LI   R5, _STR_314
    JMP  _L2168
    JMP  _L2170
_L2169:
_L2170:
    LI   R5, _STR_315
_L2171:
    JZ   R5, _L2174
    JMP  _L2172
_L2173:
    JMP  _L2171
_L2172:
    JZ   R5, _L2175
    LI   R5, _STR_316
    CMPEQ  R9, R9, R11
    JZ   R9, _L2177
    LI   R11, _STR_303
    JMP  _L2178
_L2177:
    LI   R11, _STR_68
_L2178:
    JMP  _L2176
_L2175:
_L2176:
    JMP  _L2173
_L2174:
    JZ   R5, _L2179
    JMP  _L2180
_L2179:
_L2180:
_L2168:
vfs_exists:
    JZ   R5, _L2182
    JMP  _L2181
    JMP  _L2183
_L2182:
_L2183:
    LI   R28, fs_exists
_L2181:
vfs_is_dir:
    JZ   R5, _L2185
    JMP  _L2184
    JMP  _L2186
_L2185:
_L2186:
_L2184:
vfs_find_by_id:
    JZ   R5, _L2188
    JMP  _L2187
    JMP  _L2189
_L2188:
_L2189:
    JZ   R7, _L2190
    JMP  _L2191
_L2190:
_L2191:
_L2187:
vfs_node_abs_path:
_L2192:
vfs_node_abs_path_by_id:
    JZ   R5, _L2194
    JMP  _L2193
    JMP  _L2195
_L2194:
_L2195:
_L2193:
resolve_path:
    JZ   R5, _L2201
    JMP  _L2202
_L2201:
    LI   R8, _STR_317
_L2202:
    JMP  _L2200
_L2200:
hwrite:
    LI   R28, hostio_write
    JZ   R5, _L2204
    JMP  _L2205
_L2204:
_L2205:
    JMP  _L2203
_L2203:
hread:
    LI   R28, hostio_read
    JZ   R5, _L2207
    JMP  _L2208
_L2207:
_L2208:
    JMP  _L2206
_L2206:
vfs_persist_save:
    LI   R5, _STR_318
    JMP  _L2209
_L2209:
vfs_persist_load:
    JMP  _L2210
_L2210:
vfs_persist_auto_load:
    LI   R28, vfs_persist_load
    JZ   R5, _L2212
    JMP  _L2211
    JMP  _L2213
_L2212:
_L2213:
    LI   R5, _STR_319
_L2211:
vfs_persist_info:
    LI   R5, _STR_320
_L2214:
wreg_read:
    JMP  _L2215
_L2215:
wreg_write:
_L2216:
fnv1a:
_L2218:
    JZ   R8, _L2221
    JMP  _L2219
_L2220:
    JMP  _L2218
_L2219:
    JMP  _L2220
_L2221:
    JMP  _L2217
_L2217:
wifi_ip_str:
_L2223:
    JZ   R5, _L2226
    JMP  _L2224
_L2225:
    JMP  _L2223
_L2224:
    JZ   R5, _L2227
    JMP  _L2228
_L2227:
_L2228:
    JZ   R5, _L2229
    JMP  _L2230
_L2229:
_L2230:
    JZ   R5, _L2231
    JMP  _L2232
_L2231:
_L2232:
    JMP  _L2225
_L2226:
_L2222:
wifi_init:
    LI   R5, wifi
    LI   R7, wifi
    LI   R7, 683
    OR  R6, R6, R7
    LI   R28, wreg_write
    LI   R6, 160
    LI   R28, 99
    LI   R7, 160
    LI   R28, 101
    LI   R28, 103
    LI   R28, 102
    LI   R6, _STR_321
    LI   R7, _STR_322
    LI   R28, slog
    LI   R5, _STR_323
    LI   R5, _STR_324
    LI   R5, _STR_325
_L2233:
wifi_scan:
    JZ   R5, _L2235
    LI   R5, _STR_326
    JMP  _L2234
    JMP  _L2236
_L2235:
_L2236:
    LI   R5, _STR_327
    LI   R7, 112
    LI   R28, wreg_read
    LI   R28, 106
_L2237:
    LI   R6, wifi
    JZ   R5, _L2240
    JMP  _L2238
_L2239:
    JMP  _L2237
_L2238:
    LI   R28, 107
    LI   R28, 576
    LI   R10, 33
    JMP  _L2239
_L2240:
    LI   R7, _STR_328
    LI   R5, _STR_329
_L2234:
wifi_print_scan:
    JZ   R5, _L2242
    LI   R5, _STR_330
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
    LI   R5, _STR_337
_L2244:
    JZ   R5, _L2247
    JMP  _L2245
_L2246:
    JMP  _L2244
_L2245:
    LI   R5, _STR_338
    LI   R8, wifi
    LI   R11, wifi
    MUL  R13, R13, R28
    LOAD R13, R11, 0
    LI   R14, wifi
    LI   R17, wifi
    JZ   R19, _L2248
    LI   R20, _STR_339
    ADD  R19, R20, R0
    JMP  _L2249
_L2248:
    LI   R20, _STR_340
_L2249:
    JMP  _L2246
_L2247:
_L2241:
wifi_connect:
    JZ   R5, _L2251
    LI   R5, _STR_341
    JMP  _L2250
    JMP  _L2252
_L2251:
_L2252:
    JZ   R6, _L2253
    JMP  _L2254
_L2253:
_L2254:
_L2255:
    JZ   R5, _L2258
    JMP  _L2256
_L2257:
    JMP  _L2255
_L2256:
    JZ   R5, _L2259
    JMP  _L2258
    JMP  _L2260
_L2259:
_L2260:
    JMP  _L2257
_L2258:
    LI   R5, _STR_342
    AND   R8, R8, R11
    JZ   R8, _L2261
    LI   R11, _STR_343
    JMP  _L2262
_L2261:
    LI   R11, _STR_344
_L2262:
    JZ   R5, _L2263
    LI   R28, fnv1a
    JMP  _L2264
_L2263:
_L2264:
    JZ   R5, _L2265
    LI   R28, 98
    LI   R28, 100
    JMP  _L2266
_L2265:
    LI   R6, 36
    LI   R7, 36
_L2266:
    LI   R28, 104
    LI   R28, 105
    JZ   R5, _L2267
    LI   R5, _STR_345
    LI   R7, _STR_346
    JMP  _L2268
_L2267:
_L2268:
    JZ   R5, _L2269
    LI   R9, 33
    JZ   R6, _L2271
    LI   R9, 65
    JMP  _L2272
_L2271:
_L2272:
    LI   R28, wifi_ip_str
    LI   R5, _STR_347
    LI   R5, _STR_348
    LI   R5, _STR_349
    LI   R5, _STR_350
    LI   R5, _STR_351
    LI   R5, _STR_352
    LI   R7, _STR_353
    JMP  _L2270
_L2269:
_L2270:
    LI   R5, _STR_354
_L2250:
wifi_disconnect:
    JZ   R5, _L2274
    LI   R5, _STR_355
    JMP  _L2273
    JMP  _L2275
_L2274:
_L2275:
    LI   R5, _STR_356
    LI   R7, _STR_357
_L2273:
wifi_status:
    LI   R5, _STR_358
    LI   R5, _STR_359
    JZ   R7, _L2277
    LI   R8, _STR_360
    JMP  _L2278
_L2277:
    LI   R8, _STR_361
_L2278:
    LI   R5, _STR_362
    JZ   R7, _L2279
    LI   R8, _STR_363
    JMP  _L2280
_L2279:
    LI   R8, _STR_364
_L2280:
    JZ   R6, _L2281
    LI   R5, _STR_365
    LI   R5, _STR_366
    LI   R5, _STR_367
    LI   R5, _STR_368
    LI   R5, _STR_369
    LI   R5, _STR_370
    LI   R5, _STR_371
    JMP  _L2282
_L2281:
_L2282:
    LI   R5, _STR_372
    LI   R5, _STR_373
_L2276:
wifi_is_up:
    JMP  _L2283
_L2283:
wifi_rssi:
    JMP  _L2284
_L2284:
theme_accent:
    LI   R5, current_theme
    LI   R5, 4280449023
    JMP  _L2285
    LI   R5, 4282664004
    LI   R5, 4278242406
_L2286:
_L2285:
wm_init:
_L2288:
    JZ   R5, _L2291
    JMP  _L2289
_L2290:
    JMP  _L2288
_L2289:
    LI   R5, windows
    JMP  _L2290
_L2291:
    LI   R5, window_count
    LI   R5, focused_win
    LI   R5, _STR_374
_L2287:
desktop_welcome_screen:
    LI   R5, 4279246912
    LI   R6, 150
    LI   R28, theme_accent
    LI   R6, 250
    LI   R7, 500
    LI   R9, 4280299600
    LI   R5, _STR_375
    LI   R28, draw_taskbar
_L2292:
wm_create_window:
_L2294:
    JZ   R5, _L2297
    JMP  _L2295
_L2296:
    JMP  _L2294
_L2295:
    JZ   R5, _L2298
    LI   R8, 4293848814
    LI   R10, windows
    JZ   R5, _L2300
    LI   R6, focused_win
    JMP  _L2301
_L2300:
_L2301:
    JMP  _L2293
    JMP  _L2299
_L2298:
_L2299:
    JMP  _L2296
_L2297:
    LI   R5, _STR_376
_L2293:
draw_window_frame:
    JZ   R5, _L2303
    JMP  _L2302
    JMP  _L2304
_L2303:
_L2304:
    LI   R11, 24
    LI   R13, 4278190080
_L2302:
draw_taskbar:
    LI   R7, 30
    LI   R8, 30
    LI   R9, 4279308561
_L2306:
    JZ   R5, _L2309
    JMP  _L2307
_L2308:
    JMP  _L2306
_L2307:
    JZ   R7, _L2310
    LI   R8, 26
    LI   R9, 22
    JZ   R12, _L2312
    LI   R28, -8
    STORE R9, R30, 4
    STORE R10, R30, 5
    STORE R11, R30, 6
    STORE R12, R30, 7
    LOAD R9, R30, 4
    LOAD R10, R30, 5
    LOAD R11, R30, 6
    LOAD R12, R30, 7
    ADD  R13, R7, R0  ; sonuç = R7
    JMP  _L2313
_L2312:
    LI   R13, 4281545523
_L2313:
    LI   R7, 110
    JMP  _L2311
_L2310:
_L2311:
    JMP  _L2308
_L2309:
_L2305:
wm_render:
_L2315:
    JZ   R5, _L2318
    JMP  _L2316
_L2317:
    JMP  _L2315
_L2316:
    LI   R28, draw_window_frame
    JMP  _L2317
_L2318:
_L2314:
wm_run:
    JZ   R5, _L2320
    JMP  _L2319
    JMP  _L2321
_L2320:
_L2321:
    LI   R28, wm_mouse_event
_L2319:
wm_click:
_L2323:
    JZ   R5, _L2326
    JMP  _L2324
_L2325:
    JMP  _L2323
_L2324:
    LI   R7, windows
    LI   R9, windows
    CMPLE  R8, R11, R8
    LI   R11, windows
    ADD  R11, R13, R0
    LI   R13, windows
    CMPLE  R10, R10, R11
    LI   R14, windows
    CMPLE  R13, R16, R13
    AND   R5, R5, R13
    LI   R16, windows
    MUL  R18, R18, R28
    ADD  R16, R16, R18
    LOAD R18, R16, 0
    ADD  R16, R18, R0
    LI   R18, windows
    ADD  R19, R29, R28
    ADD  R18, R18, R20
    LOAD R20, R18, 0
    ADD  R16, R16, R20
    CMPLE  R15, R15, R16
    CMPNE R15, R15, R0
    AND   R5, R5, R15
    JZ   R5, _L2327
    JZ   R5, _L2329
    JMP  _L2330
_L2329:
_L2330:
    JMP  _L2322
    JMP  _L2328
_L2327:
_L2328:
    JMP  _L2325
_L2326:
_L2322:
wm_set_theme:
    JZ   R5, _L2332
    LI   R5, _STR_377
    JMP  _L2331
    JMP  _L2333
_L2332:
_L2333:
_L2334:
    JZ   R5, _L2337
    JMP  _L2335
_L2336:
    JMP  _L2334
_L2335:
    JZ   R7, _L2338
    JMP  _L2339
_L2338:
_L2339:
    JMP  _L2336
_L2337:
    LI   R5, _STR_378
_L2331:
wm_mouse_event:
    JZ   R5, _L2341
    LI   R5, drag_win
    LI   R5, resize_win
    LI   R5, prev_mx
    LI   R5, prev_my
    JMP  _L2340
    JMP  _L2342
_L2341:
_L2342:
    JZ   R5, _L2343
    LI   R6, drag_offset_x
    LI   R6, drag_offset_y
    JZ   R5, _L2345
    JMP  _L2346
_L2345:
_L2346:
    JZ   R5, _L2347
    JMP  _L2348
_L2347:
_L2348:
    LI   R6, windows
    LI   R7, drag_win
    JZ   R5, _L2349
    LI   R8, windows
    LI   R9, drag_win
    JMP  _L2350
_L2349:
_L2350:
    LI   R9, 30
    JZ   R5, _L2351
    JMP  _L2352
_L2351:
_L2352:
    LI   R6, drag_win
    JMP  _L2344
_L2343:
_L2344:
    JZ   R5, _L2353
    LI   R6, prev_mx
    LI   R6, prev_my
    LI   R6, resize_win
    JZ   R5, _L2355
    JMP  _L2356
_L2355:
_L2356:
    JZ   R5, _L2357
    JMP  _L2358
_L2357:
_L2358:
    JZ   R5, _L2359
    LI   R9, resize_win
    JMP  _L2360
_L2359:
_L2360:
    JZ   R5, _L2361
    JMP  _L2362
_L2361:
_L2362:
    JMP  _L2354
_L2353:
_L2354:
_L2363:
    JZ   R5, _L2366
    JMP  _L2364
_L2365:
    JMP  _L2363
_L2364:
    OR   R6, R6, R9
    JZ   R6, _L2367
    JMP  _L2365
    JMP  _L2368
_L2367:
_L2368:
    ADD  R10, R10, R13
    CMPLT  R8, R10, R8
    OR   R5, R5, R8
    JZ   R5, _L2369
    JMP  _L2370
_L2369:
_L2370:
    JZ   R5, _L2371
    JMP  _L2372
_L2371:
_L2372:
    JZ   R5, _L2373
    JMP  _L2374
_L2373:
_L2374:
    LI   R14, 12
    SUB  R11, R11, R14
    CMPLE  R9, R11, R9
    JZ   R5, _L2375
    JMP  _L2376
_L2375:
_L2376:
    JZ   R5, _L2377
    LI   R5, drag_offset_x
    LI   R5, drag_offset_y
    JMP  _L2378
_L2377:
_L2378:
_L2366:
_L2340:
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
    .zero 132192
file_count:
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
    .word 54
    .zero 6
    .word 127
    .word 12
    .word 62
    .word 3
    .word 30
    .word 48
    .word 31
    .zero 2
    .word 99
    .word 51
    .word 102
    .word 28
    .word 110
    .word 59
    .word 6
    .zero 5
    .word 255
    .zero 3
    .word 63
    .zero 7
    .zero 9
    .word 96
    .word 1
    .word 115
    .word 123
    .word 111
    .word 103
    .word 14
    .word 56
    .word 120
    .word 70
    .word 22
    .word 15
    .word 124
    .word 119
    .word 107
    .word 7
    .word 45
    .word 49
    .word 76
    .word 64
    .word 8
    .zero 11
    .word 44
    .word 25
    .word 38
    .zero 14
cmd_queue:
    .zero 17664
cmd_head:
sprites:
    .zero 32808
tile_strips:
    .zero 262176
gpu_ring:
    .word 196608
ring_head:
current_owner:
gpu_ready:
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
alarm_table:
    .zero 16
alarm_table_init:
blocks:
    .zero 192
block_count:
mouse:
net:
arp_table:
perms:
    .zero 1120
process_table:
    .zero 384
current_pid:
context_switches:
command_buffer:
history:
    .zero 640
history_idx:
cores:
stats:
active_cores:
active_core:
total_ticks:
slog_buf:
    .zero 12032
slog_head:
slog_total:
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
    .word 100
    .word 101
    .word 104
    .word 105
    .word 106
    .word 108
    .word 109
    .word 112
    .word 113
    .word 114
    .word 116
    .word 117
    .word 118
    .word 121
    .word 122
    .word 50
    .word 52
    .word 53
    .word 55
    .word 57
    .word 10
    .word 27
    .word 9
    .word 32
    .word 61
    .word 91
    .word 93
    .word 92
    .word 39
    .word 46
    .word 47
    .zero 26
hid_shifted:
    .word 65
    .word 66
    .word 67
    .word 68
    .word 69
    .word 71
    .word 72
    .word 73
    .word 74
    .word 75
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
    .word 35
    .word 36
    .word 37
    .word 94
    .word 42
    .word 40
    .word 41
    .word 95
    .word 43
    .word 125
    .word 58
    .word 34
    .word 126
nodes:
    .zero 2432
vfs_cwd_id:
wifi:
    .zero 683
windows:
    .zero 328
window_count:
focused_win:
current_theme:
drag_win:
drag_offset_x:
drag_offset_y:
resize_win:
prev_mx:
prev_my:
_STR_0:
    .word 0
_STR_1:
_STR_2:
_STR_3:
_STR_4:
_STR_5:
_STR_6:
    .word 226
    .word 128
    .word 148
_STR_7:
_STR_8:
_STR_9:
_STR_10:
_STR_11:
_STR_12:
_STR_13:
_STR_14:
_STR_15:
_STR_16:
_STR_17:
_STR_18:
_STR_19:
_STR_20:
_STR_21:
_STR_22:
_STR_23:
_STR_24:
_STR_25:
_STR_26:
_STR_27:
_STR_28:
_STR_29:
_STR_30:
_STR_31:
_STR_32:
_STR_33:
_STR_34:
_STR_35:
_STR_36:
_STR_37:
_STR_38:
_STR_39:
_STR_40:
_STR_41:
_STR_42:
_STR_43:
_STR_44:
_STR_45:
_STR_46:
_STR_47:
_STR_48:
    .word 196
    .word 159
    .word 177
_STR_49:
_STR_50:
_STR_51:
_STR_52:
_STR_53:
_STR_54:
_STR_55:
_STR_56:
_STR_57:
_STR_58:
_STR_59:
_STR_60:
_STR_61:
_STR_62:
_STR_63:
_STR_64:
_STR_65:
_STR_66:
_STR_67:
_STR_68:
_STR_69:
_STR_70:
_STR_71:
_STR_72:
_STR_73:
_STR_74:
_STR_75:
_STR_76:
_STR_77:
_STR_78:
_STR_79:
_STR_80:
_STR_81:
_STR_82:
_STR_83:
_STR_84:
_STR_85:
_STR_86:
_STR_87:
_STR_88:
_STR_89:
_STR_90:
_STR_91:
_STR_92:
_STR_93:
_STR_94:
_STR_95:
_STR_96:
_STR_97:
_STR_98:
_STR_99:
_STR_100:
_STR_101:
_STR_102:
_STR_103:
_STR_104:
_STR_105:
_STR_106:
_STR_107:
_STR_108:
_STR_109:
_STR_110:
_STR_111:
_STR_112:
_STR_113:
_STR_114:
_STR_115:
_STR_116:
_STR_117:
_STR_118:
_STR_119:
_STR_120:
_STR_121:
_STR_122:
_STR_123:
_STR_124:
_STR_125:
_STR_126:
_STR_127:
_STR_128:
    .word 13
_STR_129:
_STR_130:
_STR_131:
_STR_132:
_STR_133:
_STR_134:
_STR_135:
_STR_136:
_STR_137:
_STR_138:
_STR_139:
_STR_140:
_STR_141:
_STR_142:
_STR_143:
_STR_144:
_STR_145:
_STR_146:
_STR_147:
_STR_148:
_STR_149:
_STR_150:
_STR_151:
_STR_152:
_STR_153:
_STR_154:
_STR_155:
_STR_156:
_STR_157:
_STR_158:
_STR_159:
_STR_160:
_STR_161:
_STR_162:
_STR_163:
_STR_164:
_STR_165:
_STR_166:
_STR_167:
_STR_168:
_STR_169:
_STR_170:
_STR_171:
_STR_172:
_STR_173:
_STR_174:
_STR_175:
_STR_176:
_STR_177:
_STR_178:
_STR_179:
_STR_180:
_STR_181:
_STR_182:
_STR_183:
_STR_184:
_STR_185:
_STR_186:
_STR_187:
_STR_188:
_STR_189:
_STR_190:
_STR_191:
_STR_192:
_STR_193:
_STR_194:
_STR_195:
_STR_196:
_STR_197:
_STR_198:
_STR_199:
_STR_200:
_STR_201:
_STR_202:
_STR_203:
_STR_204:
_STR_205:
_STR_206:
_STR_207:
_STR_208:
_STR_209:
_STR_210:
_STR_211:
_STR_212:
_STR_213:
_STR_214:
_STR_215:
_STR_216:
_STR_217:
_STR_218:
_STR_219:
_STR_220:
_STR_221:
_STR_222:
_STR_223:
_STR_224:
_STR_225:
_STR_226:
_STR_227:
_STR_228:
_STR_229:
_STR_230:
_STR_231:
_STR_232:
_STR_233:
_STR_234:
_STR_235:
_STR_236:
_STR_237:
_STR_238:
_STR_239:
_STR_240:
_STR_241:
_STR_242:
_STR_243:
_STR_244:
_STR_245:
_STR_246:
_STR_247:
_STR_248:
_STR_249:
_STR_250:
_STR_251:
_STR_252:
_STR_253:
_STR_254:
_STR_255:
_STR_256:
_STR_257:
_STR_258:
_STR_259:
_STR_260:
_STR_261:
_STR_262:
_STR_263:
_STR_264:
_STR_265:
_STR_266:
_STR_267:
_STR_268:
_STR_269:
_STR_270:
_STR_271:
_STR_272:
_STR_273:
_STR_274:
_STR_275:
_STR_276:
_STR_277:
_STR_278:
_STR_279:
_STR_280:
_STR_281:
_STR_282:
_STR_283:
_STR_284:
_STR_285:
_STR_286:
_STR_287:
_STR_288:
_STR_289:
_STR_290:
_STR_291:
_STR_292:
_STR_293:
_STR_294:
_STR_295:
_STR_296:
_STR_297:
_STR_298:
    .word 195
    .word 188
_STR_299:
_STR_300:
_STR_301:
_STR_302:
_STR_303:
_STR_304:
_STR_305:
_STR_306:
_STR_307:
_STR_308:
_STR_309:
_STR_310:
_STR_311:
_STR_312:
_STR_313:
_STR_314:
_STR_315:
_STR_316:
_STR_317:
_STR_318:
_STR_319:
_STR_320:
_STR_321:
_STR_322:
_STR_323:
_STR_324:
_STR_325:
_STR_326:
_STR_327:
_STR_328:
_STR_329:
_STR_330:
_STR_331:
_STR_332:
_STR_333:
_STR_334:
_STR_335:
_STR_336:
_STR_337:
_STR_338:
_STR_339:
_STR_340:
_STR_341:
_STR_342:
_STR_343:
_STR_344:
_STR_345:
_STR_346:
_STR_347:
_STR_348:
_STR_349:
_STR_350:
_STR_351:
_STR_352:
_STR_353:
_STR_354:
_STR_355:
_STR_356:
_STR_357:
_STR_358:
_STR_359:
_STR_360:
_STR_361:
_STR_362:
_STR_363:
    .word 158
_STR_364:
_STR_365:
_STR_366:
_STR_367:
_STR_368:
_STR_369:
_STR_370:
_STR_371:
_STR_372:
_STR_373:
_STR_374:
_STR_375:
_STR_376:
_STR_377:
_STR_378:
