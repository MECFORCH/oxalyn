#include "kernel.h"
#include "input.h"

typedef struct {
    char buffer[KEY_BUFFER_SIZE];
    int  head, tail;
} KeyBuffer;

static KeyBuffer key_buf;

/* ------------------------------------------------------------------ */
void keyboard_init(void)
{
    key_buf.head = 0;
    key_buf.tail = 0;
}

/* ------------------------------------------------------------------ */
void keyboard_feed(char c)
{
    int next = (key_buf.head + 1) % KEY_BUFFER_SIZE;
    if (next != key_buf.tail) {          /* drop char if buffer is full */
        key_buf.buffer[key_buf.head] = c;
        key_buf.head = next;
    }
}

/* ------------------------------------------------------------------ */
/* US QWERTY scancode -> ASCII table (Set-1 style, unshifted only).
 * Provided for a future real keyboard controller; not driven by
 * hardware IRQs yet (Oxalyn-64 has no keyboard interrupt line today). */
char scancode_to_ascii(uint8_t code)
{
    static const char keymap[] = {
        0,  27, '1','2','3','4','5','6','7','8','9','0','-','=','\b','\t',
        'q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
        'a','s','d','f','g','h','j','k','l',';','\'','`', 0, '\\',
        'z','x','c','v','b','n','m',',','.','/', 0, '*', 0, ' '
    };
    if ((size_t)code < sizeof(keymap)) return keymap[code];
    return 0;
}

/* ------------------------------------------------------------------ */
void keyboard_irq_handler(uint8_t scancode)
{
    char ch = scancode_to_ascii(scancode);
    if (ch) keyboard_feed(ch);
}

/* ------------------------------------------------------------------ */
int keyboard_has_key(void)
{
    return key_buf.head != key_buf.tail;
}

/* ------------------------------------------------------------------ */
char keyboard_getkey(void)
{
    char ch;
    while (key_buf.head == key_buf.tail) {
        keyboard_poll();          /* pull from UART until something arrives */
    }
    ch = key_buf.buffer[key_buf.tail];
    key_buf.tail = (key_buf.tail + 1) % KEY_BUFFER_SIZE;
    return ch;
}

/* ------------------------------------------------------------------ */
/* Bridges the current polling UART (see uart.c) into the ring buffer.
 * On real hardware this call would be replaced by keyboard_irq_handler()
 * fired from an interrupt; today shell.c and apps read through here. */
void keyboard_poll(void)
{
    char c = (char)KGETCHAR();
    if (c) keyboard_feed(c);
}
