#include "kernel.h"
#include "scheduler.h"
#include "memory.h"
#include "uart.h"
#include "gpu.h"
#include "gpu_hw.h"
#include "gui_guard.h"
#include "gpu_cmd.h"
#include "shell.h"
#include "ui.h"
#include "input.h"
#include "mouse.h"
#include "auth.h"
#include "perms.h"
#include "filesystem.h"
#include "apps.h"
#include "wm.h"
#include "network.h"
#include "usb_hid.h"
#include "wifi.h"
#include "rtc.h"
#include <stdarg.h>

/* GLOBAL KERNEL STATE */
Process  process_table[MAX_PROCESSES];
int      current_pid        = 0;
uint32_t total_ticks        = 0;
uint32_t context_switches   = 0;
uint32_t syscalls_handled   = 0;

/* ------------------------------------------------------------------ */
/* MAIN KERNEL ENTRY                                                    */
/* FAZ 1-2: bootloader already ran (boot.asm) and jumped here.          */
/* This function walks through every subsystem in the roadmap order:   */
/*   splash -> core init -> input -> auth/perms -> fs -> apps -> wm ->  */
/*   network(stub) -> login -> shell                                    */
/* ------------------------------------------------------------------ */
void kernel_main(void)
{
    int shell_pid;

    uart_init();
    memory_init();
    scheduler_init();
    gpu_init();
    gpu_cmd_init();   /* Sprite/tile motoru ve GPU komut kuyruğunu başlat */

    /* FAZ 1.2 / 2.2 — splash screen + animated loading bar */
    ui_boot_splash();

    ui_loading_bar("Memory Manager", 10);
    ui_loading_bar("Scheduler", 20);

    keyboard_init();
    mouse_init();
    usb_hid_init();
    ui_loading_bar("Input (keyboard/mouse/USB HID)", 35);

    auth_init();
    perms_init();
    ui_loading_bar("Auth + Permissions", 50);

    fs_init();
    ui_loading_bar("Filesystem (RAM)", 65);

    apps_init();
    ui_loading_bar("Applications", 80);

    wm_init();
    network_init();
    wifi_init();
    ui_loading_bar("Window Manager + Network + WiFi", 100);
    desktop_welcome_screen();
    /*
     * Keep the first complete desktop frame explicit.  The timer-driven
     * wm_run() path is responsible for later interactive frames, but login
     * runs before the scheduler starts and otherwise leaves the simulator
     * with only the one-shot splash path.
     */
    wm_render();

    printf("\n[OK] Boot complete!\n\n");
    printf("HILAL_BIS v1.0 - Oxalyn-64 OS\n");
    printf("[*] Kernel initialized successfully\n");
    printf("[*] Memory: 512 KB word-addressed\n");
    printf("[*] Processes: %d max\n", MAX_PROCESSES);
    printf("[*] GPU: %dx%d framebuffer ready\n", FB_WIDTH, FB_HEIGHT);

    /* FAZ 6.1 — login gate before the shell is reachable */
    if (login_prompt() < 0) {
        panic("Too many failed login attempts");
    }

    shell_pid = process_create(shell_main, 7);
    if (shell_pid < 0) {
        panic("Failed to create shell process");
    }

    printf("[*] Shell spawned (PID %d)\n", shell_pid);
    printf("[*] Starting scheduler...\n\n");

#if defined(OXALYN_HOST_TEST) || defined(OXALYN_SIMULATOR)
    /* Host dev build: no real timer IRQ exists to drive scheduler_run()'s
       trap-based dispatch, so call the shell directly (see scheduler.c
       process_run_now() for why). shell_main() loops forever, so this
       still never returns. */
    process_run_now(shell_pid);
#else
    scheduler_run();   /* never returns — real hardware trap-driven loop */
#endif
}

#ifdef OXALYN_HOST_TEST
/*
 * Host build entry point. Do not use kernel_main as the ELF entry directly:
 * libc must initialize stdio and the process runtime before the kernel starts.
 */
