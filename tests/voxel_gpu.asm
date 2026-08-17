; voxel_gpu.asm — gerçek Oxalyn assembly voxel mesh render testi
; Vertex layout: position vec4 + color vec4 = 8 float / 32 byte
; Ring payloads: CLEAR, shader uploads, VB/IB uploads, raster/depth, DRAW_INDEXED, PRESENT
start:
    LI   R7, 511
    LI   R1, 1
    OUT  R1, 0xE3
    IN   R6, 0xE0
    JZ   R6, fail
    LI   R1, 0
    OUT  R1, 0xEE
    LI   R1, 25
    SHL  R1, R1, 5
    OUT  R1, 0xEF
    LI   R1, 75
    SHL  R1, R1, 3
    OUT  R1, 0xF0
    LI   R1, 25
    SHL  R1, R1, 7
    OUT  R1, 0xF1
    LI   R1, 0
    OUT  R1, 0xF2
    MOVI R3, ring_data
    OUT  R3, 0xE4
    LI   R1, 1000
    OUT  R1, 0xE5
    MOVI R2, ring_end
    MOVI R4, ring_data
    SUB  R2, R2, R4
    OUT  R2, 0xE6
    LI   R1, 1
    OUT  R1, 0xE8
wait:
    IN   R5, 0xE2
    LI   R1, 1
    AND  R5, R5, R1
    JZ   R5, wait
    LI   R1, 86
    OUT  R1, 0
    HALT
fail:
    LI   R1, 222
    OUT  R1, 0
    HALT

ring_data:
    .word 0x00000001
    .word 0x00000020
    .word 0x00000003
    .word 0x00000000
    .word 0x3CF5C28F
    .word 0x3D75C28F
    .word 0x3DE147AE
    .word 0x3F800000
    .word 0x3F800000
    .word 0x00000000
    .word 0x00000004
    .word 0x00000030
    .word 0x00000000
    .word 0x00000000
    .word 0x00000008
    .word 0x00000004
    .word 0x31100000
    .word 0x3210C850
    .word 0x31300004
    .word 0x2F018000
    .word 0x2F01C200
    .word 0x2F020400
    .word 0x2F024600
    .word 0x01000000
    .word 0x00000004
    .word 0x00000028
    .word 0x00000001
    .word 0x00000001
    .word 0x00000006
    .word 0x00000004
    .word 0x2E100000
    .word 0x2E180001
    .word 0x2E200002
    .word 0x2E280003
    .word 0x3310C850
    .word 0x01000000
    .word 0x00000005
    .word 0x00000008
    .word 0x00000000
    .word 0x00000001
    .word 0x00000006
    .word 0x00000190
    .word 0x00200000
    .word 0x00000000
    .word 0x00000180
    .word 0x00000000
    .word 0x00000000
    .word 0xBECCCCCD
    .word 0x3F000000
    .word 0x3F800000
    .word 0x3F0F5C29
    .word 0x3E99999A
    .word 0x3DF5C28F
    .word 0x3F800000
    .word 0x00000000
    .word 0x3E800000
    .word 0x3E800000
    .word 0x3F800000
    .word 0x3F0F5C29
    .word 0x3E99999A
    .word 0x3DF5C28F
    .word 0x3F800000
    .word 0xBF266666
    .word 0x3F07AE14
    .word 0x3EB33333
    .word 0x3F800000
    .word 0x3F0F5C29
    .word 0x3E99999A
    .word 0x3DF5C28F
    .word 0x3F800000
    .word 0xBF266666
    .word 0xBDF5C28F
    .word 0x3F19999A
    .word 0x3F800000
    .word 0x3F0F5C29
    .word 0x3E99999A
    .word 0x3DF5C28F
    .word 0x3F800000
    .word 0x3F266666
    .word 0xBDF5C28F
    .word 0x3F19999A
    .word 0x3F800000
    .word 0x3E23D70A
    .word 0x3F147AE1
    .word 0x3E75C28F
    .word 0x3F800000
    .word 0x3F266666
    .word 0x3F07AE14
    .word 0x3EB33333
    .word 0x3F800000
    .word 0x3E23D70A
    .word 0x3F147AE1
    .word 0x3E75C28F
    .word 0x3F800000
    .word 0x00000000
    .word 0x3F4F5C29
    .word 0x3EE66666
    .word 0x3F800000
    .word 0x3E23D70A
    .word 0x3F147AE1
    .word 0x3E75C28F
    .word 0x3F800000
    .word 0x00000000
    .word 0x3E23D70A
    .word 0x3F333333
    .word 0x3F800000
    .word 0x3E23D70A
    .word 0x3F147AE1
    .word 0x3E75C28F
    .word 0x3F800000
    .word 0x00000000
    .word 0x3E800000
    .word 0x3E800000
    .word 0x3F800000
    .word 0x3EF5C28F
    .word 0x3F570A3D
    .word 0x3EDC28F6
    .word 0x3F800000
    .word 0x3F266666
    .word 0x3F07AE14
    .word 0x3EB33333
    .word 0x3F800000
    .word 0x3EF5C28F
    .word 0x3F570A3D
    .word 0x3EDC28F6
    .word 0x3F800000
    .word 0x00000000
    .word 0x3F4F5C29
    .word 0x3EE66666
    .word 0x3F800000
    .word 0x3EF5C28F
    .word 0x3F570A3D
    .word 0x3EDC28F6
    .word 0x3F800000
    .word 0xBF266666
    .word 0x3F07AE14
    .word 0x3EB33333
    .word 0x3F800000
    .word 0x3EF5C28F
    .word 0x3F570A3D
    .word 0x3EDC28F6
    .word 0x3F800000
    .word 0x00000007
    .word 0x00000058
    .word 0x00201000
    .word 0x00000000
    .word 0x00000048
    .word 0x00000000
    .word 0x00000000
    .word 0x00000001
    .word 0x00000002
    .word 0x00000000
    .word 0x00000002
    .word 0x00000003
    .word 0x00000004
    .word 0x00000005
    .word 0x00000006
    .word 0x00000004
    .word 0x00000006
    .word 0x00000007
    .word 0x00000008
    .word 0x00000009
    .word 0x0000000A
    .word 0x00000008
    .word 0x0000000A
    .word 0x0000000B
    .word 0x0000000D
    .word 0x0000000C
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x0000000E
    .word 0x0000000C
    .word 0x00000001
    .word 0x00000001
    .word 0x00000000
    .word 0x00000003
    .word 0x0000002C
    .word 0x00000012
    .word 0x00000000
    .word 0x00000000
    .word 0x00000001
    .word 0x00200000
    .word 0x00000000
    .word 0x00201000
    .word 0x00000000
    .word 0x00000020
    .word 0x00000001
    .word 0x00000000
    .word 0x0000000F
    .word 0x00000000
ring_end: