---
name: WASM kernel image limit
description: The real WASM-to-Oxalyn boot image is currently larger than physical memory.
---

The kernel pipeline now has a real WASM-to-Oxalyn translator, a boot wrapper, and a final big-endian `.bin` stage. The current full kernel does not fit the machine's 65,536-word image capacity, so `bin2mem` must reject it rather than truncate it or claim a bootable image.

**Why:** The translator emits a correct instruction stream, but the current freestanding kernel expands to 198,082 words after linking. Treating that output as bootable would hide a real memory-layout/size problem.

**How to apply:** Keep the capacity check as a hard gate. Only mark the kernel bootable after an image at or below 65,536 words passes `.bin → .mem → simulator` boot validation.