int main(void)
{
    kernel_main();
    return 0;
}
#endif

/* ------------------------------------------------------------------ */
/* PANIC                                                                */
/* ------------------------------------------------------------------ */
void panic(const char *msg)
{
    printf("\n[PANIC] %s\n", msg);
    printf("[PANIC] System halted.\n");
    while (1) { /* spin */ }
}

/* ------------------------------------------------------------------ */
/* TRAP DISPATCHER                                                      */
/* ------------------------------------------------------------------ */
void trap_dispatcher(uint32_t cause, uint64_t tval)
{
    switch (cause) {
        case 7:   /* Timer interrupt */
            timer_interrupt_handler();
            break;
        case 5:   /* ECALL from user */
        case 6:   /* ECALL from supervisor */
            ecall_handler();
            break;
        case 2:   /* Illegal instruction */
            printf("[TRAP] Illegal instruction at 0x%x\n", (unsigned)tval);
            process_kill(current_pid);
            scheduler();
            break;
        default:
            printf("[TRAP] Unknown trap %u (tval=0x%llx)\n",
                   (unsigned)cause, (unsigned long long)tval);
            process_kill(current_pid);
            scheduler();
    }
}

/* Forward declaration — alarm_tick tanımı aşağıda, buradan önce kullanılıyor */
static void alarm_tick(void);

/* ------------------------------------------------------------------ */
/* TIMER INTERRUPT                                                      */
/* ------------------------------------------------------------------ */
void timer_interrupt_handler(void)
{
    total_ticks++;

    /* USB HID: bekleyen raporları oku + key-repeat sayacını güncelle */
    usb_hid_poll();
    usb_hid_tick();
    smp_handle_ipi((uint32_t)smp_current_core());
    smp_account_tick((uint32_t)smp_current_core());
    if (current_pid >= 0 && current_pid < MAX_PROCESSES) {
        process_table[current_pid].cpu_ticks++;
        process_table[current_pid].last_cpu = (uint32_t)smp_current_core();
    }
    wm_run();
    /* Timer ticks are the real kernel render loop after boot. */
    wm_render();

    if (process_table[current_pid].ticks_remaining > 0)
        process_table[current_pid].ticks_remaining--;

    /* Bekleyen sinyalleri her tick'te kontrol et */
    signal_check(current_pid);
    /* Alarm tablosunu kontrol et */
    alarm_tick();

    if (process_table[current_pid].ticks_remaining == 0) {
        process_table[current_pid].ticks_remaining = TIMER_QUANTUM;
        scheduler();
    }
}

/* ------------------------------------------------------------------ */
/* ECALL HANDLER                                                        */
/* ------------------------------------------------------------------ */
void ecall_handler(void)
{
    syscalls_handled++;
    /* R2 = syscall number, R3/R4/R5 = args — filled by asm wrapper.
       Here we call with zeroes; the asm layer must populate them. */
    syscall_handler(
        (uint32_t)process_table[current_pid].regs[2],
        process_table[current_pid].regs[3],
        process_table[current_pid].regs[4],
        process_table[current_pid].regs[5]
    );
}

