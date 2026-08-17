#ifndef USB_HID_H
#define USB_HID_H

/*
 * HILAL_BIS — USB HID Sürücüsü
 * Oxalyn-64 Mimarisi İçin
 *
 * Bellek-eşlemeli I/O port haritası (0x30-0x3F arası):
 *
 *  0x30  USB_STATUS   (R)  bit0=hazır, bit1=kbd bağlı, bit2=mouse bağlı
 *  0x31  USB_HID_TYPE (R)  bekleyen rapor tipi: 0=yok,1=kbd,2=mouse
 *  0x32  USB_DATA0    (R)  rapor byte 0
 *  0x33  USB_DATA1    (R)  rapor byte 1
 *  0x34  USB_DATA2    (R)  rapor byte 2
 *  0x35  USB_DATA3    (R)  rapor byte 3
 *  0x36  USB_DATA4    (R)  rapor byte 4
 *  0x37  USB_DATA5    (R)  rapor byte 5
 *  0x38  USB_DATA6    (R)  rapor byte 6
 *  0x39  USB_DATA7    (R)  rapor byte 7
 *  0x3A  USB_ACK      (W)  herhangi bir değer yaz → raporu onayla
 *  0x3B  USB_CTRL     (W)  bit0=etkinleştir, bit1=sıfırla
 *
 * HID Klavye Raporu (8 byte):
 *   [0] modifier  (Shift/Ctrl/Alt/Meta bitleri)
 *   [1] reserved  (0)
 *   [2-7] keycode (eş zamanlı en fazla 6 tuş)
 *
 * HID Mouse Raporu (4 byte):
 *   [0] buttons   (bit0=sol, bit1=sağ, bit2=orta)
 *   [1] X delta   (işaretli)
 *   [2] Y delta   (işaretli)
 *   [3] wheel     (işaretli)
 */

#include <stdint.h>

/* ── Port Adresleri ─────────────────────────────────────────── */
#define USB_PORT_STATUS   0x30u
#define USB_PORT_HID_TYPE 0x31u
#define USB_PORT_DATA0    0x32u
#define USB_PORT_ACK      0x3Au
#define USB_PORT_CTRL     0x3Bu

/* ── Durum Bitleri ──────────────────────────────────────────── */
#define USB_STATUS_READY        (1u << 0)
#define USB_STATUS_KBD_CONN     (1u << 1)
#define USB_STATUS_MOUSE_CONN   (1u << 2)

/* ── HID Rapor Tipleri ──────────────────────────────────────── */
#define USB_HID_NONE    0u
#define USB_HID_KBD     1u
#define USB_HID_MOUSE   2u

/* ── Kontrol Bitleri ────────────────────────────────────────── */
#define USB_CTRL_ENABLE (1u << 0)
#define USB_CTRL_RESET  (1u << 1)

/* ── Modifier Bitleri (HID Kbd raporu byte 0) ───────────────── */
#define HID_MOD_LCTRL   (1u << 0)
#define HID_MOD_LSHIFT  (1u << 1)
#define HID_MOD_LALT    (1u << 2)
#define HID_MOD_LMETA   (1u << 3)
#define HID_MOD_RCTRL   (1u << 4)
#define HID_MOD_RSHIFT  (1u << 5)
#define HID_MOD_RALT    (1u << 6)
#define HID_MOD_RMETA   (1u << 7)
#define HID_MOD_SHIFT   (HID_MOD_LSHIFT | HID_MOD_RSHIFT)
#define HID_MOD_CTRL    (HID_MOD_LCTRL  | HID_MOD_RCTRL)
#define HID_MOD_ALT     (HID_MOD_LALT   | HID_MOD_RALT)

