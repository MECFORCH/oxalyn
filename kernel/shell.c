#include "kernel.h"
#include "shell.h"
#include "scheduler.h"
#include "gpu.h"
#include "apps.h"
#include "filesystem.h"
#include "auth.h"
#include "wm.h"
#include "mouse.h"
#include "wifi.h"
#include "rtc.h"
#include "ipc.h"
#include "syslog.h"
#include "platform.h"
#include "gui_guard.h"

#define CMD_MAXLEN   64
#define HISTORY_SIZE 10

static char command_buffer[CMD_MAXLEN];
static char history[HISTORY_SIZE][CMD_MAXLEN];
static int  history_idx = 0;

/* ------------------------------------------------------------------ */
/* SHELL COMMANDS                                                       */
/* ------------------------------------------------------------------ */

static int cmd_help(void)
{
    printf("Available commands:\n");
    printf("  help                 - Show this help\n");
    printf("  ps                   - List processes\n");
    printf("  kill <PID>           - Kill a process (SIGTERM)\n");
    printf("  kill9 <PID>          - Force-kill (SIGKILL)\n");
    printf("  signal <PID> <SIG>   - Send signal number to process\n");
    printf("  clear                - Clear screen\n");
    printf("  perf                 - Show performance counters\n");
    printf("  gui status           - Show GUI guard state\n");
    printf("  gui reset            - Re-enable this process GUI\n");
    printf("  time                 - Show current RTC date/time + uptime\n");
    printf("  alarm <ms>           - Set SIGALRM in <ms> ms (0=cancel)\n");
    printf("  yield                - Voluntarily yield CPU slice\n");
    printf("  app list             - List applications\n");
    printf("  app run <name>       - Launch an application\n");
    printf("  app install <name>   - Install an application\n");
    printf("  hello|counter|graphics - Shortcuts for 'app run <name>'\n");
    printf("  ls                   - List files\n");
    printf("  cat <file>           - Print a file\n");
    printf("  write <file> <text>  - Create/overwrite a file\n");
    printf("  rm <file>            - Delete a file\n");
    printf("  whoami               - Show current user\n");
    printf("  passwd <new>         - Change your password\n");
    printf("  logout               - Log out and re-authenticate\n");
    printf("  theme <0|1|2>        - green | blue | dark\n");
    printf("  mouse <dx> <dy>      - Move simulated cursor\n");
    printf("  click                - Simulated left click at cursor\n");
    printf("  wifi scan            - Scan for nearby WiFi networks\n");
    printf("  wifi connect <ssid> [psk] - Connect to a WiFi network\n");
    printf("  wifi disconnect      - Disconnect from WiFi\n");
    printf("  wifi status          - Show Intel AC 9560 status\n");
    printf("  ipc pipe             - Demo: IPC pipe between two tasks\n");
    printf("  syslog               - Dump kernel syslog ring buffer\n");
    printf("  reboot | shutdown    - Halt the system\n");
    return 0;
}

static int cmd_ps(void)
{
    extern Process process_table[MAX_PROCESSES];
    extern int current_pid;
    int i;

    printf("PID  State   Priority  Ticks\n");
    printf("---  ------  --------  -----\n");

    for (i = 0; i < MAX_PROCESSES; i++) {
        if (process_table[i].state != PROC_FREE) {
            const char *st;
            switch (process_table[i].state) {
                case PROC_READY:   st = "READY "; break;
                case PROC_RUNNING: st = "RUN   "; break;
                case PROC_BLOCKED: st = "BLOCK "; break;
                case PROC_ZOMBIE:  st = "ZOMBIE"; break;
                default:           st = "?     ";
            }
            printf("%d    %s  %d         %d\n",
                   i, st,
                   (int)process_table[i].priority,
                   (int)process_table[i].ticks_remaining);
        }
    }

    printf("\nCurrent PID: %d\n", current_pid);
    return 0;
}

static int cmd_kill(int pid)
{
    process_kill(pid);
    printf("Killed PID %d\n", pid);
    return 0;
}

static int cmd_clear(void)
{
    gpu_clear(0xFF001A33);
    gpu_present();
    return 0;
}