/* ------------------------------------------------------------------ */
/* SYSTEM CALL DISPATCHER                                               */
/* ------------------------------------------------------------------ */
void syscall_handler(uint32_t num, uint64_t arg1, uint64_t arg2, uint64_t arg3)
{
    uint64_t retval = 0;

    switch (num) {
        case 1:  retval = (uint64_t)sys_fork();                          break;
        case 2:  retval = (uint64_t)sys_exec((void *)(uintptr_t)arg1);  break;
        case 3:  sys_exit((int)arg1); retval = 0;                        break;
        case 4:  retval = (uint64_t)sys_write((int)arg1, (void *)(uintptr_t)arg2, (int)arg3); break;
        case 5:  retval = (uint64_t)sys_read((int)arg1, (void *)(uintptr_t)arg2, (int)arg3);  break;
        case 6:  retval = (uint64_t)sys_sleep((uint32_t)arg1);           break;
        case 7:  retval = (uint64_t)current_pid;                         break;
        case 8:  retval = (uint64_t)sys_spawn((void *)(uintptr_t)arg1);   break;
        case 9:  retval = (uint64_t)sys_gpu_draw((void *)(uintptr_t)arg1);break;
        case 10: retval = (uint64_t)sys_kill((int)arg1, (int)arg2);        break;
        case 11: retval = (uint64_t)sys_alarm((uint32_t)arg1);             break;
        case 12: sys_yield(); retval = 0;                                   break;
        case 13: retval = (uint64_t)sys_gettime(
                     (uint32_t *)(uintptr_t)arg1,
                     (uint32_t *)(uintptr_t)arg2);                         break;
        case 14: retval = (uint64_t)sys_gui_status(
                      (GuiStatus *)(uintptr_t)arg1);                          break;
        case 15: retval = (uint64_t)sys_gui_reset();                         break;
        default: retval = (uint64_t)-1;
    }

    process_table[current_pid].regs[7] = retval;
}

/* ------------------------------------------------------------------ */
/* SYSTEM CALL IMPLEMENTATIONS                                          */
/* ------------------------------------------------------------------ */

int sys_fork(void)
{
    int new_pid = -1;
    int i;

    for (i = 0; i < MAX_PROCESSES; i++) {
        if (process_table[i].state == PROC_FREE) {
            new_pid = i;
            break;
        }
    }
    if (new_pid < 0) return -1;

    memcpy(&process_table[new_pid], &process_table[current_pid], sizeof(Process));

    process_table[new_pid].state            = PROC_READY;
    process_table[new_pid].parent_pid       = (uint32_t)current_pid;
    process_table[new_pid].ticks_remaining  = TIMER_QUANTUM;

    /* Parent returns child PID, child returns 0 */
    process_table[current_pid].regs[7] = (uint64_t)new_pid;
    process_table[new_pid].regs[7]     = 0;

    return new_pid;
}

int sys_exec(void *program_addr)
{
    memset(process_table[current_pid].regs, 0,
           sizeof(process_table[current_pid].regs));
    process_table[current_pid].pc = (uint32_t)(uintptr_t)program_addr;
    /*
     * exec yeni bir kullanıcı programı başlatır; önceki programın GUI hata
     * geçmişi ve tükettiği kota yeni programa miras kalmamalıdır.
     */
    gui_guard_reset(&process_table[current_pid]);
    return 0;
}

void sys_exit(int status)
{
    process_table[current_pid].state      = PROC_ZOMBIE;
    process_table[current_pid].regs[7]    = (uint64_t)status;
    scheduler();
}

int sys_write(int fd, void *buf, int count)
{
    int i;
    if (fd == 1) {   /* stdout -> UART */
        if (count < 0 || !gui_user_buffer_valid(buf, (size_t)count))
            return -1;
        for (i = 0; i < count; i++)
            KPUTCHAR(((char *)buf)[i]);
        return count;
    } else if (fd == 2) {   /* framebuffer */
        volatile uint32_t *fb = platform_framebuffer();
        const uint32_t *src   = (const uint32_t *)buf;
        int admission;
        if (count < 0 || count > FB_WIDTH * FB_HEIGHT ||
            !gui_user_buffer_valid(buf, (size_t)count * sizeof(uint32_t)))
            return gui_guard_record_fault(&process_table[current_pid],
                                          "gecersiz framebuffer yazma istegi"), -1;
        admission = gui_guard_admit_pixels(&process_table[current_pid],
                                           (uint64_t)count);
        if (admission != 0) return admission;
        for (i = 0; i < count; i++)
            fb[i] = src[i];
        gpu_present();
        return count;
    }
    return -1;
}

int sys_read(int fd, void *buf, int count)
{
    int i;
    if (fd == 0) {   /* stdin -> UART */
        for (i = 0; i < count; i++)
            ((char *)buf)[i] = (char)KGETCHAR();
        return count;
    }
    return -1;
}

