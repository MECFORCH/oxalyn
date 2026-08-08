#ifndef PERMS_H
#define PERMS_H

#define PERM_READ    1
#define PERM_WRITE   2
#define PERM_EXECUTE 4

#define MAX_PERM_ENTRIES 32

typedef struct {
    char resource[32];
    int  owner_uid;
    int  perms;      /* bitmask of PERM_* granted to the owner */
    int  used;
} Permission;

void perms_init(void);
void perms_register(const char *resource, int owner_uid, int perms);
int  check_permission(const char *resource, int uid, int perm);

#endif /* PERMS_H */
