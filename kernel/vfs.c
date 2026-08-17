/*
 * HILAL_BIS — Sanal Dosya Sistemi (VFS)
 * Dizin ağacı RAM'de tutulur; dosya içeriği alt katman fs_* ile yönetilir.
 */

#include "vfs.h"
#include "filesystem.h"
#include "kstring.h"
#include "kernel.h"

static VfsNode nodes[VFS_MAX_NODES];
int vfs_cwd_id = 0;

/* ── Yardımcılar ─────────────────────────────────────────── */
static VfsNode *node_by_id(int id)
{
    if (id < 0 || id >= VFS_MAX_NODES) return NULL;
    return nodes[id].used ? &nodes[id] : NULL;
}

static int alloc_node(void)
{
    int i;
    for (i = 0; i < VFS_MAX_NODES; i++)
        if (!nodes[i].used) return i;
    return -1;
}

static void node_path(int id, char *buf, int buflen)
{
    char parts[VFS_MAX_DEPTH][VFS_NAME_LEN];
    int  depth = 0, cur = id, d, pos;

    while (cur > 0 && depth < VFS_MAX_DEPTH) {
        VfsNode *n = node_by_id(cur);
        if (!n) break;
        kstrncpy(parts[depth++], n->name, VFS_NAME_LEN);
        cur = n->parent_id;
    }

    buf[0] = '/'; pos = 1;
    for (d = depth - 1; d >= 0; d--) {
        int len = (int)kstrlen(parts[d]);
        if (pos + len + 1 >= buflen) break;
        kstrncpy(buf + pos, parts[d], buflen - pos);
        pos += len;
        if (d > 0 && pos < buflen - 1) buf[pos++] = '/';
    }
    buf[pos] = '\0';
    if (pos == 1 && buf[0] == '/') buf[1] = '\0';
}

static int find_child(int parent_id, const char *name)
{
    int i;
    for (i = 0; i < VFS_MAX_NODES; i++) {
        if (nodes[i].used &&
            nodes[i].parent_id == parent_id &&
            kstrcmp(nodes[i].name, name) == 0)
            return i;
    }
    return -1;
}

static int resolve_path_id(const char *abs_path)
{
    char seg[VFS_NAME_LEN];
    const char *p = abs_path;
    int cur = 0;

    if (*p == '/') p++;
    if (*p == '\0') return 0;

    while (*p) {
        int si = 0;
        while (*p && *p != '/') {
            if (si < VFS_NAME_LEN - 1) seg[si++] = *p;
            p++;
        }
        seg[si] = '\0';
        if (*p == '/') p++;
        if (si == 0) continue;
        if (kstrcmp(seg, ".") == 0) continue;
        if (kstrcmp(seg, "..") == 0) {
            VfsNode *cn = node_by_id(cur);
            cur = (cn && cn->parent_id >= 0) ? cn->parent_id : 0;
            continue;
        }
        cur = find_child(cur, seg);
        if (cur < 0) return -1;
    }
    return cur;
}

/* ================================================================ */
void vfs_init(void)
{
    int i;
    for (i = 0; i < VFS_MAX_NODES; i++) nodes[i].used = 0;

    nodes[0].id = 0; nodes[0].parent_id = -1;
    nodes[0].type = VFS_TYPE_DIR; nodes[0].owner_uid = 0;
    nodes[0].used = 1;
    kstrncpy(nodes[0].name, "/", VFS_NAME_LEN);
    vfs_cwd_id = 0;

    vfs_mkdir("/bin",        0);
    vfs_mkdir("/etc",        0);
    vfs_mkdir("/home",       0);
    vfs_mkdir("/home/root",  0);
    vfs_mkdir("/home/guest", 1);
    vfs_mkdir("/tmp",        0);
    vfs_mkdir("/dev",        0);
    vfs_mkdir("/var",        0);
    vfs_mkdir("/var/log",    0);

    KPRINT("[VFS] Dizin agaci hazir\n");
}

/* ================================================================ */
void vfs_resolve(const char *path, char *abs, int buflen)
{
    if (path[0] == '/') {
        kstrncpy(abs, path, buflen);
    } else {
        char cwd[VFS_PATH_LEN];
        int  cwdlen;
        node_path(vfs_cwd_id, cwd, VFS_PATH_LEN);
        cwdlen = (int)kstrlen(cwd);
        kstrncpy(abs, cwd, buflen);
        if (cwdlen < buflen - 2 && cwd[cwdlen - 1] != '/') {
            abs[cwdlen]     = '/';
            abs[cwdlen + 1] = '\0';
            cwdlen++;
        }
        kstrncpy(abs + cwdlen, path, buflen - cwdlen);
    }
}

/* ================================================================ */
VfsNode *vfs_find(const char *abs_path)
{
    int id = resolve_path_id(abs_path);
    return (id >= 0) ? node_by_id(id) : NULL;
}

