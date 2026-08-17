# HILAL_BIS v1.0 — OS Kernel for Oxalyn-64

HILAL_BIS is a multi-process OS kernel targeting the Oxalyn-64 custom CPU
architecture: preemptive scheduling, a buddy-style memory allocator, UART
I/O, GPU/framebuffer graphics, a RAM filesystem, a login/permission layer,
an application registry, a window manager, and an interactive shell.

## Project Structure

```
kernel/
├── boot.asm        Bootloader — sets stack, trap vector, jumps to kernel_main()
├── kernel.c/.h      Boot sequence, syscall dispatcher, process lifecycle
├── scheduler.c/.h   Priority-based scheduler, context switching
├── memory.c/.h      Buddy-style heap allocator (kmalloc / kfree)
├── uart.c/.h        UART driver + minimal printf (kprintf)
├── gpu.c/.h         Framebuffer driver — clear, pixel, line, rect, circle(s)
├── ui.c/.h          Boot splash, hilal crescent logo, animated loading bar
├── input.c/.h       Keyboard ring buffer + scancode table
├── mouse.c/.h       Mouse state + cursor (simulator-only, no real HW)
├── auth.c/.h        Login (root/guest) — educational only, NOT secure
├── perms.c/.h       Per-resource permission checks
├── filesystem.c/.h  RAM filesystem (create/read/write/delete/list)
├── apps.c/.h        Application registry + built-in demo apps
├── wm.c/.h           Window manager, taskbar, themes
├── network.c/.h     Stub only — no NIC exists in the Oxalyn-64 I/O map yet
├── shell.c/.h       Interactive shell tying all of the above together
├── kstring.c/.h     Freestanding memcpy/strcmp/etc — no libc required
├── types.h          Common type aliases
└── Makefile
```

## Build & run

```bash
cd kernel
make            # host kernel binary'sini derle
make typecheck  # syntax check only (no link)
make test-kernel # kernel unit testleri
make run-host   # build + run interactively as a normal Linux process
                # (real login prompt, real shell — try user "root"/"root"
                # or "guest"/"guest")
make run        # gerçek Oxalyn C backend'i yoksa bilinçli olarak fail eder;
                # host GCC çıktısı artık .bin diye paketlenmez
make clean
```

Requires GCC with C99 support (`gcc -std=c99`).

### Two build targets, one source tree

- **`OXALYN_SIMULATOR` (host gcc, what `make`/`make run-host` use today):**
  UART is backed by real terminal I/O (raw Linux syscalls, still no libc)
  and the framebuffer is a real in-memory array — so `make run-host` is an
  actually-interactive kernel you can log into and drive from your
  terminal today. Process dispatch on this path is **cooperative /
  run-to-completion** (see `process_run_now()` in `scheduler.c`): there is
  no real timer IRQ on a host process, so `app run <name>` calls the
  program directly instead of truly backgrounding it. `sys_sleep()` is a
  documented no-op here for the same reason.
- **Real Oxalyn-64 hardware / CPU simulator:** the `#else` branches of
  `uart.c`/`gpu.c` use the real MMIO addresses (`0x10` UART, `0x8000`
  framebuffer), and `scheduler_run()`'s infinite loop is correct because
  the timer IRQ + `trap.asm` really do save/restore R0–R31 and jump via
  `ERET`. Getting there requires an Oxalyn ISA code-generation backend
  (not gcc); the guarded kernel target currently reports that this backend
  is unavailable.

## Shell Commands

| Command                 | Description                              |
|--------------------------|-------------------------------------------|
| `help`                   | List available commands                    |
| `ps`                     | Show process table                         |
| `kill <PID>`             | Kill a process by PID                      |
| `clear`                  | Clear framebuffer                          |
| `perf`                   | Show kernel performance stats               |
| `app list`               | List applications (installed + available) |
| `app run <name>`         | Launch an application                       |
| `app install <name>`     | Install an application                      |
| `hello` / `counter` / `graphics` | Shortcuts for `app run <name>`      |
| `ls`                     | List files                                  |
| `cat <file>`             | Print a file                                |
| `write <file> <text>`    | Create/overwrite a file                     |
| `rm <file>`              | Delete a file                               |
| `whoami`                 | Show current user                           |
| `passwd <new>`           | Change your password                        |
| `logout`                 | Log out and re-authenticate                 |
| `theme <0\|1\|2>`         | green / blue / dark window theme          |
| `mouse <dx> <dy>`        | Move the simulated cursor (no real mouse HW)|
| `click`                  | Simulated left click at the cursor          |
| `reboot` / `shutdown`    | Halt the system                             |

Default accounts: `root`/`root` (admin) and `guest`/`guest` (user) — change
them with `passwd` after logging in. **`simple_hash()` is a one-byte XOR
checksum, not real cryptography** — this login gate is for demonstrating
privilege levels and per-file permissions, nothing more.

## Oxalyn-64 ISA Constraints

- Supported instructions: `ADD SUB AND OR XOR SHL SHR LOAD STORE LI JMP JZ JNZ CALL RET OUT IN MUL DIV JALR LUI CMPEQ CMPNE CMPLT CMPLE CSRW CSRR ECALL ERET HALT`
- **No LI64** — use `LUI + OR` to build 64-bit constants from 11-bit chunks
- **No `.data` directive** — use `.word` or inline encoding
- Memory is word-addressed (1 word = 64 bits = 8 bytes)
- Calling convention: R0=0, R2–R6=args, R7=return, R30=link register, R31=stack pointer

## Known limitations (please read before assuming more than this does)

- **No real background concurrency on the host build.** `app run counter`
  runs to completion before the prompt returns; true preemptive
  multitasking needs the real Oxalyn timer IRQ + `trap.asm`, which this
  C rewrite doesn't drive yet (see build modes above).
- **Keyboard/mouse are software-only.** There is no keyboard IRQ or mouse
  controller in the current Oxalyn-64 SPEC; `input.c`/`mouse.c` are ready
  for one (scancode table, ring buffer, cursor draw) but are driven by
  UART polling / shell commands today.
- **`network.c` is a stub**, matching the roadmap's own scope for this
  phase — there is no NIC to talk to.
- **`auth.c`'s hashing is not secure** — see above.
- **The real hardware trap/MPU work** (register save/restore in
  `trap.asm`, enabling memory protection) is a separate, careful piece of
  Oxalyn assembly work against actual silicon semantics; it hasn't been
  touched here and shouldn't be claimed done without testing it against
  the real CPU simulator.

## Expected boot output (`make run-host`)

```
+======================================+
|        HILAL_BIS v1.0  (Oxalyn-64)    |
+======================================+
[*] Initializing kernel subsystems...
[##############################] 100% Window Manager + Network
[OK] Boot complete!
...
+======================================+
|          HILAL_BIS LOGIN              |
+======================================+
Username: root
Password: ****
[OK] Login successful. Welcome, root!
root@HILAL_BIS>
```
