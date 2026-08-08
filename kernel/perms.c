#include "kernel.h"
#include "perms.h"

static Permission perms[MAX_PERM_ENTRIES];

/* ------------------------------------------------------------------ */
void perms_init(void)
{
    int i;
    for (i = 0; i < MAX_PERM_ENTRIES; i++) perms[i].used = 0;
}

/* ------------------------------------------------------------------ */
void perms_register(const char *resource, int owner_uid, int mode)
{
    int i;
    for (i = 0; i < MAX_PERM_ENTRIES; i++) {
        if (perms[i].used && kstrcmp(perms[i].resource, resource) == 0) {
            perms[i].owner_uid = owner_uid;
            perms[i].perms     = mode;
            return;
        }
    }
    for (i = 0; i < MAX_PERM_ENTRIES; i++) {
        if (!perms[i].used) {
            kstrncpy(perms[i].resource, resource, sizeof(perms[i].resource) - 1);
            perms[i].owner_uid = owner_uid;
            perms[i].perms     = mode;
            perms[i].used      = 1;
            return;
        }
    }
}

/* ------------------------------------------------------------------ */
int check_permission(const char *resource, int uid, int perm)
{
    int i;
    if (uid == 0) return 1;   /* root always allowed */

    for (i = 0; i < MAX_PERM_ENTRIES; i++) {
        if (perms[i].used && kstrcmp(perms[i].resource, resource) == 0) {
            if (uid == perms[i].owner_uid && (perms[i].perms & perm)) return 1;
            return 0;
        }
    }
    /* No explicit entry -> resource doesn't exist / no policy set. */
    return 0;
}
