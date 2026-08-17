/*
 * render_gui.c — Gravityon kamera destekli render + BGRA blit
 *
 * render.c'deki sabit kameradan farklı olarak bu modül,
 * dışarıdan gelen Camera pozisyonu ve açısını kullanır.
 */

#include "render_gui.h"
#include "mesher.h"
#include "../gravityon/gravityon.h"
#include "../gravityon/gravityon_math.h"

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* voxel_gui.c'deki Camera tanımına erişim */
typedef struct Camera {
    float x, y, z;
    float yaw;
    float pitch;
} Camera;

/* ── Vertex/Uniform yapıları (render.c ile aynı) ─────────────────── */
typedef struct RVtx {
    float position[4];
    float normal[4];
    float uv[4];
    float block_id;
} RVtx;

typedef struct RUni {
    float mvp[16];
    float model[16];
    float light_direction[4];
} RUni;

/* ── Shader'lar ──────────────────────────────────────────────────── */
static void vert_fn(const void *vd, const void *ud,
                    float op[4], float *ov)
{
    const RVtx *v = (const RVtx *)vd;
    const RUni *u = (const RUni *)ud;
    const float *m = u->mvp;
    const float *mo = u->model;
    float px = v->position[0], py = v->position[1], pz = v->position[2];

    op[0] = m[0]*px + m[4]*py + m[8]*pz  + m[12];
    op[1] = m[1]*px + m[5]*py + m[9]*pz  + m[13];
    op[2] = m[2]*px + m[6]*py + m[10]*pz + m[14];
    op[3] = m[3]*px + m[7]*py + m[11]*pz + m[15];

    ov[0] = mo[0]*v->normal[0] + mo[4]*v->normal[1] + mo[8]*v->normal[2];
    ov[1] = mo[1]*v->normal[0] + mo[5]*v->normal[1] + mo[9]*v->normal[2];
    ov[2] = mo[2]*v->normal[0] + mo[6]*v->normal[1] + mo[10]*v->normal[2];
    ov[3] = v->uv[0];
    ov[4] = v->uv[1];
    ov[5] = v->block_id;
}

static void frag_fn(const float *vr, const void *ud, float oc[4])
{
    const RUni *u = (const RUni *)ud;
    float nx = vr[0], ny = vr[1], nz = vr[2];
    float len = sqrtf(nx*nx + ny*ny + nz*nz);
    float lx = u->light_direction[0];
    float ly = u->light_direction[1];
    float lz = u->light_direction[2];
    float ll  = sqrtf(lx*lx + ly*ly + lz*lz);
    int bi = (int)vr[5] & 3;
    int cx = (int)(vr[3]*2.0f) & 1;
    int cy = (int)(vr[4]*2.0f) & 1;
    float chk = (cx ^ cy) ? 1.0f : 0.78f;
    float br, bg, bb;
    float diff;

    if (len > 1e-6f) { nx/=len; ny/=len; nz/=len; }
    if (ll  > 1e-6f) { lx/=ll;  ly/=ll;  lz/=ll;  }
    diff = nx*lx + ny*ly + nz*lz;
    if (diff < 0.0f) diff = 0.0f;

    if      (bi == 1) { br=0.30f; bg=0.68f; bb=0.32f; }
    else if (bi == 2) { br=0.62f; bg=0.40f; bb=0.20f; }
    else if (bi == 3) { br=0.28f; bg=0.48f; bb=0.75f; }
    else              { br=0.72f; bg=0.72f; bb=0.72f; }

    float lit = 0.18f + 0.82f * diff;
    oc[0] = lit * br * chk;
    oc[1] = lit * bg * chk;
    oc[2] = lit * bb * chk;
    oc[3] = 1.0f;
}

