/**
 * GRAVITYON GPU API — Uygulama
 * ============================
 * Software rasterizer backend: tam pipeline, z-buffer, perspektif-doğru
 * interpolasyon, scissor, viewport transform, back-face culling.
 */

#define _POSIX_C_SOURCE 199309L
#include "gravityon.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <pthread.h>

/* =========================================================================
 * YARDIMCI MAKROLAR
 * ========================================================================= */

#define GRAV_CHECK_NULL(ptr)  if (!(ptr)) return GRAV_ERROR_INVALID_ARGUMENT
#define GRAV_CHECK_HANDLE(h)  if (!(h))   return GRAV_ERROR_INVALID_HANDLE
#define GRAV_CLAMP(v,lo,hi)   ((v)<(lo)?(lo):((v)>(hi)?(hi):(v)))
#define GRAV_MAX(a,b)         ((a)>(b)?(a):(b))
#define GRAV_MIN(a,b)         ((a)<(b)?(a):(b))
#define GRAV_ABS(x)           ((x)<0?-(x):(x))

static int grav_bytes_contain(const char* haystack, size_t haystackSize,
                              const char* needle, size_t needleSize) {
    size_t i;
    if (needleSize == 0) return 1;
    if (!haystack || needleSize > haystackSize) return 0;
    for (i = 0; i + needleSize <= haystackSize; i++)
        if (memcmp(haystack + i, needle, needleSize) == 0) return 1;
    return 0;
}

/* =========================================================================
 * İÇ YAPILARI
 * ========================================================================= */

/* Komut türleri */
typedef enum CmdType {
    CMD_BEGIN_RENDER_PASS,
    CMD_END_RENDER_PASS,
    CMD_BIND_PIPELINE,
    CMD_BIND_VERTEX_BUFFER,
    CMD_BIND_INDEX_BUFFER,
    CMD_SET_VIEWPORT,
    CMD_SET_SCISSOR,
    CMD_SET_UNIFORMS,
    CMD_DRAW,
    CMD_DRAW_INDEXED,
    CMD_DRAW_INSTANCED,
    CMD_DRAW_INDIRECT,
    CMD_DEBUG_MARKER,
    CMD_BEGIN_QUERY,
    CMD_END_QUERY,
    CMD_CLEAR_COLOR_IMAGE,
} CmdType;

/* Tek komut */
typedef struct Command {
    CmdType type;
    union {
        struct { GravRenderPassBeginInfo info; }        beginRenderPass;
        struct { GravPipeline pipeline; }               bindPipeline;
        struct { GravBuffer buffer; uint64_t offset; }  bindVertex;
        struct { GravBuffer buffer; uint64_t offset; }  bindIndex;
        struct { GravViewport vp; }                     setViewport;
        struct { GravRect2D sc; }                       setScissor;
        struct {
            uint8_t  data[256];
            size_t   size;
        }                                               setUniforms;
        struct {
            uint32_t count;
            uint32_t first;
        }                                               draw;
        struct {
            uint32_t count, instances, first, firstInstance;
        }                                               drawInstanced;
        struct {
            GravBuffer args;
            uint64_t offset;
            uint32_t drawCount, stride;
        }                                               drawIndirect;
        struct { char name[96]; }                       debugMarker;
        struct { GravQuery query; }                     query;
        struct {
            uint32_t count;
            uint32_t firstIndex;
            int32_t  vertexOffset;
        }                                               drawIndexed;
        struct { GravImage image; GravColorF color; }   clearColor;
    };
} Command;

/* Instance */
struct GravInstance_T {
    uint32_t appVersion;
    char     appName[128];
};

/* Device */
struct GravDevice_T {
    GravInstance parent;
    uint64_t     lastSubmitNs;
    uint32_t     threadCount;
    pthread_mutex_t computeMutex;
    struct GravComputeJob_T* computeJobs;
    uint64_t nextJobId;
};

/* Buffer */
struct GravBuffer_T {
    void*          data;
    uint64_t       size;
    GravBufferUsage usage;
    int            mapped;
};

/* Image */
struct GravImage_T {
    uint32_t       width, height;
    GravFormat     format;
    GravImageUsage usage;
    void*          pixels;      /* RGBA8: uint8_t[w*h*4] | D32: float[w*h] */
    size_t         sizeBytes;
};

/* Shader Module */
struct GravShaderModule_T {
    GravVertFn vertFn;
    GravFragFn fragFn;
    GravGeometryFn geometryFn;
    GravTessellationFn tessellationFn;
    char debugName[64];
};

/* Render Pass */
struct GravRenderPass_T {
    GravAttachmentDesc color;
    GravAttachmentDesc depth;
    int                hasDepth;
};

/* Framebuffer */
struct GravFramebuffer_T {
    GravRenderPass renderPass;
    GravImage      colorImage;
    GravImage      depthImage;
    GravExtent2D   extent;
};

/* Pipeline */
struct GravPipeline_T {
    GravShaderModule      shader;
    GravRenderPass        renderPass;
    uint32_t              vertexStride;
    uint32_t              attributeCount;
    GravVertexAttribute   attributes[GRAV_MAX_VERTEX_ATTRIBUTES];
    uint32_t              varyingCount;
    GravPrimitiveTopology topology;
    GravCullMode          cullMode;
    GravFillMode          fillMode;
    int                   depthTestEnable;
    int                   depthWriteEnable;
    GravDepthCompare      depthCompare;
    GravBlendState        blend;
    GravViewport          viewport;
    GravRect2D            scissor;
    const void*           uniforms;
    size_t                uniformSize;
    uint32_t              msaaSamples;
    int                   conservativeRaster;
    int                   primitiveRestart;
    uint32_t              tileSize;
};

/* Command Buffer */
struct GravCommandBuffer_T {
    Command* cmds;
    uint32_t count;
    uint32_t capacity;
    int      recording;
};

struct GravComputePipeline_T {
    GravComputeFn computeFn;
    char debugName[64];
};

struct GravQuery_T {
    GravQueryType type;
    uint64_t value;
    uint64_t startedNs;
    int active;
    int available;
};

struct GravPipelineCache_T {
    char path[256];
    char* keys;
    size_t bytes;
};

typedef struct GravComputeJob_T {
    uint64_t id;
    pthread_t thread;
    int joined;
    GravComputePipeline pipeline;
    GravComputeInput input;
    void* uniforms;
    struct GravComputeJob_T* next;
} GravComputeJob;

/* =========================================================================
 * SONUÇ STRİNG
 * ========================================================================= */

const char* gravResultString(GravResult r) {
    switch (r) {
        case GRAV_SUCCESS:                      return "GRAV_SUCCESS";
        case GRAV_NOT_READY:                    return "GRAV_NOT_READY";
        case GRAV_TIMEOUT:                      return "GRAV_TIMEOUT";
        case GRAV_ERROR_OUT_OF_MEMORY:          return "GRAV_ERROR_OUT_OF_MEMORY";
        case GRAV_ERROR_INVALID_HANDLE:         return "GRAV_ERROR_INVALID_HANDLE";
        case GRAV_ERROR_INVALID_ARGUMENT:       return "GRAV_ERROR_INVALID_ARGUMENT";
        case GRAV_ERROR_OUT_OF_RANGE:           return "GRAV_ERROR_OUT_OF_RANGE";
        case GRAV_ERROR_COMMAND_BUFFER_FULL:    return "GRAV_ERROR_COMMAND_BUFFER_FULL";
        case GRAV_ERROR_NOT_RECORDING:          return "GRAV_ERROR_NOT_RECORDING";
        case GRAV_ERROR_ALREADY_RECORDING:      return "GRAV_ERROR_ALREADY_RECORDING";
        case GRAV_ERROR_RENDER_PASS_NOT_BEGUN:  return "GRAV_ERROR_RENDER_PASS_NOT_BEGUN";
        case GRAV_ERROR_NO_PIPELINE_BOUND:      return "GRAV_ERROR_NO_PIPELINE_BOUND";
        case GRAV_ERROR_NO_VERTEX_BUFFER_BOUND: return "GRAV_ERROR_NO_VERTEX_BUFFER_BOUND";
        case GRAV_ERROR_IO:                     return "GRAV_ERROR_IO";
        case GRAV_ERROR_UNSUPPORTED:            return "GRAV_ERROR_UNSUPPORTED";
        case GRAV_ERROR_BUSY:                   return "GRAV_ERROR_BUSY";
        default:                                return "GRAV_ERROR_UNKNOWN";
    }
}

/* =========================================================================
 * INSTANCE
 * ========================================================================= */

GravResult gravCreateInstance(const GravInstanceCreateInfo* pInfo, GravInstance* pInstance) {
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pInstance);
    struct GravInstance_T* inst = calloc(1, sizeof(*inst));
    if (!inst) return GRAV_ERROR_OUT_OF_MEMORY;
    inst->appVersion = pInfo->appVersion;
    if (pInfo->appName)
        strncpy(inst->appName, pInfo->appName, sizeof(inst->appName)-1);
    *pInstance = inst;
    return GRAV_SUCCESS;
}

GravResult gravDestroyInstance(GravInstance instance) {
    GRAV_CHECK_HANDLE(instance);
    free(instance);
    return GRAV_SUCCESS;
}

GravResult gravEnumerateDeviceFeatures(GravInstance instance, GravDeviceFeatures* pFeatures) {
    GRAV_CHECK_HANDLE(instance);
    GRAV_CHECK_NULL(pFeatures);
    pFeatures->wireframeSupport  = 1;
    pFeatures->depthClampSupport = 1;
    pFeatures->alphaBlendSupport = 1;
    pFeatures->maxRenderWidth    = 16384;
    pFeatures->maxRenderHeight   = 16384;
    pFeatures->maxVaryings       = GRAV_MAX_VARYINGS;
    pFeatures->msaaSupport = 1;
    pFeatures->geometryShaderSupport = 1;
    pFeatures->tessellationSupport = 1;
    pFeatures->asyncComputeSupport = 1;
    pFeatures->computeShaderSupport = 1;
    pFeatures->mipmappingSupport = 1;
    pFeatures->anisotropicFilteringSupport = 1;
    pFeatures->pipelineStateObjectSupport = 1;
    pFeatures->shaderReflectionSupport = 1;
    pFeatures->occlusionCullingSupport = 1;
    pFeatures->conservativeRasterSupport = 1;
    pFeatures->primitiveRestartSupport = 1;
    pFeatures->indirectDrawSupport = 1;
    pFeatures->querySupport = 1;
    pFeatures->debugMarkerSupport = 1;
    pFeatures->instancedRenderingSupport = 1;
    pFeatures->tileRenderingSupport = 1;
    pFeatures->multiThreadingSupport = 1;
    pFeatures->shaderOptimizationSupport = 1;
    pFeatures->pipelineCachingSupport = 1;
    pFeatures->vertexCompressionSupport = 1;
    return GRAV_SUCCESS;
}

/* =========================================================================
 * DEVICE
 * ========================================================================= */

GravResult gravCreateDevice(GravInstance instance, const GravDeviceCreateInfo* pInfo, GravDevice* pDevice) {
    GRAV_CHECK_HANDLE(instance);
    GRAV_CHECK_NULL(pDevice);
    struct GravDevice_T* dev = calloc(1, sizeof(*dev));
    if (!dev) return GRAV_ERROR_OUT_OF_MEMORY;
    dev->parent = instance;
    dev->threadCount = (pInfo && pInfo->threadCount) ? pInfo->threadCount : 1;
    pthread_mutex_init(&dev->computeMutex, NULL);
    dev->nextJobId = 1;
    *pDevice = dev;
    return GRAV_SUCCESS;
}

GravResult gravDestroyDevice(GravDevice device) {
    GRAV_CHECK_HANDLE(device);
    pthread_mutex_lock(&device->computeMutex);
    GravComputeJob* job = device->computeJobs;
    device->computeJobs = NULL;
    pthread_mutex_unlock(&device->computeMutex);
    while (job) {
        GravComputeJob* next = job->next;
        if (!job->joined) pthread_join(job->thread, NULL);
        free(job->uniforms);
        free(job);
        job = next;
    }
    pthread_mutex_destroy(&device->computeMutex);
    free(device);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * BUFFER
 * ========================================================================= */

GravResult gravCreateBuffer(GravDevice device, const GravBufferCreateInfo* pInfo, GravBuffer* pBuffer) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pBuffer);
    if (pInfo->size == 0) return GRAV_ERROR_INVALID_ARGUMENT;
    struct GravBuffer_T* buf = calloc(1, sizeof(*buf));
    if (!buf) return GRAV_ERROR_OUT_OF_MEMORY;
    buf->data = calloc(1, (size_t)pInfo->size);
    if (!buf->data) { free(buf); return GRAV_ERROR_OUT_OF_MEMORY; }
    buf->size  = pInfo->size;
    buf->usage = pInfo->usage;
    *pBuffer = buf;
    return GRAV_SUCCESS;
}

GravResult gravDestroyBuffer(GravDevice device, GravBuffer buffer) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(buffer);
    free(buffer->data);
    free(buffer);
    return GRAV_SUCCESS;
}

GravResult gravMapBuffer(GravDevice device, GravBuffer buffer, void** ppData) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(buffer);
    GRAV_CHECK_NULL(ppData);
    buffer->mapped = 1;
    *ppData = buffer->data;
    return GRAV_SUCCESS;
}

GravResult gravUnmapBuffer(GravDevice device, GravBuffer buffer) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(buffer);
    buffer->mapped = 0;
    return GRAV_SUCCESS;
}

