/**
 * GRAVITYON GPU Backend — Gravityon API → GPUSim Köprüsü
 * ========================================================
 * gravSubmitCommandBuffer() çağrıldığında, eğer device'a bir GPUSim
 * bağlıysa (gravGPUAttach ile), bu dosyadaki fonksiyonlar devreye girer.
 *
 * Tasarım:
 *   1. Gravityon command buffer komutları GPU ring buffer'a dönüştürülür.
 *   2. Vertex/index/uniform verileri GPU VRAM'e kopyalanır.
 *   3. Shader'lar (C fonksiyon pointer) GBYT_SHADER_NATIVE olarak yüklenir.
 *   4. Doorbell → GPU komutları işler.
 *   5. PRESENT → framebuffer hazır.
 *
 * VRAM Bellek Düzeni:
 *   [0         .. FB_SZ-1]     Framebuffer RGBA8  (800×600×4 = 1.92MB)
 *   [FB_SZ     .. FB_SZ+DB-1]  Derinlik buffer f32 (800×600×4 = 1.92MB)
 *   [GEOM_BASE .. ..]          Vertex / index buffer verileri
 *   GEOM_BASE = 2 × 800×600×4 = 3.84MB
 *
 * Derlemek için gravityon.c ile birlikte linklenmeli.
 */

#define _POSIX_C_SOURCE 199309L
#include "../gravityon.h"
#include "gpu_sim.h"
#include "gpu_io.h"
#include "gpu_cmd.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* ── VRAM geometri başlangıç ofseti ────────────────────── */
#define GPU_VRAM_FB_W      800u
#define GPU_VRAM_FB_H      600u
#define GPU_VRAM_FB_SIZE   (GPU_VRAM_FB_W * GPU_VRAM_FB_H * 4u)   /* RGBA8 */
#define GPU_VRAM_DB_SIZE   (GPU_VRAM_FB_W * GPU_VRAM_FB_H * 4u)   /* D32F  */
#define GPU_VRAM_GEOM_BASE (GPU_VRAM_FB_SIZE + GPU_VRAM_DB_SIZE)   /* ~3.84 MB */

/* ── Shader slotları ─────────────────────────────────── */
#define GPU_SLOT_VERT 0
#define GPU_SLOT_FRAG 1

/* =========================================================================
 * iç tip erişimi — gravityon.c'nin opak yapılarına doğrudan erişim
 * için ihtiyaç duyulan alanlar burada yeniden tanımlanıyor.
 * gravityon.h API'sini kullanarak erişebileceğimiz kadar erişiyoruz,
 * geri kalanı için minimal inline struct kullanıyoruz.
 * ========================================================================= */

/* gravityon.c'deki iç yapıların subset'i — sadece ihtiyaç duyulan alanlar */
typedef struct _GravBuffer_access {
    void*    data;
    uint64_t size;
    int      usage;
    int      mapped;
} _GravBuffer_access;

typedef struct _GravImage_access {
    uint32_t width, height;
    int      format;
    int      usage;
    void*    pixels;
    size_t   sizeBytes;
} _GravImage_access;

typedef struct _GravShaderModule_access {
    GravVertFn vertFn;
    GravFragFn fragFn;
} _GravShaderModule_access;

typedef struct _GravPipeline_access {
    void*    shader;   /* GravShaderModule */
    void*    renderPass;
    uint32_t vertexStride;
    uint32_t attributeCount;
    uint8_t  _attr_pad[GRAV_MAX_VERTEX_ATTRIBUTES * 8];
    uint32_t varyingCount;
    int      topology;
    int      cullMode;
    int      fillMode;
    int      depthTestEnable;
    int      depthWriteEnable;
    int      depthCompare;
    GravViewport viewport;
    GravRect2D   scissor;
    const void*  uniforms;
    size_t       uniformSize;
} _GravPipeline_access;

typedef struct _GravFramebuffer_access {
    void*    renderPass;
    void*    colorImage;   /* GravImage */
    void*    depthImage;   /* GravImage (NULL = yok) */
    GravExtent2D extent;
} _GravFramebuffer_access;