int sys_sleep(uint32_t ms)
{
    process_table[current_pid].ticks_remaining =
        (ms / (uint32_t)TIMER_QUANTUM) + 1;
    process_table[current_pid].state = PROC_BLOCKED;
    scheduler();
    return 0;
}

int sys_spawn(void *program_addr)
{
    int pid = sys_fork();
    if (pid >= 0)
        process_table[pid].pc = (uint32_t)(uintptr_t)program_addr;
    return pid;
}

int sys_kill(int pid, int sig)
{
    if (pid < 0 || pid >= MAX_PROCESSES) return -1;
    if (process_table[pid].state == PROC_FREE) return -1;
    signal_deliver(pid, sig);
    return 0;
}

/* ------------------------------------------------------------------ */
/* sys_alarm — ms sonra mevcut prosese SIGALRM gönder (0=iptal)        */
/* ------------------------------------------------------------------ */
typedef struct { int pid; uint32_t fire_tick; } AlarmEntry;
static AlarmEntry alarm_table[MAX_PROCESSES];
static int alarm_table_init = 0;

int sys_alarm(uint32_t ms)
{
    int i;
    extern uint32_t total_ticks;

    if (!alarm_table_init) {
        int j;
        for (j = 0; j < MAX_PROCESSES; j++) alarm_table[j].pid = -1;
        alarm_table_init = 1;
    }

    /* ms == 0: mevcut alarmı iptal et */
    for (i = 0; i < MAX_PROCESSES; i++) {
        if (alarm_table[i].pid == current_pid) {
            alarm_table[i].pid = -1;
            break;
        }
    }
    if (ms == 0) return 0;

    /* Boş yuva bul ve alarm kur */
    for (i = 0; i < MAX_PROCESSES; i++) {
        if (alarm_table[i].pid < 0) {
            alarm_table[i].pid       = current_pid;
            alarm_table[i].fire_tick = total_ticks + ms / (uint32_t)TIMER_QUANTUM;
            return 0;
        }
    }
    return -1; /* tablo dolu */
}

/* alarm_tick — timer_interrupt_handler içinden çağrılır */
static void alarm_tick(void)
{
    extern uint32_t total_ticks;
    int i;
    if (!alarm_table_init) return;
    for (i = 0; i < MAX_PROCESSES; i++) {
        if (alarm_table[i].pid >= 0 &&
            total_ticks >= alarm_table[i].fire_tick) {
            signal_deliver(alarm_table[i].pid, SIGALRM);
            alarm_table[i].pid = -1;
        }
    }
}

/* ------------------------------------------------------------------ */
/* sys_yield — CPU'yu gönüllü olarak bırak                             */
/* ------------------------------------------------------------------ */
void sys_yield(void)
{
    process_table[current_pid].ticks_remaining = 0;
    scheduler();
}

/* ------------------------------------------------------------------ */
/* sys_gettime — anlık tick + saniye bilgisini döner                   */
/* ------------------------------------------------------------------ */
int sys_gettime(uint32_t *out_tick, uint32_t *out_sec)
{
    extern uint32_t total_ticks;
    if (out_tick) *out_tick = total_ticks;
    if (out_sec)  *out_sec  = total_ticks / (1000u / (uint32_t)TIMER_QUANTUM);
    return 0;
}

int sys_gui_status(GuiStatus *status)
{
    Process *process = &process_table[current_pid];
    if (!gui_user_buffer_valid(status, sizeof(*status))) return -1;
    status->enabled = process->gui_enabled;
    status->faults  = process->gui_faults;
    status->ops     = process->gui_ops;
    status->pixels  = process->gui_pixels;
    return 0;
}

int sys_gui_reset(void)
{
    gui_guard_reset(&process_table[current_pid]);
    KPRINT("[GUI_GUARD] GUI yetkisi yeniden etkinlestirildi\n");
    return 0;
}

