#include "world.h"

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define WORLD_INITIAL_CAPACITY 64u

static int idx(int lx, int ly, int lz)
{
    return (ly * CHUNK_Z + lz) * CHUNK_X + lx;
}

static uint32_t hash_chunk_coords(int32_t cx, int32_t cy, int32_t cz)
{
    uint32_t h = 2166136261u;

    h = (h ^ (uint32_t)cx) * 16777619u;
    h = (h ^ (uint32_t)cy) * 16777619u;
    h = (h ^ (uint32_t)cz) * 16777619u;

    h ^= h >> 16;
    h *= 0x7feb352du;
    h ^= h >> 15;
    h *= 0x846ca68bu;
    h ^= h >> 16;
    return h;
}

static size_t slot_index(const World *w, int32_t cx, int32_t cy, int32_t cz)
{
    return (size_t)hash_chunk_coords(cx, cy, cz) & (w->capacity - 1u);
}

static Chunk *find_chunk(const World *w, int32_t cx, int32_t cy, int32_t cz)
{
    size_t i;
    size_t probes;

    if (w == NULL || w->slots == NULL || w->capacity == 0u) {
        return NULL;
    }

    i = slot_index(w, cx, cy, cz);
    for (probes = 0u; probes < w->capacity; ++probes) {
        Chunk *c = w->slots[i];
        if (c == NULL) {
            return NULL;
        }
        if (c->cx == cx && c->cy == cy && c->cz == cz) {
            return c;
        }
        i = (i + 1u) & (w->capacity - 1u);
    }
    return NULL;
}

static void insert_without_resize(World *w, Chunk *c)
{
    size_t i = slot_index(w, c->cx, c->cy, c->cz);

    while (w->slots[i] != NULL) {
        i = (i + 1u) & (w->capacity - 1u);
    }
    w->slots[i] = c;
    ++w->count;
}

static int resize_world(World *w, size_t new_capacity)
{
    Chunk **new_slots;
    Chunk **old_slots;
    size_t old_capacity;
    size_t i;

    if (new_capacity < WORLD_INITIAL_CAPACITY ||
        (new_capacity & (new_capacity - 1u)) != 0u) {
        return -1;
    }

    new_slots = (Chunk **)calloc(new_capacity, sizeof(*new_slots));
    if (new_slots == NULL) {
        return -1;
    }

    old_slots = w->slots;
    old_capacity = w->capacity;
    w->slots = new_slots;
    w->capacity = new_capacity;
    w->count = 0u;

    if (old_slots != NULL) {
        for (i = 0u; i < old_capacity; ++i) {
            if (old_slots[i] != NULL) {
                insert_without_resize(w, old_slots[i]);
            }
        }
        free(old_slots);
    }
    return 0;
}

static int ensure_insert_capacity(World *w)
{
    size_t new_capacity;

    if (w->capacity != 0u && w->count < w->capacity - w->capacity / 4u) {
        return 0;
    }

    if (w->capacity == 0u) {
        new_capacity = WORLD_INITIAL_CAPACITY;
    } else {
        if (w->capacity > SIZE_MAX / 2u) {
            return -1;
        }
        new_capacity = w->capacity * 2u;
    }
    return resize_world(w, new_capacity);
}

static int remove_chunk_from_map(World *w, Chunk *target)
{
    size_t i;
    size_t next;
    size_t probes;

    if (w == NULL || target == NULL || w->slots == NULL || w->capacity == 0u) {
        return 0;
    }

    i = slot_index(w, target->cx, target->cy, target->cz);
    for (probes = 0u; probes < w->capacity; ++probes) {
        if (w->slots[i] == NULL) {
            return 0;
        }
        if (w->slots[i] == target) {
            w->slots[i] = NULL;
            --w->count;

            /*
             * Reinsert the following probe cluster because this map does not
             * use tombstones.
             */
            next = (i + 1u) & (w->capacity - 1u);
            while (w->slots[next] != NULL) {
                Chunk *cluster_chunk = w->slots[next];
                w->slots[next] = NULL;
                --w->count;
                insert_without_resize(w, cluster_chunk);
                next = (next + 1u) & (w->capacity - 1u);
            }
            return 1;
        }
        i = (i + 1u) & (w->capacity - 1u);
    }
    return 0;
}

