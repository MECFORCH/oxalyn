#include "kernel.h"
#include "filesystem.h"
#include "perms.h"

typedef struct {
    char name[32];
    char data[MAX_FILE_SIZE];
    int  size;
    int  owner_uid;
    int  used;
} File;

static File files[MAX_FILES];
static int  file_count = 0;

/* ------------------------------------------------------------------ */
void fs_init(void)
{
    int i;
    for (i = 0; i < MAX_FILES; i++) files[i].used = 0;
    file_count = 0;
}

/* ------------------------------------------------------------------ */
static int find_file(const char *name)
{
    int i;
    for (i = 0; i < MAX_FILES; i++)
        if (files[i].used && kstrcmp(files[i].name, name) == 0) return i;
    return -1;
}

/* ------------------------------------------------------------------ */
int fs_exists(const char *name)
{
    return find_file(name) >= 0;
}

/* ------------------------------------------------------------------ */
int fs_create(const char *name, const char *data, int size, int owner_uid)
{
    int slot = -1, i;

    if (find_file(name) >= 0) return fs_write(name, data, size, owner_uid);

    for (i = 0; i < MAX_FILES; i++) {
        if (!files[i].used) { slot = i; break; }
    }
    if (slot < 0) return FS_ENOSPC;

    if (size > MAX_FILE_SIZE) size = MAX_FILE_SIZE;

    kstrncpy(files[slot].name, name, sizeof(files[slot].name) - 1);
    if (size > 0) kmemcpy(files[slot].data, data, (size_t)size);
    files[slot].size      = size;
    files[slot].owner_uid = owner_uid;
    files[slot].used      = 1;
    file_count++;

    perms_register(name, owner_uid, PERM_READ | PERM_WRITE);
    printf("[FS] Created %s (%d bytes)\n", name, size);
    return 0;
}

/* ------------------------------------------------------------------ */
int fs_write(const char *name, const char *data, int size, int uid)
{
    int idx = find_file(name);
    if (idx < 0) return fs_create(name, data, size, uid);

    if (!check_permission(name, uid, PERM_WRITE)) {
        printf("Permission denied: %s\n", name);
        return FS_EACCES;
    }
    if (size > MAX_FILE_SIZE) size = MAX_FILE_SIZE;
    if (size > 0) kmemcpy(files[idx].data, data, (size_t)size);
    files[idx].size = size;
    return 0;
}

/* ------------------------------------------------------------------ */
int fs_read(const char *name, char *buf, int len, int uid)
{
    int idx = find_file(name);
    int cp;
    if (idx < 0) return FS_ENOENT;

    if (!check_permission(name, uid, PERM_READ)) {
        printf("Permission denied: %s\n", name);
        return FS_EACCES;
    }

    cp = (len < files[idx].size) ? len : files[idx].size;
    kmemcpy(buf, files[idx].data, (size_t)cp);
    return cp;
}

/* ------------------------------------------------------------------ */
int fs_delete(const char *name, int uid)
{
    int idx = find_file(name);
    if (idx < 0) return FS_ENOENT;

    if (!check_permission(name, uid, PERM_WRITE)) {
        printf("Permission denied: %s\n", name);
        return FS_EACCES;
    }
    files[idx].used = 0;
    file_count--;
    return 0;
}

/* ------------------------------------------------------------------ */
int fs_count(void) { return file_count; }

void fs_list(void)
{
    int i;
    printf("Files:\n");
    for (i = 0; i < MAX_FILES; i++) {
        if (files[i].used)
            printf("  %s (%d B)\n", files[i].name, files[i].size);
    }
    if (file_count == 0) printf("  (empty)\n");
}