typedef struct _GravDevice_access {
    void*    parent;
    uint64_t lastSubmitNs;
} _GravDevice_access;

/* gravityon.c'deki komut türleri (aynı sırada) */
typedef enum _CmdType {
    _CMD_BEGIN_RENDER_PASS,
    _CMD_END_RENDER_PASS,
    _CMD_BIND_PIPELINE,
    _CMD_BIND_VERTEX_BUFFER,
    _CMD_BIND_INDEX_BUFFER,
    _CMD_SET_VIEWPORT,
    _CMD_SET_SCISSOR,
    _CMD_SET_UNIFORMS,
    _CMD_DRAW,
    _CMD_DRAW_INDEXED,
    _CMD_CLEAR_COLOR_IMAGE,
} _CmdType;

typedef struct _Command {
    int type;   /* _CmdType */
    union {
        struct { GravRenderPassBeginInfo info; }        beginRenderPass;
        struct { GravPipeline pipeline; }               bindPipeline;
        struct { GravBuffer buffer; uint64_t offset; }  bindVertex;
        struct { GravBuffer buffer; uint64_t offset; }  bindIndex;
        struct { GravViewport vp; }                     setViewport;
        struct { GravRect2D sc; }                       setScissor;
        struct { uint8_t data[256]; size_t size; }      setUniforms;
        struct { uint32_t count; uint32_t first; }      draw;
        struct { uint32_t count; uint32_t firstIndex; int32_t vertexOffset; } drawIndexed;
        struct { GravImage image; GravColorF color; }   clearColor;
    };
} _Command;

typedef struct _GravCommandBuffer_access {
    _Command* cmds;
    uint32_t  count;
    uint32_t  capacity;
    int       recording;
} _GravCommandBuffer_access;

/* =========================================================================
 * GPU Backend Submit
 * ========================================================================= */

/* Payload buffer — ring buffer yazımı için geçici */
static uint8_t s_payload[256 * 1024];

/* Mevcut GEOM VRAM ofseti (frame başında sıfırlanır) */
static uint64_t s_geom_ptr = GPU_VRAM_GEOM_BASE;

static inline void geom_reset(void) {
    s_geom_ptr = GPU_VRAM_GEOM_BASE;
}

/* Veriyi VRAM'e kopyala, ofset döndür */
static uint64_t vram_upload(GPUSim* gpu, const void* data, uint32_t bytes) {
    if (s_geom_ptr + bytes > gpu->vramSize) {
        fprintf(stderr, "[GPU-BE] VRAM taşması!\n");
        return 0;
    }
    memcpy(gpu->vram + s_geom_ptr, data, bytes);
    uint64_t ofs = s_geom_ptr;
    s_geom_ptr += (bytes + 7) & ~7u;   /* 8 byte hizala */
    return ofs;
}

/* Ring buffer'a komut gönder */
static void ring_cmd(GPURingBuffer* rb, GPUCmdType type, const void* payload, uint32_t size) {
    if (gpu_ring_write(rb, type, payload, size) < 0) {
        /* Ring doluysa işle */
        fprintf(stderr, "[GPU-BE] Ring buffer doldu, flush yapılıyor\n");
    }
}