/* ================================================================ */
int vfs_mkdir(const char *path, uint32_t uid)
{
    char abs[VFS_PATH_LEN], parent_abs[VFS_PATH_LEN];
    const char *name;
    int parent_id, new_id, len, i;
    VfsNode *n;

    vfs_resolve(path, abs, VFS_PATH_LEN);
    if (resolve_path_id(abs) >= 0) return 0;   /* zaten var */

    len = (int)kstrlen(abs);
    kstrncpy(parent_abs, abs, VFS_PATH_LEN);

    for (i = len - 1; i > 0; i--) {
        if (abs[i] == '/') { parent_abs[i] = '\0'; break; }
    }

    name = abs + i + 1;
    if (i == 0) {
        parent_id = 0;
        name      = abs + 1;
    } else {
        parent_id = resolve_path_id(parent_abs);
    }
    if (parent_id < 0) return -1;

    new_id = alloc_node();
    if (new_id < 0) return -1;

    n            = &nodes[new_id];
    n->id        = new_id;
    n->parent_id = parent_id;
    n->type      = VFS_TYPE_DIR;
    n->owner_uid = uid;
    n->size      = 0;
    n->used      = 1;
    kstrncpy(n->name, name, VFS_NAME_LEN);
    return new_id;
}

/* ================================================================ */
int vfs_rmdir(const char *path)
{
    char abs[VFS_PATH_LEN];
    int id, child;

    vfs_resolve(path, abs, VFS_PATH_LEN);
    id = resolve_path_id(abs);
    if (id < 0 || nodes[id].type != VFS_TYPE_DIR) return -1;

    for (child = 0; child < VFS_MAX_NODES; child++)
        if (nodes[child].used && nodes[child].parent_id == id) return -1;

    nodes[id].used = 0;
    if (vfs_cwd_id == id) vfs_cwd_id = 0;
    return 0;
}

/* ================================================================ */
int vfs_chdir(const char *path)
{
    char abs[VFS_PATH_LEN];
    int id;

    vfs_resolve(path, abs, VFS_PATH_LEN);
    id = resolve_path_id(abs);
    if (id < 0 || nodes[id].type != VFS_TYPE_DIR) return -1;
    vfs_cwd_id = id;
    return 0;
}

/* ================================================================ */
void vfs_getcwd(char *buf, int buflen)
{
    node_path(vfs_cwd_id, buf, buflen);
}

/* ================================================================
 * Alt katman (flat FS) wrappers — doğru imzalarla
 * ================================================================ */
int vfs_create(const char *path, uint32_t uid)
{
    char abs[VFS_PATH_LEN];
    vfs_resolve(path, abs, VFS_PATH_LEN);
    return fs_create(abs, "", 0, (int)uid);
}

int vfs_delete(const char *path)
{
    char abs[VFS_PATH_LEN];
    vfs_resolve(path, abs, VFS_PATH_LEN);
    return fs_delete(abs, 0);   /* root yetkisi */
}

int vfs_read(const char *path, char *buf, int maxlen)
{
    char abs[VFS_PATH_LEN];
    vfs_resolve(path, abs, VFS_PATH_LEN);
    return fs_read(abs, buf, maxlen, 0);
}

int vfs_write(const char *path, const char *data, int len)
{
    char abs[VFS_PATH_LEN];
    vfs_resolve(path, abs, VFS_PATH_LEN);
    return fs_write(abs, data, len, 0);
}

/* ================================================================ */
void vfs_ls(const char *path)
{
    char abs[VFS_PATH_LEN];
    int  dir_id, i, count = 0;

    vfs_resolve(path, abs, VFS_PATH_LEN);
    dir_id = resolve_path_id(abs);
    if (dir_id < 0) { KPRINT("ls: yol bulunamadi: %s\n", abs); return; }

    KPRINT("%s:\n", abs);
    for (i = 0; i < VFS_MAX_NODES; i++) {
        if (nodes[i].used && nodes[i].parent_id == dir_id) {
            KPRINT("  %s%s\n", nodes[i].name,
                    nodes[i].type == VFS_TYPE_DIR ? "/" : "");
            count++;
        }
    }

    /* Kök dizinde ek olarak flat FS dosyalarını da göster */
    if (dir_id == 0 && count == 0) fs_list();
}

/* ================================================================ */
int vfs_exists(const char *path)
{
    char abs[VFS_PATH_LEN];
    vfs_resolve(path, abs, VFS_PATH_LEN);
    if (resolve_path_id(abs) >= 0) return 1;
    return fs_exists(abs);
}

int vfs_is_dir(const char *path)
{
    char abs[VFS_PATH_LEN];
    int id;
    vfs_resolve(path, abs, VFS_PATH_LEN);
    id = resolve_path_id(abs);
    if (id < 0) return 0;
    return nodes[id].type == VFS_TYPE_DIR;
}

/* ── Kalıcı depolama yardımcıları ───────────────────────────────── */

VfsNode *vfs_find_by_id(int id)
{
    if (id < 0 || id >= VFS_MAX_NODES) return NULL;
    return nodes[id].used ? &nodes[id] : NULL;
}

void vfs_node_abs_path(int id, char *buf, int buflen)
{
    node_path(id, buf, buflen);
}

void vfs_node_abs_path_by_id(int parent_id, char *buf, int buflen)
{
    if (parent_id < 0) {
        buf[0] = '/'; buf[1] = '\0';
        return;
    }
    node_path(parent_id, buf, buflen);
}