/* ── HID Keycodes (USB HID Usage Table 0x07) ────────────────── */
#define HID_KEY_NONE        0x00u
#define HID_KEY_A           0x04u
#define HID_KEY_Z           0x1Du
#define HID_KEY_1           0x1Eu
#define HID_KEY_0           0x27u
#define HID_KEY_ENTER       0x28u
#define HID_KEY_ESC         0x29u
#define HID_KEY_BACKSPACE   0x2Au
#define HID_KEY_TAB         0x2Bu
#define HID_KEY_SPACE       0x2Cu
#define HID_KEY_MINUS       0x2Du
#define HID_KEY_EQUAL       0x2Eu
#define HID_KEY_LBRACKET    0x2Fu
#define HID_KEY_RBRACKET    0x30u
#define HID_KEY_BACKSLASH   0x31u
#define HID_KEY_SEMICOLON   0x33u
#define HID_KEY_APOSTROPHE  0x34u
#define HID_KEY_GRAVE       0x35u
#define HID_KEY_COMMA       0x36u
#define HID_KEY_DOT         0x37u
#define HID_KEY_SLASH       0x38u
#define HID_KEY_CAPSLOCK    0x39u
#define HID_KEY_F1          0x3Au
#define HID_KEY_F2          0x3Bu
#define HID_KEY_F3          0x3Cu
#define HID_KEY_F4          0x3Du
#define HID_KEY_F5          0x3Eu
#define HID_KEY_F6          0x3Fu
#define HID_KEY_F7          0x40u
#define HID_KEY_F8          0x41u
#define HID_KEY_F9          0x42u
#define HID_KEY_F10         0x43u
#define HID_KEY_F11         0x44u
#define HID_KEY_F12         0x45u
#define HID_KEY_INSERT      0x49u
#define HID_KEY_HOME        0x4Au
#define HID_KEY_PAGEUP      0x4Bu
#define HID_KEY_DELETE      0x4Cu
#define HID_KEY_END         0x4Du
#define HID_KEY_PAGEDOWN    0x4Eu
#define HID_KEY_RIGHT       0x4Fu
#define HID_KEY_LEFT        0x50u
#define HID_KEY_DOWN        0x51u
#define HID_KEY_UP          0x52u

/* ── USB HID Aygıt Bilgisi ──────────────────────────────────── */
typedef struct {
    uint8_t connected;          /* 1 = bağlı */
    uint8_t vendor_class;       /* HID sınıfı */
    uint8_t protocol;           /* 1=kbd, 2=mouse */
    uint8_t reserved;
} UsbHidDevice;

/* ── Klavye Durumu ──────────────────────────────────────────── */
typedef struct {
    uint8_t  modifier;          /* Aktif modifier bitleri */
    uint8_t  keys[6];           /* Basılı tuşlar (HID keycode) */
    uint8_t  prev_keys[6];      /* Önceki karedeki tuşlar (repeat için) */
    uint8_t  capslock;          /* CapsLock durum toggle */
    uint32_t repeat_timer;      /* Tekrar gecikmesi sayacı (tick) */
    uint32_t repeat_key;        /* Tekrar eden tuş */
} UsbKbdState;

/* ── Mouse Durumu ───────────────────────────────────────────── */
typedef struct {
    uint8_t buttons;            /* Aktif buton bitleri */
    int8_t  last_dx;
    int8_t  last_dy;
    int8_t  last_wheel;
} UsbMouseState;

/* ── Genel Durum ────────────────────────────────────────────── */
typedef struct {
    uint8_t       controller_ready;
    UsbHidDevice  kbd_dev;
    UsbHidDevice  mouse_dev;
    UsbKbdState   kbd;
    UsbMouseState mouse;
    uint32_t      events_processed;  /* istatistik */
    uint32_t      kbd_errors;
    uint32_t      mouse_errors;
} UsbHidState;

extern UsbHidState g_usb_hid;

/* ── Genel API ──────────────────────────────────────────────── */
void    usb_hid_init(void);
void    usb_hid_poll(void);         /* Her timer tick'te çağrılır */
void    usb_hid_reset(void);

/* Dahili rapor işleyiciler */
void    usb_hid_process_kbd(const uint8_t report[8]);
void    usb_hid_process_mouse(const uint8_t report[4]);

/* Durumu sorgulayan yardımcılar */
int     usb_kbd_connected(void);
int     usb_mouse_connected(void);
uint8_t usb_kbd_modifier(void);
int     usb_kbd_key_pressed(uint8_t keycode);
uint8_t usb_mouse_buttons(void);

/* Key repeat zamanlayıcı (kernel timer_interrupt_handler'dan çağrılır) */
void    usb_hid_tick(void);

#endif /* USB_HID_H */
