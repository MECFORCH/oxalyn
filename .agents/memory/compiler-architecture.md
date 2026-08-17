---
name: Compiler architecture
description: Durable scope and safety rules for the cross-architecture compiler
---

The compiler uses architecture detection plus per-architecture source backends.
It translates only a verified assembly subset; arbitrary machine-code binaries
are detected and reported but must not be converted until a real decoder exists.

**Why:** Register conventions, flags, ABI rules, relocations, and memory
semantics differ across architectures. Guessing a conversion would produce a
binary that can look valid while behaving incorrectly.

**How to apply:** Extend detection and the translator backend together. Keep
unsupported instructions as explicit errors, add regression coverage for every
new instruction family, and never claim binary-input support until decoding,
relocations, and control-flow semantics are implemented.

The repository also contains a separate minimal C backend. Its verified
boundary is C source → Oxalyn assembly → big-endian `.bin` → simulator, with
R1–R4 arguments, R7 return values, and JALR/R31 links. It intentionally rejects
globals until data sections and linking are implemented.

**Why:** A real backend can be useful before it can compile the whole kernel,
but silently accepting unsupported storage or ABI features would recreate the
same false-success problem as host ELF packaging.

**How to apply:** Keep minimal C programs covered by end-to-end simulator
tests, and do not promote the kernel target until runtime, linker, globals,
pointer/memory semantics, and kernel-wide ABI coverage are validated.

The full kernel C frontend now has a separate Clang-to-freestanding-WASM
milestone. It proves all kernel translation units and their data can be
compiled and linked, but WASM remains an intermediate artifact and must not be
treated as an Oxalyn instruction stream.

**Why:** This provides a practical full-source compile gate without weakening
the rule that only decoded, relocated Oxalyn instructions may become `.bin`.

**How to apply:** Use `make -C kernel oxalyn-objects` and
`make -C kernel oxalyn-wasm` for frontend/linker validation. Keep
`make -C kernel oxalyn` disabled until the WASM/backend, startup, ABI, and
simulator boot gates pass.