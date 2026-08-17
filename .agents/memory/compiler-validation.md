---
name: Compiler validation scope
description: Scope and interpretation of Oxalyn compiler validation results
---

Kernel-wide unit compilation is not a clean proxy for validating isolated compiler features: the kernel currently exercises unsupported or incomplete variadic calls, function-pointer prototypes, and several broader parser constructs.

**Why:** A feature change can leave the relevant compiler tests fully passing while unrelated kernel units still fail for pre-existing language coverage gaps.

**How to apply:** For compiler work, prioritize `tests/compiler_tests.sh` and focused compile/assemble/simulate tests; classify kernel scan failures by parser feature before expanding scope.