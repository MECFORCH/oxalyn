#include "mesher.h"

#include <limits.h>
#include <stdlib.h>
#include <string.h>

typedef struct FaceInfo {
    int normal_axis;
    int normal_sign;
    int u_axis;
    int u_sign;
    int v_axis;
    int v_sign;
    int width;
    int height;
} FaceInfo;

typedef struct MaskCell {
    Block block;
} MaskCell;

static const FaceInfo FACE_INFO[6] = {
    /* +X: u=+Y, v=+Z */
    {0, 1, 1, 1, 2, 1, CHUNK_Y, CHUNK_Z},
    /* -X: u=+Z, v=+Y */
    {0, -1, 2, 1, 1, 1, CHUNK_Z, CHUNK_Y},
    /* +Y: u=+Z, v=+X */
    {1, 1, 2, 1, 0, 1, CHUNK_Z, CHUNK_X},
    /* -Y: u=+X, v=+Z */
    {1, -1, 0, 1, 2, 1, CHUNK_X, CHUNK_Z},
    /* +Z: u=+X, v=+Y */
    {2, 1, 0, 1, 1, 1, CHUNK_X, CHUNK_Y},
    /* -Z: u=+Y, v=+X */
    {2, -1, 1, 1, 0, 1, CHUNK_Y, CHUNK_X}
};

static int checked_grow_capacity(size_t current, size_t required,
                                  size_t element_size, size_t *capacity)
{
    size_t next = current == 0u ? 64u : current;

    while (next < required) {
        if (next > SIZE_MAX / 2u) {
            return -1;
        }
        next *= 2u;
    }
    if (next > SIZE_MAX / element_size) {
        return -1;
    }
    *capacity = next;
    return 0;
}

static int reserve_vertices(Mesh *mesh, size_t additional)
{
    size_t required;
    size_t capacity;
    MesherVertex *vertices;

    if (additional > SIZE_MAX - mesh->vertex_count) {
        return -1;
    }
    required = mesh->vertex_count + additional;
    if (required <= mesh->vertex_capacity) {
        return 0;
    }
    if (checked_grow_capacity(mesh->vertex_capacity, required,
                              sizeof(*mesh->vertices), &capacity) != 0) {
        return -1;
    }
    vertices = (MesherVertex *)realloc(mesh->vertices,
                                       capacity * sizeof(*mesh->vertices));
    if (vertices == NULL) {
        return -1;
    }
    mesh->vertices = vertices;
    mesh->vertex_capacity = capacity;
    return 0;
}

static int reserve_indices(Mesh *mesh, size_t additional)
{
    size_t required;
    size_t capacity;
    uint32_t *indices;

    if (additional > SIZE_MAX - mesh->index_count) {
        return -1;
    }
    required = mesh->index_count + additional;
    if (required <= mesh->index_capacity) {
        return 0;
    }
    if (checked_grow_capacity(mesh->index_capacity, required,
                              sizeof(*mesh->indices), &capacity) != 0) {
        return -1;
    }
    indices = (uint32_t *)realloc(mesh->indices,
                                  capacity * sizeof(*mesh->indices));
    if (indices == NULL) {
        return -1;
    }
    mesh->indices = indices;
    mesh->index_capacity = capacity;
    return 0;
}

static void set_axis_value(int coordinates[3], int axis, int value)
{
    coordinates[axis] = value;
}

static void face_cell_coordinates(const FaceInfo *face, int slice,
                                  int u, int v, int coordinates[3])
{
    coordinates[0] = 0;
    coordinates[1] = 0;
    coordinates[2] = 0;
    set_axis_value(coordinates, face->normal_axis, slice);
    set_axis_value(coordinates, face->u_axis, u);
    set_axis_value(coordinates, face->v_axis, v);
}

static int64_t chunk_origin(int32_t coordinate)
{
    return (int64_t)coordinate * CHUNK_X;
}

static Block block_at_world(World *world, int64_t x, int64_t y, int64_t z)
{
    if (x < INT_MIN || x > INT_MAX ||
        y < INT_MIN || y > INT_MAX ||
        z < INT_MIN || z > INT_MAX) {
        return (Block)0;
    }
    return world_get_block(world, (int)x, (int)y, (int)z);
}

