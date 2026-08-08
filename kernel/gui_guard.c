#include "kernel.h"
#include "gui_guard.h"

static uint64_t abs_coord(int value)
{
    return value < 0 ? (uint64_t)(-(value + 1)) + 1u : (uint64_t)value;
}

int gui_user_buffer_valid(const void *buffer, size_t size)
{
    if (!buffer) return 0;
#ifdef OXALYN_HOST_TEST
    /*
     * Host test pointer'ları normal process adresleridir; C ile güvenli bir
     * "probe" yapılamaz. Null kontrolü burada tek taşınabilir kontroldür.
     */
    (void)size;
    return 1;
#else
    /*
     * Oxalyn bellek haritasında process stack/user bölgesi 0x2000..0x7FFF,
     * framebuffer ise 0x8000'den başlar. Toplama taşmasını da reddet.
     */
    uintptr_t address = (uintptr_t)buffer;
    if (address < 0x2000u || address > 0x7FFFu) return 0;
    if (size > (size_t)(0x8000u - address)) return 0;
    return 1;
#endif
}

static int coord_reasonable(int value, int limit)
{
    return value >= -limit && value <= limit;
}

static int request_valid(const GpuDrawRequest *request, uint64_t *pixels)
{
    uint64_t estimate = 0;
    int dx;
    int dy;

    if (!request || !pixels) return 0;

    switch (request->cmd) {
        case 0: /* clear */
            estimate = (uint64_t)FB_WIDTH * (uint64_t)FB_HEIGHT;
            break;
        case 1: /* pixel */
            if (request->x < 0 || request->x >= FB_WIDTH ||
                request->y < 0 || request->y >= FB_HEIGHT) return 0;
            estimate = 1;
            break;
        case 2: /* line */
            if (!coord_reasonable(request->x, FB_WIDTH) ||
                !coord_reasonable(request->y, FB_HEIGHT) ||
                !coord_reasonable(request->w, FB_WIDTH) ||
                !coord_reasonable(request->h, FB_HEIGHT)) return 0;
            dx = request->w - request->x;
            dy = request->h - request->y;
            estimate = (uint64_t)(abs_coord(dx) > abs_coord(dy)
                       ? abs_coord(dx) : abs_coord(dy)) + 1u;
            break;
        case 3: /* filled rectangle */
            if (!coord_reasonable(request->x, FB_WIDTH) ||
                !coord_reasonable(request->y, FB_HEIGHT) ||
                request->w <= 0 || request->h <= 0 ||
                request->w > FB_WIDTH || request->h > FB_HEIGHT) return 0;
            estimate = (uint64_t)request->w * (uint64_t)request->h;
            break;
        case 4: /* circle */
            if (!coord_reasonable(request->x, FB_WIDTH) ||
                !coord_reasonable(request->y, FB_HEIGHT) ||
                request->w <= 0 || request->w > FB_WIDTH) return 0;
            estimate = (uint64_t)request->w * (uint64_t)request->w;
            break;
        default:
            return 0;
    }

    *pixels = estimate;
    return estimate <= GUI_MAX_PIXELS;
}

void gui_guard_init(struct Process *process)
{
    if (!process) return;
    process->gui_enabled = 1;
    process->gui_faults = 0;
    process->gui_ops = 0;
    process->gui_pixels = 0;
}

int gui_guard_enabled(const struct Process *process)
{
    return process && process->gui_enabled != 0;
}

void gui_guard_record_fault(struct Process *process, const char *reason)
{
    if (!process) return;
    if (process->gui_faults < GUI_FAULT_LIMIT)
        process->gui_faults++;
    if (reason)
        KPRINT("[GUI_GUARD] %s (fault %u/%u)\n", reason,
               (unsigned)process->gui_faults, (unsigned)GUI_FAULT_LIMIT);
    if (process->gui_faults >= GUI_FAULT_LIMIT) {
        process->gui_enabled = 0;
        KPRINT("[GUI_GUARD] GUI karantinaya alindi; kernel calismaya devam ediyor\n");
    }
}

int gui_guard_admit(struct Process *process,
                    const GpuDrawRequest *request,
                    uint64_t *estimated_pixels)
{
    uint64_t pixels = 0;

    if (!gui_guard_enabled(process)) return GUI_FAULT_DISABLED;
    if (!request_valid(request, &pixels)) {
        gui_guard_record_fault(process, "gecersiz cizim istegi");
        return GUI_FAULT_INVALID;
    }
    if (gui_guard_admit_pixels(process, pixels) != 0)
        return GUI_FAULT_BUDGET;

    if (estimated_pixels) *estimated_pixels = pixels;
    return 0;
}

int gui_guard_admit_pixels(struct Process *process, uint64_t pixels)
{
    if (!gui_guard_enabled(process)) return GUI_FAULT_DISABLED;
    if (pixels > GUI_MAX_PIXELS) {
        gui_guard_record_fault(process, "GUI piksel istegi cok buyuk");
        return GUI_FAULT_INVALID;
    }
    if (process->gui_ops >= GUI_MAX_OPS ||
        process->gui_pixels > GUI_MAX_PIXELS - pixels) {
        gui_guard_record_fault(process, "GUI cizim kotasi asildi");
        return GUI_FAULT_BUDGET;
    }

    process->gui_ops++;
    process->gui_pixels += pixels;
    return 0;
}

void gui_guard_reset(struct Process *process)
{
    gui_guard_init(process);
}