#ifndef MOUSE_H
#define MOUSE_H

#include <stdint.h>

typedef struct {
    int x, y;
    int buttons;   /* bit0=left, bit1=right, bit2=middle */
    int moved;
    int changed;   /* position or button state changed since last WM tick */
} Mouse;

extern Mouse mouse;

void mouse_init(void);
void mouse_move(int dx, int dy);
void mouse_button(int button, int pressed);
void draw_cursor(void);

#endif /* MOUSE_H */