static Block neighbor_block(World *world, const Chunk *chunk,
                            const FaceInfo *face, int lx, int ly, int lz)
{
    int64_t world_x = chunk_origin(chunk->cx) + lx;
    int64_t world_y = chunk_origin(chunk->cy) + ly;
    int64_t world_z = chunk_origin(chunk->cz) + lz;

    if (face->normal_axis == 0) {
        world_x += face->normal_sign;
    } else if (face->normal_axis == 1) {
        world_y += face->normal_sign;
    } else {
        world_z += face->normal_sign;
    }
    return block_at_world(world, world_x, world_y, world_z);
}

static void face_axes(const FaceInfo *face, int u[3], int v[3], int normal[3])
{
    u[0] = 0;
    u[1] = 0;
    u[2] = 0;
    v[0] = 0;
    v[1] = 0;
    v[2] = 0;
    normal[0] = 0;
    normal[1] = 0;
    normal[2] = 0;
    u[face->u_axis] = face->u_sign;
    v[face->v_axis] = face->v_sign;
    normal[face->normal_axis] = face->normal_sign;
}

static void vertex_position(const Chunk *chunk, const FaceInfo *face,
                            int coordinates[3], int plane_offset,
                            const int u[3], const int v[3],
                            int width, int height, int corner,
                            float position[3])
{
    int64_t world_coordinates[3];
    int64_t base[3];
    int64_t offset_u = (corner == 1 || corner == 2) ? width : 0;
    int64_t offset_v = (corner == 2 || corner == 3) ? height : 0;
    int axis;

    base[0] = (int64_t)coordinates[0];
    base[1] = (int64_t)coordinates[1];
    base[2] = (int64_t)coordinates[2];
    base[face->normal_axis] += plane_offset;
    for (axis = 0; axis < 3; ++axis) {
        int32_t chunk_coordinate = axis == 0 ? chunk->cx :
                                    (axis == 1 ? chunk->cy : chunk->cz);
        world_coordinates[axis] =
            (int64_t)chunk_coordinate * CHUNK_X + base[axis] +
            (int64_t)u[axis] * offset_u +
            (int64_t)v[axis] * offset_v;
        position[axis] = (float)world_coordinates[axis];
    }
}

static void atlas_uv(const MesherConfig *config, Block block,
                     int corner, int width, int height, float uv[2])
{
    uint32_t columns = config->atlas_columns == 0u ? 1u : config->atlas_columns;
    uint32_t rows = config->atlas_rows == 0u ? 1u : config->atlas_rows;
    uint32_t tile_count = columns * rows;
    uint32_t tile = block == 0u ? 0u : ((uint32_t)block - 1u);
    uint32_t tile_x;
    uint32_t tile_y;
    float u;
    float v;

    if (tile_count != 0u) {
        tile %= tile_count;
    }
    tile_x = tile % columns;
    tile_y = tile / columns;
    u = ((float)tile_x + ((corner == 1 || corner == 2) ? 1.0f : 0.0f) *
         (float)width) / (float)columns;
    v = ((float)tile_y + ((corner == 2 || corner == 3) ? 1.0f : 0.0f) *
         (float)height) / (float)rows;
    uv[0] = u;
    uv[1] = v;
}

static int append_quad(Mesh *mesh, const Chunk *chunk, const FaceInfo *face,
                       const MesherConfig *config, const int coordinates[3],
                       int width, int height, Block block)
{
    int u[3];
    int v[3];
    int normal[3];
    int plane_offset = face->normal_sign > 0 ? 1 : 0;
    size_t vertex_start;
    size_t index_start;
    int corner;

    if (mesh->vertex_count > UINT32_MAX - 4u ||
        reserve_vertices(mesh, 4u) != 0 ||
        reserve_indices(mesh, 6u) != 0) {
        return -1;
    }

    face_axes(face, u, v, normal);
    vertex_start = mesh->vertex_count;
    index_start = mesh->index_count;
    for (corner = 0; corner < 4; ++corner) {
        MesherVertex *vertex = &mesh->vertices[vertex_start + (size_t)corner];
        float position[3];
        float uv[2];

        vertex_position(chunk, face, (int *)coordinates, plane_offset,
                        u, v, width, height, corner, position);
        atlas_uv(config, block, corner, width, height, uv);
        vertex->x = position[0];
        vertex->y = position[1];
        vertex->z = position[2];
        vertex->nx = (float)normal[0];
        vertex->ny = (float)normal[1];
        vertex->nz = (float)normal[2];
        vertex->u = uv[0];
        vertex->v = uv[1];
        vertex->block = block;
    }
    mesh->indices[index_start + 0u] = (uint32_t)vertex_start;
    mesh->indices[index_start + 1u] = (uint32_t)vertex_start + 1u;
    mesh->indices[index_start + 2u] = (uint32_t)vertex_start + 2u;
    mesh->indices[index_start + 3u] = (uint32_t)vertex_start;
    mesh->indices[index_start + 4u] = (uint32_t)vertex_start + 2u;
    mesh->indices[index_start + 5u] = (uint32_t)vertex_start + 3u;
    mesh->vertex_count += 4u;
    mesh->index_count += 6u;
    return 0;
}

