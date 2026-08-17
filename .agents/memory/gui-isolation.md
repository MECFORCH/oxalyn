---
name: GUI isolation guard
description: The kernel keeps GUI faults and resource exhaustion isolated from core services.
---

## The rule

Treat application GUI requests as untrusted: validate command data and user
buffers, account for per-process operation/pixel budgets, and quarantine only
the GUI capability after repeated faults. Kernel, scheduler, shell, and
filesystem execution must continue.

**Why:** A malformed GUI request must not turn a display failure into an
operating-system failure.

**How to apply:** Route framebuffer writes and draw syscalls through the guard;
reset the guard on `exec` or explicit GUI reset; expose status for diagnostics.