/* ------------------------------------------------------------------ */
/* SİNYAL SİSTEMİ                                                       */
/*                                                                      */
/* Her sinyal, process_table[pid].signal_mask içinde bir bit olarak    */
/* tutulur.  signal_deliver() ilgili biti set eder.  signal_check()    */
/* her timer tick'inde çağrılır ve bekleyen bitleri tek tek işler.     */
/* SIGKILL yakalanamaz — süreci anında PROC_FREE yapar.                */
/* SIGTERM / SIGINT → işlemci varsa signal_mask temizlenir ve proses   */
/* normal sys_exit() akışıyla sonlandırılır.                           */
/* SIGCHLD / SIGHUP → şimdilik sessizce tüketilir (log).              */
/* SIGALRM → gelecekte per-process alarm için ayrılmış.               */
/* ------------------------------------------------------------------ */

void signal_deliver(int pid, int sig)
{
    if (pid < 0 || pid >= MAX_PROCESSES) return;
    if (process_table[pid].state == PROC_FREE) return;
    if (sig < 1 || sig > 31) return;

    process_table[pid].signal_mask |= (1u << (uint32_t)sig);
}

void signal_check(int pid)
{
    uint32_t mask;
    int sig;

    if (pid < 0 || pid >= MAX_PROCESSES) return;
    if (process_table[pid].state == PROC_FREE) return;

    mask = process_table[pid].signal_mask;
    if (!mask) return;

    /* Bitleri düşükten yükseğe tara — ilkini işle, sonra dön */
    for (sig = 1; sig <= 31; sig++) {
        if (!(mask & (1u << (uint32_t)sig))) continue;

        /* Biti hemen temizle (re-entrant sorunları önler) */
        process_table[pid].signal_mask &= ~(1u << (uint32_t)sig);

        switch (sig) {
            case SIGKILL:
                /* Yakalanamaz — anında öldür */
                process_table[pid].state = PROC_FREE;
                if (current_pid == pid) scheduler();
                return;

            case SIGTERM:
            case SIGINT:
            case SIGQUIT:
                /* Yazılım sonlandırma — proses temizlenerek öldürülür */
                process_table[pid].state = PROC_ZOMBIE;
                if (current_pid == pid) {
                    process_table[pid].state = PROC_FREE;
                    scheduler();
                }
                return;

            case SIGALRM:
                /* Alarm — engeli kaldır (sys_sleep bloğunu aç) */
                if (process_table[pid].state == PROC_BLOCKED)
                    process_table[pid].state = PROC_READY;
                break;

            case SIGCHLD:
            case SIGHUP:
            default:
                /* Varsayılan: sinyal tüketildi, sessizce devam */
                break;
        }
        return; /* Her tick'te en fazla bir sinyali işle */
    }
}

int sys_gpu_draw(void *draw_cmd)
{
    GpuDrawRequest *dc = (GpuDrawRequest *)draw_cmd;
    int admission;

    if (!gui_user_buffer_valid(draw_cmd, sizeof(*dc))) {
        gui_guard_record_fault(&process_table[current_pid],
                               "gecersiz GUI komut adresi");
        return GUI_FAULT_INVALID;
    }
    admission = gui_guard_admit(&process_table[current_pid], dc, NULL);
    if (admission != 0) return admission;

    /*
     * The guard owns the process identity.  Gravityon is a device backend,
     * not a security boundary, so pass the admitted PID as sideband metadata
     * and translate the kernel request into the device wire protocol.
     */
    gpu_hw_set_owner((uint32_t)current_pid);
    switch (dc->cmd) {
        case 0: gpu_clear(dc->color);                                  break;
        case 1: gpu_put_pixel(dc->x, dc->y, dc->color);               break;
        case 2: gpu_draw_line(dc->x, dc->y, dc->w, dc->h, dc->color); break;
        case 3: gpu_draw_rect(dc->x, dc->y, dc->w, dc->h, dc->color); break;
        case 4: gpu_draw_circle(dc->x, dc->y, dc->w, dc->color);      break;
        default: return -1;
    }
    gpu_present();
    return 0;
}
