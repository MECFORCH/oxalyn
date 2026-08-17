/*
 * GUI güvenlik katmanı testleri.
 *
 * Bu testler GUI istemcisinin hatalı isteklerinin kernel'i durdurmadığını,
 * hata eşiğinde yalnızca GUI yetkisinin karantinaya alındığını doğrular.
 */

#include "../kernel/kernel.h"
#include "../kernel/gui_guard.h"
#include "test_framework.h"

static void clear_process(Process *process)
{
    unsigned char *bytes = (unsigned char *)process;
    size_t i;
    for (i = 0; i < sizeof(*process); i++)
        bytes[i] = 0;
}

static void test_valid_request(void)
{
    Process process;
    GpuDrawRequest request = {3, 10, 20, 100, 50, 0xFF00FF00u};
    uint64_t pixels = 0;

    clear_process(&process);
    gui_guard_init(&process);

    TEST_BEGIN("GUI guard — geçerli dikdörtgen kabul edilmeli");
    ASSERT_EQ(gui_guard_admit(&process, &request, &pixels), 0);
    ASSERT_EQ(process.gui_enabled, 1);
    ASSERT_EQ(process.gui_faults, 0);
    ASSERT_EQ(process.gui_ops, 1);
    ASSERT_EQ(pixels, 5000);
}

static void test_invalid_requests_quarantine_only_gui(void)
{
    Process process;
    GpuDrawRequest request = {3, 0, 0, -1, 100, 0};

    clear_process(&process);
    gui_guard_init(&process);

    TEST_BEGIN("GUI guard — üç hatada GUI karantinaya alınmalı");
    ASSERT_EQ(gui_guard_admit(&process, &request, NULL), GUI_FAULT_INVALID);
    ASSERT_EQ(gui_guard_admit(&process, &request, NULL), GUI_FAULT_INVALID);
    ASSERT_EQ(gui_guard_admit(&process, &request, NULL), GUI_FAULT_INVALID);
    ASSERT_EQ(process.gui_faults, GUI_FAULT_LIMIT);
    ASSERT_EQ(process.gui_enabled, 0);
    ASSERT_EQ(gui_guard_admit(&process, NULL, NULL), GUI_FAULT_DISABLED);
}

static void test_reset_reenables_gui(void)
{
    Process process;
    GpuDrawRequest request = {1, 1, 1, 0, 0, 0xFFFFFFFFu};

    clear_process(&process);
    gui_guard_init(&process);
    gui_guard_record_fault(&process, "test");
    gui_guard_record_fault(&process, "test");
    gui_guard_record_fault(&process, "test");

    TEST_BEGIN("GUI guard — reset sonrası GUI yeniden açılmalı");
    ASSERT_EQ(gui_guard_enabled(&process), 0);
    gui_guard_reset(&process);
    ASSERT_EQ(gui_guard_enabled(&process), 1);
    ASSERT_EQ(process.gui_faults, 0);
    ASSERT_EQ(process.gui_ops, 0);
    ASSERT_EQ(gui_guard_admit(&process, &request, NULL), 0);
}

static void test_boundaries_and_budget(void)
{
    Process process;
    GpuDrawRequest request = {1, FB_WIDTH - 1, FB_HEIGHT - 1, 0, 0, 0};
    uint64_t pixels = 0;
    unsigned int i;

    clear_process(&process);
    gui_guard_init(&process);

    TEST_BEGIN("GUI guard — framebuffer sınır pikseli kabul edilmeli");
    ASSERT_EQ(gui_guard_admit(&process, &request, &pixels), 0);
    ASSERT_EQ(pixels, 1);

    TEST_BEGIN("GUI guard — işlem kotası aşılınca kernel çalışmaya devam etmeli");
    for (i = 1; i < GUI_MAX_OPS; i++)
        ASSERT_EQ(gui_guard_admit(&process, &request, NULL), 0);
    ASSERT_EQ(process.gui_ops, GUI_MAX_OPS);
    ASSERT_EQ(gui_guard_admit(&process, &request, NULL), GUI_FAULT_BUDGET);
}

int main(void)
{
    printf("HILAL_BIS GUI Guard Testleri\n");
    printf("============================\n");

    TEST_SUITE("GUI GUARD");
    test_valid_request();
    test_invalid_requests_quarantine_only_gui();
    test_reset_reenables_gui();
    test_boundaries_and_budget();
    TEST_SUMMARY();
    return 0;
}