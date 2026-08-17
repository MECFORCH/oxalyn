#ifndef IPC_H
#define IPC_H

/*
 * HILAL_BIS — IPC: Boru Hatları + Mesaj Kuyrukları
 *
 * Boru hattı (pipe): çift yönlü halka tamponu, iki proses arasında.
 * Mesaj kuyruğu (mq): sabit boyutlu mesaj slotları, isimle erişilir.
 */

#include <stdint.h>
#include <stddef.h>

/* ── Boru Hattı ─────────────────────────────────────────── */
#define MAX_PIPES       8
#define PIPE_BUF_SIZE   256

typedef struct {
    char     buf[PIPE_BUF_SIZE];
    int      head, tail;
    int      used;           /* 1=aktif */
    uint32_t reader_pid;
    uint32_t writer_pid;
} Pipe;

/* Yeni boru hattı oluştur.
 * Başarıda: read_fd ve write_fd set edilir, pipe ID (>=0) döner.
 * Hata: -1 */
int  pipe_create(uint32_t reader_pid, uint32_t writer_pid,
                 int *read_fd, int *write_fd);

/* Boru hattına yaz (write_fd ile).  Döner: yazılan byte sayısı, -1=hata */
int  pipe_write(int write_fd, const char *data, int len);

/* Boru hattından oku (read_fd ile).  Non-blocking: 0 byte okunabilir.
 * Döner: okunan byte sayısı, -1=hata */
int  pipe_read(int read_fd, char *buf, int maxlen);

/* Boruyu kapat (her iki uç kapatılınca tampon serbest bırakılır) */
void pipe_close(int fd);

/* Boruda okunmayı bekleyen byte sayısı */
int  pipe_available(int read_fd);

/* ── Mesaj Kuyruğu ──────────────────────────────────────── */
#define MAX_QUEUES   8
#define MAX_MSGS     16
#define MSG_MAX_SIZE 64

typedef struct {
    char data[MSG_MAX_SIZE];
    int  len;
    uint32_t sender_pid;
} IpcMessage;

typedef struct {
    char       name[16];
    IpcMessage msgs[MAX_MSGS];
    int        head, tail, count;
    int        used;
} MsgQueue;

/* İsimli kuyruk oluştur. Döner: kuyruk ID (>=0) veya -1 */
int  mq_create(const char *name);

/* İsme göre var olan kuyruğu bul. Döner: ID veya -1 */
int  mq_open(const char *name);

/* Kuyruğa mesaj gönder. Döner: 0=tamam, -1=dolu/hata */
int  mq_send(int mqid, uint32_t sender_pid,
             const char *data, int len);

/* Kuyruktan mesaj al (FIFO).  Döner: mesaj boyutu, 0=boş, -1=hata */
int  mq_recv(int mqid, IpcMessage *out);

/* Kuyruktaki mesaj sayısı */
int  mq_count(int mqid);

/* Kuyruğu sil */
void mq_destroy(int mqid);

/* Tüm IPC yapılarını başlat */
void ipc_init(void);

#endif /* IPC_H */
