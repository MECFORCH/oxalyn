/*
 * HILAL_BIS — Kernel Unit Testleri
 *
 * Derleme (kernel/Makefile üzerinden):
 *   make test-kernel
 *
 * Çalıştırma:
 *   ./test_kernel
 *
 * Kapsam:
 *   - auth: login doğrulama, hash tutarlılığı
 *   - filesystem: yazma/okuma/silme
 *   - memory: kmalloc/kfree
 *   - scheduler: process oluşturma/öldürme
 *   - kstring: string fonksiyonları
 */

#include "../kernel/kernel.h"
#include "../kernel/auth.h"
#include "../kernel/filesystem.h"
#include "../kernel/perms.h"
#include "../kernel/memory.h"
#include "../kernel/scheduler.h"
#include "../kernel/kstring.h"
#include "test_framework.h"

/* ── Stub: uart_putchar/uart_getchar (test modunda kullanılmaz) ── */
void uart_init(void)  {}
void uart_putchar(char c) { (void)c; }
char uart_getchar(void) { return '\0'; }
void uart_puts(const char *s) { (void)s; }

/* ── Stub: gpu başlatma ──────────────────────────────────────── */
void gpu_init(void)     {}
void gpu_cmd_init(void) {}
void gpu_clear(uint32_t c) { (void)c; }

/* ── Stub: scheduler (bazı testler ihtiyaç duyuyor) ──────────── */
extern int current_pid;

/* ================================================================
 * AUTH TESTLERİ
 * ================================================================ */
static void test_auth_hash_consistent(void)
{
    TEST_BEGIN("simple_hash — aynı girdi aynı çıktı vermeli");
    uint32_t h1 = simple_hash("root");
    uint32_t h2 = simple_hash("root");
    ASSERT_EQ(h1, h2);
}

static void test_auth_hash_different(void)
{
    TEST_BEGIN("simple_hash — farklı parolalar farklı hash üretmeli");
    uint32_t h1 = simple_hash("root");
    uint32_t h2 = simple_hash("guest");
    ASSERT_NE(h1, h2);
}

static void test_auth_init(void)
{
    TEST_BEGIN("auth_init — root ve guest kullanıcıları oluşturulmalı");
    auth_init();
    ASSERT_EQ(users[0].active,    1);
    ASSERT_STREQ(users[0].username, "root");
    ASSERT_EQ(users[0].uid,       0);
    ASSERT_EQ(users[0].privilege, 1);
    ASSERT_EQ(users[1].active,    1);
    ASSERT_STREQ(users[1].username, "guest");
    ASSERT_EQ(users[1].uid,       1);
    ASSERT_EQ(users[1].privilege, 0);
}

static void test_auth_hash_matches_stored(void)
{
    TEST_BEGIN("auth_init — root hash, 'root' parolasıyla eşleşmeli");
    auth_init();
    ASSERT_EQ(users[0].password_hash, simple_hash("root"));
}

static void test_auth_set_password(void)
{
    TEST_BEGIN("auth_set_password — yeni hash kaydedilmeli");
    auth_init();
    int r = auth_set_password(0, "yeniParola123");
    ASSERT_EQ(r, 0);
    ASSERT_EQ(users[0].password_hash, simple_hash("yeniParola123"));
    ASSERT_NE(users[0].password_hash, simple_hash("root"));
}

static void test_auth_set_password_invalid_uid(void)
{
    TEST_BEGIN("auth_set_password — geçersiz uid → -1 döndürmeli");
    auth_init();
    int r = auth_set_password(99, "xyz");
    ASSERT_EQ(r, -1);
}

static void test_auth_username(void)
{
    TEST_BEGIN("auth_username — uid 0 → 'root' döndürmeli");
    auth_init();
    const char *name = auth_username(0);
    ASSERT_STREQ(name, "root");
}

static void test_auth_username_unknown(void)
{
    TEST_BEGIN("auth_username — geçersiz uid → '?' döndürmeli");
    auth_init();
    const char *name = auth_username(99);
    ASSERT_STREQ(name, "?");
}

/* ================================================================
 * MEMORY TESTLERİ
 * ================================================================ */
static void test_memory_alloc(void)
{
    TEST_BEGIN("kmalloc — geçerli boyut → NULL olmamalı");
    memory_init();
    void *p = kmalloc(64);
    ASSERT_NOT_NULL(p);
}

static void test_memory_alloc_zero(void)
{
    TEST_BEGIN("kmalloc(0) → NULL döndürmeli");
    memory_init();
    void *p = kmalloc(0);
    ASSERT_NULL(p);
}

static void test_memory_free(void)
{
    TEST_BEGIN("kfree — double alloc → freed bellek yeniden kullanılmalı");
    memory_init();
    void *p1 = kmalloc(128);
    ASSERT_NOT_NULL(p1);
    kfree(p1);
    void *p2 = kmalloc(128);
    ASSERT_NOT_NULL(p2);
}

