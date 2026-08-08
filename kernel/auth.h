#ifndef AUTH_H
#define AUTH_H

#define MAX_USERS     4
#define UNAME_MAX     16
#define PASSWORD_MAX  16

typedef struct {
    char     username[UNAME_MAX];
    uint32_t password_hash;      /* FNV-1a 32-bit */
    int      uid;
    int      privilege;          /* 0 = user, 1 = admin */
    int      active;
} User;

extern User users[MAX_USERS];
extern int current_uid;   /* -1 until a successful login */

void     auth_init(void);
uint32_t simple_hash(const char *pwd);   /* FNV-1a 32-bit */
int  login_prompt(void);              /* returns uid, or -1 after 3 failed tries */
const char *auth_username(int uid);
int  auth_set_password(int uid, const char *new_pwd);

#endif /* AUTH_H */