GravResult gravBufferSize(GravDevice device, GravBuffer buffer, uint64_t* pSize) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(buffer);
    GRAV_CHECK_NULL(pSize);
    *pSize = buffer->size;
    return GRAV_SUCCESS;
}

/* =========================================================================
 * IMAGE
 * ========================================================================= */

static size_t image_pixel_size(GravFormat fmt) {
    switch (fmt) {
        case GRAV_FORMAT_R8G8B8A8_UNORM:   return 4;
        case GRAV_FORMAT_R32G32B32A32_F:   return 16;
        case GRAV_FORMAT_D32_SFLOAT:       return 4;
        default:                           return 4;
    }
}

GravResult gravCreateImage(GravDevice device, const GravImageCreateInfo* pInfo, GravImage* pImage) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pImage);
    if (pInfo->extent.width == 0 || pInfo->extent.height == 0)
        return GRAV_ERROR_INVALID_ARGUMENT;
    struct GravImage_T* img = calloc(1, sizeof(*img));
    if (!img) return GRAV_ERROR_OUT_OF_MEMORY;
    img->width     = pInfo->extent.width;
    img->height    = pInfo->extent.height;
    img->format    = pInfo->format;
    img->usage     = pInfo->usage;
    img->sizeBytes = (size_t)pInfo->extent.width * pInfo->extent.height * image_pixel_size(pInfo->format);
    img->pixels    = calloc(1, img->sizeBytes);
    if (!img->pixels) { free(img); return GRAV_ERROR_OUT_OF_MEMORY; }
    /* Derinlik buffer'ını +∞ ile doldur */
    if (pInfo->format == GRAV_FORMAT_D32_SFLOAT) {
        float* fp = (float*)img->pixels;
        for (size_t i = 0; i < (size_t)img->width * img->height; i++) fp[i] = 1.0f;
    }
    *pImage = img;
    return GRAV_SUCCESS;
}

GravResult gravDestroyImage(GravDevice device, GravImage image) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    free(image->pixels);
    free(image);
    return GRAV_SUCCESS;
}

GravResult gravGetImageData(GravDevice device, GravImage image, void** ppPixels, size_t* pSizeBytes) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    if (ppPixels)   *ppPixels   = image->pixels;
    if (pSizeBytes) *pSizeBytes = image->sizeBytes;
    return GRAV_SUCCESS;
}

GravResult gravGetImageExtent(GravDevice device, GravImage image, uint32_t* pWidth, uint32_t* pHeight) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    if (pWidth)  *pWidth  = image->width;
    if (pHeight) *pHeight = image->height;
    return GRAV_SUCCESS;
}

GravResult gravGetImageFormat(GravDevice device, GravImage image, GravFormat* pFormat) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    GRAV_CHECK_NULL(pFormat);
    *pFormat = image->format;
    return GRAV_SUCCESS;
}

/* =========================================================================
 * SHADER MODULE
 * ========================================================================= */

GravResult gravCreateShaderModule(GravDevice device, const GravShaderModuleCreateInfo* pInfo, GravShaderModule* pModule) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pModule);
    if (!pInfo->vertFn || !pInfo->fragFn) return GRAV_ERROR_INVALID_ARGUMENT;
    struct GravShaderModule_T* m = calloc(1, sizeof(*m));
    if (!m) return GRAV_ERROR_OUT_OF_MEMORY;
    m->vertFn = pInfo->vertFn;
    m->fragFn = pInfo->fragFn;
    m->geometryFn = pInfo->geometryFn;
    m->tessellationFn = pInfo->tessellationFn;
    if (pInfo->debugName)
        strncpy(m->debugName, pInfo->debugName, sizeof(m->debugName) - 1);
    *pModule = m;
    return GRAV_SUCCESS;
}

GravResult gravDestroyShaderModule(GravDevice device, GravShaderModule module) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(module);
    free(module);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * RENDER PASS
 * ========================================================================= */

GravResult gravCreateRenderPass(GravDevice device, const GravRenderPassCreateInfo* pInfo, GravRenderPass* pRenderPass) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pRenderPass);
    struct GravRenderPass_T* rp = calloc(1, sizeof(*rp));
    if (!rp) return GRAV_ERROR_OUT_OF_MEMORY;
    rp->color    = pInfo->colorAttachment;
    rp->depth    = pInfo->depthAttachment;
    rp->hasDepth = pInfo->hasDepthAttachment;
    *pRenderPass = rp;
    return GRAV_SUCCESS;
}

GravResult gravDestroyRenderPass(GravDevice device, GravRenderPass renderPass) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(renderPass);
    free(renderPass);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * FRAMEBUFFER
 * ========================================================================= */

GravResult gravCreateFramebuffer(GravDevice device, const GravFramebufferCreateInfo* pInfo, GravFramebuffer* pFramebuffer) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pFramebuffer);
    struct GravFramebuffer_T* fb = calloc(1, sizeof(*fb));
    if (!fb) return GRAV_ERROR_OUT_OF_MEMORY;
    fb->renderPass  = pInfo->renderPass;
    fb->colorImage  = pInfo->colorImage;
    fb->depthImage  = pInfo->depthImage;
    fb->extent      = pInfo->extent;
    *pFramebuffer = fb;
    return GRAV_SUCCESS;
}

GravResult gravDestroyFramebuffer(GravDevice device, GravFramebuffer framebuffer) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(framebuffer);
    free(framebuffer);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * PIPELINE
 * ========================================================================= */

GravResult gravCreatePipeline(GravDevice device, const GravPipelineCreateInfo* pInfo, GravPipeline* pPipeline) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pInfo);
    GRAV_CHECK_NULL(pPipeline);
    if (!pInfo->shaderModule) return GRAV_ERROR_INVALID_ARGUMENT;
    if (pInfo->attributeCount > GRAV_MAX_VERTEX_ATTRIBUTES ||
        pInfo->varyingCount > GRAV_MAX_VARYINGS ||
        (pInfo->attributeCount > 0 && pInfo->vertexStride == 0))
        return GRAV_ERROR_INVALID_ARGUMENT;
    struct GravPipeline_T* pl = calloc(1, sizeof(*pl));
    if (!pl) return GRAV_ERROR_OUT_OF_MEMORY;
    pl->shader         = pInfo->shaderModule;
    pl->renderPass     = pInfo->renderPass;
    pl->vertexStride   = pInfo->vertexStride;
    pl->attributeCount = pInfo->attributeCount;
    pl->varyingCount   = pInfo->varyingCount;
    pl->topology       = pInfo->topology;
    pl->cullMode       = pInfo->cullMode;
    pl->fillMode       = pInfo->fillMode;
    pl->depthTestEnable  = pInfo->depthTestEnable;
    pl->depthWriteEnable = pInfo->depthWriteEnable;
    pl->depthCompare     = pInfo->depthCompare;
    pl->blend            = pInfo->blend;
    pl->viewport         = pInfo->viewport;
    pl->scissor          = pInfo->scissor;
    pl->uniforms         = pInfo->uniforms;
    pl->uniformSize      = pInfo->uniformSize;
    pl->msaaSamples      = pInfo->msaaSamples ? pInfo->msaaSamples : 1;
    if (pl->msaaSamples != 1 && pl->msaaSamples != 2 &&
        pl->msaaSamples != 4 && pl->msaaSamples != 8) {
        free(pl);
        return GRAV_ERROR_INVALID_ARGUMENT;
    }
    pl->conservativeRaster = pInfo->conservativeRaster;
    pl->primitiveRestart = pInfo->primitiveRestart;
    pl->tileSize = pInfo->tileSize;
    if (pInfo->attributeCount > 0)
        memcpy(pl->attributes, pInfo->attributes,
               pInfo->attributeCount * sizeof(GravVertexAttribute));
    *pPipeline = pl;
    return GRAV_SUCCESS;
}

GravResult gravDestroyPipeline(GravDevice device, GravPipeline pipeline) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(pipeline);
    free(pipeline);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * COMMAND BUFFER
 * ========================================================================= */

GravResult gravAllocateCommandBuffer(GravDevice device, const GravCommandBufferAllocInfo* pInfo, GravCommandBuffer* pCmdBuf) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(pCmdBuf);
    uint32_t cap = (pInfo && pInfo->maxCommands > 0) ? pInfo->maxCommands : GRAV_MAX_COMMANDS;
    struct GravCommandBuffer_T* cb = calloc(1, sizeof(*cb));
    if (!cb) return GRAV_ERROR_OUT_OF_MEMORY;
    cb->cmds = calloc(cap, sizeof(Command));
    if (!cb->cmds) { free(cb); return GRAV_ERROR_OUT_OF_MEMORY; }
    cb->capacity  = cap;
    cb->count     = 0;
    cb->recording = 0;
    *pCmdBuf = cb;
    return GRAV_SUCCESS;
}

GravResult gravFreeCommandBuffer(GravDevice device, GravCommandBuffer cmdBuf) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cmdBuf);
    free(cmdBuf->cmds);
    free(cmdBuf);
    return GRAV_SUCCESS;
}

GravResult gravBeginCommandBuffer(GravCommandBuffer cmdBuf) {
    GRAV_CHECK_HANDLE(cmdBuf);
    if (cmdBuf->recording) return GRAV_ERROR_ALREADY_RECORDING;
    cmdBuf->count     = 0;
    cmdBuf->recording = 1;
    return GRAV_SUCCESS;
}

GravResult gravEndCommandBuffer(GravCommandBuffer cmdBuf) {
    GRAV_CHECK_HANDLE(cmdBuf);
    if (!cmdBuf->recording) return GRAV_ERROR_NOT_RECORDING;
    cmdBuf->recording = 0;
    return GRAV_SUCCESS;
}

GravResult gravResetCommandBuffer(GravCommandBuffer cmdBuf) {
    GRAV_CHECK_HANDLE(cmdBuf);
    cmdBuf->count     = 0;
    cmdBuf->recording = 0;
    return GRAV_SUCCESS;
}

/* Komut ekle yardımcısı */
static Command* push_cmd(GravCommandBuffer cb) {
    if (cb->count >= cb->capacity) return NULL;
    return &cb->cmds[cb->count++];
}

#define REQUIRE_RECORDING(cb) if (!(cb)->recording) return GRAV_ERROR_NOT_RECORDING

GravResult gravCmdBeginRenderPass(GravCommandBuffer cb, const GravRenderPassBeginInfo* pInfo) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_NULL(pInfo); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_BEGIN_RENDER_PASS;
    c->beginRenderPass.info = *pInfo;
    return GRAV_SUCCESS;
}

GravResult gravCmdEndRenderPass(GravCommandBuffer cb) {
    GRAV_CHECK_HANDLE(cb); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_END_RENDER_PASS;
    return GRAV_SUCCESS;
}

GravResult gravCmdBindPipeline(GravCommandBuffer cb, GravPipeline pipeline) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(pipeline); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_BIND_PIPELINE;
    c->bindPipeline.pipeline = pipeline;
    return GRAV_SUCCESS;
}

GravResult gravCmdBindVertexBuffer(GravCommandBuffer cb, GravBuffer buffer, uint64_t offset) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(buffer); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_BIND_VERTEX_BUFFER;
    c->bindVertex.buffer = buffer;
    c->bindVertex.offset = offset;
    return GRAV_SUCCESS;
}

GravResult gravCmdBindIndexBuffer(GravCommandBuffer cb, GravBuffer buffer, uint64_t offset) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(buffer); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_BIND_INDEX_BUFFER;
    c->bindIndex.buffer = buffer;
    c->bindIndex.offset = offset;
    return GRAV_SUCCESS;
}

GravResult gravCmdSetViewport(GravCommandBuffer cb, const GravViewport* pViewport) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_NULL(pViewport); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_SET_VIEWPORT;
    c->setViewport.vp = *pViewport;
    return GRAV_SUCCESS;
}

GravResult gravCmdSetScissor(GravCommandBuffer cb, const GravRect2D* pScissor) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_NULL(pScissor); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_SET_SCISSOR;
    c->setScissor.sc = *pScissor;
    return GRAV_SUCCESS;
}

GravResult gravCmdSetUniforms(GravCommandBuffer cb, const void* pUniforms, size_t size) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_NULL(pUniforms); REQUIRE_RECORDING(cb);
    if (size > 256) return GRAV_ERROR_OUT_OF_RANGE;
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_SET_UNIFORMS;
    memcpy(c->setUniforms.data, pUniforms, size);
    c->setUniforms.size = size;
    return GRAV_SUCCESS;
}

GravResult gravCmdDraw(GravCommandBuffer cb, uint32_t vertexCount, uint32_t firstVertex) {
    GRAV_CHECK_HANDLE(cb); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_DRAW;
    c->draw.count = vertexCount;
    c->draw.first = firstVertex;
    return GRAV_SUCCESS;
}

GravResult gravCmdDrawIndexed(GravCommandBuffer cb, uint32_t indexCount, uint32_t firstIndex, int32_t vertexOffset) {
    GRAV_CHECK_HANDLE(cb); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_DRAW_INDEXED;
    c->drawIndexed.count        = indexCount;
    c->drawIndexed.firstIndex   = firstIndex;
    c->drawIndexed.vertexOffset = vertexOffset;
    return GRAV_SUCCESS;
}

GravResult gravCmdDrawInstanced(GravCommandBuffer cb, uint32_t vertexCount,
                                uint32_t instanceCount, uint32_t firstVertex,
                                uint32_t firstInstance) {
    GRAV_CHECK_HANDLE(cb); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_DRAW_INSTANCED;
    c->drawInstanced.count = vertexCount;
    c->drawInstanced.instances = instanceCount;
    c->drawInstanced.first = firstVertex;
    c->drawInstanced.firstInstance = firstInstance;
    return GRAV_SUCCESS;
}