static int cmd_gui(const char *subcommand)
{
    GuiStatus status;

    if (kstrcmp(subcommand, "status") == 0) {
        if (sys_gui_status(&status) < 0) return -1;
        printf("GUI:     %s\n", status.enabled ? "ENABLED" : "QUARANTINED");
        printf("Faults:  %u/%u\n", (unsigned)status.faults, (unsigned)GUI_FAULT_LIMIT);
        printf("Ops:     %u/%u\n", (unsigned)status.ops, (unsigned)GUI_MAX_OPS);
        printf("Pixels:  %llu/%llu\n",
               (unsigned long long)status.pixels,
               (unsigned long long)GUI_MAX_PIXELS);
        return 0;
    }
    if (kstrcmp(subcommand, "reset") == 0)
        return sys_gui_reset();

    printf("Usage: gui status | gui reset\n");
    return -1;
}

static int cmd_perf(void)
{
    extern uint32_t total_ticks, context_switches, syscalls_handled;
    printf("Ticks:            %u\n", (unsigned)total_ticks);
    printf("Context switches: %u\n", (unsigned)context_switches);
    printf("Syscalls:         %u\n", (unsigned)syscalls_handled);
    return 0;
}

/* ------------------------------------------------------------------ */
/* SIMPLE atoi                                                          */
/* ------------------------------------------------------------------ */
static int simple_atoi(const char *s)
{
    int result = 0;
    int sign   = 1;
    if (*s == '-') { sign = -1; s++; }
    while (*s >= '0' && *s <= '9')
        result = result * 10 + (*s++ - '0');
    return result * sign;
}

/* Splits "a b c" into up to 3 whitespace-separated tokens (in place). */
static int split_args(char *s, char *argv[], int max_args)
{
    int argc = 0;
    while (*s && argc < max_args) {
        while (*s == ' ') s++;
        if (!*s) break;
        argv[argc++] = s;
        while (*s && *s != ' ') s++;
        if (*s) *s++ = '\0';
    }
    return argc;
}

/* ------------------------------------------------------------------ */
/* MAIN SHELL LOOP                                                      */
/* ------------------------------------------------------------------ */

void shell_main(void)
{
    printf("\n");
    printf("HILAL_BIS v1.0 Shell — logged in as %s\n", auth_username(current_uid));
    printf("Type 'help' for available commands\n\n");

    while (1)
        shell_prompt();
}

void shell_prompt(void)
{
    int  i = 0;
    char c;

    printf("%s@HILAL_BIS> ", auth_username(current_uid));

    /* Read one line */
    while (i < CMD_MAXLEN - 1) {
        c = (char)KGETCHAR();
        if (c == '\n' || c == '\r') {
            printf("\n");
            command_buffer[i] = '\0';
            break;
        } else if (c == '\b' && i > 0) {
            printf("\b \b");
            i--;
        } else if (c >= 32 && c < 127) {
            KPUTCHAR(c);
            command_buffer[i++] = c;
        }
    }
    command_buffer[i] = '\0';

    /* Save to history */
    if (i > 0) {
        kstrncpy(history[history_idx % HISTORY_SIZE], command_buffer, CMD_MAXLEN - 1);
        history_idx++;
    }

    shell_parse_command(command_buffer);
}

