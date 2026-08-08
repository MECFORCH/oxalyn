---
name: Toolchain output safety
description: Rules for keeping host and Oxalyn binary outputs distinct
---

The host kernel build and the Oxalyn ISA build are separate products. A native
GCC ELF must never be renamed or copied into an Oxalyn `.bin`. The verified
minimal C backend may produce Oxalyn binaries, but kernel-wide output still
requires a linker, runtime, data-section support, and broader ABI validation.

**Why:** A host ELF can look like a successful build while being impossible for
the Oxalyn assembler, simulator, or RTL to execute.

**How to apply:** Keep host outputs for local tests only, keep generated kernel
artifacts ignored, require the C→assembly→assembler pipeline, and fail
unsupported globals or incomplete kernel builds explicitly.