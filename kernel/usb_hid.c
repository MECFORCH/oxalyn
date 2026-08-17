/*
 * HILAL_BIS — USB HID Sürücüsü
 * Oxalyn-64 Mimarisi, Bellek-Eşlemeli I/O
 *
 * Klavye: tam HID Usage Table 0x07 keycodes, shift/caps/ctrl/alt
 * Mouse : delta X/Y, 3 buton, scroll wheel, sınır kontrolü
 * Key repeat: 500ms gecikme → 30ms aralık
 */

#include "usb_hid.h"
#include "input.h"
#include "mouse.h"
#include "kernel.h"
#include "mmio.h"   /* H3: Host modda düşük adres segfault'unu önler */

/* ── Port I/O makroları ─────────────────────────────────────── */
/* Oxalyn-64: port adresi doğrudan bellek adresi gibi kullanılır */
static inline uint64_t usb_port_read(uint32_t port)
{
    return mmio_read(port);
}

static inline void usb_port_write(uint32_t port, uint64_t val)
{
    mmio_write(port, val);
}

/* ── Key-repeat sabitleri (timer tick cinsinden) ────────────── */
#define KEY_REPEAT_DELAY    50u   /* ~500ms ilk gecikme  (10ms/tick)  */
#define KEY_REPEAT_INTERVAL  3u   /* ~30ms  tekrar aralığı            */

/* ── Küresel durum ──────────────────────────────────────────── */
UsbHidState g_usb_hid;

/* ── HID keycode → ASCII çevrim tablosu ─────────────────────── */
/* İndeks = HID keycode (0x00-0x52), değer = basılmamış ASCII   */
static const char hid_unshifted[0x53] = {
    /* 0x00 */ 0,    0,    0,    0,
    /* 0x04 */ 'a',  'b',  'c',  'd',  'e',  'f',  'g',  'h',
    /* 0x0C */ 'i',  'j',  'k',  'l',  'm',  'n',  'o',  'p',
    /* 0x14 */ 'q',  'r',  's',  't',  'u',  'v',  'w',  'x',
    /* 0x1C */ 'y',  'z',
    /* 0x1E */ '1',  '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9',  '0',
    /* 0x28 */ '\n', 27,   '\b', '\t', ' ',
    /* 0x2D */ '-',  '=',  '[',  ']',  '\\', 0,    ';',  '\'', '`',
    /* 0x36 */ ',',  '.',  '/',
    /* 0x39 */ 0,    /* CapsLock — özel işlenir */
    /* 0x3A */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   /* F1-F12 */
    /* 0x46 */ 0, 0, 0,                                /* PrintScr/Scroll/Pause */
    /* 0x49 */ 0, 0, 0, 0, 0, 0,                       /* Ins/Home/PgUp/Del/End/PgDn */
    /* 0x4F */ 0, 0, 0, 0                               /* →←↓↑ */
};

/* Shift ile üretilen karakter tablosu (aynı boyut) */
static const char hid_shifted[0x53] = {
    /* 0x00 */ 0,    0,    0,    0,
    /* 0x04 */ 'A',  'B',  'C',  'D',  'E',  'F',  'G',  'H',
    /* 0x0C */ 'I',  'J',  'K',  'L',  'M',  'N',  'O',  'P',
    /* 0x14 */ 'Q',  'R',  'S',  'T',  'U',  'V',  'W',  'X',
    /* 0x1C */ 'Y',  'Z',
    /* 0x1E */ '!',  '@',  '#',  '$',  '%',  '^',  '&',  '*',  '(',  ')',
    /* 0x28 */ '\n', 27,   '\b', '\t', ' ',
    /* 0x2D */ '_',  '+',  '{',  '}',  '|',  0,    ':',  '"',  '~',
    /* 0x36 */ '<',  '>',  '?',
    /* 0x39 */ 0,
    /* 0x3A */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /* 0x46 */ 0, 0, 0,
    /* 0x49 */ 0, 0, 0, 0, 0, 0,
    /* 0x4F */ 0, 0, 0, 0
};

/* ── Yardımcı: tek bir keycode'u ASCII'ye çevir ─────────────── */
static char keycode_to_ascii(uint8_t code, uint8_t mod, uint8_t caps)
{
    if (code >= 0x53u) return 0;

    int shifted = (mod & HID_MOD_SHIFT) ? 1 : 0;

    /* CapsLock yalnızca harfler için Shift etkisini ters çevirir */
    if (caps && code >= 0x04u && code <= 0x1Du)
        shifted = !shifted;

    return shifted ? hid_shifted[code] : hid_unshifted[code];
}