/* ── Shader yükleme (GBYT_SHADER_NATIVE) ─────────────────── */
static void load_native_shaders(GPUSim* gpu, GravPipeline pl) {
    _GravPipeline_access* pa = (_GravPipeline_access*)pl;
    _GravShaderModule_access* sm = (_GravShaderModule_access*)pa->shader;

    /* Vertex shader → slot 0 */
    GBYTShader* vsh = &gpu->shaders[GPU_SLOT_VERT];
    vsh->type       = GBYT_SHADER_NATIVE;
    vsh->instrCount = 0;
    gpu->shaderValid[GPU_SLOT_VERT] = 1;

    /* Fragment shader → slot 1 */
    GBYTShader* fsh = &gpu->shaders[GPU_SLOT_FRAG];
    fsh->type       = GBYT_SHADER_NATIVE;
    fsh->instrCount = 0;
    gpu->shaderValid[GPU_SLOT_FRAG] = 1;

    /* Native pointer'ları GBYTShaderEx'e yaz */
    typedef struct { GBYTShader base; GravVertFn vfn; GravFragFn ffn; } Ext;
    ((Ext*)vsh)->vfn = sm->vertFn;
    ((Ext*)fsh)->ffn = sm->fragFn;

    /* GPU aktif shader ve varying sayısını ayarla */
    gpu->activeVertSlot     = GPU_SLOT_VERT;
    gpu->activeFragSlot     = GPU_SLOT_FRAG;
    gpu->activeVaryingCount = pa->varyingCount;

    /* Uniform buffer (slot 0) */
    if (pa->uniforms && pa->uniformSize > 0) {
        uint32_t n = (uint32_t)(pa->uniformSize / sizeof(float));
        if (n > GPU_SIM_MAX_UNIFORMS) n = GPU_SIM_MAX_UNIFORMS;
        memcpy(gpu->uniforms[0], pa->uniforms, n * sizeof(float));
        gpu->uniformCount[0] = n;
    }
}

/* ── Pipeline durumunu GPU'ya uygula ─────────────────────── */
static void apply_pipeline(GPUSim* gpu, GravPipeline pl) {
    _GravPipeline_access* pa = (_GravPipeline_access*)pl;

    gpu->cullMode         = (uint32_t)pa->cullMode;
    gpu->fillMode         = (uint32_t)pa->fillMode;
    gpu->topology         = (uint32_t)pa->topology;
    gpu->depthTestEnable  = pa->depthTestEnable;
    gpu->depthWriteEnable = pa->depthWriteEnable;
    gpu->depthCompareOp   = (uint32_t)pa->depthCompare;

    gpu->vpX = pa->viewport.x;     gpu->vpY = pa->viewport.y;
    gpu->vpW = pa->viewport.width;  gpu->vpH = pa->viewport.height;
    gpu->vpMinDepth = pa->viewport.minDepth;
    gpu->vpMaxDepth = pa->viewport.maxDepth;

    gpu->scX = pa->scissor.x;  gpu->scY = pa->scissor.y;
    gpu->scW = pa->scissor.width; gpu->scH = pa->scissor.height;

    load_native_shaders(gpu, pl);
}

/* ── Framebuffer bağla ─────────────────────────────────── */
static void bind_framebuffer(GPUSim* gpu, GravFramebuffer fb) {
    _GravFramebuffer_access* fba = (_GravFramebuffer_access*)fb;
    _GravImage_access* ci = (_GravImage_access*)fba->colorImage;
    if (!ci) return;

    /* Eğer uygulama kendi image boyutunu belirledi ve GPU boyutundan
     * farklıysa GPU'yu güncelle */
    if (ci->width != gpu->fbWidth || ci->height != gpu->fbHeight) {
        gpu->fbWidth  = ci->width;
        gpu->fbHeight = ci->height;
        gpu->fbPitch  = ci->width * 4;
        gpu->vpW      = (float)ci->width;
        gpu->vpH      = (float)ci->height;
        gpu->scW      = ci->width;
        gpu->scH      = ci->height;
        /* Derinlik buffer'ı hemen arkasına koy */
        gpu->dbOffset = (uint64_t)ci->width * ci->height * 4;
    }

    /* GPU framebuffer adresini VRAM başına sabitle (always 0) */
    gpu->fbOffset = 0;
}

