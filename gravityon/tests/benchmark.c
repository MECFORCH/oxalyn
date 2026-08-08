/**
 * Gravityon benchmark — tekrarlı triangle render ölçümü.
 *
 * Kullanım:
 *   GRAV_THREADS=4 GRAV_BENCH_FRAMES=32 make -C gravityon benchmark
 *   GRAV_THREADS=4 ./gravityon/benchmark
 */
#define _POSIX_C_SOURCE 199309L
#include "../gravityon.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef struct Vertex {
    float pos[3];
    float color[3];
} Vertex;

static void vert(const void* data, const void* uniforms,
                 float outPos[4], float* varyings) {
    const Vertex* v = (const Vertex*)data;
    (void)uniforms;
    outPos[0] = v->pos[0]; outPos[1] = v->pos[1];
    outPos[2] = v->pos[2]; outPos[3] = 1.0f;
    varyings[0] = v->color[0]; varyings[1] = v->color[1];
    varyings[2] = v->color[2];
}

static void frag(const float* varyings, const void* uniforms, float color[4]) {
    (void)uniforms;
    color[0] = varyings[0]; color[1] = varyings[1];
    color[2] = varyings[2]; color[3] = 1.0f;
}

static uint32_t env_u32(const char* name, uint32_t fallback) {
    const char* value = getenv(name);
    char* end = NULL;
    unsigned long parsed;
    if (!value || !*value) return fallback;
    parsed = strtoul(value, &end, 10);
    return end != value && *end == '\0' && parsed > 0 && parsed <= UINT32_MAX
        ? (uint32_t)parsed : fallback;
}

static uint64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

int main(void) {
    const uint32_t width = 800, height = 600;
    const uint32_t frames = env_u32("GRAV_BENCH_FRAMES", 32);
    const uint32_t threads = env_u32("GRAV_THREADS", 1);
    const Vertex vertices[] = {
        {{ 0.0f,  0.7f, 0.0f}, {1.0f, 0.0f, 0.0f}},
        {{-0.7f, -0.5f, 0.0f}, {0.0f, 1.0f, 0.0f}},
        {{ 0.7f, -0.5f, 0.0f}, {0.0f, 0.0f, 1.0f}},
    };
    GravInstance instance;
    GravDevice device;
    GravImage color, depth;
    GravRenderPass pass;
    GravFramebuffer framebuffer;
    GravShaderModule shader;
    GravPipeline pipeline;
    GravBuffer vertexBuffer;
    GravCommandBuffer commands;
    void* mapped;

    if (gravCreateInstance(&(GravInstanceCreateInfo){
            .appName = "Gravityon benchmark", .apiVersion = GRAV_API_VERSION
        }, &instance) != GRAV_SUCCESS ||
        gravCreateDevice(instance, &(GravDeviceCreateInfo){.threadCount = threads},
                         &device) != GRAV_SUCCESS)
        return 1;
    gravCreateImage(device, &(GravImageCreateInfo){
        .extent={width,height}, .format=GRAV_FORMAT_R8G8B8A8_UNORM,
        .usage=GRAV_IMAGE_USAGE_COLOR_ATTACHMENT}, &color);
    gravCreateImage(device, &(GravImageCreateInfo){
        .extent={width,height}, .format=GRAV_FORMAT_D32_SFLOAT,
        .usage=GRAV_IMAGE_USAGE_DEPTH_ATTACHMENT}, &depth);
    gravCreateRenderPass(device, &(GravRenderPassCreateInfo){
        .colorAttachment={GRAV_FORMAT_R8G8B8A8_UNORM,GRAV_LOAD_OP_CLEAR,GRAV_STORE_OP_STORE},
        .hasDepthAttachment=1,
        .depthAttachment={GRAV_FORMAT_D32_SFLOAT,GRAV_LOAD_OP_CLEAR,GRAV_STORE_OP_STORE}
    }, &pass);
    gravCreateFramebuffer(device, &(GravFramebufferCreateInfo){
        .renderPass=pass, .colorImage=color, .depthImage=depth,
        .extent={width,height}}, &framebuffer);
    gravCreateShaderModule(device, &(GravShaderModuleCreateInfo){
        .vertFn=vert, .fragFn=frag}, &shader);
    gravCreatePipeline(device, &(GravPipelineCreateInfo){
        .shaderModule=shader, .renderPass=pass, .vertexStride=sizeof(Vertex),
        .varyingCount=3, .topology=GRAV_TOPOLOGY_TRIANGLE_LIST,
        .cullMode=GRAV_CULL_NONE, .fillMode=GRAV_FILL_SOLID,
        .depthTestEnable=1, .depthWriteEnable=1, .depthCompare=GRAV_COMPARE_LESS,
        .viewport={0,0,(float)width,(float)height,0,1},
        .scissor={0,0,width,height}, .tileSize=32}, &pipeline);
    gravCreateBuffer(device, &(GravBufferCreateInfo){
        .size=sizeof(vertices), .usage=GRAV_BUFFER_USAGE_VERTEX}, &vertexBuffer);
    gravMapBuffer(device, vertexBuffer, &mapped);
    memcpy(mapped, vertices, sizeof(vertices));
    gravUnmapBuffer(device, vertexBuffer);
    gravAllocateCommandBuffer(device, NULL, &commands);

    uint64_t start = now_ns();
    for (uint32_t frame = 0; frame < frames; frame++) {
        gravBeginCommandBuffer(commands);
        gravCmdBeginRenderPass(commands, &(GravRenderPassBeginInfo){
            .renderPass=pass, .framebuffer=framebuffer,
            .renderArea={0,0,width,height},
            .clearColor={0.05f,0.05f,0.1f,1.0f}, .clearDepth=1.0f});
        gravCmdBindPipeline(commands, pipeline);
        gravCmdBindVertexBuffer(commands, vertexBuffer, 0);
        gravCmdDraw(commands, 3, 0);
        gravCmdEndRenderPass(commands);
        gravEndCommandBuffer(commands);
        if (gravSubmitCommandBuffer(device, commands) != GRAV_SUCCESS) return 1;
    }
    double elapsed_ms = (double)(now_ns() - start) / 1000000.0;
    double frame_ms = elapsed_ms / (double)frames;
    printf("frames=%u threads=%u total_ms=%.3f ms_per_frame=%.3f fps=%.2f pixels=%u\n",
           frames, threads, elapsed_ms, frame_ms, 1000.0 / frame_ms, width * height);

    gravFreeCommandBuffer(device, commands);
    gravDestroyBuffer(device, vertexBuffer);
    gravDestroyPipeline(device, pipeline);
    gravDestroyShaderModule(device, shader);
    gravDestroyFramebuffer(device, framebuffer);
    gravDestroyRenderPass(device, pass);
    gravDestroyImage(device, depth);
    gravDestroyImage(device, color);
    gravDestroyDevice(device);
    gravDestroyInstance(instance);
    return 0;
}