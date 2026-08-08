#ifndef OXALYN_RENDER_H
#define OXALYN_RENDER_H

#include <stdint.h>

#include "world.h"

/**
 * Render one chunk through Gravityon and save the color image as a PPM file.
 * Returns 0 on success and -1 on invalid input, allocation, or GPU failure.
 */
int render_chunk_to_ppm(World *world, const Chunk *chunk, const char *path,
                        uint32_t width, uint32_t height);

#endif /* OXALYN_RENDER_H */