GravResult gravCmdDrawIndirect(GravCommandBuffer cb, GravBuffer args,
                               uint64_t offset, uint32_t drawCount,
                               uint32_t stride) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(args); REQUIRE_RECORDING(cb);
    if (stride < 16 || drawCount == 0) return GRAV_ERROR_INVALID_ARGUMENT;
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_DRAW_INDIRECT;
    c->drawIndirect.args = args;
    c->drawIndirect.offset = offset;
    c->drawIndirect.drawCount = drawCount;
    c->drawIndirect.stride = stride;
    return GRAV_SUCCESS;
}

GravResult gravCmdDebugMarker(GravCommandBuffer cb, const char* name) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_NULL(name); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_DEBUG_MARKER;
    strncpy(c->debugMarker.name, name, sizeof(c->debugMarker.name) - 1);
    c->debugMarker.name[sizeof(c->debugMarker.name) - 1] = '\0';
    return GRAV_SUCCESS;
}

GravResult gravCmdBeginQuery(GravCommandBuffer cb, GravQuery query) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(query); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_BEGIN_QUERY;
    c->query.query = query;
    return GRAV_SUCCESS;
}

GravResult gravCmdEndQuery(GravCommandBuffer cb, GravQuery query) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(query); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_END_QUERY;
    c->query.query = query;
    return GRAV_SUCCESS;
}

GravResult gravCmdClearColorImage(GravCommandBuffer cb, GravImage image, GravColorF color) {
    GRAV_CHECK_HANDLE(cb); GRAV_CHECK_HANDLE(image); REQUIRE_RECORDING(cb);
    Command* c = push_cmd(cb); if (!c) return GRAV_ERROR_COMMAND_BUFFER_FULL;
    c->type = CMD_CLEAR_COLOR_IMAGE;
    c->clearColor.image = image;
    c->clearColor.color = color;
    return GRAV_SUCCESS;
}

/* =========================================================================
 * SOFTWARE RASTERIZER — KALBİ
 * ========================================================================= */

/* Çalışma zamanı durumu */
typedef struct RastState {
    GravPipeline      pipeline;
    GravFramebuffer   framebuffer;
    GravBuffer        vertexBuffer;
    uint64_t          vertexOffset;
    GravBuffer        indexBuffer;
    uint64_t          indexOffset;
    GravViewport      viewport;
    GravRect2D        scissor;
    const void*       uniforms;
    size_t            uniformSize;
    uint8_t           uniformData[256];
    int               inRenderPass;
    GravQuery         query;
    uint64_t          querySamples;
    uint32_t          threadCount;
} RastState;

typedef struct RastTriangle {
    float clip[3][4];
    float varyings[3][GRAV_MAX_VARYINGS];
} RastTriangle;

static inline uint8_t blend_factor(GravBlendFactor factor,
                                   uint8_t src, uint8_t srcA,
                                   uint8_t dst, uint8_t dstA)
{
    switch (factor) {
        case GRAV_BLEND_ZERO:                return 0;
        case GRAV_BLEND_ONE:                 return 255;
        case GRAV_BLEND_SRC_ALPHA:           return srcA;
        case GRAV_BLEND_ONE_MINUS_SRC_ALPHA: return (uint8_t)(255 - srcA);
        case GRAV_BLEND_DST_ALPHA:           return dstA;
        case GRAV_BLEND_ONE_MINUS_DST_ALPHA: return (uint8_t)(255 - dstA);
        case GRAV_BLEND_SRC_COLOR:           return src;
        case GRAV_BLEND_ONE_MINUS_SRC_COLOR: return (uint8_t)(255 - src);
        case GRAV_BLEND_DST_COLOR:           return dst;
        case GRAV_BLEND_ONE_MINUS_DST_COLOR: return (uint8_t)(255 - dst);
        default:                             return 255;
    }
}

static inline uint8_t blend_channel(uint8_t src, uint8_t srcA,
                                    uint8_t dst, uint8_t dstA,
                                    GravBlendFactor srcFactor,
                                    GravBlendFactor dstFactor)
{
    uint32_t sf = blend_factor(srcFactor, src, srcA, dst, dstA);
    uint32_t df = blend_factor(dstFactor, src, srcA, dst, dstA);
    return (uint8_t)((src * sf + dst * df + 127u) / 255u);
}

/* Rengi RGBA8 piksel yazma; pipeline blending açıksa mevcut renk korunur. */
static inline void write_pixel_rgba8(GravImage img, int x, int y,
                                     float r, float g, float b, float a,
                                     const GravBlendState* blend)
{
    uint8_t sr, sg, sb, sa;
    if (!img || img->format != GRAV_FORMAT_R8G8B8A8_UNORM ||
        x < 0 || y < 0 || (uint32_t)x >= img->width || (uint32_t)y >= img->height)
        return;

    sr = (uint8_t)(GRAV_CLAMP(r, 0.0f, 1.0f) * 255.0f);
    sg = (uint8_t)(GRAV_CLAMP(g, 0.0f, 1.0f) * 255.0f);
    sb = (uint8_t)(GRAV_CLAMP(b, 0.0f, 1.0f) * 255.0f);
    sa = (uint8_t)(GRAV_CLAMP(a, 0.0f, 1.0f) * 255.0f);

    uint8_t* px = (uint8_t*)img->pixels + ((size_t)y * img->width + (size_t)x) * 4;
    if (blend && blend->enable) {
        uint8_t dr = px[0], dg = px[1], db = px[2], da = px[3];
        px[0] = blend_channel(sr, sa, dr, da, blend->srcColor, blend->dstColor);
        px[1] = blend_channel(sg, sa, dg, da, blend->srcColor, blend->dstColor);
        px[2] = blend_channel(sb, sa, db, da, blend->srcColor, blend->dstColor);
        px[3] = blend_channel(sa, sa, da, da, blend->srcAlpha, blend->dstAlpha);
    } else {
        px[0] = sr; px[1] = sg; px[2] = sb; px[3] = sa;
    }
}

static inline void write_pixel_rgba8_coverage(GravImage img, int x, int y,
                                              float r, float g, float b, float a,
                                              float coverage,
                                              const GravBlendState* blend)
{
    if (coverage >= 0.999f) {
        write_pixel_rgba8(img, x, y, r, g, b, a, blend);
        return;
    }
    if (coverage <= 0.001f) return;
    {
        uint8_t* px = (uint8_t*)img->pixels + ((size_t)y * img->width + (size_t)x) * 4;
        float dr = px[0] / 255.0f, dg = px[1] / 255.0f;
        float db = px[2] / 255.0f, da = px[3] / 255.0f;
        write_pixel_rgba8(img, x, y,
                          dr + (r - dr) * coverage,
                          dg + (g - dg) * coverage,
                          db + (b - db) * coverage,
                          da + (a - da) * coverage,
                          blend);
    }
}

/* Derinlik okuma/yazma */
static inline float read_depth(GravImage dep, int x, int y) {
    if (!dep) return 1.0f;
    return ((float*)dep->pixels)[y * dep->width + x];
}
static inline void write_depth(GravImage dep, int x, int y, float d) {
    if (!dep) return;
    ((float*)dep->pixels)[y * dep->width + x] = d;
}

/* Derinlik karşılaştırması */
static inline int depth_test(GravDepthCompare cmp, float z, float zBuf) {
    switch (cmp) {
        case GRAV_COMPARE_LESS:    return z < zBuf;
        case GRAV_COMPARE_LEQUAL:  return z <= zBuf;
        case GRAV_COMPARE_GREATER: return z > zBuf;
        case GRAV_COMPARE_ALWAYS:  return 1;
        default:                   return z < zBuf;
    }
}

/* Scissor kontrolü */
static inline int in_scissor(RastState* s, int x, int y) {
    return x >= s->scissor.x && y >= s->scissor.y &&
           x <  s->scissor.x + (int)s->scissor.width &&
           y <  s->scissor.y + (int)s->scissor.height;
}

/* NDC → Ekran koordinatları */
static inline void ndc_to_screen(RastState* s, float nx, float ny, float nz, float* sx, float* sy, float* sz) {
    GravViewport* vp = &s->viewport;
    *sx = (nx * 0.5f + 0.5f) * vp->width  + vp->x;
    *sy = (1.0f - (ny * 0.5f + 0.5f)) * vp->height + vp->y;  /* Y flip */
    *sz = nz * (vp->maxDepth - vp->minDepth) * 0.5f + (vp->maxDepth + vp->minDepth) * 0.5f;
}

/* Barycentric üçgen rasterizasyonu */
static void rasterize_triangle(
    RastState*  s,
    GravImage   color,
    GravImage   depth,
    /* 3 vertex clip-space pozisyonu */
    float       clip[3][4],
    /* 3 vertex varyingları */
    float       varyings[3][GRAV_MAX_VARYINGS],
    uint32_t    varyingCount,
    int         regionMinX,
    int         regionMinY,
    int         regionMaxX,
    int         regionMaxY
) {
    GravPipeline pl = s->pipeline;
    const void*  uni = s->uniforms;

    /* Perspektif bölme → NDC */
    float ndc[3][3];
    float invW[3];
    for (int i = 0; i < 3; i++) {
        float w = clip[i][3];
        if (fabsf(w) < 1e-7f) w = 1e-7f;
        invW[i]   = 1.0f / w;
        ndc[i][0] = clip[i][0] * invW[i];
        ndc[i][1] = clip[i][1] * invW[i];
        ndc[i][2] = clip[i][2] * invW[i];
    }

    /* Ekran koordinatları */
    float sx[3], sy[3], sz[3];
    for (int i = 0; i < 3; i++)
        ndc_to_screen(s, ndc[i][0], ndc[i][1], ndc[i][2], &sx[i], &sy[i], &sz[i]);

    /* Back-face culling (2D çapraz çarpım işareti) */
    if (pl->cullMode != GRAV_CULL_NONE) {
        float ex1 = sx[1]-sx[0], ey1 = sy[1]-sy[0];
        float ex2 = sx[2]-sx[0], ey2 = sy[2]-sy[0];
        float cross = ex1*ey2 - ey1*ex2;
        if (pl->cullMode == GRAV_CULL_BACK  && cross >= 0) return;
        if (pl->cullMode == GRAV_CULL_FRONT && cross <= 0) return;
    }

    /* Bounding box */
    int minX = (int)floorf(GRAV_MIN(sx[0], GRAV_MIN(sx[1], sx[2])));
    int minY = (int)floorf(GRAV_MIN(sy[0], GRAV_MIN(sy[1], sy[2])));
    int maxX = (int) ceilf(GRAV_MAX(sx[0], GRAV_MAX(sx[1], sx[2])));
    int maxY = (int) ceilf(GRAV_MAX(sy[0], GRAV_MAX(sy[1], sy[2])));

    /* Scissor kırpma */
    minX = GRAV_MAX(minX, s->scissor.x);
    minY = GRAV_MAX(minY, s->scissor.y);
    maxX = GRAV_MIN(maxX, s->scissor.x + (int)s->scissor.width  - 1);
    maxY = GRAV_MIN(maxY, s->scissor.y + (int)s->scissor.height - 1);

    /* Ekran sınırları */
    minX = GRAV_MAX(minX, 0);
    minY = GRAV_MAX(minY, 0);
    maxX = GRAV_MIN(maxX, (int)color->width  - 1);
    maxY = GRAV_MIN(maxY, (int)color->height - 1);
    minX = GRAV_MAX(minX, regionMinX);
    minY = GRAV_MAX(minY, regionMinY);
    maxX = GRAV_MIN(maxX, regionMaxX);
    maxY = GRAV_MIN(maxY, regionMaxY);
    if (minX > maxX || minY > maxY) return;

    /* Kenar sabitlerini hazırla */
    float dx01 = sx[1]-sx[0], dy01 = sy[1]-sy[0];
    float dx12 = sx[2]-sx[1], dy12 = sy[2]-sy[1];
    float dx20 = sx[0]-sx[2], dy20 = sy[0]-sy[2];

    float triArea = dx01*dy20 - dy01*dx20;
    if (fabsf(triArea) < 1e-6f) return;
    float invArea = 1.0f / triArea;

    /* Perspektif-doğru varying interpolasyonu için 1/w dizisi */
    float pw[3]; for (int i=0;i<3;i++) pw[i] = invW[i];

    /* Varying vektörleri */
    float frag_varying[GRAV_MAX_VARYINGS];
    float outColor[4];

    for (int py = minY; py <= maxY; py++) {
        for (int px = minX; px <= maxX; px++) {
            float fpx = (float)px + 0.5f, fpy = (float)py + 0.5f;

            /* Barycentric koordinatlar */
            float w0 = ((fpx - sx[1]) * dy12 - (fpy - sy[1]) * dx12) * invArea;
            float w1 = ((fpx - sx[2]) * dy20 - (fpy - sy[2]) * dx20) * invArea;
            float w2 = 1.0f - w0 - w1;
            {
                float edgeTolerance = pl->conservativeRaster
                    ? 0.5f * (fabsf(invArea) *
                              (fabsf(dx01) + fabsf(dy01) +
                               fabsf(dx12) + fabsf(dy12) +
                               fabsf(dx20) + fabsf(dy20)))
                    : 0.0f;
                if (w0 < -edgeTolerance || w1 < -edgeTolerance ||
                    w2 < -edgeTolerance) continue;
            }

            float coverage = 1.0f;
            if (pl->msaaSamples > 1) {
                static const float samples[8][2] = {
                    {-0.25f,-0.25f},{0.25f,-0.25f},
                    {-0.25f,0.25f},{0.25f,0.25f},
                    {-0.375f,-0.125f},{0.125f,-0.375f},
                    {0.375f,0.125f},{-0.125f,0.375f}
                };
                uint32_t covered = 0;
                for (uint32_t si = 0; si < pl->msaaSamples; si++) {
                    float qx = (float)px + 0.5f + samples[si][0];
                    float qy = (float)py + 0.5f + samples[si][1];
                    float q0 = ((qx - sx[1]) * dy12 - (qy - sy[1]) * dx12) * invArea;
                    float q1 = ((qx - sx[2]) * dy20 - (qy - sy[2]) * dx20) * invArea;
                    float q2 = 1.0f - q0 - q1;
                    if (q0 >= 0 && q1 >= 0 && q2 >= 0) covered++;
                }
                coverage = (float)covered / (float)pl->msaaSamples;
                if (coverage <= 0.0f) continue;
            }

            /* Derinlik interpole */
            float z = w0*sz[0] + w1*sz[1] + w2*sz[2];
            if (z < 0.0f || z > 1.0f) continue;

            /* Derinlik testi */
            if (pl->depthTestEnable) {
                float zBuf = read_depth(depth, px, py);
                if (!depth_test(pl->depthCompare, z, zBuf)) continue;
                if (pl->depthWriteEnable) write_depth(depth, px, py, z);
            }

            /* Perspektif-doğru interpolasyon */
            float wInterp = w0*pw[0] + w1*pw[1] + w2*pw[2];
            float invWInterp = (fabsf(wInterp) > 1e-8f) ? 1.0f / wInterp : 0.0f;

            for (uint32_t v = 0; v < varyingCount && v < GRAV_MAX_VARYINGS; v++) {
                frag_varying[v] = (w0*pw[0]*varyings[0][v] +
                                   w1*pw[1]*varyings[1][v] +
                                   w2*pw[2]*varyings[2][v]) * invWInterp;
            }

            /* Fragment shader */
            pl->shader->fragFn(frag_varying, uni, outColor);

            /* Framebuffer'a yaz */
            write_pixel_rgba8_coverage(color, px, py,
                                       outColor[0], outColor[1], outColor[2], outColor[3],
                                       coverage, &pl->blend);
        }
    }
}

