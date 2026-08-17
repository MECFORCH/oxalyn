#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <stddef.h>

#ifdef OXALYN_GUI_RENDER_BUILD
#define MAX_FILES      8
#define MAX_FILE_SIZE  256
#else
#define MAX_FILES      32
#define MAX_FILE_SIZE  4096
#endif

/* Freestanding kernel -> no libc <errno.h>; small local error codes */
#define FS_ENOSPC  (-1)
#define FS_ENOENT  (-2)
#define FS_EACCES  (-3)

void fs_init(void);
int  fs_create(const char *name, const char *data, int size, int owner_uid);
int  fs_write(const char *name, const char *data, int size, int uid);
int  fs_read(const char *name, char *buf, int len, int uid);
int  fs_delete(const char *name, int uid);
void fs_list(void);
int  fs_exists(const char *name);
int  fs_count(void);   /* kaç dosya var */

#endif /* FILESYSTEM_H */
