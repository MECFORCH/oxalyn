/*
 * HILAL_BIS — VFS Kalıcı Depolama Katmanı
 *
 * VFS dizin ağacını ve tüm dosya içeriklerini düz ikili formata
 * seri hale getirir; EEPROM dosyasına kaydeder ve yeniden yükler.
 *
 * Format:
 *   [4 bayt] sihirli sayı: 0x4F584653 ("OXFS")
 *   [4 bayt] sürüm: 1
 *   [4 bayt] node sayısı
 *   [4 bayt] dosya sayısı
 *   [node_count × sizeof(VfsPersistNode)]   — dizin/dosya meta verisi
 *   [file_count × sizeof(VfsPersistFile)]   — dosya içerikleri
 */

#ifndef VFS_PERSIST_H
#define VFS_PERSIST_H

#include <stdint.h>
#include "vfs.h"
#include "filesystem.h"

/* ── Dosya başlığı ─────────────────────────────────────── */
#define VFS_PERSIST_MAGIC   0x4F584653u   /* "OXFS" */
#define VFS_PERSIST_VERSION 1u

/* Varsayılan EEPROM yolu (simülatörde -e bayrağı geçirilmezse) */
#define VFS_EEPROM_PATH "oxalyn_vfs.bin"

/* ── Seri hale getirilmiş node kaydı ──────────────────── */
typedef struct {
    int32_t  id;
    int32_t  parent_id;
    uint8_t  type;          /* VFS_TYPE_DIR veya VFS_TYPE_FILE */
    uint32_t owner_uid;
    char     name[VFS_NAME_LEN];
    char     fs_key[VFS_NAME_LEN]; /* filesystem'deki anahtar (dosya ise) */
} VfsPersistNode;

/* ── Seri hale getirilmiş dosya içeriği ───────────────── */
typedef struct {
    char     fs_key[VFS_NAME_LEN];
    int32_t  owner_uid;
    int32_t  size;
    char     data[MAX_FILE_SIZE];
} VfsPersistFile;

/* ── API ───────────────────────────────────────────────── */

/*
 * vfs_persist_save — VFS durumunu diske yaz.
 * path: hedef dosya yolu (NULL → VFS_EEPROM_PATH)
 * Döndürür: 0=başarı, -1=hata
 */
int vfs_persist_save(const char *path);

/*
 * vfs_persist_load — Daha önce kaydedilmiş VFS durumunu yükle.
 * path: kaynak dosya yolu (NULL → VFS_EEPROM_PATH)
 * Döndürür: 0=başarı, -1=dosya yok veya bozuk
 *
 * Yükleme başarılıysa mevcut VFS durumunu tamamen değiştirir.
 * Başarısız olursa VFS değişmeden kalır.
 */
int vfs_persist_load(const char *path);

/*
 * vfs_persist_auto_load — Başlangıçta çağır.
 * Dosya varsa yükler, yoksa sessizce geçer.
 */
void vfs_persist_auto_load(const char *path);

/*
 * vfs_persist_info — Kaydedilmiş snapshot meta verisini UART'a yazar.
 */
void vfs_persist_info(const char *path);

#endif /* VFS_PERSIST_H */