typedef struct RastTileWorker {
    RastState* state;
    GravImage color;
    GravImage depth;
    const RastTriangle* triangles;
    size_t triangleCount;
    uint32_t tileSize;
    uint32_t tilesX;
    uint32_t tileCount;
    uint32_t workerIndex;
    uint32_t workerCount;
} RastTileWorker;

static void rasterize_tile_range(const RastTileWorker* job,
                                 uint32_t firstTile,
                                 uint32_t step) {
    for (uint32_t tile = firstTile; tile < job->tileCount; tile += step) {
        uint32_t tx = tile % job->tilesX;
        uint32_t ty = tile / job->tilesX;
        int minX = (int)(tx * job->tileSize);
        int minY = (int)(ty * job->tileSize);
        int maxX = (int)GRAV_MIN((tx + 1u) * job->tileSize,
                                 job->color->width) - 1;
        int maxY = (int)GRAV_MIN((ty + 1u) * job->tileSize,
                                 job->color->height) - 1;

        for (size_t i = 0; i < job->triangleCount; i++) {
            const RastTriangle* tri = &job->triangles[i];
            rasterize_triangle(job->state, job->color, job->depth,
                               (float (*)[4])tri->clip,
                               (float (*)[GRAV_MAX_VARYINGS])tri->varyings,
                               job->state->pipeline->varyingCount,
                               minX, minY, maxX, maxY);
        }
    }
}

static void* rasterize_tile_worker(void* userdata) {
    RastTileWorker* job = (RastTileWorker*)userdata;
    rasterize_tile_range(job, job->workerIndex, job->workerCount);
    return NULL;
}

static void rasterize_triangles_tiled(RastState* state,
                                      GravImage color,
                                      GravImage depth,
                                      const RastTriangle* triangles,
                                      size_t triangleCount) {
    uint32_t tileSize = state->pipeline->tileSize
                      ? state->pipeline->tileSize : 32u;
    if (tileSize < 8u) tileSize = 8u;
    uint32_t tilesX = (color->width + tileSize - 1u) / tileSize;
    uint32_t tilesY = (color->height + tileSize - 1u) / tileSize;
    uint32_t tileCount = tilesX * tilesY;
    uint32_t workers = state->threadCount;
    if (workers > tileCount) workers = tileCount;
    if (workers < 2u) {
        RastTileWorker job = { state, color, depth, triangles, triangleCount,
                               tileSize, tilesX, tileCount, 0u, 1u };
        rasterize_tile_range(&job, 0u, 1u);
        return;
    }

    pthread_t* threads = calloc(workers, sizeof(*threads));
    RastTileWorker* jobs = calloc(workers, sizeof(*jobs));
    if (!threads || !jobs) {
        free(threads);
        free(jobs);
        RastTileWorker job = { state, color, depth, triangles, triangleCount,
                               tileSize, tilesX, tileCount, 0u, 1u };
        rasterize_tile_range(&job, 0u, 1u);
        return;
    }

    uint32_t created = 0;
    for (uint32_t i = 0; i < workers; i++) {
        jobs[i] = (RastTileWorker){
            state, color, depth, triangles, triangleCount,
            tileSize, tilesX, tileCount, i, workers
        };
        if (pthread_create(&threads[i], NULL, rasterize_tile_worker, &jobs[i]) != 0)
            break;
        created++;
    }
    for (uint32_t i = 0; i < created; i++)
        pthread_join(threads[i], NULL);

    /* If a worker could not be created, render only its unassigned tiles. */
    if (created < workers) {
        for (uint32_t tile = 0; tile < tileCount; tile++) {
            if (tile % workers < created) continue;
            rasterize_tile_range(&jobs[0], tile, tileCount);
        }
    }
    free(threads);
    free(jobs);
}

/* Çizgi (wireframe) çizen Bresenham */
static void draw_line(GravImage img, int x0, int y0, int x1, int y1,
                      float r, float g, float b) {
    int dx = GRAV_ABS(x1-x0), dy = GRAV_ABS(y1-y0);
    int sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;
    while (1) {
        write_pixel_rgba8(img, x0, y0, r, g, b, 1.0f, NULL);
        if (x0 == x1 && y0 == y1) break;
        int e2 = 2 * err;
        if (e2 > -dy) { err -= dy; x0 += sx; }
        if (e2 <  dx) { err += dx; y0 += sy; }
    }
}

/* Tek üçgeni rasterize et (wireframe veya fill) */
static void draw_triangle(
    RastState* s,
    GravImage color,
    GravImage depth,
    float clip[3][4],
    float var[3][GRAV_MAX_VARYINGS],
    uint32_t varyingCount
) {
    if (s->pipeline->fillMode == GRAV_FILL_WIREFRAME) {
        /* NDC → ekran dönüşümü */
        float sx[3], sy[3], sz[3];
        for (int i = 0; i < 3; i++) {
            float w = fabsf(clip[i][3]) > 1e-7f ? clip[i][3] : 1e-7f;
            float nx = clip[i][0]/w, ny = clip[i][1]/w, nz = clip[i][2]/w;
            ndc_to_screen(s, nx, ny, nz, &sx[i], &sy[i], &sz[i]);
        }
        draw_line(color, (int)sx[0],(int)sy[0], (int)sx[1],(int)sy[1], 1,1,1);
        draw_line(color, (int)sx[1],(int)sy[1], (int)sx[2],(int)sy[2], 1,1,1);
        draw_line(color, (int)sx[2],(int)sy[2], (int)sx[0],(int)sy[0], 1,1,1);
    } else {
        rasterize_triangle(s, color, depth, clip, var, varyingCount,
                           0, 0, (int)color->width - 1, (int)color->height - 1);
    }
}

/* Vertex işleme ve çizim fonksiyonu */
static void execute_draw(
    RastState* s,
    const uint8_t* vertBase,
    uint32_t       vertexCount,
    const uint32_t* indices,    /* NULL = dizinlenmemiş */
    uint32_t        indexCount
) {
    GravPipeline pl = s->pipeline;
    if (!pl || !s->framebuffer) return;
    GravImage color = s->framebuffer->colorImage;
    GravImage depth = s->framebuffer->depthImage;
    if (!color) return;

    uint32_t stride  = pl->vertexStride;
    uint32_t nvCount = indices ? indexCount : vertexCount;
    if (nvCount < 3) return;

    /* Maksimum 3 vertex için geçici depolama */
    float clip[3][4];
    float var[3][GRAV_MAX_VARYINGS];
    uint32_t vc = pl->varyingCount;
    int tiled = pl->fillMode == GRAV_FILL_SOLID && s->threadCount > 1;
    size_t triangleCapacity = tiled
        ? (pl->topology == GRAV_TOPOLOGY_TRIANGLE_STRIP
            ? (size_t)(nvCount > 2 ? nvCount - 2 : 0)
            : (size_t)((nvCount + 2) / 3))
        : 0;
    RastTriangle* triangles = tiled && triangleCapacity > 0
        ? malloc(triangleCapacity * sizeof(*triangles)) : NULL;
    if (tiled && !triangles) tiled = 0;
    size_t triangleCount = 0;

    uint32_t triVertices = (pl->topology == GRAV_TOPOLOGY_TRIANGLE_STRIP) ? 1 : 3;

    uint32_t i = 0;
    uint32_t triIdx = 0;

    while (i + 2 < nvCount) {
        uint32_t idxs[3];
        if (pl->topology == GRAV_TOPOLOGY_TRIANGLE_STRIP) {
            idxs[0] = (indices ? indices[i]   : i);
            idxs[1] = (indices ? indices[i+1] : i+1);
            idxs[2] = (indices ? indices[i+2] : i+2);
            if (pl->primitiveRestart &&
                (idxs[0] == UINT32_MAX || idxs[1] == UINT32_MAX || idxs[2] == UINT32_MAX)) {
                i++;
                triIdx = 0;
                continue;
            }
            /* Strip'te çift indexli üçgenleri ters çevir */
            if (triIdx & 1) { uint32_t tmp = idxs[1]; idxs[1]=idxs[2]; idxs[2]=tmp; }
            i++;
        } else {
            idxs[0] = (indices ? indices[i]   : i);
            idxs[1] = (indices ? indices[i+1] : i+1);
            idxs[2] = (indices ? indices[i+2] : i+2);
            if (pl->primitiveRestart &&
                (idxs[0] == UINT32_MAX || idxs[1] == UINT32_MAX || idxs[2] == UINT32_MAX)) {
                i += 3;
                continue;
            }
            i += 3;
        }
        triIdx++;

        /* Her vertex için vert shader çağır */
        for (int v = 0; v < 3; v++) {
            const void* vdata = vertBase + idxs[v] * stride;
            pl->shader->vertFn(vdata, s->uniforms, clip[v], var[v]);
        }

        if (pl->shader->geometryFn) {
            GravGeometryInput in;
            GravGeometryOutput out;
            memset(&in, 0, sizeof(in));
            memset(&out, 0, sizeof(out));
            memcpy(in.clip, clip, sizeof(clip));
            memcpy(in.varyings, var, sizeof(var));
            in.varyingCount = vc;
            in.primitiveId = triIdx - 1;
            in.uniforms = s->uniforms;
            out.vertexCount = 3;
            pl->shader->geometryFn(&in, &out);
            if (out.vertexCount == 3) {
                memcpy(clip, out.clip, sizeof(clip));
                memcpy(var, out.varyings, sizeof(var));
            } else {
                continue;
            }
        }
        if (pl->shader->tessellationFn) {
            GravGeometryOutput out;
            memset(&out, 0, sizeof(out));
            out.vertexCount = 3;
            pl->shader->tessellationFn(s->uniforms, 1.0f, &out);
            if (out.vertexCount == 3) {
                memcpy(clip, out.clip, sizeof(clip));
                memcpy(var, out.varyings, sizeof(var));
            }
        }

        if (tiled && triangleCount < triangleCapacity) {
            memcpy(triangles[triangleCount].clip, clip, sizeof(clip));
            memcpy(triangles[triangleCount].varyings, var, sizeof(var));
            triangleCount++;
        } else {
            draw_triangle(s, color, depth, clip, var, vc);
        }
    }
    if (tiled && triangleCount > 0)
        rasterize_triangles_tiled(s, color, depth, triangles, triangleCount);
    free(triangles);
    (void)triVertices;
}

/* =========================================================================
 * SUBMIT
 * ========================================================================= */

/* GPU backend hook — gpu_backend.c tarafından sağlanır (isteğe bağlı) */
#ifdef GRAVITYON_GPU_BACKEND
extern GravResult gravGPUSubmitFull(GravDevice device, GravCommandBuffer cmdBuf);
extern int gravGPUIsAttached(GravDevice device);
#endif

GravResult gravSubmitCommandBuffer(GravDevice device, GravCommandBuffer cmdBuf) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cmdBuf);
    if (cmdBuf->recording) return GRAV_ERROR_ALREADY_RECORDING;

#ifdef GRAVITYON_GPU_BACKEND
    /* GPU backend bağlıysa oraya yönlendir */
    if (gravGPUIsAttached(device)) {
        return gravGPUSubmitFull(device, cmdBuf);
    }
