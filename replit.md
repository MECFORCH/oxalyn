# Oxalyn-64 Project Notes

## Overview

Oxalyn-64 is a 64-bit experimental CPU project with:

- a C simulator under `simulator/`
- an assembler and debugger
- a dependency-free Gravityon framebuffer/GPU simulator
- an extensible compiler under `compiler/`, including a verified minimal
  C-to-Oxalyn assembly backend
- a Clang/WASM frontend pipeline that compiles the complete kernel C source
  set to a linked freestanding WASM intermediate artifact
- Verilog RTL and FPGA support

Build outputs belong under `build/` and generated images/binaries are ignored
by Git. The architecture compiler translates a verified source-assembly subset
from Oxalyn-64, x86-64, ARM64, and RISC-V64 into Oxalyn assembly and `.bin`.
`build/cc` separately translates a verified minimal C subset through real
Oxalyn assembly and the big-endian assembler; it does not claim kernel-wide C
support or linker/data-section support. It detects ELF, PE/COFF, Mach-O, and
WebAssembly headers, but does not yet translate arbitrary machine-code
binaries. `make -C kernel oxalyn-objects` is the complete-kernel C frontend
milestone; `make -C kernel oxalyn-wasm` links that intermediate output.
Neither target claims that WASM is an Oxalyn `.bin`; the Oxalyn backend/linker
and runtime are still required before `make -C kernel oxalyn` can be enabled.

## User preferences

- Prefer portable implementations without external GUI or OS dependencies.
- Keep generated binaries, images, and waveforms out of the source tree.
- Fail explicitly on unsupported instructions instead of emitting guessed code.
- Keep test templates empty until new regression cases are intentionally added.