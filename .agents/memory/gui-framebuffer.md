---
name: GUI framebuffer presentation
description: Host kernel framebuffer export and simulator GUI presentation boundaries.
---

## The rule

The host kernel exports its 800x600 framebuffer as row-major RGBA8 only from
`gpu_present()`, while the CPU simulator owns its GUI refresh loop and reads
the simulator framebuffer directly.

**Why:** Keeping presentation outside individual pixel primitives avoids
platform-specific GUI code in the kernel and prevents a viewer from observing
an uninitialized or stale buffer.

**How to apply:** Call `gpu_present()` after a logical drawing batch or a
successful draw syscall. Use the simulator's GUI targets for a live window;
use `framebuffer.raw` only for host-mode capture and external viewers.