/* ── Yardımcı: tuşun önceki karedeki listede olup olmadığı ─── */
static int key_was_pressed(const uint8_t prev[6], uint8_t code)
{
    int i;
    for (i = 0; i < 6; i++)
        if (prev[i] == code) return 1;
    return 0;
}

/* ── Yardımcı: tuşun şu an basılı listesinde olup olmadığı ── */
static int key_is_pressed(const uint8_t keys[6], uint8_t code)
{
    int i;
    for (i = 0; i < 6; i++)
        if (keys[i] == code) return 1;
    return 0;
}

/* ── Ctrl kombinasyonu üret ──────────────────────────────────── */
static char ctrl_combo(uint8_t code)
{
    /* Ctrl+A = 0x01 ... Ctrl+Z = 0x1A */
    if (code >= HID_KEY_A && code <= HID_KEY_Z)
        return (char)(code - HID_KEY_A + 1);
    if (code == HID_KEY_BACKSPACE) return '\b';
    if (code == HID_KEY_ENTER)     return '\n';
    return 0;
}

/* ═══════════════════════════════════════════════════════════════
 * USB HID INIT
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_init(void)
{
    uint64_t status;

    /* Durumu sıfırla */
    kmemset(&g_usb_hid, 0, sizeof(g_usb_hid));

    /* Controller'ı etkinleştir */
    usb_port_write(USB_PORT_CTRL, USB_CTRL_ENABLE);

    /* Controller hazır mı? */
    status = usb_port_read(USB_PORT_STATUS);

    if (!(status & USB_STATUS_READY)) {
        KPRINT("[USB HID] Uyarı: Controller henüz hazır değil (status=0x%x)\n",
                (uint32_t)status);
        /* Yine de devam et — donanım geç başlatılıyor olabilir */
    } else {
        KPRINT("[USB HID] Controller hazır\n");
        g_usb_hid.controller_ready = 1;
    }

    /* Bağlı aygıtları tespit et */
    if (status & USB_STATUS_KBD_CONN) {
        g_usb_hid.kbd_dev.connected    = 1;
        g_usb_hid.kbd_dev.vendor_class = 0x03; /* HID sınıfı */
        g_usb_hid.kbd_dev.protocol     = 0x01; /* Klavye protokolü */
        KPRINT("[USB HID] Klavye bağlandı\n");
    }

    if (status & USB_STATUS_MOUSE_CONN) {
        g_usb_hid.mouse_dev.connected    = 1;
        g_usb_hid.mouse_dev.vendor_class = 0x03;
        g_usb_hid.mouse_dev.protocol     = 0x02; /* Mouse protokolü */
        KPRINT("[USB HID] Mouse bağlandı\n");
    }
}

/* ═══════════════════════════════════════════════════════════════
 * USB HID RESET
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_reset(void)
{
    usb_port_write(USB_PORT_CTRL, USB_CTRL_RESET);
    kmemset(&g_usb_hid.kbd,   0, sizeof(g_usb_hid.kbd));
    kmemset(&g_usb_hid.mouse, 0, sizeof(g_usb_hid.mouse));
    g_usb_hid.controller_ready = 0;
    /* Yeniden başlat */
    usb_hid_init();
}

/* ═══════════════════════════════════════════════════════════════
 * KBD RAPOR İŞLEYİCİ
 * HID Klavye Raporu: [mod, 0, k0, k1, k2, k3, k4, k5]
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_process_kbd(const uint8_t report[8])
{
    UsbKbdState *k = &g_usb_hid.kbd;
    uint8_t mod    = report[0];
    int     i;

    k->modifier = mod;

    /* CapsLock toggle: önceki karedde basılı değildi, şimdi var */
    if (key_is_pressed(&report[2], HID_KEY_CAPSLOCK) &&
        !key_was_pressed(k->prev_keys, HID_KEY_CAPSLOCK)) {
        k->capslock ^= 1u;
    }

    /* Yeni basılan tuşları bul ve karakter üret */
    for (i = 0; i < 6; i++) {
        uint8_t code = report[2 + i];
        if (code == HID_KEY_NONE) continue;
        if (code == HID_KEY_CAPSLOCK) continue;

        if (!key_was_pressed(k->prev_keys, code)) {
            /* Yeni basım */
            char ch = 0;

            if (mod & HID_MOD_CTRL) {
                ch = ctrl_combo(code);
            } else {
                ch = keycode_to_ascii(code, mod, k->capslock);
            }

            if (ch) keyboard_feed(ch);

            /* Key-repeat için kaydet */
            k->repeat_key   = code;
            k->repeat_timer = KEY_REPEAT_DELAY;
        }
    }

    /* Bırakılan tuş repeat key ise sıfırla */
    if (k->repeat_key && !key_is_pressed(&report[2], (uint8_t)k->repeat_key)) {
        k->repeat_key   = 0;
        k->repeat_timer = 0;
    }

    /* Önceki durumu güncelle */
    kmemcpy(k->prev_keys, &report[2], 6);
}

