/*
 * HILAL_BIS — VFS Kalıcı Depolama Katmanı
 *
 * VFS dizin ağacını ve tüm dosya içeriklerini EEPROM dosyasına
 * seri hale getirir/yükler. libc gerektirmez; hostio (raw syscall) kullanır.
 */

#include "vfs_persist.h"
#include "vfs.h"
#include "filesystem.h"
#include "kstring.h"
#include "platform.h"
#include "hostio.h"

/* ── Yardımcılar ─────────────────────────────────────────────────── */

static const char *resolve_path(const char *user_path)
{
    return (user_path && user_path[0]) ? user_path : VFS_EEPROM_PATH;
}

/* hostio ile 'n' bayt yaz; başarısızsa -1 döner */
static int hwrite(int fd, const void *buf, int n)
{
    return (hostio_write(fd, buf, (size_t)n) == (long)n) ? 0 : -1;
}

/* hostio ile tam olarak 'n' bayt oku; başarısızsa -1 döner */
static int hread(int fd, void *buf, int n)
{
    return (hostio_read(fd, buf, (size_t)n) == (long)n) ? 0 : -1;
}

/* ── vfs_persist_save ─────────────────────────────────────────────── */
int vfs_persist_save(const char *path)
{
#if HOSTIO_AVAILABLE
    const char *fpath = resolve_path(path);
    int fd;
    uint32_t magic      = VFS_PERSIST_MAGIC;
    uint32_t version    = VFS_PERSIST_VERSION;
    uint32_t node_count = 0;
    uint32_t file_count = 0;
    int i;

    /* Aktif node ve dosyaları say */
    for (i = 0; i < VFS_MAX_NODES; i++) {
        VfsNode *n = vfs_find_by_id(i);
        if (n && n->used) node_count++;
    }
    file_count = (uint32_t)fs_count();

    fd = hostio_open(fpath,
                     HOSTIO_O_WRONLY | HOSTIO_O_CREAT | HOSTIO_O_TRUNC,
                     0644);
    if (fd < 0) {
        KPRINT("[PERSIST] Kayit acilamadi: %s\n", fpath);
        return -1;
    }

    /* Başlık */
    if (hwrite(fd, &magic,      4) < 0 ||
        hwrite(fd, &version,    4) < 0 ||
        hwrite(fd, &node_count, 4) < 0 ||
        hwrite(fd, &file_count, 4) < 0) {
        KPRINT("[PERSIST] Baslik yazma hatasi\n");
        hostio_close(fd);
        return -1;
    }

    /* Node kayıtları */
    for (i = 0; i < VFS_MAX_NODES; i++) {
        VfsNode *n = vfs_find_by_id(i);
        if (!n || !n->used) continue;
        {
            VfsPersistNode rec;
            kmemset(&rec, 0, sizeof(rec));
            rec.id        = (int32_t)n->id;
            rec.parent_id = (int32_t)n->parent_id;
            rec.type      = (uint8_t)n->type;
            rec.owner_uid = (uint32_t)n->owner_uid;
            kmemcpy(rec.name, n->name, VFS_NAME_LEN);
            if (n->type == VFS_TYPE_FILE) {
                char abs[VFS_PATH_LEN];
                vfs_node_abs_path(i, abs, VFS_PATH_LEN);
                kstrncpy(rec.fs_key, abs, VFS_NAME_LEN - 1);
            }
            hwrite(fd, &rec, (int)sizeof(rec));
        }
    }

    /* Dosya içerikleri */
    for (i = 0; i < VFS_MAX_NODES; i++) {
        VfsNode *n = vfs_find_by_id(i);
        if (!n || !n->used || n->type != VFS_TYPE_FILE) continue;
        {
            VfsPersistFile rec;
            char abs[VFS_PATH_LEN];
            int  rd;
            kmemset(&rec, 0, sizeof(rec));
            vfs_node_abs_path(i, abs, VFS_PATH_LEN);
            kstrncpy(rec.fs_key, abs, VFS_NAME_LEN - 1);
            rec.owner_uid = (int32_t)n->owner_uid;
            rd = fs_read(abs, rec.data, MAX_FILE_SIZE, 0);
            rec.size = (rd > 0) ? rd : 0;
            hwrite(fd, &rec, (int)sizeof(rec));
        }
    }

    hostio_close(fd);
    KPRINT("[PERSIST] Kaydedildi: %s (%u node, %u dosya)\n",
            fpath, node_count, file_count);
    return 0;
#else
    (void)path;
    KPRINT("[PERSIST] Kayit desteklenmiyor (donanim modu)\n");
    return -1;
#endif
}

