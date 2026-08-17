---
name: Tile rasterizer
description: Software rasterizer parallelization boundary and fallback behavior.
---

Parallel rendering is partitioned by disjoint framebuffer tiles, not by
triangles. Each tile processes the full triangle list in order, preserving
depth and blending semantics while avoiding cross-thread writes.

**Why:** Parallelizing triangles would make depth ordering and blending
nondeterministic; tile ownership keeps all color/depth writes disjoint.

**How to apply:** Keep tile size configurable through the pipeline, use the
serial path for one worker, and retain a serial fallback when thread creation
or tile storage allocation fails.