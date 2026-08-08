#ifndef INPUT_H
#define INPUT_H

#include <stdint.h>

#define KEY_BUFFER_SIZE 256

void keyboard_init(void);

/* Feed one already-decoded ASCII character into the ring buffer.
 * Called by the UART poll loop (see input.c: keyboard_poll()). */
void keyboard_feed(char c);

/* Feed a raw hardware scancode; converted via scancode_to_ascii()
 * and pushed into the same ring buffer. Ready for a future IRQ-driven
 * keyboard controller — not wired to real hardware yet, since Oxalyn-64
 * has no keyboard IRQ line in the current SPEC. */
void keyboard_irq_handler(uint8_t scancode);
char scancode_to_ascii(uint8_t code);

int  keyboard_has_key(void);   /* non-blocking check       */
char keyboard_getkey(void);    /* blocking pop (uses UART) */

/* Pulls any pending UART byte into the ring buffer without blocking
 * forever; used by apps that need to poll input while doing other work
 * (e.g. the paint app's redraw loop). */
void keyboard_poll(void);

#endif /* INPUT_H */