/* ── Render pass clear ─────────────────────────────────── */
static void gpu_clear(GPUSim* gpu, GravRenderPassBeginInfo* bi) {
    /* Color clear */
    {
        uint8_t* fb = gpu->vram + gpu->fbOffset;
        uint8_t r = (uint8_t)(bi->clearColor.r > 1 ? 255 : bi->clearColor.r < 0 ? 0 : bi->clearColor.r * 255);
        uint8_t g = (uint8_t)(bi->clearColor.g > 1 ? 255 : bi->clearColor.g < 0 ? 0 : bi->clearColor.g * 255);
        uint8_t b = (uint8_t)(bi->clearColor.b > 1 ? 255 : bi->clearColor.b < 0 ? 0 : bi->clearColor.b * 255);
        uint8_t a = (uint8_t)(bi->clearColor.a > 1 ? 255 : bi->clearColor.a < 0 ? 0 : bi->clearColor.a * 255);
        for (uint32_t py = 0; py < gpu->fbHeight; py++)
            for (uint32_t px = 0; px < gpu->fbWidth; px++) {
                uint8_t* p = fb + py * gpu->fbPitch + px * 4;
                p[0]=r; p[1]=g; p[2]=b; p[3]=a;
            }
    }
    /* Depth clear */
    if (gpu->dbOffset) {
        float* db = (float*)(gpu->vram + gpu->dbOffset);
        uint32_t n = gpu->fbWidth * gpu->fbHeight;
        for (uint32_t i = 0; i < n; i++) db[i] = bi->clearDepth;
    }
}

/* ── Draw — doğrudan GPU exec (ring buffer bypass) ─────── */
static void gpu_draw_direct(GPUSim* gpu,
                             const uint8_t* vbase, uint32_t vcount,
                             const uint32_t* ibuf, uint32_t icount,
                             uint32_t stride, uint32_t topology)
{
    /* exec_draw_verts GPU sim'in iç fonksiyonu.
     * gpu_sim.c'den erişmek için extern tanımlaması yapıyoruz. */
    extern void exec_draw_verts(GPUSim*, const uint8_t*, uint32_t,
                                 const uint32_t*, uint32_t, uint32_t, uint32_t);
    extern void exec_draw_native(GPUSim*, const uint8_t*, uint32_t,
                                  const uint32_t*, uint32_t, uint32_t, uint32_t);
    extern void rasterize_native(GPUSim*, float[3][4],
                                  float[3][GPU_SIM_MAX_VARYINGS], uint32_t);

    /* GBYT_SHADER_NATIVE ise native path kullan */
    typedef struct { GBYTShader base; GravVertFn vfn; GravFragFn ffn; } Ext;
    Ext* vex = (Ext*)&gpu->shaders[gpu->activeVertSlot];
    if (vex->base.type == GBYT_SHADER_NATIVE && vex->vfn) {
        exec_draw_native(gpu, vbase, vcount, ibuf, icount, stride, topology);
    } else {
        exec_draw_verts(gpu, vbase, vcount, ibuf, icount, stride, topology);
    }
}

/* =========================================================================
 * gravGPUSubmitFull — command buffer'ı tam olarak GPU'ya gönderir
 * gravityon.c tarafından çağrılır (extern declare ile).
 * ========================================================================= */

