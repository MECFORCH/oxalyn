#include "render.h"
#include "world.h"

#include <stdio.h>
#include <stdlib.h>

static int build_demo_world(World *world)
{
    int x;
    int y;
    int z;

    for (x = 0; x < CHUNK_X; ++x) {
        for (z = 0; z < CHUNK_Z; ++z) {
            for (y = 0; y < 3; ++y) {
                if (world_set_block(world, x, y, z, (Block)(y == 2 ? 2 : 1)) != 0) {
                    return -1;
                }
            }
        }
    }

    for (x = 3; x < 7; ++x) {
        for (z = 3; z < 7; ++z) {
            if (world_set_block(world, x, 3, z, (Block)3) != 0) {
                return -1;
            }
        }
    }
    return 0;
}

int main(int argc, char **argv)
{
    const char *output_path = argc > 1 ? argv[1] : "voxel_world.ppm";
    World world = {0};
    Chunk *chunk;
    int result = 1;

    world_init(&world);
    if (build_demo_world(&world) != 0) {
        fprintf(stderr, "voxel demo: world construction failed\n");
        goto cleanup;
    }
    chunk = world_get_or_create_chunk(&world, 0, 0, 0);
    if (chunk == NULL) {
        fprintf(stderr, "voxel demo: chunk allocation failed\n");
        goto cleanup;
    }
    if (render_chunk_to_ppm(&world, chunk, output_path, 800u, 600u) != 0) {
        fprintf(stderr, "voxel demo: Gravityon render failed\n");
        goto cleanup;
    }

    printf("voxel demo: rendered %s\n", output_path);
    result = 0;

cleanup:
    world_free(&world);
    return result;
}