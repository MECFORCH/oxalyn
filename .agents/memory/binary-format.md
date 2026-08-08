---
name: Oxalyn binary format
description: The simulator and assembler exchange big-endian 32-bit instruction words.
---

Oxalyn `.bin` files store each 32-bit instruction word in big-endian byte order.
The simulator loads four bytes at a time into one word entry, so hand-written
binary regression fixtures must use the same order.

**Why:** A raw-opcode regression fixture written little-endian reported a
different opcode and masked the actual illegal-instruction behavior.

**How to apply:** When creating a raw `.bin` fixture, encode the instruction
as four bytes from most significant to least significant and verify the
simulator's reported opcode before asserting trap behavior.