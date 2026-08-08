#ifndef SOUND_H
#define SOUND_H

/*
 * HILAL_BIS — Ses Sürücüsü
 * Oxalyn-64 Port Haritası: 0x40-0x4F
 *
 *  0x40  SND_CTRL     (W)  bit0=çal, bit1=dur, bit2=döngü
 *  0x41  SND_FREQ_LO  (W)  frekans alt baytı (Hz)
 *  0x42  SND_FREQ_HI  (W)  frekans üst baytı (Hz)
 *  0x43  SND_DURATION (W)  süre (ms, 0=sonsuza kadar)
 *  0x44  SND_VOLUME   (W)  ses seviyesi (0-255)
 *  0x45  SND_STATUS   (R)  bit0=çalıyor
 */

#include <stdint.h>

#define SND_PORT_CTRL       0x40u
#define SND_PORT_FREQ_LO    0x41u
#define SND_PORT_FREQ_HI    0x42u
#define SND_PORT_DURATION   0x43u
#define SND_PORT_VOLUME     0x44u
#define SND_PORT_STATUS     0x45u

#define SND_CTRL_PLAY   (1u << 0)
#define SND_CTRL_STOP   (1u << 1)
#define SND_CTRL_LOOP   (1u << 2)

/* Standart nota frekansları (Hz, 4. oktav) */
#define NOTE_C4    262u
#define NOTE_D4    294u
#define NOTE_E4    330u
#define NOTE_F4    349u
#define NOTE_G4    392u
#define NOTE_A4    440u
#define NOTE_B4    494u
#define NOTE_C5    523u

/* Sistem ses efektleri */
#define SFX_BOOT   1
#define SFX_ERROR  2
#define SFX_NOTIFY 3
#define SFX_CLICK  4

void sound_init(void);
void sound_beep(uint16_t freq_hz, uint16_t duration_ms);
void sound_stop(void);
int  sound_is_playing(void);
void sound_set_volume(uint8_t vol);   /* 0-255 */

/* Nota çal: octave 1-8 */
void sound_play_note(uint16_t base_freq, int octave, uint16_t duration_ms);

/* Önceden tanımlı efektler */
void sound_sfx(int sfx_id);

/* Basit melodi: freq/duration çiftleri dizisi, son eleman freq=0 */
typedef struct { uint16_t freq; uint16_t dur_ms; } Note;
void sound_play_melody(const Note *melody);

#endif /* SOUND_H */