#endif

    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    RastState state;
    memset(&state, 0, sizeof(state));
    state.threadCount = device->threadCount;

    for (uint32_t i = 0; i < cmdBuf->count; i++) {
        Command* c = &cmdBuf->cmds[i];
        switch (c->type) {

        case CMD_BEGIN_RENDER_PASS: {
            GravRenderPassBeginInfo* bi = &c->beginRenderPass.info;
            state.framebuffer = bi->framebuffer;
            state.inRenderPass = 1;
            /* Viewport ve scissor'ı render alanından başlat */
            state.viewport = (GravViewport){
                .x = (float)bi->renderArea.x,
                .y = (float)bi->renderArea.y,
                .width  = (float)bi->renderArea.width,
                .height = (float)bi->renderArea.height,
                .minDepth = 0.0f,
                .maxDepth = 1.0f
            };
            state.scissor = bi->renderArea;

            GravFramebuffer fb = bi->framebuffer;
            if (!fb) break;
            GravRenderPass rp = bi->renderPass;

            /* Color clear */
            if (rp && rp->color.loadOp == GRAV_LOAD_OP_CLEAR && fb->colorImage) {
                GravColorF cc = bi->clearColor;
                uint8_t r = (uint8_t)(GRAV_CLAMP(cc.r,0,1)*255);
                uint8_t g = (uint8_t)(GRAV_CLAMP(cc.g,0,1)*255);
                uint8_t b = (uint8_t)(GRAV_CLAMP(cc.b,0,1)*255);
                uint8_t a = (uint8_t)(GRAV_CLAMP(cc.a,0,1)*255);
                uint8_t* px = (uint8_t*)fb->colorImage->pixels;
                size_t n = (size_t)fb->colorImage->width * fb->colorImage->height;
                for (size_t p = 0; p < n; p++) {
                    px[p*4+0]=r; px[p*4+1]=g; px[p*4+2]=b; px[p*4+3]=a;
                }
            }
            /* Depth clear */
            if (rp && rp->hasDepth && rp->depth.loadOp == GRAV_LOAD_OP_CLEAR && fb->depthImage) {
                float* dp = (float*)fb->depthImage->pixels;
                size_t n = (size_t)fb->depthImage->width * fb->depthImage->height;
                for (size_t p = 0; p < n; p++) dp[p] = bi->clearDepth;
            }
            break;
        }

        case CMD_END_RENDER_PASS:
            state.inRenderPass = 0;
            break;

        case CMD_BIND_PIPELINE:
            state.pipeline = c->bindPipeline.pipeline;
            /* Pipeline'ın varsayılan viewport/scissor'ını uygula */
            if (state.pipeline) {
                state.viewport = state.pipeline->viewport;
                state.scissor  = state.pipeline->scissor;
                state.uniforms = state.pipeline->uniforms;
            }
            break;

        case CMD_BIND_VERTEX_BUFFER:
            state.vertexBuffer = c->bindVertex.buffer;
            state.vertexOffset = c->bindVertex.offset;
            break;

        case CMD_BIND_INDEX_BUFFER:
            state.indexBuffer = c->bindIndex.buffer;
            state.indexOffset = c->bindIndex.offset;
            break;

        case CMD_SET_VIEWPORT:
            state.viewport = c->setViewport.vp;
            break;

        case CMD_SET_SCISSOR:
            state.scissor = c->setScissor.sc;
            break;

        case CMD_SET_UNIFORMS:
            memcpy(state.uniformData, c->setUniforms.data, c->setUniforms.size);
            state.uniforms = state.uniformData;
            state.uniformSize = c->setUniforms.size;
            break;

        case CMD_DRAW: {
            if (!state.vertexBuffer) break;
            const uint8_t* vbase = (const uint8_t*)state.vertexBuffer->data +
                                   state.vertexOffset + (size_t)c->draw.first *
                                   (state.pipeline ? state.pipeline->vertexStride : 0);
            execute_draw(&state, vbase, c->draw.count, NULL, 0);
            break;
        }

        case CMD_DRAW_INDEXED: {
            if (!state.vertexBuffer || !state.indexBuffer) break;
            const uint8_t*  vbase  = (const uint8_t*)state.vertexBuffer->data + state.vertexOffset;
            const uint32_t* ibase  = (const uint32_t*)((uint8_t*)state.indexBuffer->data + state.indexOffset);
            if (c->drawIndexed.vertexOffset > 0)
                vbase += (size_t)c->drawIndexed.vertexOffset *
                         (state.pipeline ? state.pipeline->vertexStride : 0);
            execute_draw(&state, vbase, 0, ibase + c->drawIndexed.firstIndex, c->drawIndexed.count);
            break;
        }

        case CMD_DRAW_INSTANCED: {
            if (!state.vertexBuffer || !state.pipeline) break;
            const uint8_t* base = (const uint8_t*)state.vertexBuffer->data +
                                  state.vertexOffset +
                                  (size_t)c->drawInstanced.first * state.pipeline->vertexStride;
            for (uint32_t instance = 0; instance < c->drawInstanced.instances; instance++) {
                (void)instance;
                execute_draw(&state, base, c->drawInstanced.count, NULL, 0);
            }
            break;
        }

        case CMD_DRAW_INDIRECT: {
            if (!state.vertexBuffer || !state.pipeline || !c->drawIndirect.args) break;
            if (c->drawIndirect.offset >= c->drawIndirect.args->size) break;
            const uint8_t* raw = (const uint8_t*)c->drawIndirect.args->data +
                                 c->drawIndirect.offset;
            uint64_t available = c->drawIndirect.args->size - c->drawIndirect.offset;
            for (uint32_t draw = 0; draw < c->drawIndirect.drawCount; draw++) {
                if ((uint64_t)draw * c->drawIndirect.stride + 16 > available) break;
                const uint32_t* args = (const uint32_t*)(raw +
                                      (size_t)draw * c->drawIndirect.stride);
                const uint8_t* base = (const uint8_t*)state.vertexBuffer->data +
                                      state.vertexOffset +
                                      (size_t)args[2] * state.pipeline->vertexStride;
                for (uint32_t instance = 0; instance < args[1]; instance++) {
                    (void)instance;
                    execute_draw(&state, base, args[0], NULL, 0);
                }
            }
            break;
        }

        case CMD_DEBUG_MARKER:
            /* Markers are intentionally side-effect free in the software backend. */
            break;

        case CMD_BEGIN_QUERY:
            if (c->query.query) {
                c->query.query->active = 1;
                c->query.query->available = 0;
                c->query.query->value = 0;
                c->query.query->startedNs = 0;
                if (c->query.query->type == GRAV_QUERY_TIMESTAMP) {
                    struct timespec now;
                    clock_gettime(CLOCK_MONOTONIC, &now);
                    c->query.query->startedNs = (uint64_t)now.tv_sec * 1000000000ULL +
                                                 (uint64_t)now.tv_nsec;
                }
                state.query = c->query.query;
                state.querySamples = 0;
            }
            break;

        case CMD_END_QUERY:
            if (c->query.query) {
                if (c->query.query->type == GRAV_QUERY_OCCLUSION)
                    c->query.query->value = state.querySamples;
                else {
                    struct timespec now;
                    clock_gettime(CLOCK_MONOTONIC, &now);
                    c->query.query->value = (uint64_t)now.tv_sec * 1000000000ULL +
                                             (uint64_t)now.tv_nsec;
                }
                c->query.query->active = 0;
                c->query.query->available = 1;
                if (state.query == c->query.query) state.query = NULL;
            }
            break;

        case CMD_CLEAR_COLOR_IMAGE: {
            GravImage img = c->clearColor.image;
            if (!img) break;
            GravColorF cc = c->clearColor.color;
            uint8_t r = (uint8_t)(GRAV_CLAMP(cc.r,0,1)*255);
            uint8_t g = (uint8_t)(GRAV_CLAMP(cc.g,0,1)*255);
            uint8_t b2 = (uint8_t)(GRAV_CLAMP(cc.b,0,1)*255);
            uint8_t a = (uint8_t)(GRAV_CLAMP(cc.a,0,1)*255);
            uint8_t* px = (uint8_t*)img->pixels;
            size_t n = (size_t)img->width * img->height;
            for (size_t p = 0; p < n; p++) {
                px[p*4+0]=r; px[p*4+1]=g; px[p*4+2]=b2; px[p*4+3]=a;
            }
            break;
        }

        } /* switch */
    } /* for */

    clock_gettime(CLOCK_MONOTONIC, &t1);
    device->lastSubmitNs = (uint64_t)(t1.tv_sec - t0.tv_sec) * 1000000000ULL
                         + (uint64_t)(t1.tv_nsec - t0.tv_nsec);
    return GRAV_SUCCESS;
}

uint64_t gravGetLastSubmitTimeNs(GravDevice device) {
    if (!device) return 0;
    return device->lastSubmitNs;
}

/* =========================================================================
 * COMPUTE, QUERY, REFLECTION AND PIPELINE CACHE
 * ========================================================================= */

static void* grav_compute_worker(void* opaque) {
    GravComputeJob* job = (GravComputeJob*)opaque;
    uint32_t gx = job->input.groupX ? job->input.groupX : 1;
    uint32_t gy = job->input.groupY ? job->input.groupY : 1;
    uint32_t gz = job->input.groupZ ? job->input.groupZ : 1;
    uint64_t total = (uint64_t)gx * gy * gz;
    for (uint64_t i = 0; i < total; i++) {
        job->input.invocation = (uint32_t)i;
        job->pipeline->computeFn(&job->input);
    }
    return NULL;
}

static GravResult grav_prepare_compute(GravDevice device,
                                       GravComputePipeline pipeline,
                                       GravBuffer storage,
                                       uint32_t groupX, uint32_t groupY, uint32_t groupZ,
                                       const void* uniforms, size_t uniformSize,
                                       GravComputeJob** outJob) {
    GravComputeJob* job;
    if (!device || !pipeline || !pipeline->computeFn || !storage || !outJob)
        return GRAV_ERROR_INVALID_ARGUMENT;
    if (uniformSize > 0 && !uniforms) return GRAV_ERROR_INVALID_ARGUMENT;
    job = (GravComputeJob*)calloc(1, sizeof(*job));
    if (!job) return GRAV_ERROR_OUT_OF_MEMORY;
    job->pipeline = pipeline;
    job->input.device = device;
    job->input.storage = storage;
    job->input.groupX = groupX;
    job->input.groupY = groupY;
    job->input.groupZ = groupZ;
    job->input.uniformSize = uniformSize;
    if (uniformSize > 0) {
        job->uniforms = malloc(uniformSize);
        if (!job->uniforms) { free(job); return GRAV_ERROR_OUT_OF_MEMORY; }
        memcpy(job->uniforms, uniforms, uniformSize);
        job->input.uniforms = job->uniforms;
    }
    *outJob = job;
    return GRAV_SUCCESS;
}

GravResult gravCreateComputePipeline(GravDevice device,
                                     const GravComputePipelineCreateInfo* info,
                                     GravComputePipeline* pipeline) {
    GravComputePipeline p;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(info);
    GRAV_CHECK_NULL(pipeline);
    if (!info->computeFn) return GRAV_ERROR_INVALID_ARGUMENT;
    p = (GravComputePipeline)calloc(1, sizeof(*p));
    if (!p) return GRAV_ERROR_OUT_OF_MEMORY;
    p->computeFn = info->computeFn;
    if (info->debugName)
        strncpy(p->debugName, info->debugName, sizeof(p->debugName) - 1);
    *pipeline = p;
    return GRAV_SUCCESS;
}

GravResult gravDestroyComputePipeline(GravDevice device, GravComputePipeline pipeline) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(pipeline);
    free(pipeline);
    return GRAV_SUCCESS;
}

GravResult gravDispatchCompute(GravDevice device, GravComputePipeline pipeline,
                               GravBuffer storage, uint32_t groupX,
                               uint32_t groupY, uint32_t groupZ,
                               const void* uniforms, size_t uniformSize) {
    GravComputeJob* job;
    GravResult result = grav_prepare_compute(device, pipeline, storage, groupX, groupY,
                                             groupZ, uniforms, uniformSize, &job);
    if (result != GRAV_SUCCESS) return result;
    grav_compute_worker(job);
    free(job->uniforms);
    free(job);
    return GRAV_SUCCESS;
}

GravResult gravDispatchComputeAsync(GravDevice device, GravComputePipeline pipeline,
                                    GravBuffer storage, uint32_t groupX,
                                    uint32_t groupY, uint32_t groupZ,
                                    const void* uniforms, size_t uniformSize,
                                    uint64_t* jobId) {
    GravComputeJob* job;
    GravResult result;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(jobId);
    result = grav_prepare_compute(device, pipeline, storage, groupX, groupY, groupZ,
                                  uniforms, uniformSize, &job);
    if (result != GRAV_SUCCESS) return result;
    pthread_mutex_lock(&device->computeMutex);
    job->id = device->nextJobId++;
    job->next = device->computeJobs;
    device->computeJobs = job;
    pthread_mutex_unlock(&device->computeMutex);
    if (pthread_create(&job->thread, NULL, grav_compute_worker, job) != 0) {
        pthread_mutex_lock(&device->computeMutex);
        if (device->computeJobs == job) device->computeJobs = job->next;
        else {
            GravComputeJob* p = device->computeJobs;
            while (p && p->next != job) p = p->next;
            if (p) p->next = job->next;
        }
        pthread_mutex_unlock(&device->computeMutex);
        free(job->uniforms);
        free(job);
        return GRAV_ERROR_BUSY;
    }
    *jobId = job->id;
    return GRAV_SUCCESS;
}

