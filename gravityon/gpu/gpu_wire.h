/*
 * Oxalyn kernel ↔ Gravityon GPU wire contract.
 *
 * This header is deliberately freestanding: it contains only integer
 * constants, so the kernel can include it without a libc or host-GPU
 * dependency.
 */
#ifndef OXALYN_GRAVITYON_GPU_WIRE_H
#define OXALYN_GRAVITYON_GPU_WIRE_H

#include <stdint.h>

/* GPU I/O ports used by the kernel adapter and the simulator. */
#define OX_GPU_PORT_ID          0xE0u
#define OX_GPU_PORT_CTRL        0xE3u
#define OX_GPU_PORT_RING_BASE   0xE4u
#define OX_GPU_PORT_RING_SIZE   0xE5u
#define OX_GPU_PORT_RING_HEAD   0xE6u
#define OX_GPU_PORT_DOORBELL    0xE8u
#define OX_GPU_PORT_FB_ADDR     0xEEu
#define OX_GPU_PORT_FB_WIDTH    0xEFu
#define OX_GPU_PORT_FB_HEIGHT   0xF0u
#define OX_GPU_PORT_FB_PITCH    0xF1u
#define OX_GPU_PORT_FB_FORMAT   0xF2u
#define OX_GPU_PORT_DEBUG       0xFFu

#define OX_GPU_ID               UINT64_C(0x47505500)
#define OX_GPU_CTRL_RESET       UINT32_C(1)

/*
 * The ring address is expressed in Oxalyn 64-bit memory words. Each wire
 * word occupies the low 32 bits of one Oxalyn memory word.
 */
#define OX_GPU_RING_BASE_WORD  UINT32_C(0x6000)
#define OX_GPU_RING_WORDS      UINT32_C(8192)
#define OX_GPU_RING_BYTES      (OX_GPU_RING_WORDS * UINT32_C(4))

/* Oxalyn-specific 2D extensions. */
#define OX_GPU_CMD_2D_PIXEL         UINT32_C(0x0100)
#define OX_GPU_CMD_2D_LINE          UINT32_C(0x0101)
#define OX_GPU_CMD_2D_RECT          UINT32_C(0x0102)
#define OX_GPU_CMD_2D_CIRCLE        UINT32_C(0x0103)
#define OX_GPU_CMD_2D_FILL_CIRCLE   UINT32_C(0x0104)
#define OX_GPU_CMD_2D_CLEAR         UINT32_C(0x0105)
#define OX_GPU_CMD_2D_PRESENT       UINT32_C(0x0106)

#endif /* OXALYN_GRAVITYON_GPU_WIRE_H */