static int world_to_chunk_coord(int coordinate, int32_t *chunk, int *local)
{
    int64_t value = (int64_t)coordinate;
    int64_t quotient = value / CHUNK_X;
    int64_t remainder = value % CHUNK_X;

    if (remainder < 0) {
        --quotient;
        remainder += CHUNK_X;
    }
    if (quotient < INT32_MIN || quotient > INT32_MAX) {
        return -1;
    }

    *chunk = (int32_t)quotient;
    *local = (int)remainder;
    return 0;
}

static void mark_existing_chunk_dirty(World *w, int32_t cx, int32_t cy, int32_t cz)
{
    Chunk *neighbor = find_chunk(w, cx, cy, cz);
    if (neighbor != NULL) {
        neighbor->dirty = true;
    }
}

static void mark_boundary_neighbors_dirty(World *w,
                                          int32_t cx, int32_t cy, int32_t cz,
                                          int lx, int ly, int lz)
{
    if (lx == 0) {
        mark_existing_chunk_dirty(w, cx - 1, cy, cz);
    } else if (lx == CHUNK_X - 1) {
        mark_existing_chunk_dirty(w, cx + 1, cy, cz);
    }
    if (ly == 0) {
        mark_existing_chunk_dirty(w, cx, cy - 1, cz);
    } else if (ly == CHUNK_Y - 1) {
        mark_existing_chunk_dirty(w, cx, cy + 1, cz);
    }
    if (lz == 0) {
        mark_existing_chunk_dirty(w, cx, cy, cz - 1);
    } else if (lz == CHUNK_Z - 1) {
        mark_existing_chunk_dirty(w, cx, cy, cz + 1);
    }
}

Chunk *world_get_or_create_chunk(World *w, int cx, int cy, int cz)
{
    Chunk *chunk;

    if (w == NULL) {
        return NULL;
    }

    chunk = find_chunk(w, (int32_t)cx, (int32_t)cy, (int32_t)cz);
    if (chunk != NULL) {
        return chunk;
    }
    if (ensure_insert_capacity(w) != 0) {
        return NULL;
    }

    chunk = (Chunk *)calloc(1u, sizeof(*chunk));
    if (chunk == NULL) {
        return NULL;
    }
    chunk->cx = (int32_t)cx;
    chunk->cy = (int32_t)cy;
    chunk->cz = (int32_t)cz;
    chunk->dirty = true;
    insert_without_resize(w, chunk);
    return chunk;
}

void world_free_chunk(World *w, Chunk *c)
{
    if (w == NULL || c == NULL) {
        return;
    }
    if (remove_chunk_from_map(w, c)) {
        free(c);
    }
}

Block world_get_block(World *w, int x, int y, int z)
{
    int lx;
    int ly;
    int lz;
    int32_t cx;
    int32_t cy;
    int32_t cz;
    Chunk *chunk;

    if (w == NULL ||
        world_to_chunk_coord(x, &cx, &lx) != 0 ||
        world_to_chunk_coord(y, &cy, &ly) != 0 ||
        world_to_chunk_coord(z, &cz, &lz) != 0) {
        return (Block)0;
    }

    chunk = find_chunk(w, cx, cy, cz);
    if (chunk == NULL) {
        return (Block)0;
    }
    return chunk->blocks[idx(lx, ly, lz)];
}

