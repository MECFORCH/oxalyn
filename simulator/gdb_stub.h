/*
 * gdb_stub.h — Oxalyn-64 GDB Remote Serial Protocol (RSP) Stub
 *
 * sim --gdb <port> komutuyla aktif olur.
 * GDB, localhost:<port> üzerinden TCP bağlantısı kurar.
 *
 * Bellek adresleme:
 *   Oxalyn-64: word-addressed (pc ve mem[] 64-bit word indeksleri kullanır)
 *   GDB RSP: byte-addressed
 *   Dönüşüm: gdb_byte_addr = oxalyn_word_addr * 8  (big-endian)
 *            oxalyn_word_addr = gdb_byte_addr / 8
 *   Byte konumu: offset = gdb_byte_addr % 8  (0=MSB, 7=LSB)
 *
 * GDB register haritası (Oxalyn64.xml olmadan temel layout):
 *   Indeks 0-31: R0-R31 (64-bit)
 *   Indeks 32  : PC     (32-bit, word adresi olarak gönderilir)
 *   Indeks 33  : FLAGS  (64-bit)
 */

#ifndef GDB_STUB_H
#define GDB_STUB_H

#include <stdint.h>

/* sim.c'deki CPU durumuna erişim için accessor'lar (sim.c içinde tanımlı) */
uint64_t  oxalyn_reg_get(int idx);
void      oxalyn_reg_set(int idx, uint64_t val);
uint32_t  oxalyn_pc_get(void);
void      oxalyn_pc_set(uint32_t word_addr);
uint64_t  oxalyn_flags_get(void);
void      oxalyn_flags_set(uint64_t f);
uint8_t   oxalyn_halted_get(void);
void      oxalyn_halted_set(uint8_t h);
/* Bellek: byte granülarite, GDB byte adresi ile */
uint8_t   oxalyn_mem_read_byte(uint32_t byte_addr);
void      oxalyn_mem_write_byte(uint32_t byte_addr, uint8_t val);
uint32_t  oxalyn_mem_size_bytes(void);
/* Tek komut çalıştır (pipeline dahil) */
void      oxalyn_step(void);

/* Stub yaşam döngüsü */
int  gdb_stub_init(int tcp_port);   /* -1: hata, 0: OK */
void gdb_stub_run(void);            /* Bağlantı kur, RSP döngüsü çalıştır */

/* Watchpoint kontrolü — sim.c'den her bellek okuma/yazma öncesi çağır.
 * is_write: 1=yazma, 0=okuma
 * Dönüş: 1 → watchpoint tetiklendi (sim durmalı), 0 → devam et */
int  gdb_watchpoint_check(uint32_t byte_addr, uint32_t byte_len, int is_write);

#endif /* GDB_STUB_H */
