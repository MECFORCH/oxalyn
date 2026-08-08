/*
 * HILAL_BIS — IPC: Boru Hatları + Mesaj Kuyrukları
 */

#include "ipc.h"
#include "kstring.h"
#include "platform.h"

/* ── Boru hatları ─────────────────────────────────────────── */
static Pipe pipes[MAX_PIPES];

/* Boru hattı FD kodlaması: read_fd = pipe_id * 2, write_fd = pipe_id*2+1 */
#define FD_TO_PIPE(fd)  ((fd) >> 1)
#define FD_IS_READ(fd)  (((fd) & 1) == 0)
#define FD_IS_WRITE(fd) (((fd) & 1) == 1)
#define PIPE_BASE_FD    32          /* 0-31 normal dosya FD'leri */

/* ── Mesaj kuyrukları ─────────────────────────────────────── */
static MsgQueue queues[MAX_QUEUES];

/* ================================================================ */
void ipc_init(void)
{
    int i;
    for (i = 0; i < MAX_PIPES;  i++) pipes[i].used  = 0;
    for (i = 0; i < MAX_QUEUES; i++) queues[i].used = 0;
    KPRINT("[IPC] Basladi (%d boru, %d kuyruk)\n", MAX_PIPES, MAX_QUEUES);
}

/* ════════════════════════════════════════════════════════════
 * BORU HATTI
 * ════════════════════════════════════════════════════════════ */

int pipe_create(uint32_t reader_pid, uint32_t writer_pid,
                int *read_fd, int *write_fd)
{
    int i;
    for (i = 0; i < MAX_PIPES; i++) {
        if (!pipes[i].used) {
            pipes[i].head       = 0;
            pipes[i].tail       = 0;
            pipes[i].used       = 1;
            pipes[i].reader_pid = reader_pid;
            pipes[i].writer_pid = writer_pid;
            kmemset(pipes[i].buf, 0, PIPE_BUF_SIZE);

            *read_fd  = PIPE_BASE_FD + i * 2;
            *write_fd = PIPE_BASE_FD + i * 2 + 1;
            return i;
        }
    }
    return -1;   /* boru yok */
}

/* ------------------------------------------------------------------ */
int pipe_write(int write_fd, const char *data, int len)
{
    int pid  = FD_TO_PIPE(write_fd - PIPE_BASE_FD);
    int written = 0;
    Pipe *p;

    if (pid < 0 || pid >= MAX_PIPES) return -1;
    if (!FD_IS_WRITE(write_fd - PIPE_BASE_FD)) return -1;

    p = &pipes[pid];
    if (!p->used) return -1;

    while (written < len) {
        int next = (p->head + 1) % PIPE_BUF_SIZE;
        if (next == p->tail) break;    /* tampon dolu */
        p->buf[p->head] = data[written++];
        p->head = next;
    }
    return written;
}

/* ------------------------------------------------------------------ */
int pipe_read(int read_fd, char *buf, int maxlen)
{
    int pid = FD_TO_PIPE(read_fd - PIPE_BASE_FD);
    int rd  = 0;
    Pipe *p;

    if (pid < 0 || pid >= MAX_PIPES) return -1;
    if (!FD_IS_READ(read_fd - PIPE_BASE_FD)) return -1;

    p = &pipes[pid];
    if (!p->used) return -1;

    while (rd < maxlen && p->tail != p->head) {
        buf[rd++] = p->buf[p->tail];
        p->tail   = (p->tail + 1) % PIPE_BUF_SIZE;
    }
    return rd;
}

/* ------------------------------------------------------------------ */
void pipe_close(int fd)
{
    int pid = FD_TO_PIPE(fd - PIPE_BASE_FD);
    if (pid < 0 || pid >= MAX_PIPES) return;
    /* Her iki uç kapatıldığında serbest bırak — basit: hemen serbest */
    pipes[pid].used = 0;
}

/* ------------------------------------------------------------------ */
int pipe_available(int read_fd)
{
    int pid = FD_TO_PIPE(read_fd - PIPE_BASE_FD);
    Pipe *p;

    if (pid < 0 || pid >= MAX_PIPES) return 0;
    p = &pipes[pid];
    if (!p->used) return 0;
    return (p->head - p->tail + PIPE_BUF_SIZE) % PIPE_BUF_SIZE;
}

/* ════════════════════════════════════════════════════════════
 * MESAJ KUYRUĞU
 * ════════════════════════════════════════════════════════════ */

int mq_create(const char *name)
{
    int i;
    for (i = 0; i < MAX_QUEUES; i++) {
        if (!queues[i].used) {
            queues[i].used  = 1;
            queues[i].head  = 0;
            queues[i].tail  = 0;
            queues[i].count = 0;
            kstrncpy(queues[i].name, name, sizeof(queues[i].name));
            return i;
        }
    }
    return -1;
}

/* ------------------------------------------------------------------ */
int mq_open(const char *name)
{
    int i;
    for (i = 0; i < MAX_QUEUES; i++) {
        if (queues[i].used && kstrcmp(queues[i].name, name) == 0)
            return i;
    }
    return -1;
}

/* ------------------------------------------------------------------ */
int mq_send(int mqid, uint32_t sender_pid, const char *data, int len)
{
    MsgQueue  *q;
    IpcMessage *m;

    if (mqid < 0 || mqid >= MAX_QUEUES) return -1;
    q = &queues[mqid];
    if (!q->used) return -1;
    if (q->count >= MAX_MSGS) return -1;      /* kuyruk dolu */

    if (len > MSG_MAX_SIZE) len = MSG_MAX_SIZE;

    m = &q->msgs[q->head];
    kmemcpy(m->data, data, (size_t)len);
    m->len        = len;
    m->sender_pid = sender_pid;

    q->head  = (q->head + 1) % MAX_MSGS;
    q->count++;
    return 0;
}

/* ------------------------------------------------------------------ */
int mq_recv(int mqid, IpcMessage *out)
{
    MsgQueue *q;

    if (mqid < 0 || mqid >= MAX_QUEUES) return -1;
    q = &queues[mqid];
    if (!q->used || q->count == 0) return 0;

    *out     = q->msgs[q->tail];
    q->tail  = (q->tail + 1) % MAX_MSGS;
    q->count--;
    return out->len;
}

/* ------------------------------------------------------------------ */
int mq_count(int mqid)
{
    if (mqid < 0 || mqid >= MAX_QUEUES) return 0;
    return queues[mqid].count;
}

/* ------------------------------------------------------------------ */
void mq_destroy(int mqid)
{
    if (mqid < 0 || mqid >= MAX_QUEUES) return;
    queues[mqid].used  = 0;
    queues[mqid].count = 0;
}
