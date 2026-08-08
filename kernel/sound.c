/*
 * HILAL_BIS — Ses Sürücüsü
 * Oxalyn-64 bellek-eşlemeli I/O, portlar 0x40-0x45
 */

#include "sound.h"
#include "mmio.h"   /* H3: Host modda düşük adres segfault'unu önler */
#include "platform.h"

static inline void snd_write(uint32_t port, uint64_t val)
{
    mmio_write(port, val);
}

static inline uint64_t snd_read(uint32_t port)
{
    return mmio_read(port);
}

/* ================================================================ */
void sound_init(void)
{
    snd_write(SND_PORT_CTRL,   SND_CTRL_STOP);
    snd_write(SND_PORT_VOLUME, 200u);          /* varsayılan ses seviyesi */
    KPRINT("[SND] Basladi\n");
}

/* ================================================================ */
void sound_beep(uint16_t freq_hz, uint16_t duration_ms)
{
    snd_write(SND_PORT_CTRL,     SND_CTRL_STOP);
    snd_write(SND_PORT_FREQ_LO,  (uint64_t)(freq_hz & 0xFFu));
    snd_write(SND_PORT_FREQ_HI,  (uint64_t)((freq_hz >> 8) & 0xFFu));
    snd_write(SND_PORT_DURATION, (uint64_t)duration_ms);
    snd_write(SND_PORT_CTRL,     SND_CTRL_PLAY);
}

/* ================================================================ */
void sound_stop(void)
{
    snd_write(SND_PORT_CTRL, SND_CTRL_STOP);
}

/* ================================================================ */
int sound_is_playing(void)
{
    return (int)(snd_read(SND_PORT_STATUS) & 1u);
}

/* ================================================================ */
void sound_set_volume(uint8_t vol)
{
    snd_write(SND_PORT_VOLUME, (uint64_t)vol);
}

/* ================================================================ */
/* Basit frekans ölçekleme: her oktav frekansı 2 katlar */
void sound_play_note(uint16_t base_freq, int octave, uint16_t duration_ms)
{
    uint32_t freq = (uint32_t)base_freq;
    int shift;

    if (octave < 1) octave = 1;
    if (octave > 8) octave = 8;

    /* 4. oktav = base_freq; yukarı: <<, aşağı: >> */
    shift = octave - 4;
    if (shift > 0)       freq = freq << shift;
    else if (shift < 0)  freq = freq >> (-shift);

    if (freq > 0xFFFFu) freq = 0xFFFFu;
    if (freq < 20u)     freq = 20u;

    sound_beep((uint16_t)freq, duration_ms);
}

/* ================================================================ */
/* Önceden tanımlı ses efektleri */
void sound_sfx(int sfx_id)
{
    switch (sfx_id) {
    case SFX_BOOT:
        /* Çıkış sesi: do-mi-sol */
        sound_beep(NOTE_C4, 120);
        sound_beep(NOTE_E4, 120);
        sound_beep(NOTE_G4, 200);
        break;
    case SFX_ERROR:
        sound_beep(200, 300);
        break;
    case SFX_NOTIFY:
        sound_beep(NOTE_A4, 80);
        sound_beep(NOTE_C5, 80);
        break;
    case SFX_CLICK:
        sound_beep(800, 30);
        break;
    default:
        break;
    }
}

/* ================================================================ */
/* Melodi çal: {freq, dur_ms} çiftleri, freq==0 ile sonlanır */
void sound_play_melody(const Note *melody)
{
    int i;
    for (i = 0; melody[i].freq != 0; i++) {
        if (melody[i].freq == 1u) {
            /* 1 = sessizlik (rest) */
            sound_stop();
        } else {
            sound_beep(melody[i].freq, melody[i].dur_ms);
        }
        /* Basit gecikme: simülatörde anında geçer, donanımda timer beklenir */
        {
            volatile int d = (int)melody[i].dur_ms * 100;
            while (d-- > 0) { /* busy-wait */ }
        }
    }
    sound_stop();
}
