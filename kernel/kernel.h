#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>
#include <stddef.h>
#include "kstring.h"   /* freestanding memcpy/strcmp/etc — no libc needed */
#include "platform.h"  /* ortak MMIO, UART ve framebuffer sınırı */
#include "smp.h"

/* CONSTANTS */

#define MAX_PROCESSES   8
#define MAX_WINDOWS     8
#define HEAP_SIZE       (12 * 1024)
#define FB_WIDTH        800
#define FB_HEIGHT       600
#define FB_ADDR         0x8000
#define TIMER_QUANTUM   10          /* 10ms time slice */

/* PROCESS STATES */
#define PROC_FREE       0
#define PROC_READY      1
#define PROC_RUNNING    2
#define PROC_BLOCKED    3
#define PROC_ZOMBIE     4

/* ── Sinyal Numaraları (POSIX uyumlu subset) ───────────── */
#define SIGHUP    1    /* Uçbirim kapandı               */
#define SIGINT    2    /* Ctrl+C kesmesi                */
#define SIGQUIT   3    /* Ctrl+\ çıkış                  */
#define SIGKILL   9    /* Anında öldür (yakalanamaz)    */
#define SIGALRM  14    /* Alarm saati doldu             */
#define SIGTERM  15    /* Yazılım sonlandırma isteği    */
#define SIGCHLD  17    /* Alt proses durumu değişti     */

/* PROCESS STRUCTURE */
typedef struct Process {
    uint64_t regs[32];          /* R0-R31 saved */
    uint32_t pc;                /* Program counter (from MEPC) */
    uint32_t state;             /* PROC_* */
    uint32_t priority;          /* 0-7 (higher = more priority) */
    uint32_t ticks_remaining;   /* Time quantum countdown */
    uint32_t parent_pid;        /* Parent process ID */
    uint32_t signal_mask;       /* Pending signals */
    uint32_t stack_base;        /* Stack base address */
    uint32_t perf_cycles;       /* Cycle counter */
    uint32_t gui_enabled;       /* GUI yetkisi açık mı? */
    uint32_t gui_faults;        /* GUI doğrulama hataları */
    uint32_t gui_ops;           /* süreç başına kabul edilen GUI istekleri */
    uint64_t gui_pixels;        /* süreç başına tahmini çizim bütçesi */
    void (*entry_fn)(void);     /* Host dev build only — see process_run_now() */
    uint32_t affinity_mask;     /* allowed logical CPU mask */
    uint32_t last_cpu;          /* last CPU selected by the scheduler */
    uint64_t cpu_ticks;         /* scheduler ticks charged to this process */
} Process;

typedef struct {
    uint32_t enabled;
    uint32_t faults;
    uint32_t ops;
    uint64_t pixels;
} GuiStatus;

/* WINDOW STRUCTURE */
typedef struct {
    int x, y, w, h;            /* Position and size */
    uint32_t bg_color;          /* Background color (RGBA) */
    char title[32];             /* Window title */
    int active;                 /* 1 = visible, 0 = hidden */
    int focused;                /* 1 = topmost/focused window */
    int minimized;               /* 1 = hidden from canvas, shown on taskbar */
    uint32_t title_color;       /* Title bar accent colour (theme-dependent) */
} Window;

/* FUNCTION DECLARATIONS */

/* kernel.c */
void kernel_main(void);
void panic(const char *msg);
void trap_handler(void);        /* Called from trap (asm) */
void trap_dispatcher(uint32_t cause, uint64_t tval);
void timer_interrupt_handler(void);
void ecall_handler(void);
void syscall_handler(uint32_t num, uint64_t arg1, uint64_t arg2, uint64_t arg3);

int  sys_fork(void);
int  sys_exec(void *program_addr);
void sys_exit(int status);
int  sys_write(int fd, void *buf, int count);
int  sys_read(int fd, void *buf, int count);
int  sys_sleep(uint32_t ms);
int  sys_spawn(void *program_addr);
int  sys_gpu_draw(void *draw_cmd);
int  sys_kill(int pid, int sig);
int  sys_alarm(uint32_t ms);    /* ms sonra SIGALRM gönder (0=iptal) */
void sys_yield(void);           /* CPU'yu gönüllü bırak              */
int  sys_gettime(uint32_t *out_tick, uint32_t *out_sec); /* anlık zaman */
int  sys_gui_status(GuiStatus *status);
int  sys_gui_reset(void);

/* ── Sinyal sistemi ─────────────────────────────────────────────── */
void signal_deliver(int pid, int sig);   /* Sinyali kuyruğa ekle        */
void signal_check(int pid);              /* Bekleyen sinyalleri işle    */

/* scheduler.c */
void scheduler_init(void);
void scheduler(void);
void scheduler_run(void);
void context_switch(int from_pid, int to_pid);
int  process_create(void (*entry)(void), int priority);
void process_kill(int pid);
int  get_current_pid(void);
void process_run_now(int pid);   /* host dev-build dispatch, see scheduler.c */
int  process_set_affinity(int pid, uint32_t mask);
uint32_t process_get_affinity(int pid);

/* memory.c */
void  memory_init(void);
void *kmalloc(size_t size);
void  kfree(void *ptr);

/* uart.c */
void uart_init(void);
void uart_putchar(char c);
char uart_getchar(void);
void uart_puts(const char *s);
void kprintf(const char *fmt, ...);

/* I/O yönlendirme: eski kaynaklardaki printf çağrıları da platform
 * çıkışına yönlendirilir. Yeni sürücüler KPRINT kullanmalıdır. */
#ifdef OXALYN_HOST_TEST
#  include <stdio.h>
#  include "hostio.h"   /* oxalyn_printf bildirimi */
#endif
#define printf KPRINT

/* gpu.c */
void gpu_init(void);
void gpu_clear(uint32_t color);
void gpu_put_pixel(int x, int y, uint32_t color);
void gpu_draw_line(int x1, int y1, int x2, int y2, uint32_t color);
void gpu_draw_rect(int x, int y, int w, int h, uint32_t color);
void gpu_draw_circle(int cx, int cy, int r, uint32_t color);
void gpu_present(void);
void gpu_save_frame_raw(const char *filename);

/* shell.c */
void shell_main(void);
void shell_prompt(void);
int  shell_parse_command(const char *cmd);

#endif /* KERNEL_H */
