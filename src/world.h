#ifndef VOXEL_WORLD_H
#define VOXEL_WORLD_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define CHUNK_X 16
#define CHUNK_Y 16
#define CHUNK_Z 16
#define CHUNK_BLOCK_COUNT (CHUNK_X * CHUNK_Y * CHUNK_Z)

typedef uint8_t Block;

/*
 * A chunk owns its block storage. mesh_handle is reserved for a future
 * Gravityon mesh and is not allocated or released by this module.
 */
typedef struct Chunk {
    int32_t cx;
    int32_t cy;
    int32_t cz;
    Block blocks[CHUNK_BLOCK_COUNT];
    bool dirty;
    void *mesh_handle;
} Chunk;

/*
 * World owns every Chunk returned by world_get_or_create_chunk. The fields
 * are public so a World can be allocated by the caller (including on stack).
 */
typedef struct World {
    Chunk **slots;
    size_t capacity;
    size_t count;
} World;

/** Return an existing chunk or allocate and insert a new empty chunk. */
Chunk *world_get_or_create_chunk(World *w, int cx, int cy, int cz);

/** Remove a chunk owned by the world and release its memory. */
void world_free_chunk(World *w, Chunk *c);

/** Read a block in world coordinates; missing chunks and invalid coordinates are air. */
Block world_get_block(World *w, int x, int y, int z);

/** Write a block in world coordinates; returns 0 on success and -1 on failure. */
int world_set_block(World *w, int x, int y, int z, Block b);

/** Initialize an empty world; the caller must call world_free when finished. */
void world_init(World *w);

/** Release all chunks and hash-map storage owned by the world. */
void world_free(World *w);

/** Save one chunk as int32 coordinates followed by its raw block bytes. */
void world_save_chunk(World *w, Chunk *c, const char *path);

/** Load one raw chunk file, returning the loaded world-owned chunk or NULL. */
Chunk *world_load_chunk(World *w, int cx, int cy, int cz, const char *path);

/** Place a small deterministic block pattern for smoke tests and examples. */
void world_fill_test_pattern(World *w, int base_x, int base_y, int base_z);

#endif /* VOXEL_WORLD_H */