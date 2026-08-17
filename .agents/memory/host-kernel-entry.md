---
name: Host kernel entry
description: Host kernel binaries must preserve libc startup before entering kernel_main.
---

## The rule

The host development binary must enter through a normal `main()` wrapper and then call `kernel_main()`; `kernel_main` must not be used as the ELF entry point when host stdio or file capture is enabled.

**Why:** Bypassing libc startup causes host stdio and file I/O state to be uninitialized, so the GUI boot test can crash before producing its framebuffer capture.

**How to apply:** Keep the freestanding/native entry path separate from `OXALYN_HOST_TEST`; validate host boot by checking both the GUI boot markers and the expected RGBA8 framebuffer file size.