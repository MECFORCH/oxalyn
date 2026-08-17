<<<<<<< HEAD
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
=======
# [Project name]

_Replace the heading above with the project's name, and this line with one sentence describing what this app does for users._

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

_Populate as you build — short repo map plus pointers to the source-of-truth file for DB schema, API contracts, theme files, etc._

## Architecture decisions

_Populate as you build — non-obvious choices a reader couldn't infer from the code (3-5 bullets)._

## Product

_Describe the high-level user-facing capabilities of this app once they exist._

## User preferences

_Populate as you build — explicit user instructions worth remembering across sessions._

## Gotchas

_Populate as you build — sharp edges, "always run X before Y" rules._

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
>>>>>>> 9ef0b8f (Initial commit)
