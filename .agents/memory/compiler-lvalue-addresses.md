---
name: Compiler lvalue addresses
description: Address preservation rules for the minimal C compiler's lvalue expressions.
---

An lvalue expression must keep its computed address in a separate register from its loaded value until assignment evaluation finishes.

**Why:** Evaluating the right-hand side can reuse the value register; overwriting the address causes struct-field and array-element assignments to write to the loaded value instead of memory.

**How to apply:** When extending postfix expressions or address-of handling, preserve `expr_meta.addr_reg`; only release a loaded value register after the address has been captured.