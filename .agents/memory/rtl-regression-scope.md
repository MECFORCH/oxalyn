---
name: RTL regression scope
description: Which RTL checks are reliable for interrupt pipeline changes
---

Dedicated timer and UART RTL benches are the reliable checks for interrupt/trap pipeline work. The legacy `sim-verilog` smoke bench currently reports an unrelated baseline failure on an untouched checkout, so it should be tracked separately rather than used to judge UART interrupt fixes.

**Why:** The smoke bench produced the same incorrect result before and after the UART changes, while the dedicated timer and UART paths passed.

**How to apply:** Run the dedicated timer/UART targets for interrupt changes, and report the legacy smoke result separately until its arithmetic/pipeline expectation is repaired.