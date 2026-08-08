---
name: Kernel GPU wire contract
description: Shared contract and trust boundary for kernel 2D packets sent to Gravityon.
---

The kernel-to-Gravityon 2D path uses one freestanding shared wire header. Every
kernel 2D payload begins with the PID already admitted by the kernel GUI guard;
Gravityon records it for accounting but does not treat the device backend as a
security boundary.

**Why:** Keeping ports, ring sizing, and command IDs in separate kernel and
Gravityon copies made protocol drift likely. Carrying the admitted PID in the
packet preserves attribution without delegating authorization to the GPU.

**How to apply:** Extend the shared wire header and both encoder/decoder paths
together. Keep the simulator integration test covering framebuffer output,
present completion, owner attribution, and rejection of unowned payloads.
Do not claim real-hardware readiness until asynchronous ring backpressure and
wrap-around behavior are validated.