GravResult gravWaitCompute(GravDevice device, uint64_t jobId) {
    GravComputeJob *job, *prev = NULL;
    GRAV_CHECK_HANDLE(device);
    if (jobId == 0) return GRAV_ERROR_INVALID_ARGUMENT;
    pthread_mutex_lock(&device->computeMutex);
    job = device->computeJobs;
    while (job && job->id != jobId) {
        prev = job;
        job = job->next;
    }
    if (!job) {
        pthread_mutex_unlock(&device->computeMutex);
        return GRAV_ERROR_INVALID_ARGUMENT;
    }
    if (prev) prev->next = job->next;
    else device->computeJobs = job->next;
    pthread_mutex_unlock(&device->computeMutex);
    if (!job->joined) pthread_join(job->thread, NULL);
    job->joined = 1;
    free(job->uniforms);
    free(job);
    return GRAV_SUCCESS;
}

GravResult gravCreateQuery(GravDevice device, GravQueryType type, GravQuery* query) {
    GravQuery q;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(query);
    if (type != GRAV_QUERY_OCCLUSION && type != GRAV_QUERY_TIMESTAMP)
        return GRAV_ERROR_INVALID_ARGUMENT;
    q = (GravQuery)calloc(1, sizeof(*q));
    if (!q) return GRAV_ERROR_OUT_OF_MEMORY;
    q->type = type;
    *query = q;
    return GRAV_SUCCESS;
}

GravResult gravDestroyQuery(GravDevice device, GravQuery query) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(query);
    if (query->active) return GRAV_ERROR_BUSY;
    free(query);
    return GRAV_SUCCESS;
}

GravResult gravBeginQuery(GravCommandBuffer cmdBuf, GravQuery query) {
    return gravCmdBeginQuery(cmdBuf, query);
}

GravResult gravEndQuery(GravCommandBuffer cmdBuf, GravQuery query) {
    return gravCmdEndQuery(cmdBuf, query);
}

GravResult gravGetQueryResult(GravDevice device, GravQuery query,
                              uint64_t* value, int* available) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(query);
    GRAV_CHECK_NULL(value);
    GRAV_CHECK_NULL(available);
    *value = query->value;
    *available = query->available;
    return query->available ? GRAV_SUCCESS : GRAV_NOT_READY;
}

GravResult gravReflectShader(GravShaderModule shader, GravShaderReflection* reflection) {
    const char* entry;
    size_t entryLength;
    GRAV_CHECK_HANDLE(shader);
    GRAV_CHECK_NULL(reflection);
    memset(reflection, 0, sizeof(*reflection));
    entry = shader->debugName[0] ? shader->debugName : "main";
    entryLength = strlen(entry);
    if (entryLength >= sizeof(reflection->entryPoint))
        entryLength = sizeof(reflection->entryPoint) - 1;
    memcpy(reflection->entryPoint, entry, entryLength);
    reflection->entryPoint[entryLength] = '\0';
    return GRAV_SUCCESS;
}

GravResult gravCreatePipelineCache(GravDevice device, const char* path,
                                   GravPipelineCache* cache) {
    GravPipelineCache c;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(path);
    GRAV_CHECK_NULL(cache);
    c = (GravPipelineCache)calloc(1, sizeof(*c));
    if (!c) return GRAV_ERROR_OUT_OF_MEMORY;
    strncpy(c->path, path, sizeof(c->path) - 1);
    *cache = c;
    return GRAV_SUCCESS;
}

GravResult gravDestroyPipelineCache(GravDevice device, GravPipelineCache cache) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cache);
    free(cache->keys);
    free(cache);
    return GRAV_SUCCESS;
}

GravResult gravPipelineCacheLoad(GravDevice device, GravPipelineCache cache) {
    FILE* f;
    long size;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cache);
    f = fopen(cache->path, "rb");
    if (!f) return GRAV_ERROR_IO;
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return GRAV_ERROR_IO; }
    size = ftell(f);
    if (size < 0 || (unsigned long)size > SIZE_MAX) { fclose(f); return GRAV_ERROR_IO; }
    rewind(f);
    free(cache->keys);
    cache->keys = NULL;
    cache->bytes = 0;
    if (size > 0) {
        cache->keys = (char*)malloc((size_t)size);
        if (!cache->keys) { fclose(f); return GRAV_ERROR_OUT_OF_MEMORY; }
        if (fread(cache->keys, 1, (size_t)size, f) != (size_t)size) {
            free(cache->keys); cache->keys = NULL; fclose(f); return GRAV_ERROR_IO;
        }
        cache->bytes = (size_t)size;
    }
    fclose(f);
    return GRAV_SUCCESS;
}

GravResult gravPipelineCacheSave(GravDevice device, GravPipelineCache cache) {
    FILE* f;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cache);
    f = fopen(cache->path, "wb");
    if (!f) return GRAV_ERROR_IO;
    if (cache->bytes && fwrite(cache->keys, 1, cache->bytes, f) != cache->bytes) {
        fclose(f); return GRAV_ERROR_IO;
    }
    fclose(f);
    return GRAV_SUCCESS;
}

GravResult gravPipelineCacheTouch(GravDevice device, GravPipelineCache cache,
                                  const char* key) {
    size_t len;
    char* next;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(cache);
    GRAV_CHECK_NULL(key);
    len = strlen(key);
    if (len == 0) return GRAV_ERROR_INVALID_ARGUMENT;
    if (cache->bytes >= len &&
        grav_bytes_contain(cache->keys, cache->bytes, key, len))
        return GRAV_SUCCESS;
    next = (char*)realloc(cache->keys, cache->bytes + len + 1);
    if (!next) return GRAV_ERROR_OUT_OF_MEMORY;
    cache->keys = next;
    memcpy(cache->keys + cache->bytes, key, len);
    cache->keys[cache->bytes + len] = '\n';
    cache->bytes += len + 1;
    return GRAV_SUCCESS;
}

/* =========================================================================
 * ÇIKTI: PPM & BMP
 * ========================================================================= */

GravResult gravSaveImagePPM(GravDevice device, GravImage image, const char* path) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    GRAV_CHECK_NULL(path);
    if (image->format == GRAV_FORMAT_D32_SFLOAT) return GRAV_ERROR_INVALID_ARGUMENT;

    FILE* f = fopen(path, "wb");
    if (!f) return GRAV_ERROR_IO;
    fprintf(f, "P6\n%u %u\n255\n", image->width, image->height);
    uint8_t* px = (uint8_t*)image->pixels;
    for (size_t i = 0; i < (size_t)image->width * image->height; i++) {
        fwrite(px + i*4, 1, 3, f);   /* sadece RGB yaz (alpha atla) */
    }
    fclose(f);
    return GRAV_SUCCESS;
}

GravResult gravSaveImageBMP(GravDevice device, GravImage image, const char* path) {
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    GRAV_CHECK_NULL(path);
    if (image->format == GRAV_FORMAT_D32_SFLOAT) return GRAV_ERROR_INVALID_ARGUMENT;

    uint32_t w = image->width, h = image->height;
    uint32_t rowSize   = (w * 3 + 3) & ~3u;
    uint32_t imageSize = rowSize * h;
    uint32_t fileSize  = 54 + imageSize;

    FILE* f = fopen(path, "wb");
    if (!f) return GRAV_ERROR_IO;

    /* BMP dosya başlığı (14 bayt) */
    uint8_t hdr[54] = {0};
    hdr[0]='B'; hdr[1]='M';
    *(uint32_t*)(hdr+ 2) = fileSize;
    *(uint32_t*)(hdr+10) = 54;
    /* DIB başlığı (40 bayt) */
    *(uint32_t*)(hdr+14) = 40;
    *(int32_t*) (hdr+18) = (int32_t)w;
    *(int32_t*) (hdr+22) = -(int32_t)h;  /* negatif = üstten-aşağı */
    *(uint16_t*)(hdr+26) = 1;
    *(uint16_t*)(hdr+28) = 24;
    *(uint32_t*)(hdr+34) = imageSize;
    fwrite(hdr, 1, 54, f);

    uint8_t* px = (uint8_t*)image->pixels;
    uint8_t  pad[4] = {0};
    for (uint32_t y = 0; y < h; y++) {
        for (uint32_t x = 0; x < w; x++) {
            uint8_t* p = px + (y*w+x)*4;
            uint8_t bgr[3] = {p[2], p[1], p[0]};   /* BMP: BGR sırası */
            fwrite(bgr, 1, 3, f);
        }
        uint32_t padBytes = rowSize - w*3;
        if (padBytes) fwrite(pad, 1, padBytes, f);
    }
    fclose(f);
    return GRAV_SUCCESS;
}

/* =========================================================================
 * SAMPLER
 * ========================================================================= */

struct GravSampler_T {
    GravFilterMode minFilter;
    GravFilterMode magFilter;
    GravWrapMode   wrapU;
    GravWrapMode   wrapV;
    float          maxAnisotropy;
};

GravResult gravCreateSampler(GravDevice device,
                              const GravSamplerCreateInfo* pInfo,
                              GravSampler* pSampler)
{
    GravSampler s;
    GRAV_CHECK_NULL(device); GRAV_CHECK_NULL(pInfo); GRAV_CHECK_NULL(pSampler);
    s = (GravSampler)malloc(sizeof(struct GravSampler_T));
    if (!s) return GRAV_ERROR_OUT_OF_MEMORY;
    s->minFilter = pInfo->minFilter;
    s->magFilter = pInfo->magFilter;
    s->wrapU     = pInfo->wrapU;
    s->wrapV     = pInfo->wrapV;
    s->maxAnisotropy = pInfo->maxAnisotropy > 1.0f ? pInfo->maxAnisotropy : 1.0f;
    *pSampler = s;
    return GRAV_SUCCESS;
}

GravResult gravDestroySampler(GravDevice device, GravSampler sampler)
{
    GRAV_CHECK_NULL(device);
    if (sampler) free(sampler);
    return GRAV_SUCCESS;
}

/* UV wrap uygulama */
static float apply_wrap(float t, GravWrapMode mode)
{
    switch (mode) {
    case GRAV_WRAP_CLAMP_TO_EDGE:
        return GRAV_CLAMP(t, 0.0f, 1.0f);
    case GRAV_WRAP_MIRRORED_REPEAT: {
        float i = floorf(t);
        float f = t - i;
        return ((int)i & 1) ? 1.0f - f : f;
    }
    default: /* REPEAT */
        t = t - floorf(t);
        if (t < 0.0f) t += 1.0f;
        return t;
    }
}

void gravSampleTexture(GravSampler sampler, GravImage image,
                       float u, float v, float outColor[4])
{
    uint8_t* px;
    float    fu, fv;
    int      x, y;

    if (!sampler || !image || !image->pixels ||
        image->format != GRAV_FORMAT_R8G8B8A8_UNORM) {
        outColor[0] = outColor[1] = outColor[2] = outColor[3] = 0.0f;
        return;
    }

    fu = apply_wrap(u, sampler->wrapU);
    fv = apply_wrap(v, sampler->wrapV);
    px = (uint8_t*)image->pixels;

    if (sampler->magFilter == GRAV_FILTER_BILINEAR ||
        sampler->magFilter == GRAV_FILTER_ANISOTROPIC) {
        /* Bilinear interpolasyon */
        float sx  = fu * (float)(image->width  - 1);
        float sy  = fv * (float)(image->height - 1);
        int   x0  = (int)sx, y0 = (int)sy;
        int   x1  = GRAV_MIN(x0 + 1, (int)image->width  - 1);
        int   y1  = GRAV_MIN(y0 + 1, (int)image->height - 1);
        float tx  = sx - (float)x0;
        float ty  = sy - (float)y0;
        int   ch;
        uint8_t* p00 = px + (y0 * image->width + x0) * 4;
        uint8_t* p10 = px + (y0 * image->width + x1) * 4;
        uint8_t* p01 = px + (y1 * image->width + x0) * 4;
        uint8_t* p11 = px + (y1 * image->width + x1) * 4;
        for (ch = 0; ch < 4; ch++) {
            float top    = p00[ch] * (1.0f - tx) + p10[ch] * tx;
            float bottom = p01[ch] * (1.0f - tx) + p11[ch] * tx;
            outColor[ch] = (top * (1.0f - ty) + bottom * ty) / 255.0f;
        }
    } else {
        /* Nearest */
        x = (int)(fu * (float)(image->width  - 1) + 0.5f);
        y = (int)(fv * (float)(image->height - 1) + 0.5f);
        x = GRAV_CLAMP(x, 0, (int)image->width  - 1);
        y = GRAV_CLAMP(y, 0, (int)image->height - 1);
        uint8_t* p = px + (y * image->width + x) * 4;
        outColor[0] = p[0] / 255.0f;
        outColor[1] = p[1] / 255.0f;
        outColor[2] = p[2] / 255.0f;
        outColor[3] = p[3] / 255.0f;
    }
}

static void grav_sample_level(GravSampler sampler, const uint8_t* pixels,
                              uint32_t width, uint32_t height,
                              float u, float v, float outColor[4]) {
    struct GravImage_T level;
    memset(&level, 0, sizeof(level));
    level.width = width;
    level.height = height;
    level.format = GRAV_FORMAT_R8G8B8A8_UNORM;
    level.pixels = (void*)pixels;
    gravSampleTexture(sampler, &level, u, v, outColor);
}

