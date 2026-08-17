#include "gpu_hw.h"
#include "platform.h"
#include "../gravityon/gpu/gpu_wire.h"

/*
 * Gravityon GPU ports.  These values intentionally match
 * gravityon/gpu/gpu_io.h, but the kernel does not include the host-side GPU
 * headers: the freestanding kernel must have no libc/Gravityon dependency.
 */
/*
 * Reserve the upper part of the user RAM window for the kernel/GPU DMA ring.
 * The simulator's Oxalyn path uses word addresses and lower 32-bit payload
 * words, so one 64-bit RAM word stores one 32-bit wire word.
 */
#if defined(OXALYN_HOST_TEST)
static volatile uint64_t host_ring[OX_GPU_RING_WORDS];
#else
static volatile uint64_t *const gpu_ring =
    (volatile uint64_t *)(uintptr_t)(OX_GPU_RING_BASE_WORD * 8u);
#endif

static uint32_t ring_head;
static uint32_t current_owner;
static int      gpu_ready;

static volatile uint64_t *ring_words(void)
{
#if defined(OXALYN_HOST_TEST)
    return host_ring;
#else
    return gpu_ring;
#endif
}

static void ring_word(uint32_t index, uint32_t value)
{
    ring_words()[index] = (uint64_t)value;
}

static uint32_t color_component(uint32_t color, unsigned shift)
{
    return (color >> shift) & 0xFFu;
}

static void gpu_hw_doorbell(void)
{
    MEMORY_BARRIER();
    MMIO_WRITE(OX_GPU_PORT_RING_HEAD, ring_head);
    MMIO_WRITE(OX_GPU_PORT_DOORBELL, 1);
}

static void gpu_hw_packet(uint32_t type, const uint32_t *payload,
                          uint32_t payload_words)
{
    uint32_t i;
    if (!gpu_ready) return;
    if (ring_head + 3u + payload_words >= OX_GPU_RING_WORDS) {
        /*
         * A submitted packet is consumed synchronously by the current
         * simulator and by the documented doorbell contract.  Resetting the
         * device here prevents the monotonically increasing word head from
         * escaping the reserved RAM window.
         */
        MMIO_WRITE(OX_GPU_PORT_CTRL, OX_GPU_CTRL_RESET);
        ring_head = 0;
        MMIO_WRITE(OX_GPU_PORT_RING_HEAD, 0);
    }
    ring_word(ring_head++, type);
    /* Every kernel 2D packet carries the admitted process identity. */
    ring_word(ring_head++, (payload_words + 1u) * 4u);
    ring_word(ring_head++, current_owner);
    for (i = 0; i < payload_words; i++)
        ring_word(ring_head++, payload[i]);
    gpu_hw_doorbell();
}

void gpu_hw_init(void)
{
#if defined(OXALYN_HOST_TEST)
    gpu_ready = 0;
    ring_head = 0;
    current_owner = 0;
#else
    uint32_t i;
    gpu_ready = (MMIO_READ(OX_GPU_PORT_ID) == OX_GPU_ID);
    ring_head = 0;
    current_owner = 0;
    if (!gpu_ready) return;
    for (i = 0; i < OX_GPU_RING_WORDS; i++) ring_words()[i] = 0;
    MMIO_WRITE(OX_GPU_PORT_CTRL, OX_GPU_CTRL_RESET);
    MMIO_WRITE(OX_GPU_PORT_RING_BASE, OX_GPU_RING_BASE_WORD);
    MMIO_WRITE(OX_GPU_PORT_RING_SIZE, OX_GPU_RING_BYTES);
    MMIO_WRITE(OX_GPU_PORT_RING_HEAD, 0);
    MMIO_WRITE(OX_GPU_PORT_FB_ADDR, 0);
    MMIO_WRITE(OX_GPU_PORT_FB_WIDTH, 800);
    MMIO_WRITE(OX_GPU_PORT_FB_HEIGHT, 600);
    MMIO_WRITE(OX_GPU_PORT_FB_PITCH, 800 * 4);
    MMIO_WRITE(OX_GPU_PORT_FB_FORMAT, 0);
#endif
}

int gpu_hw_available(void) { return gpu_ready; }

void gpu_hw_set_owner(uint32_t pid)
{
    current_owner = pid;
}

void gpu_hw_clear(uint32_t color)
{
    uint32_t p[1] = {color};
    gpu_hw_packet(OX_GPU_CMD_2D_CLEAR, p, 1);
}

void gpu_hw_pixel(int x, int y, uint32_t color)
{
    uint32_t p[3] = {(uint32_t)x, (uint32_t)y, color};
    gpu_hw_packet(OX_GPU_CMD_2D_PIXEL, p, 3);
}

void gpu_hw_line(int x1, int y1, int x2, int y2, uint32_t color)
{
    uint32_t p[5] = {(uint32_t)x1, (uint32_t)y1, (uint32_t)x2,
                     (uint32_t)y2, color};
    gpu_hw_packet(OX_GPU_CMD_2D_LINE, p, 5);
}

void gpu_hw_rect(int x, int y, int w, int h, uint32_t color)
{
    uint32_t p[5] = {(uint32_t)x, (uint32_t)y, (uint32_t)w,
                     (uint32_t)h, color};
    gpu_hw_packet(OX_GPU_CMD_2D_RECT, p, 5);
}

void gpu_hw_circle(int cx, int cy, int r, uint32_t color)
{
    uint32_t p[4] = {(uint32_t)cx, (uint32_t)cy, (uint32_t)r, color};
    gpu_hw_packet(OX_GPU_CMD_2D_CIRCLE, p, 4);
}

void gpu_hw_fill_circle(int cx, int cy, int r, uint32_t color)
{
    uint32_t p[4] = {(uint32_t)cx, (uint32_t)cy, (uint32_t)r, color};
    gpu_hw_packet(OX_GPU_CMD_2D_FILL_CIRCLE, p, 4);
}

void gpu_hw_present(void)
{
    gpu_hw_packet(OX_GPU_CMD_2D_PRESENT, NULL, 0);
}