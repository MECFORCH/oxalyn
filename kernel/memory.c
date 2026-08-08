#include "kernel.h"
#include "memory.h"

#define HEAP_START  0x1000u
#define MAX_BLOCKS  64

typedef struct {
    void  *ptr;
    size_t size;
    int    used;
} Block;

static Block blocks[MAX_BLOCKS];
static int   block_count = 0;

/* ------------------------------------------------------------------ */
void memory_init(void)
{
    blocks[0].ptr  = (void *)(uintptr_t)HEAP_START;
    blocks[0].size = HEAP_SIZE;
    blocks[0].used = 0;
    block_count    = 1;
}

/* ------------------------------------------------------------------ */
void *kmalloc(size_t size)
{
    int i, j;
    if (size == 0)              return NULL;
    if (block_count >= MAX_BLOCKS) return NULL;

    for (i = 0; i < block_count; i++) {
        if (!blocks[i].used && blocks[i].size >= size) {
            void *ptr = blocks[i].ptr;

            /* Split block if remainder is meaningful */
            if (blocks[i].size > size * 2 && block_count < MAX_BLOCKS) {
                Block nb;
                nb.ptr  = (void *)((uintptr_t)ptr + size);
                nb.size = blocks[i].size - size;
                nb.used = 0;

                for (j = block_count; j > i + 1; j--)
                    blocks[j] = blocks[j - 1];
                blocks[i + 1] = nb;
                block_count++;
            }

            blocks[i].size = size;
            blocks[i].used = 1;
            return ptr;
        }
    }
    return NULL;   /* Out of memory */
}

/* ------------------------------------------------------------------ */
void kfree(void *ptr)
{
    int i, j;
    if (!ptr) return;

    for (i = 0; i < block_count; i++) {
        if (blocks[i].ptr == ptr && blocks[i].used) {
            blocks[i].used = 0;

            /* Coalesce with previous free block */
            if (i > 0 && !blocks[i - 1].used) {
                blocks[i - 1].size += blocks[i].size;
                for (j = i; j < block_count - 1; j++)
                    blocks[j] = blocks[j + 1];
                block_count--;
                i--;
            }

            /* Coalesce with next free block */
            if (i < block_count - 1 && !blocks[i + 1].used) {
                blocks[i].size += blocks[i + 1].size;
                for (j = i + 1; j < block_count - 1; j++)
                    blocks[j] = blocks[j + 1];
                block_count--;
            }

            return;
        }
    }
}