GravResult gravGenerateMipmaps(GravDevice device, GravImage image, GravMipInfo* mips) {
    uint32_t width, height, level;
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_HANDLE(image);
    GRAV_CHECK_NULL(mips);
    if (image->format != GRAV_FORMAT_R8G8B8A8_UNORM || !image->pixels ||
        image->width == 0 || image->height == 0)
        return GRAV_ERROR_INVALID_ARGUMENT;
    memset(mips, 0, sizeof(*mips));
    width = image->width;
    height = image->height;
    mips->width[0] = width;
    mips->height[0] = height;
    mips->levels[0] = (uint8_t*)image->pixels;
    mips->levelCount = 1;
    while ((width > 1 || height > 1) && mips->levelCount < 16) {
        level = mips->levelCount - 1;
        uint32_t nextWidth = width > 1 ? width / 2 : 1;
        uint32_t nextHeight = height > 1 ? height / 2 : 1;
        size_t bytes = (size_t)nextWidth * nextHeight * 4;
        uint8_t* dst = (uint8_t*)malloc(bytes);
        if (!dst) {
            gravDestroyMipmaps(mips);
            return GRAV_ERROR_OUT_OF_MEMORY;
        }
        for (uint32_t y = 0; y < nextHeight; y++) {
            for (uint32_t x = 0; x < nextWidth; x++) {
                uint32_t sx = x * 2, sy = y * 2;
                uint32_t sum[4] = {0, 0, 0, 0};
                uint32_t samples = 0;
                for (uint32_t oy = 0; oy < 2; oy++) {
                    for (uint32_t ox = 0; ox < 2; ox++) {
                        uint32_t px = sx + ox, py = sy + oy;
                        if (px < width && py < height) {
                            const uint8_t* src = mips->levels[level] +
                                ((size_t)py * width + px) * 4;
                            for (uint32_t c = 0; c < 4; c++) sum[c] += src[c];
                            samples++;
                        }
                    }
                }
                uint8_t* out = dst + ((size_t)y * nextWidth + x) * 4;
                for (uint32_t c = 0; c < 4; c++)
                    out[c] = (uint8_t)(sum[c] / (samples ? samples : 1));
            }
        }
        level = mips->levelCount;
        mips->levels[level] = dst;
        mips->width[level] = nextWidth;
        mips->height[level] = nextHeight;
        mips->levelCount++;
        width = nextWidth;
        height = nextHeight;
    }
    return GRAV_SUCCESS;
}

void gravDestroyMipmaps(GravMipInfo* mips) {
    if (!mips) return;
    for (uint32_t i = 1; i < mips->levelCount && i < 16; i++)
        free(mips->levels[i]);
    memset(mips, 0, sizeof(*mips));
}

void gravSampleTextureLod(GravSampler sampler, const GravMipInfo* mips,
                          float u, float v, float lod, float outColor[4]) {
    int index;
    float t;
    float a[4], b[4];
    if (!outColor) return;
    if (!sampler || !mips || mips->levelCount == 0) {
        outColor[0] = outColor[1] = outColor[2] = outColor[3] = 0.0f;
        return;
    }
    lod = GRAV_CLAMP(lod, 0.0f, (float)mips->levelCount - 1.0f);
    index = (int)floorf(lod);
    t = lod - (float)index;
    grav_sample_level(sampler, mips->levels[index], mips->width[index],
                      mips->height[index], u, v, a);
    if (t <= 0.001f || index + 1 >= (int)mips->levelCount) {
        memcpy(outColor, a, sizeof(a));
        return;
    }
    grav_sample_level(sampler, mips->levels[index + 1], mips->width[index + 1],
                      mips->height[index + 1], u, v, b);
    for (int c = 0; c < 4; c++) outColor[c] = a[c] + (b[c] - a[c]) * t;
}

static size_t grav_rle_size(const uint8_t* input, size_t bytes) {
    size_t i = 0, out = 0;
    while (i < bytes) {
        size_t run = 1;
        while (i + run < bytes && run < 255 && input[i + run] == input[i]) run++;
        out += run >= 3 ? 3 : run + 1;
        i += run;
    }
    return out;
}

GravResult gravCompressVertices(const void* input, size_t inputBytes,
                                GravVertexCompression mode, void* output,
                                size_t outputBytes, size_t* writtenBytes) {
    const uint8_t* src = (const uint8_t*)input;
    uint8_t* dst = (uint8_t*)output;
    size_t i = 0, out = 0;
    GRAV_CHECK_NULL(input);
    GRAV_CHECK_NULL(output);
    GRAV_CHECK_NULL(writtenBytes);
    if (mode == GRAV_VERTEX_COMPRESSION_NONE) {
        if (outputBytes < inputBytes) return GRAV_ERROR_OUT_OF_RANGE;
        memcpy(output, input, inputBytes);
        *writtenBytes = inputBytes;
        return GRAV_SUCCESS;
    }
    if (mode != GRAV_VERTEX_COMPRESSION_QUANTIZED16)
        return GRAV_ERROR_UNSUPPORTED;
    if (outputBytes < grav_rle_size(src, inputBytes))
        return GRAV_ERROR_OUT_OF_RANGE;
    while (i < inputBytes) {
        size_t run = 1;
        while (i + run < inputBytes && run < 255 && src[i + run] == src[i]) run++;
        if (run >= 3) {
            dst[out++] = 0;
            dst[out++] = (uint8_t)run;
            dst[out++] = src[i];
        } else {
            for (size_t j = 0; j < run; j++) {
                dst[out++] = 1;
                dst[out++] = src[i + j];
            }
        }
        i += run;
    }
    *writtenBytes = out;
    return GRAV_SUCCESS;
}

GravResult gravDecompressVertices(const void* input, size_t inputBytes,
                                  GravVertexCompression mode, void* output,
                                  size_t outputBytes, size_t originalBytes) {
    const uint8_t* src = (const uint8_t*)input;
    uint8_t* dst = (uint8_t*)output;
    size_t i = 0, out = 0;
    GRAV_CHECK_NULL(input);
    GRAV_CHECK_NULL(output);
    if (mode == GRAV_VERTEX_COMPRESSION_NONE) {
        if (outputBytes < originalBytes || inputBytes < originalBytes)
            return GRAV_ERROR_OUT_OF_RANGE;
        memcpy(output, input, originalBytes);
        return GRAV_SUCCESS;
    }
    if (mode != GRAV_VERTEX_COMPRESSION_QUANTIZED16)
        return GRAV_ERROR_UNSUPPORTED;
    while (i < inputBytes && out < originalBytes) {
        uint8_t tag = src[i++];
        if (tag == 0) {
            if (i + 1 >= inputBytes) return GRAV_ERROR_INVALID_ARGUMENT;
            uint32_t count = src[i++];
            uint8_t value = src[i++];
            if ((size_t)count > outputBytes - out ||
                (size_t)count > originalBytes - out)
                return GRAV_ERROR_OUT_OF_RANGE;
            memset(dst + out, value, count);
            out += count;
        } else if (tag == 1) {
            if (i >= inputBytes || out >= outputBytes) return GRAV_ERROR_OUT_OF_RANGE;
            dst[out++] = src[i++];
        } else {
            return GRAV_ERROR_INVALID_ARGUMENT;
        }
    }
    if (out != originalBytes) return GRAV_ERROR_INVALID_ARGUMENT;
    return GRAV_SUCCESS;
}

GravResult gravCreateImageFromRGBA(GravDevice device,
                                    uint32_t width, uint32_t height,
                                    const uint8_t* pixels,
                                    GravImage* pImage)
{
    GravImageCreateInfo info;
    GravResult r;
    info.extent.width  = width;
    info.extent.height = height;
    info.format = GRAV_FORMAT_R8G8B8A8_UNORM;
    info.usage  = GRAV_IMAGE_USAGE_SAMPLED | GRAV_IMAGE_USAGE_COLOR_ATTACHMENT;
    r = gravCreateImage(device, &info, pImage);
    if (r != GRAV_SUCCESS) return r;
    memcpy((*pImage)->pixels, pixels, (size_t)(width * height * 4));
    return GRAV_SUCCESS;
}

/* =========================================================================
 * TEXTURE YÜKLEYICILER — BMP & PNG Dosyasından GravImage
 * ========================================================================= */

/* ── Yardımcı: 4-byte little-endian oku ── */
static uint32_t _read_le32(const uint8_t* p)
{
    return (uint32_t)p[0]
         | ((uint32_t)p[1] << 8)
         | ((uint32_t)p[2] << 16)
         | ((uint32_t)p[3] << 24);
}
static uint16_t _read_le16(const uint8_t* p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}
static uint32_t _read_be32(const uint8_t* p)
{
    return ((uint32_t)p[0] << 24)
         | ((uint32_t)p[1] << 16)
         | ((uint32_t)p[2] << 8)
         |  (uint32_t)p[3];
}

/* ─────────────────────────────────────────────────────────────────────────
 * gravLoadImageBMP — 24-bit ve 32-bit sıkıştırılmamış BMP yükleyici
 * ───────────────────────────────────────────────────────────────────────── */
GravResult gravLoadImageBMP(GravDevice device, const char* path, GravImage* pImage)
{
    FILE*    f   = NULL;
    uint8_t* buf = NULL;
    uint8_t* rgba = NULL;
    GravResult ret = GRAV_ERROR_IO;

    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(path);
    GRAV_CHECK_NULL(pImage);

    f = fopen(path, "rb");
    if (!f) return GRAV_ERROR_IO;

    /* Dosya boyutunu bul */
    fseek(f, 0, SEEK_END);
    long fsz = ftell(f);
    rewind(f);
    if (fsz < 54) { fclose(f); return GRAV_ERROR_IO; }

    buf = (uint8_t*)malloc((size_t)fsz);
    if (!buf) { fclose(f); return GRAV_ERROR_OUT_OF_MEMORY; }
    if ((long)fread(buf, 1, (size_t)fsz, f) != fsz) { free(buf); fclose(f); return GRAV_ERROR_IO; }
    fclose(f); f = NULL;

    /* BMP imzası kontrol */
    if (buf[0] != 'B' || buf[1] != 'M') { ret = GRAV_ERROR_INVALID_ARGUMENT; goto fail; }

    /* Piksel verisi offseti */
    uint32_t pix_offset = _read_le32(buf + 10);

    /* DIB başlığı (BITMAPINFOHEADER: offset 14, boyut 40) */
    uint32_t dib_size  = _read_le32(buf + 14);
    if (dib_size < 40)   { ret = GRAV_ERROR_INVALID_ARGUMENT; goto fail; }

    int32_t  bmp_w   = (int32_t)_read_le32(buf + 18);
    int32_t  bmp_h   = (int32_t)_read_le32(buf + 22);
    uint16_t bpp     = _read_le16(buf + 28);
    uint32_t compr   = _read_le32(buf + 30);

    if (compr != 0 && compr != 3) { ret = GRAV_ERROR_INVALID_ARGUMENT; goto fail; }
    if (bpp != 24 && bpp != 32)   { ret = GRAV_ERROR_INVALID_ARGUMENT; goto fail; }
    if (bmp_w <= 0 || bmp_w > 16384) { ret = GRAV_ERROR_INVALID_ARGUMENT; goto fail; }

    /* Negatif yükseklik = üstten aşağıya; pozitif = alttan yukarıya */
    int      flip = (bmp_h > 0);
    uint32_t W    = (uint32_t)bmp_w;
    uint32_t H    = (uint32_t)(bmp_h < 0 ? -bmp_h : bmp_h);

    uint32_t row_stride = (bpp == 24) ? (W * 3 + 3) & ~3u : W * 4u;

    if (pix_offset + row_stride * H > (uint32_t)fsz) { ret = GRAV_ERROR_IO; goto fail; }

    rgba = (uint8_t*)malloc((size_t)(W * H * 4));
    if (!rgba) { ret = GRAV_ERROR_OUT_OF_MEMORY; goto fail; }

    for (uint32_t row = 0; row < H; row++) {
        /* BMP alttan yukarıya → flip edilirse son satır ilk satır */
        uint32_t src_row = flip ? (H - 1 - row) : row;
        const uint8_t* src = buf + pix_offset + src_row * row_stride;
        uint8_t*       dst = rgba + row * W * 4;

        for (uint32_t x = 0; x < W; x++) {
            if (bpp == 24) {
                dst[0] = src[2]; /* R */
                dst[1] = src[1]; /* G */
                dst[2] = src[0]; /* B */
                dst[3] = 0xFF;   /* A (opak) */
                src += 3;
            } else { /* 32-bit: BGRA veya RGBA — compr=3 ile mask kontrol edilebilir */
                dst[0] = src[2]; /* R */
                dst[1] = src[1]; /* G */
                dst[2] = src[0]; /* B */
                dst[3] = src[3]; /* A */
                src += 4;
            }
            dst += 4;
        }
    }

    ret = gravCreateImageFromRGBA(device, W, H, rgba, pImage);

fail:
    free(rgba);
    free(buf);
    return ret;
}

/* ─────────────────────────────────────────────────────────────────────────
 * gravLoadImagePNG — stb_image.h tabanlı PNG yükleyici
 *
 * stb_image.h: tek dosya, sıfır sistem bağımlılığı, public domain.
 * PNG, BMP, JPG, TGA, GIF destekler.
 * Derleme: sadece -I<gravityon_dizini> yeterli; ekstra kütüphane gerekmez.
 * ───────────────────────────────────────────────────────────────────────── */

/* stb_image: sadece bu çeviri biriminde uygulamayı derle */
#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_PNG
#define STBI_ONLY_BMP
#define STBI_NO_STDIO   /* kendi fopen kullanacağız — değil, STDIO lazım */
#undef  STBI_NO_STDIO
#include "stb_image.h"