int shell_parse_command(const char *cmd_in)
{
    char cmd[CMD_MAXLEN];
    char *argv[4];
    int argc;

    kstrncpy(cmd, cmd_in, CMD_MAXLEN - 1);
    cmd[CMD_MAXLEN - 1] = '\0';

    if (cmd[0] == '\0') return 0; /* empty line */

    if (kstrcmp(cmd, "help") == 0)  return cmd_help();
    if (kstrcmp(cmd, "ps") == 0)    return cmd_ps();
    if (kstrcmp(cmd, "clear") == 0) return cmd_clear();
    if (kstrcmp(cmd, "perf") == 0)  return cmd_perf();
    if (kstrncmp(cmd, "gui ", 4) == 0) return cmd_gui(cmd + 4);

    /* Legacy shortcuts -> app registry */
    if (kstrcmp(cmd, "hello") == 0)    return app_launch("hello")    < 0 ? -1 : 0;
    if (kstrcmp(cmd, "counter") == 0)  return app_launch("counter")  < 0 ? -1 : 0;
    if (kstrcmp(cmd, "graphics") == 0) return app_launch("graphics") < 0 ? -1 : 0;

    if (kstrncmp(cmd, "kill ", 5) == 0) {
        int pid = simple_atoi(cmd + 5);
        return cmd_kill(pid);
    }

    if (kstrncmp(cmd, "app ", 4) == 0) {
        char rest[CMD_MAXLEN];
        kstrncpy(rest, cmd + 4, CMD_MAXLEN - 1);
        argc = split_args(rest, argv, 2);
        if (argc >= 1 && kstrcmp(argv[0], "list") == 0) { app_list(); return 0; }
        if (argc >= 2 && kstrcmp(argv[0], "run") == 0)     return app_launch(argv[1])   < 0 ? -1 : 0;
        if (argc >= 2 && kstrcmp(argv[0], "install") == 0) return app_install(argv[1]) < 0 ? -1 : 0;
        printf("Usage: app list | app run <name> | app install <name>\n");
        return -1;
    }

    if (kstrcmp(cmd, "ls") == 0) { fs_list(); return 0; }

    if (kstrncmp(cmd, "cat ", 4) == 0) {
        char buf[MAX_FILE_SIZE + 1];
        int n = fs_read(cmd + 4, buf, MAX_FILE_SIZE, current_uid);
        if (n < 0) { printf("cat: cannot read %s\n", cmd + 4); return -1; }
        buf[n] = '\0';
        printf("%s\n", buf);
        return 0;
    }

    if (kstrncmp(cmd, "write ", 6) == 0) {
        char rest[CMD_MAXLEN];
        kstrncpy(rest, cmd + 6, CMD_MAXLEN - 1);
        argc = split_args(rest, argv, 2);
        if (argc < 2) { printf("Usage: write <file> <text>\n"); return -1; }
        fs_create(argv[0], argv[1], (int)kstrlen(argv[1]), current_uid);
        return 0;
    }

    if (kstrncmp(cmd, "rm ", 3) == 0) {
        if (fs_delete(cmd + 3, current_uid) < 0) {
            printf("rm: cannot remove %s\n", cmd + 3);
            return -1;
        }
        printf("Removed %s\n", cmd + 3);
        return 0;
    }

    if (kstrcmp(cmd, "whoami") == 0) {
        printf("%s (uid %d)\n", auth_username(current_uid), current_uid);
        return 0;
    }

    if (kstrncmp(cmd, "passwd ", 7) == 0) {
        auth_set_password(current_uid, cmd + 7);
        printf("[OK] Password updated\n");
        return 0;
    }

    if (kstrcmp(cmd, "logout") == 0) {
        printf("Logging out...\n");
        if (login_prompt() < 0) {
            printf("[SECURITY] Halting.\n");
            while (1) { }
        }
        return 0;
    }

    if (kstrncmp(cmd, "theme ", 6) == 0) {
        wm_set_theme(simple_atoi(cmd + 6));
        return 0;
    }

    if (kstrncmp(cmd, "mouse ", 6) == 0) {
        char rest[CMD_MAXLEN];
        kstrncpy(rest, cmd + 6, CMD_MAXLEN - 1);
        argc = split_args(rest, argv, 2);
        if (argc < 2) { printf("Usage: mouse <dx> <dy>\n"); return -1; }
        mouse_move(simple_atoi(argv[0]), simple_atoi(argv[1]));
        wm_run();
        printf("Cursor at (%d, %d)\n", mouse.x, mouse.y);
        return 0;
    }

    if (kstrcmp(cmd, "click") == 0) {
        mouse_button(0, 1);
        wm_run();
        printf("Click at (%d, %d)\n", mouse.x, mouse.y);
        mouse_button(0, 0);
        wm_run();
        return 0;
    }

    if (kstrcmp(cmd, "reboot") == 0 || kstrcmp(cmd, "shutdown") == 0) {
        printf("System halted. (No real power/reset line on Oxalyn-64 yet.)\n");
        while (1) { }
    }

    /* ── Sinyal komutları ─────────────────────────────────────────── */
    if (kstrncmp(cmd, "kill9 ", 6) == 0) {
        int pid = simple_atoi(cmd + 6);
        signal_deliver(pid, SIGKILL);
        printf("SIGKILL gonderildi -> PID %d\n", pid);
        return 0;
    }

    if (kstrncmp(cmd, "signal ", 7) == 0) {
        char rest[CMD_MAXLEN];
        kstrncpy(rest, cmd + 7, CMD_MAXLEN - 1);
        argc = split_args(rest, argv, 2);
        if (argc < 2) { printf("Kullanim: signal <PID> <SIGNO>\n"); return -1; }
        {
            int pid = simple_atoi(argv[0]);
            int sig = simple_atoi(argv[1]);
            signal_deliver(pid, sig);
            printf("Sinyal %d gonderildi -> PID %d\n", sig, pid);
        }
        return 0;
    }

    /* ── Zaman komutları ──────────────────────────────────────────── */
    if (kstrcmp(cmd, "time") == 0) {
        DateTime dt;
        char timebuf[32];
        uint32_t tick, sec;
        rtc_read(&dt);
        rtc_format(&dt, timebuf, (int)sizeof(timebuf));
        sys_gettime(&tick, &sec);
        printf("Tarih/Saat : %s\n", timebuf);
        printf("Calisma    : %u sn (%u tick, %u ms/tick)\n",
               (unsigned)sec, (unsigned)tick, (unsigned)TIMER_QUANTUM);
        return 0;
    }

    if (kstrncmp(cmd, "alarm ", 6) == 0) {
        uint32_t ms = (uint32_t)simple_atoi(cmd + 6);
        sys_alarm(ms);
        if (ms == 0)
            printf("[ALARM] Alarm iptal edildi\n");
        else
            printf("[ALARM] %u ms sonra SIGALRM gelecek\n", (unsigned)ms);
        return 0;
    }

    if (kstrcmp(cmd, "yield") == 0) {
        printf("[YIELD] CPU dilimleri geri veriliyor...\n");
        sys_yield();
        printf("[YIELD] Tekrar calisiyor\n");
        return 0;
    }

    /* ── WiFi komutları ───────────────────────────────────────────── */
    if (kstrncmp(cmd, "wifi ", 5) == 0) {
        char rest[CMD_MAXLEN];
        kstrncpy(rest, cmd + 5, CMD_MAXLEN - 1);
        argc = split_args(rest, argv, 3);

        if (argc >= 1 && kstrcmp(argv[0], "scan") == 0) {
            wifi_scan();
            wifi_print_scan();
            return 0;
        }
        if (argc >= 1 && kstrcmp(argv[0], "status") == 0) {
            wifi_status();
            return 0;
        }
        if (argc >= 1 && kstrcmp(argv[0], "disconnect") == 0) {
            wifi_disconnect();
            return 0;
        }
        if (argc >= 2 && kstrcmp(argv[0], "connect") == 0) {
            const char *psk = (argc >= 3) ? argv[2] : "";
            return wifi_connect(argv[1], psk);
        }
        printf("Kullanim: wifi scan | wifi connect <ssid> [psk] | wifi disconnect | wifi status\n");
        return -1;
    }

    /* ── IPC demo ─────────────────────────────────────────────────── */
    if (kstrncmp(cmd, "ipc ", 4) == 0) {
        if (kstrcmp(cmd + 4, "pipe") == 0) {
            int rfd, wfd, pid_cur, n;
            char buf[64];
            pid_cur = get_current_pid();
            if (pipe_create((uint32_t)pid_cur, (uint32_t)pid_cur, &rfd, &wfd) < 0) {
                printf("[IPC] Boru olusturulamadi\n"); return -1;
            }
            pipe_write(wfd, "Merhaba IPC borusu!", 19);
            n = pipe_read(rfd, buf, (int)sizeof(buf) - 1);
            buf[n < 0 ? 0 : n] = '\0';
            printf("[IPC] Boru yazildi/okundu: \"%s\"\n", buf);
            pipe_close(rfd);
            pipe_close(wfd);
            return 0;
        }
        printf("Kullanim: ipc pipe\n");
        return -1;
    }

    /* ── Syslog dump ──────────────────────────────────────────────── */
    if (kstrcmp(cmd, "syslog") == 0) {
        syslog_dump();
        return 0;
    }

    printf("Unknown command: %s\n", cmd);
    return -1;
}
