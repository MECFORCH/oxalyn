---
name: Native compiler translation-unit mode
description: Main-less kernel C modules use an explicit unit mode while executable tests keep the main entry contract.
---

The native C backend preserves its executable default: normal compilation emits the stack/startup stub and requires `main`. Main-less kernel modules are compiled with an explicit unit mode so parser and assembly validation can run without inventing an entry point.

**Why:** Kernel source files are translation units, not standalone programs; requiring `main` hid useful parser progress and encouraged unsafe fake entry stubs.

**How to apply:** Use unit mode for module-level compiler checks. Keep end-to-end simulator tests in default mode so startup, `main`, return-value, and assembler behavior remain covered.