static int build_face(World *world, const Chunk *chunk,
                      const MesherConfig *config, Mesh *mesh,
                      const FaceInfo *face)
{
    MaskCell mask[CHUNK_X * CHUNK_Y];
    int slice;
    int u;
    int v;

    for (slice = 0; slice < CHUNK_X; ++slice) {
        memset(mask, 0, sizeof(mask));
        for (v = 0; v < face->height; ++v) {
            for (u = 0; u < face->width; ++u) {
                int coordinates[3];
                int mask_index = v * face->width + u;
                Block block;

                face_cell_coordinates(face, slice, u, v, coordinates);
                block = chunk->blocks[(coordinates[1] * CHUNK_Z +
                                       coordinates[2]) * CHUNK_X +
                                      coordinates[0]];
                if (block != 0u &&
                    neighbor_block(world, chunk, face,
                                   coordinates[0], coordinates[1],
                                   coordinates[2]) == 0u) {
                    mask[mask_index].block = block;
                }
            }
        }

        for (v = 0; v < face->height; ++v) {
            for (u = 0; u < face->width; ++u) {
                int width;
                int height;
                int coordinates[3];
                Block block = mask[v * face->width + u].block;

                if (block == 0u) {
                    continue;
                }
                for (width = 1; u + width < face->width &&
                                mask[v * face->width + u + width].block == block;
                     ++width) {
                }
                for (height = 1; v + height < face->height; ++height) {
                    int test_u;
                    int row_matches = 1;
                    for (test_u = 0; test_u < width; ++test_u) {
                        if (mask[(v + height) * face->width + u + test_u].block !=
                            block) {
                            row_matches = 0;
                            break;
                        }
                    }
                    if (!row_matches) {
                        break;
                    }
                }
                face_cell_coordinates(face, slice, u, v, coordinates);
                if (append_quad(mesh, chunk, face, config, coordinates,
                                width, height, block) != 0) {
                    return -1;
                }
                for (int clear_v = 0; clear_v < height; ++clear_v) {
                    for (int clear_u = 0; clear_u < width; ++clear_u) {
                        mask[(v + clear_v) * face->width + u + clear_u].block = 0u;
                    }
                }
            }
        }
    }
    return 0;
}

void mesh_init(Mesh *mesh)
{
    if (mesh == NULL) {
        return;
    }
    memset(mesh, 0, sizeof(*mesh));
}

void mesh_free(Mesh *mesh)
{
    if (mesh == NULL) {
        return;
    }
    free(mesh->vertices);
    free(mesh->indices);
    memset(mesh, 0, sizeof(*mesh));
}

int mesher_build_chunk(World *world, const Chunk *chunk,
                       const MesherConfig *config, Mesh *mesh)
{
    MesherConfig default_config = {1u, 1u};
    Mesh generated;
    size_t face_index;

    if (world == NULL || chunk == NULL || mesh == NULL) {
        return -1;
    }
    if (config == NULL) {
        config = &default_config;
    }

    mesh_init(&generated);
    for (face_index = 0u; face_index < 6u; ++face_index) {
        if (build_face(world, chunk, config, &generated,
                       &FACE_INFO[face_index]) != 0) {
            mesh_free(&generated);
            return -1;
        }
    }
    mesh_free(mesh);
    *mesh = generated;
    return 0;
}