GravResult gravLoadImagePNG(GravDevice device, const char* path, GravImage* pImage)
{
    GRAV_CHECK_HANDLE(device);
    GRAV_CHECK_NULL(path);
    GRAV_CHECK_NULL(pImage);

    int w, h, ch;
    /* stbi_load: RGBA8 olarak oku (istenen kanal = 4) */
    unsigned char* pixels = stbi_load(path, &w, &h, &ch, 4);
    if (!pixels) {
        fprintf(stderr, "[Gravityon] gravLoadImagePNG: '%s' yüklenemedi — %s\n",
                path, stbi_failure_reason());
        return GRAV_ERROR_IO;
    }

    GravResult r = gravCreateImageFromRGBA(device,
                                           (uint32_t)w, (uint32_t)h,
                                           pixels, pImage);
    stbi_image_free(pixels);
    return r;
}

/* =========================================================================
 * FONT / METİN RENDERING
 *
 * 5×7 bit-map font — ASCII 32-126.
 * Her karakter 5 sütun × 7 satır; her sütun bir uint8_t bitmask (bit6=üst).
 * ========================================================================= */

/* Karakter başına 5 bayt; indeks = ch - 32 */
static const uint8_t FONT5x7[][5] = {
    {0x00,0x00,0x00,0x00,0x00}, /* ' ' */
    {0x00,0x00,0x5F,0x00,0x00}, /* '!' */
    {0x00,0x07,0x00,0x07,0x00}, /* '"' */
    {0x14,0x7F,0x14,0x7F,0x14}, /* '#' */
    {0x24,0x2A,0x7F,0x2A,0x12}, /* '$' */
    {0x23,0x13,0x08,0x64,0x62}, /* '%' */
    {0x36,0x49,0x55,0x22,0x50}, /* '&' */
    {0x00,0x05,0x03,0x00,0x00}, /* '\'' */
    {0x00,0x1C,0x22,0x41,0x00}, /* '(' */
    {0x00,0x41,0x22,0x1C,0x00}, /* ')' */
    {0x08,0x2A,0x1C,0x2A,0x08}, /* '*' */
    {0x08,0x08,0x3E,0x08,0x08}, /* '+' */
    {0x00,0x50,0x30,0x00,0x00}, /* ',' */
    {0x08,0x08,0x08,0x08,0x08}, /* '-' */
    {0x00,0x60,0x60,0x00,0x00}, /* '.' */
    {0x20,0x10,0x08,0x04,0x02}, /* '/' */
    {0x3E,0x51,0x49,0x45,0x3E}, /* '0' */
    {0x00,0x42,0x7F,0x40,0x00}, /* '1' */
    {0x42,0x61,0x51,0x49,0x46}, /* '2' */
    {0x21,0x41,0x45,0x4B,0x31}, /* '3' */
    {0x18,0x14,0x12,0x7F,0x10}, /* '4' */
    {0x27,0x45,0x45,0x45,0x39}, /* '5' */
    {0x3C,0x4A,0x49,0x49,0x30}, /* '6' */
    {0x01,0x71,0x09,0x05,0x03}, /* '7' */
    {0x36,0x49,0x49,0x49,0x36}, /* '8' */
    {0x06,0x49,0x49,0x29,0x1E}, /* '9' */
    {0x00,0x36,0x36,0x00,0x00}, /* ':' */
    {0x00,0x56,0x36,0x00,0x00}, /* ';' */
    {0x00,0x08,0x14,0x22,0x41}, /* '<' */
    {0x14,0x14,0x14,0x14,0x14}, /* '=' */
    {0x41,0x22,0x14,0x08,0x00}, /* '>' */
    {0x02,0x01,0x51,0x09,0x06}, /* '?' */
    {0x32,0x49,0x79,0x41,0x3E}, /* '@' */
    {0x7E,0x11,0x11,0x11,0x7E}, /* 'A' */
    {0x7F,0x49,0x49,0x49,0x36}, /* 'B' */
    {0x3E,0x41,0x41,0x41,0x22}, /* 'C' */
    {0x7F,0x41,0x41,0x22,0x1C}, /* 'D' */
    {0x7F,0x49,0x49,0x49,0x41}, /* 'E' */
    {0x7F,0x09,0x09,0x09,0x01}, /* 'F' */
    {0x3E,0x41,0x49,0x49,0x7A}, /* 'G' */
    {0x7F,0x08,0x08,0x08,0x7F}, /* 'H' */
    {0x00,0x41,0x7F,0x41,0x00}, /* 'I' */
    {0x20,0x40,0x41,0x3F,0x01}, /* 'J' */
    {0x7F,0x08,0x14,0x22,0x41}, /* 'K' */
    {0x7F,0x40,0x40,0x40,0x40}, /* 'L' */
    {0x7F,0x02,0x04,0x02,0x7F}, /* 'M' */
    {0x7F,0x04,0x08,0x10,0x7F}, /* 'N' */
    {0x3E,0x41,0x41,0x41,0x3E}, /* 'O' */
    {0x7F,0x09,0x09,0x09,0x06}, /* 'P' */
    {0x3E,0x41,0x51,0x21,0x5E}, /* 'Q' */
    {0x7F,0x09,0x19,0x29,0x46}, /* 'R' */
    {0x46,0x49,0x49,0x49,0x31}, /* 'S' */
    {0x01,0x01,0x7F,0x01,0x01}, /* 'T' */
    {0x3F,0x40,0x40,0x40,0x3F}, /* 'U' */
    {0x1F,0x20,0x40,0x20,0x1F}, /* 'V' */
    {0x3F,0x40,0x38,0x40,0x3F}, /* 'W' */
    {0x63,0x14,0x08,0x14,0x63}, /* 'X' */
    {0x07,0x08,0x70,0x08,0x07}, /* 'Y' */
    {0x61,0x51,0x49,0x45,0x43}, /* 'Z' */
    {0x00,0x7F,0x41,0x41,0x00}, /* '[' */
    {0x02,0x04,0x08,0x10,0x20}, /* '\\' */
    {0x00,0x41,0x41,0x7F,0x00}, /* ']' */
    {0x04,0x02,0x01,0x02,0x04}, /* '^' */
    {0x40,0x40,0x40,0x40,0x40}, /* '_' */
    {0x00,0x01,0x02,0x04,0x00}, /* '`' */
    {0x20,0x54,0x54,0x54,0x78}, /* 'a' */
    {0x7F,0x48,0x44,0x44,0x38}, /* 'b' */
    {0x38,0x44,0x44,0x44,0x20}, /* 'c' */
    {0x38,0x44,0x44,0x48,0x7F}, /* 'd' */
    {0x38,0x54,0x54,0x54,0x18}, /* 'e' */
    {0x08,0x7E,0x09,0x01,0x02}, /* 'f' */
    {0x08,0x14,0x54,0x54,0x3C}, /* 'g' */
    {0x7F,0x08,0x04,0x04,0x78}, /* 'h' */
    {0x00,0x44,0x7D,0x40,0x00}, /* 'i' */
    {0x20,0x40,0x44,0x3D,0x00}, /* 'j' */
    {0x7F,0x10,0x28,0x44,0x00}, /* 'k' */
    {0x00,0x41,0x7F,0x40,0x00}, /* 'l' */
    {0x7C,0x04,0x18,0x04,0x78}, /* 'm' */
    {0x7C,0x08,0x04,0x04,0x78}, /* 'n' */
    {0x38,0x44,0x44,0x44,0x38}, /* 'o' */
    {0x7C,0x14,0x14,0x14,0x08}, /* 'p' */
    {0x08,0x14,0x14,0x18,0x7C}, /* 'q' */
    {0x7C,0x08,0x04,0x04,0x08}, /* 'r' */
    {0x48,0x54,0x54,0x54,0x20}, /* 's' */
    {0x04,0x3F,0x44,0x40,0x20}, /* 't' */
    {0x3C,0x40,0x40,0x20,0x7C}, /* 'u' */
    {0x1C,0x20,0x40,0x20,0x1C}, /* 'v' */
    {0x3C,0x40,0x30,0x40,0x3C}, /* 'w' */
    {0x44,0x28,0x10,0x28,0x44}, /* 'x' */
    {0x0C,0x50,0x50,0x50,0x3C}, /* 'y' */
    {0x44,0x64,0x54,0x4C,0x44}, /* 'z' */
    {0x00,0x08,0x36,0x41,0x00}, /* '{' */
    {0x00,0x00,0x7F,0x00,0x00}, /* '|' */
    {0x00,0x41,0x36,0x08,0x00}, /* '}' */
    {0x08,0x04,0x08,0x10,0x08}, /* '~' */
};

#define FONT_W 5
#define FONT_H 7
#define FONT_GAP 1   /* karakter arası boşluk */

/* Hedef image'e tek piksel yaz (sınır kontrolü dahil) */
static void font_put_pixel(GravImage image, int x, int y, const uint8_t color[4])
{
    uint8_t* px;
    if (x < 0 || y < 0 || (uint32_t)x >= image->width || (uint32_t)y >= image->height)
        return;
    px = (uint8_t*)image->pixels + (y * (int)image->width + x) * 4;
    px[0] = color[0];
    px[1] = color[1];
    px[2] = color[2];
    px[3] = color[3];
}

GravResult gravDrawChar(GravImage image, int x, int y, char ch,
                        const uint8_t fgColor[4],
                        const uint8_t bgColor[4],
                        int scale)
{
    int col, row, sx, sy;
    unsigned char uc = (unsigned char)ch;

    GRAV_CHECK_NULL(image);
    if (scale < 1) scale = 1;
    if (uc < 32 || uc > 126) uc = '?';

    for (col = 0; col < FONT_W; col++) {
        uint8_t bits = FONT5x7[uc - 32][col];
        for (row = 0; row < FONT_H; row++) {
            int on = (bits >> row) & 1;
            for (sy = 0; sy < scale; sy++) {
                for (sx = 0; sx < scale; sx++) {
                    int px_x = x + col * scale + sx;
                    int px_y = y + row * scale + sy;
                    if (on)
                        font_put_pixel(image, px_x, px_y, fgColor);
                    else if (bgColor)
                        font_put_pixel(image, px_x, px_y, bgColor);
                }
            }
        }
    }
    return GRAV_SUCCESS;
}

GravResult gravDrawText(GravImage image, int x, int y, const char* text,
                        const uint8_t fgColor[4],
                        const uint8_t bgColor[4],
                        int scale)
{
    int cx = x, cy = y;
    int char_w, char_h;
    const char* p;

    GRAV_CHECK_NULL(image); GRAV_CHECK_NULL(text);
    if (scale < 1) scale = 1;
    char_w = (FONT_W + FONT_GAP) * scale;
    char_h = (FONT_H + FONT_GAP) * scale;

    for (p = text; *p; p++) {
        if (*p == '\n') {
            cx = x;
            cy += char_h;
            continue;
        }
        if (*p == '\r') continue;
        /* Sağ kenar sarma */
        if ((uint32_t)(cx + char_w) > image->width) {
            cx = x;
            cy += char_h;
        }
        gravDrawChar(image, cx, cy, *p, fgColor, bgColor, scale);
        cx += char_w;
    }
    return GRAV_SUCCESS;
}

int gravMeasureTextWidth(const char* text, int scale)
{
    int maxw = 0, cur = 0;
    int char_w;
    const char* p;
    if (!text || scale < 1) return 0;
    char_w = (FONT_W + FONT_GAP) * scale;
    for (p = text; *p; p++) {
        if (*p == '\n') { if (cur > maxw) maxw = cur; cur = 0; }
        else cur += char_w;
    }
    if (cur > maxw) maxw = cur;
    return maxw;
}

int gravMeasureTextHeight(const char* text, int scale)
{
    int lines = 1;
    const char* p;
    if (!text || scale < 1) return 0;
    for (p = text; *p; p++)
        if (*p == '\n') lines++;
    return lines * (FONT_H + FONT_GAP) * scale;
}

/* =========================================================================
 * ANİMASYON DÖNGÜSÜ
 * ========================================================================= */

#ifdef _WIN32
#  include <windows.h>
static double _grav_time_now(void)
{
    LARGE_INTEGER freq, cnt;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&cnt);
    return (double)cnt.QuadPart / (double)freq.QuadPart;
}
#else
static double _grav_time_now(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + (double)ts.tv_nsec * 1e-9;
}
#endif

double gravTimeNow(void) { return _grav_time_now(); }

void gravAnimLoopInit(GravAnimLoop* loop, double targetFps)
{
    if (!loop) return;
    loop->targetFps    = targetFps;
    loop->lastFrameTime = _grav_time_now();
    loop->deltaTime    = 0.0;
    loop->frameCount   = 0;
    loop->fpsSmooth    = targetFps > 0.0 ? targetFps : 60.0;
}

double gravAnimLoopTick(GravAnimLoop* loop)
{
    double now, dt, frame_budget;
    if (!loop) return 0.0;

    if (loop->targetFps > 0.0) {
        frame_budget = 1.0 / loop->targetFps;
        /* Kalan süreyi uyu */
        {
            double elapsed = _grav_time_now() - loop->lastFrameTime;
            if (elapsed < frame_budget) {
                double sleep_s = frame_budget - elapsed;
#ifdef _WIN32
                Sleep((DWORD)(sleep_s * 1000.0));
#else
                struct timespec req;
                req.tv_sec  = (time_t)sleep_s;
                req.tv_nsec = (long)((sleep_s - (double)req.tv_sec) * 1e9);
                nanosleep(&req, NULL);
#endif
            }
        }
    }

    now = _grav_time_now();
    dt  = now - loop->lastFrameTime;
    if (dt <= 0.0) dt = 1e-6;
    loop->lastFrameTime = now;
    loop->deltaTime     = dt;
    loop->frameCount++;

    /* Düzleştirilmiş FPS: %90 eski + %10 anlık */
    loop->fpsSmooth = loop->fpsSmooth * 0.9 + (1.0 / dt) * 0.1;

    return dt;
}