/* ── Ana render fonksiyonu ───────────────────────────────────────── */
int render_to_bgra(World *world, const Camera *cam,
                   uint8_t *out_bgra, uint32_t width, uint32_t height)
{
    const MesherConfig cfg = {4u, 4u};
    Mesh mesh;
    RVtx *vertices = NULL;
    GravInstance inst = NULL;
    GravDevice dev = NULL;
    GravImage col = NULL, dep = NULL;
    GravRenderPass rp = NULL;
    GravFramebuffer fb = NULL;
    GravShaderModule sh = NULL;
    GravPipeline pip = NULL;
    GravBuffer vbuf = NULL, ibuf = NULL;
    GravCommandBuffer cmd = NULL;
    RUni uni;
    void *mapped;
    int status = -1;

    /* Chunk al */
    Chunk *chunk = world_get_or_create_chunk(world, 0, 0, 0);
    if (!chunk) return -1;

    mesh_init(&mesh);
    if (mesher_build_chunk(world, chunk, &cfg, &mesh) != 0)
        goto cleanup;

    if (mesh.vertex_count > 0) {
        vertices = (RVtx *)malloc(mesh.vertex_count * sizeof(*vertices));
        if (!vertices) goto cleanup;
        size_t i;
        for (i = 0; i < mesh.vertex_count; ++i) {
            const MesherVertex *s = &mesh.vertices[i];
            RVtx *t = &vertices[i];
            t->position[0]=s->x; t->position[1]=s->y;
            t->position[2]=s->z; t->position[3]=1.0f;
            t->normal[0]=s->nx; t->normal[1]=s->ny;
            t->normal[2]=s->nz; t->normal[3]=0.0f;
            t->uv[0]=s->u; t->uv[1]=s->v;
            t->uv[2]=0.0f; t->uv[3]=0.0f;
            t->block_id=(float)s->block;
        }
    }

    /* Gravityon nesneleri */
    if (gravCreateInstance(&(GravInstanceCreateInfo){
            .appName="OxalynVoxelGUI",
            .appVersion=GRAV_MAKE_VERSION(0,1,0),
            .apiVersion=GRAV_API_VERSION}, &inst) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateDevice(inst, &(GravDeviceCreateInfo){.threadCount=1}, &dev)
            != GRAV_SUCCESS) goto cleanup;

    if (gravCreateImage(dev, &(GravImageCreateInfo){
            .extent={width,height},
            .format=GRAV_FORMAT_R8G8B8A8_UNORM,
            .usage=GRAV_IMAGE_USAGE_COLOR_ATTACHMENT}, &col) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateImage(dev, &(GravImageCreateInfo){
            .extent={width,height},
            .format=GRAV_FORMAT_D32_SFLOAT,
            .usage=GRAV_IMAGE_USAGE_DEPTH_ATTACHMENT}, &dep) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateRenderPass(dev, &(GravRenderPassCreateInfo){
            .colorAttachment={GRAV_FORMAT_R8G8B8A8_UNORM,GRAV_LOAD_OP_CLEAR,GRAV_STORE_OP_STORE},
            .hasDepthAttachment=1,
            .depthAttachment={GRAV_FORMAT_D32_SFLOAT,GRAV_LOAD_OP_CLEAR,GRAV_STORE_OP_STORE}},
            &rp) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateFramebuffer(dev, &(GravFramebufferCreateInfo){
            .renderPass=rp,.colorImage=col,.depthImage=dep,
            .extent={width,height}}, &fb) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateShaderModule(dev, &(GravShaderModuleCreateInfo){
            .vertFn=vert_fn,.fragFn=frag_fn,
            .debugName="gui-shader"}, &sh) != GRAV_SUCCESS) goto cleanup;

    if (gravCreatePipeline(dev, &(GravPipelineCreateInfo){
            .shaderModule=sh,.renderPass=rp,
            .vertexStride=sizeof(RVtx),.attributeCount=3,
            .attributes={
                {offsetof(RVtx,position),GRAV_FORMAT_R32G32B32A32_F},
                {offsetof(RVtx,normal),  GRAV_FORMAT_R32G32B32A32_F},
                {offsetof(RVtx,uv),      GRAV_FORMAT_R32G32B32A32_F}},
            .varyingCount=6,
            .topology=GRAV_TOPOLOGY_TRIANGLE_LIST,
            .cullMode=GRAV_CULL_NONE,
            .fillMode=GRAV_FILL_SOLID,
            .depthTestEnable=1,.depthWriteEnable=1,
            .depthCompare=GRAV_COMPARE_LESS,
            .viewport={0,0,(float)width,(float)height,0,1},
            .scissor={0,0,width,height}}, &pip) != GRAV_SUCCESS) goto cleanup;

    if (gravCreateBuffer(dev, &(GravBufferCreateInfo){
            .size=mesh.vertex_count*sizeof(*vertices),
            .usage=GRAV_BUFFER_USAGE_VERTEX}, &vbuf) != GRAV_SUCCESS) goto cleanup;
    if (mesh.vertex_count > 0) {
        gravMapBuffer(dev, vbuf, &mapped);
        memcpy(mapped, vertices, mesh.vertex_count*sizeof(*vertices));
        gravUnmapBuffer(dev, vbuf);
    }

    if (gravCreateBuffer(dev, &(GravBufferCreateInfo){
            .size=mesh.index_count*sizeof(*mesh.indices),
            .usage=GRAV_BUFFER_USAGE_INDEX}, &ibuf) != GRAV_SUCCESS) goto cleanup;
    if (mesh.index_count > 0) {
        gravMapBuffer(dev, ibuf, &mapped);
        memcpy(mapped, mesh.indices, mesh.index_count*sizeof(*mesh.indices));
        gravUnmapBuffer(dev, ibuf);
    }

    /* Kamera → MVP matrisi */
    {
        float cy = cosf(cam->yaw),   sy = sinf(cam->yaw);
        float cp = cosf(cam->pitch), sp = sinf(cam->pitch);
        /* ileri vektör */
        float fx = cy * cp;
        float fy = sp;
        float fz = sy * cp;
        GravMat4 model = gm4_identity();
        GravMat4 view  = gm4_look_at(
            gv3(cam->x, cam->y, cam->z),
            gv3(cam->x + fx, cam->y + fy, cam->z + fz),
            gv3(0.0f, 1.0f, 0.0f));
        GravMat4 proj  = gm4_perspective(70.0f, (float)width/(float)height,
                                         0.1f, 300.0f);
        GravMat4 mvp   = gm4_mul(proj, gm4_mul(view, model));
        memset(&uni, 0, sizeof(uni));
        gm4_to_array(mvp, uni.mvp);
        gm4_to_array(model, uni.model);
        uni.light_direction[0] = 1.0f;
        uni.light_direction[1] = 2.0f;
        uni.light_direction[2] = 1.5f;
    }

    if (gravAllocateCommandBuffer(dev, NULL, &cmd) != GRAV_SUCCESS) goto cleanup;
    gravBeginCommandBuffer(cmd);
    gravCmdBeginRenderPass(cmd, &(GravRenderPassBeginInfo){
        .renderPass=rp,.framebuffer=fb,
        .renderArea={0,0,width,height},
        .clearColor={0.06f,0.09f,0.14f,1.0f},
        .clearDepth=1.0f});
    gravCmdBindPipeline(cmd, pip);
    gravCmdSetUniforms(cmd, &uni, sizeof(uni));
    gravCmdBindVertexBuffer(cmd, vbuf, 0);
    gravCmdBindIndexBuffer(cmd, ibuf, 0);
    gravCmdDrawIndexed(cmd, (uint32_t)mesh.index_count, 0, 0);
    gravCmdEndRenderPass(cmd);
    gravEndCommandBuffer(cmd);
    gravSubmitCommandBuffer(dev, cmd);

    /* RGBA8 piksel verisini al ve BGRA'ya dönüştür (GDI BI_RGB = BGRA) */
    {
        void   *pixels = NULL;
        size_t  sz     = 0;
        if (gravGetImageData(dev, col, &pixels, &sz) == GRAV_SUCCESS && pixels) {
            uint8_t *src = (uint8_t *)pixels;
            uint32_t n   = width * height;
            uint32_t i;
            for (i = 0; i < n; ++i) {
                uint8_t r = src[i*4+0];
                uint8_t g = src[i*4+1];
                uint8_t b = src[i*4+2];
                uint8_t a = src[i*4+3];
                out_bgra[i*4+0] = b;
                out_bgra[i*4+1] = g;
                out_bgra[i*4+2] = r;
                out_bgra[i*4+3] = a;
            }
            status = 0;
        }
    }

cleanup:
    if (cmd)  gravFreeCommandBuffer(dev, cmd);
    if (ibuf) gravDestroyBuffer(dev, ibuf);
    if (vbuf) gravDestroyBuffer(dev, vbuf);
    if (pip)  gravDestroyPipeline(dev, pip);
    if (sh)   gravDestroyShaderModule(dev, sh);
    if (fb)   gravDestroyFramebuffer(dev, fb);
    if (rp)   gravDestroyRenderPass(dev, rp);
    if (dep)  gravDestroyImage(dev, dep);
    if (col)  gravDestroyImage(dev, col);
    if (dev)  gravDestroyDevice(dev);
    if (inst) gravDestroyInstance(inst);
    free(vertices);
    mesh_free(&mesh);
    return status;
}
