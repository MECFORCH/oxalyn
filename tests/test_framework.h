/*
 * HILAL_BIS — Minimal Kernel Unit Test Framework
 *
 * Kullanım:
 *   #include "test_framework.h"
 *   TEST_BEGIN("test ismi");
 *   ASSERT_EQ(a, b);
 *   TEST_SUMMARY();
 */

#ifndef TEST_FRAMEWORK_H
#define TEST_FRAMEWORK_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* ── Global sayaçlar ────────────────────────────────────── */
static int _tf_pass   = 0;
static int _tf_fail   = 0;
static int _tf_total  = 0;
static const char *_tf_suite = "(unnamed)";

/* ── Test grubu başlat ──────────────────────────────────── */
#define TEST_SUITE(name) \
    do { _tf_suite = (name); \
         printf("\n=== %s ===\n", _tf_suite); } while(0)

/* ── Tek test fonksiyonu etiketi ────────────────────────── */
#define TEST_BEGIN(name) \
    printf("  [ ] %s\n", (name))

/* ── Assertion makroları ────────────────────────────────── */

#define ASSERT_EQ(a, b) do { \
    _tf_total++; \
    if ((long long)(a) == (long long)(b)) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s == %s  (%lld != %lld)\n", \
               __FILE__, __LINE__, #a, #b, \
               (long long)(a), (long long)(b)); \
    } \
} while(0)

#define ASSERT_NE(a, b) do { \
    _tf_total++; \
    if ((long long)(a) != (long long)(b)) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s != %s  (both == %lld)\n", \
               __FILE__, __LINE__, #a, #b, (long long)(a)); \
    } \
} while(0)

#define ASSERT_GT(a, b) do { \
    _tf_total++; \
    if ((long long)(a) > (long long)(b)) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s > %s  (%lld <= %lld)\n", \
               __FILE__, __LINE__, #a, #b, \
               (long long)(a), (long long)(b)); \
    } \
} while(0)

#define ASSERT_GE(a, b) do { \
    _tf_total++; \
    if ((long long)(a) >= (long long)(b)) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s >= %s  (%lld < %lld)\n", \
               __FILE__, __LINE__, #a, #b, \
               (long long)(a), (long long)(b)); \
    } \
} while(0)

#define ASSERT_NOT_NULL(p) do { \
    _tf_total++; \
    if ((p) != NULL) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s is NULL\n", __FILE__, __LINE__, #p); \
    } \
} while(0)

#define ASSERT_NULL(p) do { \
    _tf_total++; \
    if ((p) == NULL) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s is not NULL\n", __FILE__, __LINE__, #p); \
    } \
} while(0)

#define ASSERT_STREQ(a, b) do { \
    _tf_total++; \
    if (strcmp((a), (b)) == 0) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — \"%s\" != \"%s\"\n", \
               __FILE__, __LINE__, (a), (b)); \
    } \
} while(0)

#define ASSERT_TRUE(cond) do { \
    _tf_total++; \
    if (cond) { \
        _tf_pass++; \
    } else { \
        _tf_fail++; \
        printf("    FAIL %s:%d — %s is false\n", __FILE__, __LINE__, #cond); \
    } \
} while(0)

#define ASSERT_FALSE(cond) ASSERT_TRUE(!(cond))

/* ── Sonuçları yazdır ve exit ───────────────────────────── */
#define TEST_SUMMARY() do { \
    printf("\n══════════════════════════════════════\n"); \
    printf("Toplam: %d  |  PASS: %d  |  FAIL: %d\n", \
           _tf_total, _tf_pass, _tf_fail); \
    printf("══════════════════════════════════════\n"); \
    if (_tf_fail > 0) { \
        printf("SONUÇ: BAŞARISIZ\n"); \
        exit(1); \
    } else { \
        printf("SONUÇ: BAŞARILI\n"); \
    } \
} while(0)

#endif /* TEST_FRAMEWORK_H */
