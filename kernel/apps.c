#include "kernel.h"
#include "apps.h"
#include "scheduler.h"
#include "gpu.h"
#include "mouse.h"
#include "sound.h"

/* ------------------------------------------------------------------ */
/* BUILT-IN DEMO APPS                                                   */
/* ------------------------------------------------------------------ */
static void prog_hello(void)
{
    printf("Hello from HILAL_BIS!\n");
    sys_exit(0);
}

static void prog_counter(void)
{
    int i;
    for (i = 0; i < 10; i++) {
        printf("Count: %d\n", i);
        sys_sleep(500);
    }
    sys_exit(0);
}

static void prog_graphics(void)
{
    printf("Graphics demo starting...\n");
    gpu_clear(0xFF001A33);
    gpu_draw_rect(100, 100, 200, 150, 0xFFFF0000);
    gpu_draw_circle(400, 300, 50, 0xFF00FF00);
    gpu_draw_line(10, 10, 790, 590, 0xFF0000FF);
    printf("Shapes drawn to framebuffer\n");
    sys_exit(0);
}

static void prog_calc(void)
{
    int a = 5, b = 3;
    printf("Calc Demo: %d + %d = %d\n", a, b, a + b);
    printf("           %d * %d = %d\n", a, b, a * b);
    sys_exit(0);
}

/* Paint: draws whatever has accumulated in the mouse state (set via the
 * shell's "mouse <dx> <dy>" / "click" commands — see mouse.c: there is
 * no real pointing device on Oxalyn-64, so this is simulator-only input,
 * exactly as the roadmap specifies). Runs one redraw pass and exits,
 * since this host build dispatches apps cooperatively/run-to-completion
 * (see scheduler.c process_run_now()) rather than truly in the background. */
static void prog_paint(void)
{
    printf("Paint mode — use 'mouse <dx> <dy>' then 'click' before running paint again\n");
    gpu_clear(0xFFFFFFFF);
    if (mouse.buttons & 1) {
        gpu_put_pixel(mouse.x, mouse.y, 0xFF000000);
        mouse.moved = 0;
    }
    draw_cursor();
    sys_exit(0);
}

/* Music: uses the SND I/O port (0x40-0x45) wired to Oxalyn-64's
 * sound subsystem.  Plays a short demo melody then exits. */
static void prog_music(void)
{
    /* Static: Note array must live until sound_play_melody() finishes */
    static const Note demo[] = {
        /* do-re-mi-fa-sol-la-si-do scale */
        { NOTE_C4, 200 }, { NOTE_D4, 200 }, { NOTE_E4, 200 },
        { NOTE_F4, 200 }, { NOTE_G4, 200 }, { NOTE_A4, 200 },
        { NOTE_B4, 200 }, { NOTE_C5, 400 },
        /* short rest then fanfare */
        {       1, 150 },
        { NOTE_G4, 120 }, { NOTE_G4, 120 }, { NOTE_A4, 120 },
        { NOTE_G4, 240 }, { NOTE_C5, 480 },
        { 0, 0 }   /* sentinel — end of melody */
    };

    printf("Music mode — do-re-mi demo + fanfare\n");
    sound_set_volume(220);
    sound_sfx(SFX_BOOT);          /* startup chime */
    sound_play_melody(demo);       /* full melody   */
    sound_sfx(SFX_NOTIFY);        /* outro ding    */
    sys_exit(0);
}

/* ------------------------------------------------------------------ */
/* APP REGISTRY                                                         */
/* ------------------------------------------------------------------ */
static AppPackage apps[MAX_APPS];
static int        app_count = 0;

void apps_init(void)
{
    app_count = 0;
    apps[app_count++] = (AppPackage){"hello",    "Hello World",      prog_hello,    1};
    apps[app_count++] = (AppPackage){"counter",  "Count 0-9",        prog_counter,  1};
    apps[app_count++] = (AppPackage){"graphics", "Graphics demo",    prog_graphics, 1};
    apps[app_count++] = (AppPackage){"calc",     "Calculator demo",  prog_calc,     1};
    apps[app_count++] = (AppPackage){"paint",    "Paint (1 frame)",  prog_paint,    0};
    apps[app_count++] = (AppPackage){"music",    "Beep synth (stub)", prog_music,   0};
}

/* ------------------------------------------------------------------ */
void app_list(void)
{
    int i;
    printf("Available applications:\n");
    printf("------------------------------------\n");
    for (i = 0; i < app_count; i++) {
        printf("  [%s] %s - %s\n",
               apps[i].installed ? "x" : " ", apps[i].name, apps[i].desc);
    }
}

/* ------------------------------------------------------------------ */
int app_launch(const char *name)
{
    int i;
    for (i = 0; i < app_count; i++) {
        if (kstrcmp(apps[i].name, name) == 0) {
            int pid;
            if (!apps[i].installed) {
                printf("Error: '%s' is not installed (try: app install %s)\n", name, name);
                return -1;
            }
            pid = process_create(apps[i].entry, 5);
            if (pid < 0) {
                printf("Error: process table full\n");
                return -1;
            }
            printf("[*] Launched %s (PID %d)\n", name, pid);
#ifdef OXALYN_SIMULATOR
            /* Host dev build: dispatch cooperatively right away (see
               scheduler.c process_run_now()) so the app's output is
               actually visible instead of silently sitting in the
               process table. */
            process_run_now(pid);
#endif
            return pid;
        }
    }
    printf("Error: application '%s' not found\n", name);
    return -1;
}

/* ------------------------------------------------------------------ */
int app_install(const char *name)
{
    int i;
    for (i = 0; i < app_count; i++) {
        if (kstrcmp(apps[i].name, name) == 0) {
            apps[i].installed = 1;
            printf("[OK] %s installed\n", name);
            return 0;
        }
    }
    printf("Error: application '%s' not found\n", name);
    return -1;
}