/* ═══════════════════════════════════════════════════════════════
 * MOUSE RAPOR İŞLEYİCİ
 * HID Mouse Raporu: [buttons, dx, dy, wheel]
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_process_mouse(const uint8_t report[4])
{
    UsbMouseState *m = &g_usb_hid.mouse;
    uint8_t  buttons = report[0];
    int8_t   dx      = (int8_t)report[1];
    int8_t   dy      = (int8_t)report[2];
    int8_t   wheel   = (int8_t)report[3];
    int      btn;

    /* Buton değişimlerini ilet */
    for (btn = 0; btn < 3; btn++) {
        uint8_t cur  = (buttons   >> btn) & 1u;
        uint8_t prev = (m->buttons >> btn) & 1u;
        if (cur != prev)
            mouse_button(btn, (int)cur);
    }
    m->buttons = buttons;

    /* Hareket */
    if (dx || dy) {
        mouse_move((int)dx, (int)dy);
    }

    m->last_dx    = dx;
    m->last_dy    = dy;
    m->last_wheel = wheel;

    /* Scroll wheel — şimdilik kprintf ile bildir; wm.c bağlayabilir */
    if (wheel != 0) {
        /* Pozitif = yukarı, negatif = aşağı */
        (void)wheel; /* wm/ui katmanı dinleyebilir */
    }
}

/* ═══════════════════════════════════════════════════════════════
 * USB HID POLL — Her zamanlayıcı tick'te çağrılır
 * Bekleyen tüm raporları tüketir (bir tick'te birden fazla olabilir)
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_poll(void)
{
    uint8_t  report[8];
    uint64_t hid_type;
    int      i;

    /* Bekleyen tüm raporları işle */
    while (1) {
        hid_type = usb_port_read(USB_PORT_HID_TYPE);
        if (hid_type == USB_HID_NONE) break;

        /* 8 byte raporu oku */
        for (i = 0; i < 8; i++) {
            report[i] = (uint8_t)(usb_port_read((uint32_t)(USB_PORT_DATA0 + i)) & 0xFFu);
        }

        if (hid_type == USB_HID_KBD) {
            if (g_usb_hid.kbd_dev.connected)
                usb_hid_process_kbd(report);
            else
                g_usb_hid.kbd_errors++;
        } else if (hid_type == USB_HID_MOUSE) {
            if (g_usb_hid.mouse_dev.connected)
                usb_hid_process_mouse(report);
            else
                g_usb_hid.mouse_errors++;
        }

        /* Raporu onayla — controller bir sonraki raporu sunabilir */
        usb_port_write(USB_PORT_ACK, 1u);
        g_usb_hid.events_processed++;

        /* Sonsuz döngü koruması: çok fazla rapor biriktiyse çık */
        if (g_usb_hid.events_processed % 64u == 0u) break;
    }
}

/* ═══════════════════════════════════════════════════════════════
 * USB HID TICK — Key-repeat zamanlayıcısı
 * timer_interrupt_handler() içinden çağrılır
 * ═══════════════════════════════════════════════════════════════ */
void usb_hid_tick(void)
{
    UsbKbdState *k = &g_usb_hid.kbd;

    if (k->repeat_key == 0) return;
    if (k->repeat_timer == 0) return;

    k->repeat_timer--;

    if (k->repeat_timer == 0) {
        /* Repeat ateşle */
        char ch = 0;
        if (k->modifier & HID_MOD_CTRL)
            ch = ctrl_combo((uint8_t)k->repeat_key);
        else
            ch = keycode_to_ascii((uint8_t)k->repeat_key,
                                  k->modifier, k->capslock);
        if (ch) keyboard_feed(ch);

        /* Sonraki repeat için kısa aralık */
        k->repeat_timer = KEY_REPEAT_INTERVAL;
    }
}

/* ═══════════════════════════════════════════════════════════════
 * DURUM SORGULAMA YARDIMCILARI
 * ═══════════════════════════════════════════════════════════════ */
int usb_kbd_connected(void)
{
    return (int)g_usb_hid.kbd_dev.connected;
}

int usb_mouse_connected(void)
{
    return (int)g_usb_hid.mouse_dev.connected;
}

uint8_t usb_kbd_modifier(void)
{
    return g_usb_hid.kbd.modifier;
}

int usb_kbd_key_pressed(uint8_t keycode)
{
    return key_is_pressed(g_usb_hid.kbd.keys, keycode);
}

uint8_t usb_mouse_buttons(void)
{
    return g_usb_hid.mouse.buttons;
}