int world_set_block(World *w, int x, int y, int z, Block b)
{
    int lx;
    int ly;
    int lz;
    int32_t cx;
    int32_t cy;
    int32_t cz;
    Chunk *chunk;

    if (w == NULL ||
        world_to_chunk_coord(x, &cx, &lx) != 0 ||
        world_to_chunk_coord(y, &cy, &ly) != 0 ||
        world_to_chunk_coord(z, &cz, &lz) != 0) {
        return -1;
    }

    chunk = world_get_or_create_chunk(w, (int)cx, (int)cy, (int)cz);
    if (chunk == NULL) {
        return -1;
    }
    chunk->blocks[idx(lx, ly, lz)] = b;
    chunk->dirty = true;
    mark_boundary_neighbors_dirty(w, cx, cy, cz, lx, ly, lz);
    return 0;
}

void world_init(World *w)
{
    if (w == NULL) {
        return;
    }
    w->slots = NULL;
    w->capacity = 0u;
    w->count = 0u;
    (void)resize_world(w, WORLD_INITIAL_CAPACITY);
}

void world_free(World *w)
{
    size_t i;

    if (w == NULL) {
        return;
    }
    if (w->slots != NULL) {
        for (i = 0u; i < w->capacity; ++i) {
            free(w->slots[i]);
        }
        free(w->slots);
    }
    w->slots = NULL;
    w->capacity = 0u;
    w->count = 0u;
}

void world_save_chunk(World *w, Chunk *c, const char *path)
{
    FILE *file;

    if (w == NULL || c == NULL || path == NULL ||
        find_chunk(w, c->cx, c->cy, c->cz) != c) {
        return;
    }

    file = fopen(path, "wb");
    if (file == NULL) {
        return;
    }
    (void)fwrite(&c->cx, sizeof(c->cx), 1u, file);
    (void)fwrite(&c->cy, sizeof(c->cy), 1u, file);
    (void)fwrite(&c->cz, sizeof(c->cz), 1u, file);
    (void)fwrite(c->blocks, sizeof(c->blocks), 1u, file);
    (void)fclose(file);
}

Chunk *world_load_chunk(World *w, int cx, int cy, int cz, const char *path)
{
    FILE *file;
    int32_t file_cx;
    int32_t file_cy;
    int32_t file_cz;
    Block blocks[CHUNK_BLOCK_COUNT];
    Chunk *chunk;

    if (w == NULL || path == NULL ||
        cx < INT32_MIN || cx > INT32_MAX ||
        cy < INT32_MIN || cy > INT32_MAX ||
        cz < INT32_MIN || cz > INT32_MAX) {
        return NULL;
    }

    file = fopen(path, "rb");
    if (file == NULL) {
        return NULL;
    }
    if (fread(&file_cx, sizeof(file_cx), 1u, file) != 1u ||
        fread(&file_cy, sizeof(file_cy), 1u, file) != 1u ||
        fread(&file_cz, sizeof(file_cz), 1u, file) != 1u ||
        fread(blocks, sizeof(blocks), 1u, file) != 1u) {
        (void)fclose(file);
        return NULL;
    }
    (void)fclose(file);

    if (file_cx != (int32_t)cx ||
        file_cy != (int32_t)cy ||
        file_cz != (int32_t)cz) {
        return NULL;
    }

    chunk = world_get_or_create_chunk(w, cx, cy, cz);
    if (chunk == NULL) {
        return NULL;
    }
    memcpy(chunk->blocks, blocks, sizeof(blocks));
    chunk->dirty = false;
    return chunk;
}

void world_fill_test_pattern(World *w, int base_x, int base_y, int base_z)
{
    (void)world_set_block(w, base_x, base_y, base_z, (Block)1);
    if (base_x < INT_MAX) {
        (void)world_set_block(w, base_x + 1, base_y, base_z, (Block)2);
    }
    if (base_y < INT_MAX) {
        (void)world_set_block(w, base_x, base_y + 1, base_z, (Block)3);
    }
    if (base_z < INT_MAX) {
        (void)world_set_block(w, base_x, base_y, base_z + 1, (Block)4);
    }
}