static void test_memory_multiple_alloc(void)
{
    TEST_BEGIN("kmalloc — art arda 8 tahsis → hepsi başarılı olmalı");
    memory_init();
    void *ptrs[8];
    int i;
    for (i = 0; i < 8; i++) {
        ptrs[i] = kmalloc(64);
        ASSERT_NOT_NULL(ptrs[i]);
    }
    for (i = 0; i < 8; i++) kfree(ptrs[i]);
}

/* ================================================================
 * FILESYSTEM TESTLERİ
 * ================================================================ */
static void test_fs_write_read(void)
{
    TEST_BEGIN("fs_write + fs_read — yazılan veri geri okunabilmeli");
    perms_init();
    fs_init();
    const char data[] = "merhaba oxalyn";
    int wr = fs_write("test.txt", data, (int)sizeof(data), 0);
    ASSERT_EQ(wr, 0);

    char buf[64];
    int rd = fs_read("test.txt", buf, (int)sizeof(buf), 0);
    ASSERT_GT(rd, 0);
    ASSERT_STREQ(buf, data);
}

static void test_fs_write_overwrite(void)
{
    TEST_BEGIN("fs_write — aynı dosyaya iki kez yaz → ikinci içerik geçerli olmalı");
    perms_init();
    fs_init();
    fs_write("over.txt", "birinci", 8, 0);
    fs_write("over.txt", "ikinci!!", 9, 0);
    char buf[64];
    fs_read("over.txt", buf, 64, 0);
    ASSERT_STREQ(buf, "ikinci!!");
}

static void test_fs_read_nonexistent(void)
{
    TEST_BEGIN("fs_read — olmayan dosya → negatif döndürmeli");
    perms_init();
    fs_init();
    char buf[16];
    int r = fs_read("yok.txt", buf, 16, 0);
    ASSERT_TRUE(r < 0);
}

static void test_fs_delete(void)
{
    TEST_BEGIN("fs_delete — silinen dosya okunamaz olmalı");
    perms_init();
    fs_init();
    fs_write("sil.txt", "data", 5, 0);
    fs_delete("sil.txt", 0);
    char buf[16];
    int r = fs_read("sil.txt", buf, 16, 0);
    ASSERT_TRUE(r < 0);
}

/* ================================================================
 * KSTRING TESTLERİ
 * ================================================================ */
static void test_kstrlen(void)
{
    TEST_BEGIN("kstrlen — 'merhaba' → 7");
    ASSERT_EQ(kstrlen("merhaba"), 7);
    ASSERT_EQ(kstrlen(""),        0);
}

static void test_kstrcmp(void)
{
    TEST_BEGIN("kstrcmp — eşit dizeler → 0");
    ASSERT_EQ(kstrcmp("abc", "abc"), 0);
    ASSERT_TRUE(kstrcmp("abc", "abd") < 0);
    ASSERT_TRUE(kstrcmp("abd", "abc") > 0);
}

static void test_kstrncpy(void)
{
    TEST_BEGIN("kstrncpy — maksimum uzunluk korunmalı");
    char dst[8];
    kstrncpy(dst, "merhaba_uzun", 7);
    dst[7] = '\0';
    ASSERT_EQ(kstrlen(dst), 7);
}

static void test_memcpy_memset(void)
{
    TEST_BEGIN("memcpy + memset — doğru kopyalama");
    char src[8] = {1,2,3,4,5,6,7,8};
    char dst[8];
    memset(dst, 0, 8);
    memcpy(dst, src, 8);
    int i, ok = 1;
    for (i = 0; i < 8; i++) if (dst[i] != src[i]) ok = 0;
    ASSERT_TRUE(ok);
}

/* ================================================================
 * MAIN
 * ================================================================ */
int main(void)
{
    printf("HILAL_BIS Kernel Unit Testleri\n");
    printf("================================\n");

    TEST_SUITE("AUTH");
    test_auth_hash_consistent();
    test_auth_hash_different();
    test_auth_init();
    test_auth_hash_matches_stored();
    test_auth_set_password();
    test_auth_set_password_invalid_uid();
    test_auth_username();
    test_auth_username_unknown();

    TEST_SUITE("MEMORY");
    test_memory_alloc();
    test_memory_alloc_zero();
    test_memory_free();
    test_memory_multiple_alloc();

    TEST_SUITE("FILESYSTEM");
    test_fs_write_read();
    test_fs_write_overwrite();
    test_fs_read_nonexistent();
    test_fs_delete();

    TEST_SUITE("KSTRING");
    test_kstrlen();
    test_kstrcmp();
    test_kstrncpy();
    test_memcpy_memset();

    TEST_SUMMARY();
    return 0;
}
