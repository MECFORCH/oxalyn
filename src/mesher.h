#ifndef OXALYN_MESHER_H
#define OXALYN_MESHER_H

#include <stddef.h>
#include <stdint.h>

#include "world.h"

typedef struct MesherVertex {
    float x;
    float y;
    float z;
    float nx;
    float ny;
    float nz;
    float u;
    float v;
    Block block;
} MesherVertex;

typedef struct Mesh {
    MesherVertex *vertices;
    uint32_t *indices;
    size_t vertex_count;
    size_t index_count;
    size_t vertex_capacity;
    size_t index_capacity;
} Mesh;

typedef struct MesherConfig {
    uint32_t atlas_columns;
    uint32_t atlas_rows;
} MesherConfig;

/** Initialize an empty mesh owned by the caller. */
void mesh_init(Mesh *mesh);

/** Release vertex and index storage owned by the mesh. */
void mesh_free(Mesh *mesh);

/**
 * Build the visible greedy mesh for one chunk.
 * Returns 0 on success and -1 on invalid input or allocation failure.
 */
int mesher_build_chunk(World *world, const Chunk *chunk,
                       const MesherConfig *config, Mesh *mesh);

#endif /* OXALYN_MESHER_H */