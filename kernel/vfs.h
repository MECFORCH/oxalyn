#ifndef VFS_H
#define VFS_H

/*
 * HILAL_BIS — Sanal Dosya Sistemi (VFS)
 * Mevcut RAM tabanlı flat FS üzerine dizin katmanı ekler.
 * Mutlak ve göreli yol çözümlemesi yapar.
 *
 * Dizin ağacı RAM'de inode dizisi olarak tutulur.
 * Dosyalar alt katmandaki fs_* fonksiyonlarına devredilir.
 */

#include <stdint.h>

#define VFS_MAX_NODES   64          /* toplam dizin + dosya */
#define VFS_NAME_LEN    32
#define VFS_PATH_LEN    128
#define VFS_MAX_DEPTH   8

#define VFS_TYPE_DIR    0
#define VFS_TYPE_FILE   1

typedef struct VfsNode {
    int      id;
    int      parent_id;         /* kök için -1 */
    int      type;              /* VFS_TYPE_* */
    char     name[VFS_NAME_LEN];
    uint32_t owner_uid;
    uint32_t size;              /* dosya için; dizin için 0 */
    int      used;
} VfsNode;

/* Geçerli çalışma dizini (her proses başına idealdir; şimdilik global) */
extern int vfs_cwd_id;

void vfs_init(void);

/* Dizin işlemleri */
int  vfs_mkdir(const char *path, uint32_t uid);
int  vfs_rmdir(const char *path);
int  vfs_chdir(const char *path);             /* cwd günceller */
void vfs_getcwd(char *buf, int buflen);       /* /home/user gibi */

/* Dosya işlemleri (alt kata devreder, yol çözümler) */
int  vfs_create(const char *path, uint32_t uid);
int  vfs_delete(const char *path);
int  vfs_read  (const char *path, char *buf, int maxlen);
int  vfs_write (const char *path, const char *data, int len);

/* Listeleme */
void vfs_ls(const char *path);          /* UART'a yazar */
int  vfs_exists(const char *path);      /* 1=var, 0=yok */
int  vfs_is_dir(const char *path);

/* Yol yardımcıları */
void vfs_resolve(const char *path, char *abs, int buflen);
                /* göreli yolu mutlak yola çevirir */

/* Düğüm arama (dahili, gerektiğinde dışarıdan kullanılır) */
VfsNode *vfs_find(const char *abs_path);

/* ── Kalıcı depolama yardımcıları (vfs_persist.c tarafından kullanılır) ── */

/* id numarasına göre node döndür (kullanılmıyorsa NULL) */
VfsNode *vfs_find_by_id(int id);

/* node id'den mutlak yol hesapla */
void vfs_node_abs_path(int id, char *buf, int buflen);

/* parent id'den mutlak yol hesapla */
void vfs_node_abs_path_by_id(int parent_id, char *buf, int buflen);

/* Kaç dosya var (filesystem katmanı) */
int fs_count(void);

#endif /* VFS_H */
