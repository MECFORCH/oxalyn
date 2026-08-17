/*
 * Kernel GUI wire-protocol integration test.
 *
 * This is intentionally not an assembly square test.  It writes the exact
 * owner-prefixed packets emitted by kernel/gpu_hw.c into an Oxalyn word RAM
 * buffer, rings the Gravityon doorbell, and checks the resulting framebuffer
 * and owner accounting.
 */
#include "../gravityon/gpu/gpu_sim.h"
#include "../gravityon/gpu/gpu_wire.h"

#include <stdint.h>
#include <stdio.h>

#define TEST_RING_BASE 16u
#define TEST_MEM_WORDS 128u

static int fail(const char *message)
{
    fprintf(stderr, "[FAIL] %s\n", message);
    return 1;
}

static void word(uint64_t *memory, uint32_t *head, uint32_t value)
{
    memory[TEST_RING_BASE + *head] = value;
    (*head)++;
}

int main(void)
{
    GPUSim gpu;
    uint64_t memory[TEST_MEM_WORDS] = {0};
    uint32_t head = 0;
    uint8_t *pixel;
    int processed;

    if (gpusim_init(&gpu) != 0)
        return fail("GPUSim init");

    gpusim_set_mem_base_words(&gpu, memory, TEST_MEM_WORDS, 8);
    gpusim_port_write(&gpu, GPU_PORT_CTRL, 1);
    gpusim_port_write(&gpu, GPU_PORT_FB_ADDR, 0);
    gpusim_port_write(&gpu, GPU_PORT_FB_WIDTH, 8);
    gpusim_port_write(&gpu, GPU_PORT_FB_HEIGHT, 8);
    gpusim_port_write(&gpu, GPU_PORT_FB_PITCH, 8 * 4);
    gpusim_port_write(&gpu, GPU_PORT_FB_FORMAT, 0);
    gpusim_port_write(&gpu, GPU_PORT_RING_BASE, TEST_RING_BASE);
    gpusim_port_write(&gpu, GPU_PORT_RING_SIZE, 256);

    /* CLEAR: header + owner + packed AARRGGBB payload */
    word(memory, &head, OX_GPU_CMD_2D_CLEAR);
    word(memory, &head, 8);
    word(memory, &head, 7);
    word(memory, &head, 0xFF000000u);

    /* RECT: header + owner + x, y, w, h, packed AARRGGBB */
    word(memory, &head, OX_GPU_CMD_2D_RECT);
    word(memory, &head, 24);
    word(memory, &head, 7);
    word(memory, &head, 1);
    word(memory, &head, 2);
    word(memory, &head, 3);
    word(memory, &head, 2);
    word(memory, &head, 0xFF112233u);

    /* PRESENT: header + owner */
    word(memory, &head, OX_GPU_CMD_2D_PRESENT);
    word(memory, &head, 4);
    word(memory, &head, 7);

    gpusim_port_write(&gpu, GPU_PORT_RING_HEAD, head);
    gpusim_port_write(&gpu, GPU_PORT_DOORBELL, 1);
    processed = (int)gpu.ownerCommands;

    if (processed != 3)
        return fail("owner-prefixed packets were not all processed");
    if (gpu.framesRendered != 1)
        return fail("kernel present did not reach Gravityon");
    if (gpu.lastOwnerPid != 7)
        return fail("kernel GUI owner PID was not preserved");

    pixel = gpu.vram + gpu.fbOffset + (2u * gpu.fbPitch) + (1u * 4u);
    if (pixel[0] != 0x11 || pixel[1] != 0x22 ||
        pixel[2] != 0x33 || pixel[3] != 0xFF)
        return fail("kernel rectangle did not render to Gravityon framebuffer");

    /* Old unowned payloads must not be silently accepted as kernel packets. */
    {
        uint32_t old_payload[5] = {1, 2, 3, 4, 0xFFFFFFFFu};
        uint64_t owners = gpu.ownerCommands;
        gpusim_exec_cmd(&gpu, (GPUCmdType)GPU_CMD_2D_RECT,
                        old_payload, sizeof(old_payload));
        if (gpu.ownerCommands != owners)
            return fail("unowned 2D packet was accepted");
    }

    gpusim_destroy(&gpu);
    puts("[OK] kernel GUI wire protocol → Gravityon framebuffer");
    return 0;
}