/* ── vfs_persist_load ─────────────────────────────────────────────── */
int vfs_persist_load(const char *path)
{
#if HOSTIO_AVAILABLE
    const char *fpath = resolve_path(path);
    int fd;
    uint32_t magic, version, node_count, file_count;
    uint32_t i;

    fd = hostio_open(fpath, HOSTIO_O_RDONLY, 0);
    if (fd < 0) return -1;   /* dosya yok — sessiz geç */

    /* Başlık doğrula */
    if (hread(fd, &magic,      4) < 0 || magic   != VFS_PERSIST_MAGIC  ||
        hread(fd, &version,    4) < 0 || version != VFS_PERSIST_VERSION ||
        hread(fd, &node_count, 4) < 0 ||
        hread(fd, &file_count, 4) < 0) {
        KPRINT("[PERSIST] Baslik bozuk veya uyumsuz: %s\n", fpath);
        hostio_close(fd);
        return -1;
    }

    if (node_count > (uint32_t)VFS_MAX_NODES ||
        file_count > (uint32_t)MAX_FILES) {
        KPRINT("[PERSIST] Kayit sinirlari asiliyor (%u/%u)\n",
                node_count, file_count);
        hostio_close(fd);
        return -1;
    }

    /* VFS ve dosya katmanını sıfırla */
    vfs_init();
    fs_init();

    /* Node'ları yükle */
    for (i = 0; i < node_count; i++) {
        VfsPersistNode rec;
        if (hread(fd, &rec, (int)sizeof(rec)) < 0) goto corrupt;

        if (rec.id == 0) continue;   /* kök vfs_init() ile açılır */

        {
            char abs[VFS_PATH_LEN];
            int  abslen;
            vfs_node_abs_path_by_id(rec.parent_id, abs, VFS_PATH_LEN);
            abslen = (int)kstrlen(abs);
            if (abslen < VFS_PATH_LEN - 2 && abs[abslen - 1] != '/') {
                abs[abslen]     = '/';
                abs[abslen + 1] = '\0';
                abslen++;
            }
            kstrncpy(abs + abslen, rec.name, VFS_PATH_LEN - abslen - 1);

            if (rec.type == VFS_TYPE_DIR) {
                if (!vfs_find(abs)) vfs_mkdir(abs, rec.owner_uid);
            } else {
                if (!vfs_exists(abs)) vfs_create(abs, rec.owner_uid);
            }
        }
    }

    /* Dosya içeriklerini yükle */
    for (i = 0; i < file_count; i++) {
        VfsPersistFile rec;
        if (hread(fd, &rec, (int)sizeof(rec)) < 0) goto corrupt;
        if (rec.size > 0 && rec.size <= MAX_FILE_SIZE)
            fs_write(rec.fs_key, rec.data, rec.size, 0);
    }

    hostio_close(fd);
    KPRINT("[PERSIST] Yuklendi: %s (%u node, %u dosya)\n",
            fpath, node_count, file_count);
    return 0;

corrupt:
    hostio_close(fd);
    KPRINT("[PERSIST] Veri bozuk — temiz VFS baslatiliyor\n");
    vfs_init();
    fs_init();
    return -1;
#else
    (void)path;
    return -1;
#endif
}

/* ── vfs_persist_auto_load ───────────────────────────────────────── */
void vfs_persist_auto_load(const char *path)
{
    if (vfs_persist_load(path) == 0) return;
    KPRINT("[PERSIST] Kayitli durum yok, temiz VFS baslatildi\n");
}

/* ── vfs_persist_info ─────────────────────────────────────────────── */
void vfs_persist_info(const char *path)
{
#if HOSTIO_AVAILABLE
    const char *fpath = resolve_path(path);
    int fd;
    uint32_t magic, version, node_count, file_count;

    fd = hostio_open(fpath, HOSTIO_O_RDONLY, 0);
    if (fd < 0) {
        KPRINT("[PERSIST] Kayit dosyasi yok: %s\n", fpath);
        return;
    }

    if (hread(fd, &magic,      4) < 0 ||
        hread(fd, &version,    4) < 0 ||
        hread(fd, &node_count, 4) < 0 ||
        hread(fd, &file_count, 4) < 0) {
        KPRINT("[PERSIST] Baslik okunamadi\n");
        hostio_close(fd);
        return;
    }
    hostio_close(fd);

    KPRINT("[PERSIST] Snapshot: %s\n", fpath);
    KPRINT("  Surum : %u\n",   version);
    KPRINT("  Nodlar: %u\n",   node_count);
    KPRINT("  Dosya : %u\n",   file_count);
    KPRINT("  Sihir : %08X (%s)\n", magic,
            magic == VFS_PERSIST_MAGIC ? "gecerli" : "HATALI");
#else
    (void)path;
    KPRINT("[PERSIST] Bilgi desteklenmiyor\n");
#endif
}
