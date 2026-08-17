#include "kernel.h"
#include "auth.h"

/*
 * NOTE (honesty, matches the roadmap's own disclaimer):
 * `simple_hash()` is a single-byte XOR checksum, NOT a real hash and
 * NOT cryptographically secure. It exists only so this educational
 * kernel has *some* login gate to demonstrate privilege levels and
 * per-file permissions (FAZ 6). Do not reuse this pattern for anything
 * that needs real security.
 */

User users[MAX_USERS];
int  current_uid = -1;

/* ------------------------------------------------------------------ */
void auth_init(void)
{
    int i;
    for (i = 0; i < MAX_USERS; i++) users[i].active = 0;

    kstrncpy(users[0].username, "root", UNAME_MAX - 1);
    users[0].password_hash = simple_hash("root");
    users[0].uid       = 0;
    users[0].privilege = 1;
    users[0].active    = 1;

    kstrncpy(users[1].username, "guest", UNAME_MAX - 1);
    users[1].password_hash = simple_hash("guest");
    users[1].uid       = 1;
    users[1].privilege = 0;
    users[1].active    = 1;
}

/* ------------------------------------------------------------------ */
/* FNV-1a 32-bit — kriptografik değil ama XOR'dan çok daha güçlü.   */
/* Aynı şifre her zaman aynı hash'i üretir (deterministik).          */
uint32_t simple_hash(const char *pwd)
{
    uint32_t hash = 2166136261u;   /* FNV offset basis */
    int i;
    for (i = 0; i < PASSWORD_MAX && pwd[i]; i++) {
        hash ^= (uint32_t)(unsigned char)pwd[i];
        hash *= 16777619u;         /* FNV prime */
    }
    return hash;
}

/* ------------------------------------------------------------------ */
static void read_line(char *dst, int max, int hide)
{
    int i = 0;
    char c;
    while (i < max - 1) {
        c = (char)KGETCHAR();
        if (c == '\0') break;                         /* H1: EOF/NUL — giriş bitti */
        if (c == '\n' || c == '\r') { printf("\n"); break; }
        if (c == '\b' && i > 0) { printf("\b \b"); i--; continue; }
        if (c >= 32 && c < 127) {
            KPUTCHAR(hide ? '*' : c);
            dst[i++] = c;
        }
    }
    /* H2: Sondaki boşluk ve \r karakterlerini temizle (Windows CRLF / cmd echo) */
    while (i > 0 && (dst[i-1] == ' ' || dst[i-1] == '\r')) dst[--i] = '\0';
    dst[i] = '\0';
}

/* ------------------------------------------------------------------ */
int login_prompt(void)
{
    char uname[UNAME_MAX];
    char pwd[PASSWORD_MAX];
    int attempts = 0;
    int i;

    while (attempts < 3) {
        printf("\n");
        printf("+======================================+\n");
        printf("|          HILAL_BIS LOGIN              |\n");
        printf("+======================================+\n\n");

        printf("Username: ");
        read_line(uname, UNAME_MAX, 0);

        printf("Password: ");
        read_line(pwd, PASSWORD_MAX, 1);

        for (i = 0; i < MAX_USERS; i++) {
            if (!users[i].active) continue;
            if (kstrcmp(users[i].username, uname) == 0 &&
                users[i].password_hash == simple_hash(pwd)) {
                current_uid = users[i].uid;
                printf("\n[OK] Login successful. Welcome, %s!\n", uname);
                return current_uid;
            }
        }

        printf("\n[FAIL] Authentication failed.\n");
        attempts++;
    }

    printf("\n[SECURITY] Too many failed login attempts.\n");
    return -1;
}

/* ------------------------------------------------------------------ */
const char *auth_username(int uid)
{
    int i;
    for (i = 0; i < MAX_USERS; i++)
        if (users[i].active && users[i].uid == uid) return users[i].username;
    return "?";
}

/* ------------------------------------------------------------------ */
int auth_set_password(int uid, const char *new_pwd)
{
    int i;
    for (i = 0; i < MAX_USERS; i++) {
        if (users[i].active && users[i].uid == uid) {
            users[i].password_hash = simple_hash(new_pwd);
            return 0;
        }
    }
    return -1;
}