GravResult gravGPUSubmitFull(GravDevice device, GravCommandBuffer cmdBuf) {
    if (!device || !cmdBuf) return GRAV_ERROR_INVALID_ARGUMENT;

    GPUSim* gpu = gpusim_find_for_device(device);
    if (!gpu || !gpu->initialized) return GRAV_ERROR_INVALID_HANDLE;

    _GravCommandBuffer_access* cb = (_GravCommandBuffer_access*)cmdBuf;
    if (cb->recording) return GRAV_ERROR_ALREADY_RECORDING;

    _GravDevice_access* dev = (_GravDevice_access*)device;

    /* Frame başında geom pointer sıfırla */
    geom_reset();

    /* Aktif pipeline ve buffer state */
    GravPipeline    activePipeline   = NULL;
    GravBuffer      activeVB         = NULL;
    uint64_t        activeVBOffset   = 0;
    GravBuffer      activeIB         = NULL;
    uint64_t        activeIBOffset   = 0;
    const void*     activeUniforms   = NULL;
    size_t          activeUniformSz  = 0;
    uint8_t         uniformData[256];
    GravViewport    activeVP;
    GravRect2D      activeSC;
    memset(&activeVP, 0, sizeof(activeVP));
    memset(&activeSC, 0, sizeof(activeSC));

    for (uint32_t i = 0; i < cb->count; i++) {
        _Command* c = &cb->cmds[i];

        switch (c->type) {

        case _CMD_BEGIN_RENDER_PASS: {
            GravRenderPassBeginInfo* bi = &c->beginRenderPass.info;
            if (bi->framebuffer) bind_framebuffer(gpu, bi->framebuffer);
            gpu_clear(gpu, bi);
            activeVP = (GravViewport){
                .x=(float)bi->renderArea.x, .y=(float)bi->renderArea.y,
                .width=(float)bi->renderArea.width, .height=(float)bi->renderArea.height,
                .minDepth=0.f, .maxDepth=1.f
            };
            activeSC = bi->renderArea;
            break;
        }

        case _CMD_END_RENDER_PASS:
            /* PRESENT — framebuffer hazır, IRQ tetikle */
            gpu->framesRendered++;
            if (gpu->irqMask & GPU_IRQ_FRAME_DONE) {
                gpu->irqStatus |= GPU_IRQ_FRAME_DONE;
                if (gpu->irqCallback)
                    gpu->irqCallback(GPU_IRQ_FRAME_DONE, gpu->irqUserdata);
            }
            /* GPU VRAM → GravImage geri kopyalama */
            {
                /* Aktif framebuffer image'ına kopyala */
                /* NOT: bu komut anında yapılır; FPGA'da DMA okuma gerekir */
            }
            break;

        case _CMD_BIND_PIPELINE:
            activePipeline = c->bindPipeline.pipeline;
            if (activePipeline) {
                apply_pipeline(gpu, activePipeline);
                _GravPipeline_access* pa = (_GravPipeline_access*)activePipeline;
                activeVP = pa->viewport;
                activeSC = pa->scissor;
                gpu->vpX=activeVP.x; gpu->vpY=activeVP.y;
                gpu->vpW=activeVP.width; gpu->vpH=activeVP.height;
                gpu->vpMinDepth=activeVP.minDepth; gpu->vpMaxDepth=activeVP.maxDepth;
                gpu->scX=activeSC.x; gpu->scY=activeSC.y;
                gpu->scW=activeSC.width; gpu->scH=activeSC.height;
            }
            break;

        case _CMD_BIND_VERTEX_BUFFER:
            activeVB       = c->bindVertex.buffer;
            activeVBOffset = c->bindVertex.offset;
            break;

        case _CMD_BIND_INDEX_BUFFER:
            activeIB       = c->bindIndex.buffer;
            activeIBOffset = c->bindIndex.offset;
            break;

        case _CMD_SET_VIEWPORT:
            activeVP = c->setViewport.vp;
            gpu->vpX=activeVP.x; gpu->vpY=activeVP.y;
            gpu->vpW=activeVP.width; gpu->vpH=activeVP.height;
            gpu->vpMinDepth=activeVP.minDepth; gpu->vpMaxDepth=activeVP.maxDepth;
            break;

        case _CMD_SET_SCISSOR:
            activeSC = c->setScissor.sc;
            gpu->scX=activeSC.x; gpu->scY=activeSC.y;
            gpu->scW=activeSC.width; gpu->scH=activeSC.height;
            break;

        case _CMD_SET_UNIFORMS:
            memcpy(uniformData, c->setUniforms.data, c->setUniforms.size);
            activeUniforms  = uniformData;
            activeUniformSz = c->setUniforms.size;
            /* GPU uniform slot 0'a yükle */
            {
                uint32_t n = (uint32_t)(activeUniformSz / sizeof(float));
                if (n > GPU_SIM_MAX_UNIFORMS) n = GPU_SIM_MAX_UNIFORMS;
                memcpy(gpu->uniforms[0], activeUniforms, n * sizeof(float));
                gpu->uniformCount[0] = n;
            }
            break;

        case _CMD_DRAW: {
            if (!activeVB || !activePipeline) break;
            _GravBuffer_access* vb = (_GravBuffer_access*)activeVB;
            _GravPipeline_access* pa = (_GravPipeline_access*)activePipeline;
            const uint8_t* vbase = (const uint8_t*)vb->data + activeVBOffset;
            gpu_draw_direct(gpu, vbase + c->draw.first * pa->vertexStride,
                            c->draw.count, NULL, 0,
                            pa->vertexStride, (uint32_t)pa->topology);
            break;
        }

        case _CMD_DRAW_INDEXED: {
            if (!activeVB || !activeIB || !activePipeline) break;
            _GravBuffer_access* vb = (_GravBuffer_access*)activeVB;
            _GravBuffer_access* ib = (_GravBuffer_access*)activeIB;
            _GravPipeline_access* pa = (_GravPipeline_access*)activePipeline;
            const uint8_t*  vbase = (const uint8_t*)vb->data + activeVBOffset;
            const uint32_t* ibase = (const uint32_t*)((uint8_t*)ib->data + activeIBOffset);
            gpu_draw_direct(gpu, vbase, 0,
                            ibase + c->drawIndexed.firstIndex,
                            c->drawIndexed.count,
                            pa->vertexStride, (uint32_t)pa->topology);
            break;
        }

        case _CMD_CLEAR_COLOR_IMAGE: {
            GravImage img = c->clearColor.image;
            if (!img) break;
            /* GPU framebuffer'ı temizle (image GPU VRAM framebuffer'ına karşılık geliyorsa) */
            {
                _GravImage_access* ia = (_GravImage_access*)img;
                float r = c->clearColor.color.r;
                float g = c->clearColor.color.g;
                float bv = c->clearColor.color.b;
                float a = c->clearColor.color.a;
                uint8_t* fb = gpu->vram + gpu->fbOffset;
                uint8_t  rb=(uint8_t)(r>1?255:r<0?0:r*255);
                uint8_t  gb=(uint8_t)(g>1?255:g<0?0:g*255);
                uint8_t  bb=(uint8_t)(bv>1?255:bv<0?0:bv*255);
                uint8_t  ab=(uint8_t)(a>1?255:a<0?0:a*255);
                for (uint32_t py=0; py<gpu->fbHeight; py++)
                    for (uint32_t px=0; px<gpu->fbWidth; px++) {
                        uint8_t* p = fb + py*gpu->fbPitch + px*4;
                        p[0]=rb; p[1]=gb; p[2]=bb; p[3]=ab;
                    }
            }
            break;
        }

        } /* switch */
    } /* for */

    /* VRAM → GravImage geri kopyalama (readback)
     * End render pass komutu sonrasında color image'a GPU VRAM'den kopyala */
    /* Bu adım sadece host'ta gerekli (sim modunda).
     * FPGA'da display controller doğrudan VRAM'den okur. */
    for (uint32_t i = 0; i < cb->count; i++) {
        _Command* c = &cb->cmds[i];
        if (c->type == _CMD_BEGIN_RENDER_PASS) {
            GravFramebuffer fb = c->beginRenderPass.info.framebuffer;
            if (!fb) continue;
            _GravFramebuffer_access* fba = (_GravFramebuffer_access*)fb;
            _GravImage_access* ci = (_GravImage_access*)fba->colorImage;
            if (!ci || !ci->pixels) continue;
            /* GPU VRAM → GravImage pixels */
            uint32_t w = ci->width < gpu->fbWidth ? ci->width : gpu->fbWidth;
            uint32_t h = ci->height < gpu->fbHeight ? ci->height : gpu->fbHeight;
            uint8_t* src = gpu->vram + gpu->fbOffset;
            uint8_t* dst = (uint8_t*)ci->pixels;
            for (uint32_t row = 0; row < h; row++)
                memcpy(dst + row * ci->width * 4,
                       src + row * gpu->fbPitch,
                       w * 4);
        }
    }

    return GRAV_SUCCESS;
}
