#include "render.h"

#include "mesher.h"
#include "../gravityon/gravityon.h"
#include "../gravityon/gravityon_math.h"

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct RenderVertex {
    float position[4];
    float normal[4];
    float uv[4];
    float block_id;
} RenderVertex;

typedef struct RenderUniforms {
    float mvp[16];
    float model[16];
    float light_direction[4];
} RenderUniforms;

static void render_vertex_shader(const void *vertex_data, const void *uniform_data,
                                 float out_position[4], float *out_varyings)
{
    const RenderVertex *vertex = (const RenderVertex *)vertex_data;
    const RenderUniforms *uniforms = (const RenderUniforms *)uniform_data;
    const float *mvp = uniforms->mvp;
    const float *model = uniforms->model;
    float px = vertex->position[0];
    float py = vertex->position[1];
    float pz = vertex->position[2];

    out_position[0] = mvp[0] * px + mvp[4] * py + mvp[8] * pz + mvp[12];
    out_position[1] = mvp[1] * px + mvp[5] * py + mvp[9] * pz + mvp[13];
    out_position[2] = mvp[2] * px + mvp[6] * py + mvp[10] * pz + mvp[14];
    out_position[3] = mvp[3] * px + mvp[7] * py + mvp[11] * pz + mvp[15];

    out_varyings[0] = model[0] * vertex->normal[0] +
                      model[4] * vertex->normal[1] +
                      model[8] * vertex->normal[2];
    out_varyings[1] = model[1] * vertex->normal[0] +
                      model[5] * vertex->normal[1] +
                      model[9] * vertex->normal[2];
    out_varyings[2] = model[2] * vertex->normal[0] +
                      model[6] * vertex->normal[1] +
                      model[10] * vertex->normal[2];
    out_varyings[3] = vertex->uv[0];
    out_varyings[4] = vertex->uv[1];
    out_varyings[5] = vertex->block_id;
}

static void render_fragment_shader(const float *varyings, const void *uniform_data,
                                   float out_color[4])
{
    const RenderUniforms *uniforms = (const RenderUniforms *)uniform_data;
    float nx = varyings[0];
    float ny = varyings[1];
    float nz = varyings[2];
    float length = sqrtf(nx * nx + ny * ny + nz * nz);
    float lx = uniforms->light_direction[0];
    float ly = uniforms->light_direction[1];
    float lz = uniforms->light_direction[2];
    float light_length = sqrtf(lx * lx + ly * ly + lz * lz);
    float diffuse;
    float block_id = varyings[5];
    float base_r;
    float base_g;
    float base_b;
    int checker_x = (int)(varyings[3] * 2.0f) & 1;
    int checker_y = (int)(varyings[4] * 2.0f) & 1;
    float checker = (checker_x ^ checker_y) != 0 ? 1.0f : 0.78f;

    if (length > 1e-6f) {
        nx /= length;
        ny /= length;
        nz /= length;
    }
    if (light_length > 1e-6f) {
        lx /= light_length;
        ly /= light_length;
        lz /= light_length;
    }
    diffuse = nx * lx + ny * ly + nz * lz;
    if (diffuse < 0.0f) {
        diffuse = 0.0f;
    }

    /*
     * The atlas coordinate is already carried by the mesh. Until a texture
     * asset is added, use stable block-id colors so the renderer is useful
     * without any external image dependency.
     */
    if (((int)block_id & 3) == 1) {
        base_r = 0.30f;
        base_g = 0.68f;
        base_b = 0.32f;
    } else if (((int)block_id & 3) == 2) {
        base_r = 0.62f;
        base_g = 0.40f;
        base_b = 0.20f;
    } else if (((int)block_id & 3) == 3) {
        base_r = 0.28f;
        base_g = 0.48f;
        base_b = 0.75f;
    } else {
        base_r = 0.72f;
        base_g = 0.72f;
        base_b = 0.72f;
    }

    out_color[0] = (0.18f + 0.82f * diffuse) * base_r * checker;
    out_color[1] = (0.18f + 0.82f * diffuse) * base_g * checker;
    out_color[2] = (0.18f + 0.82f * diffuse) * base_b * checker;
    out_color[3] = 1.0f;
}

static void copy_mesh_vertices(const Mesh *mesh, RenderVertex *vertices)
{
    size_t i;

    for (i = 0u; i < mesh->vertex_count; ++i) {
        const MesherVertex *source = &mesh->vertices[i];
        RenderVertex *target = &vertices[i];

        target->position[0] = source->x;
        target->position[1] = source->y;
        target->position[2] = source->z;
        target->position[3] = 1.0f;
        target->normal[0] = source->nx;
        target->normal[1] = source->ny;
        target->normal[2] = source->nz;
        target->normal[3] = 0.0f;
        target->uv[0] = source->u;
        target->uv[1] = source->v;
        target->uv[2] = 0.0f;
        target->uv[3] = 0.0f;
        target->block_id = (float)source->block;
    }
}

int render_chunk_to_ppm(World *world, const Chunk *chunk, const char *path,
                        uint32_t width, uint32_t height)
{
    const MesherConfig mesher_config = {4u, 4u};
    Mesh mesh;
    RenderVertex *vertices = NULL;
    GravInstance instance = NULL;
    GravDevice device = NULL;
    GravImage color_image = NULL;
    GravImage depth_image = NULL;
    GravRenderPass render_pass = NULL;
    GravFramebuffer framebuffer = NULL;
    GravShaderModule shader = NULL;
    GravPipeline pipeline = NULL;
    GravBuffer vertex_buffer = NULL;
    GravBuffer index_buffer = NULL;
    GravCommandBuffer command_buffer = NULL;
    RenderUniforms uniforms;
    GravResult result;
    GravMat4 model;
    GravMat4 view;
    GravMat4 projection;
    GravMat4 mvp;
    float center_x;
    float center_y;
    float center_z;
    void *mapped;
    int status = -1;

    if (world == NULL || chunk == NULL || path == NULL ||
        width == 0u || height == 0u) {
        return -1;
    }

    mesh_init(&mesh);
    if (mesher_build_chunk(world, chunk, &mesher_config, &mesh) != 0 ||
        mesh.vertex_count > UINT32_MAX ||
        mesh.index_count > UINT32_MAX) {
        mesh_free(&mesh);
        return -1;
    }
    if (mesh.vertex_count > 0u) {
        vertices = (RenderVertex *)malloc(mesh.vertex_count * sizeof(*vertices));
        if (vertices == NULL) {
            mesh_free(&mesh);
            return -1;
        }
        copy_mesh_vertices(&mesh, vertices);
    }

    result = gravCreateInstance(&(GravInstanceCreateInfo){
        .appName = "Oxalyn Voxel World",
        .appVersion = GRAV_MAKE_VERSION(0, 1, 0),
        .apiVersion = GRAV_API_VERSION
    }, &instance);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateDevice(instance, &(GravDeviceCreateInfo){
        .threadCount = 1u
    }, &device);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateImage(device, &(GravImageCreateInfo){
        .extent = {width, height},
        .format = GRAV_FORMAT_R8G8B8A8_UNORM,
        .usage = GRAV_IMAGE_USAGE_COLOR_ATTACHMENT
    }, &color_image);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateImage(device, &(GravImageCreateInfo){
        .extent = {width, height},
        .format = GRAV_FORMAT_D32_SFLOAT,
        .usage = GRAV_IMAGE_USAGE_DEPTH_ATTACHMENT
    }, &depth_image);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateRenderPass(device, &(GravRenderPassCreateInfo){
        .colorAttachment = {
            GRAV_FORMAT_R8G8B8A8_UNORM,
            GRAV_LOAD_OP_CLEAR,
            GRAV_STORE_OP_STORE
        },
        .hasDepthAttachment = 1,
        .depthAttachment = {
            GRAV_FORMAT_D32_SFLOAT,
            GRAV_LOAD_OP_CLEAR,
            GRAV_STORE_OP_STORE
        }
    }, &render_pass);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateFramebuffer(device, &(GravFramebufferCreateInfo){
        .renderPass = render_pass,
        .colorImage = color_image,
        .depthImage = depth_image,
        .extent = {width, height}
    }, &framebuffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateShaderModule(device, &(GravShaderModuleCreateInfo){
        .vertFn = render_vertex_shader,
        .fragFn = render_fragment_shader,
        .debugName = "oxalyn-voxel-shader"
    }, &shader);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreatePipeline(device, &(GravPipelineCreateInfo){
        .shaderModule = shader,
        .renderPass = render_pass,
        .vertexStride = sizeof(RenderVertex),
        .attributeCount = 3u,
        .attributes = {
            {offsetof(RenderVertex, position), GRAV_FORMAT_R32G32B32A32_F},
            {offsetof(RenderVertex, normal), GRAV_FORMAT_R32G32B32A32_F},
            {offsetof(RenderVertex, uv), GRAV_FORMAT_R32G32B32A32_F}
        },
        .varyingCount = 6u,
        .topology = GRAV_TOPOLOGY_TRIANGLE_LIST,
        .cullMode = GRAV_CULL_NONE,
        .fillMode = GRAV_FILL_SOLID,
        .depthTestEnable = 1,
        .depthWriteEnable = 1,
        .depthCompare = GRAV_COMPARE_LESS,
        .viewport = {0.0f, 0.0f, (float)width, (float)height, 0.0f, 1.0f},
        .scissor = {0, 0, width, height}
    }, &pipeline);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCreateBuffer(device, &(GravBufferCreateInfo){
        .size = mesh.vertex_count * sizeof(*vertices),
        .usage = GRAV_BUFFER_USAGE_VERTEX
    }, &vertex_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    if (mesh.vertex_count > 0u) {
        result = gravMapBuffer(device, vertex_buffer, &mapped);
        if (result != GRAV_SUCCESS) {
            goto cleanup;
        }
        memcpy(mapped, vertices, mesh.vertex_count * sizeof(*vertices));
        (void)gravUnmapBuffer(device, vertex_buffer);
    }
    result = gravCreateBuffer(device, &(GravBufferCreateInfo){
        .size = mesh.index_count * sizeof(*mesh.indices),
        .usage = GRAV_BUFFER_USAGE_INDEX
    }, &index_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    if (mesh.index_count > 0u) {
        result = gravMapBuffer(device, index_buffer, &mapped);
        if (result != GRAV_SUCCESS) {
            goto cleanup;
        }
        memcpy(mapped, mesh.indices, mesh.index_count * sizeof(*mesh.indices));
        (void)gravUnmapBuffer(device, index_buffer);
    }

    center_x = (float)chunk->cx * CHUNK_X + CHUNK_X * 0.5f;
    center_y = (float)chunk->cy * CHUNK_Y + CHUNK_Y * 0.5f;
    center_z = (float)chunk->cz * CHUNK_Z + CHUNK_Z * 0.5f;
    model = gm4_identity();
    view = gm4_look_at(gv3(center_x + 28.0f, center_y + 22.0f, center_z + 28.0f),
                       gv3(center_x, center_y, center_z),
                       gv3(0.0f, 1.0f, 0.0f));
    projection = gm4_perspective(55.0f, (float)width / (float)height,
                                 0.1f, 200.0f);
    mvp = gm4_mul(projection, gm4_mul(view, model));
    memset(&uniforms, 0, sizeof(uniforms));
    gm4_to_array(mvp, uniforms.mvp);
    gm4_to_array(model, uniforms.model);
    uniforms.light_direction[0] = 1.0f;
    uniforms.light_direction[1] = 2.0f;
    uniforms.light_direction[2] = 1.5f;

    result = gravAllocateCommandBuffer(device, NULL, &command_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravBeginCommandBuffer(command_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdBeginRenderPass(command_buffer, &(GravRenderPassBeginInfo){
        .renderPass = render_pass,
        .framebuffer = framebuffer,
        .renderArea = {0, 0, width, height},
        .clearColor = {0.06f, 0.09f, 0.14f, 1.0f},
        .clearDepth = 1.0f
    });
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdBindPipeline(command_buffer, pipeline);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdSetUniforms(command_buffer, &uniforms, sizeof(uniforms));
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdBindVertexBuffer(command_buffer, vertex_buffer, 0u);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdBindIndexBuffer(command_buffer, index_buffer, 0u);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdDrawIndexed(command_buffer, (uint32_t)mesh.index_count, 0u, 0);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravCmdEndRenderPass(command_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravEndCommandBuffer(command_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravSubmitCommandBuffer(device, command_buffer);
    if (result != GRAV_SUCCESS) {
        goto cleanup;
    }
    result = gravSaveImagePPM(device, color_image, path);
    if (result == GRAV_SUCCESS) {
        status = 0;
    }

cleanup:
    if (command_buffer != NULL) {
        (void)gravFreeCommandBuffer(device, command_buffer);
    }
    if (index_buffer != NULL) {
        (void)gravDestroyBuffer(device, index_buffer);
    }
    if (vertex_buffer != NULL) {
        (void)gravDestroyBuffer(device, vertex_buffer);
    }
    if (pipeline != NULL) {
        (void)gravDestroyPipeline(device, pipeline);
    }
    if (shader != NULL) {
        (void)gravDestroyShaderModule(device, shader);
    }
    if (framebuffer != NULL) {
        (void)gravDestroyFramebuffer(device, framebuffer);
    }
    if (render_pass != NULL) {
        (void)gravDestroyRenderPass(device, render_pass);
    }
    if (depth_image != NULL) {
        (void)gravDestroyImage(device, depth_image);
    }
    if (color_image != NULL) {
        (void)gravDestroyImage(device, color_image);
    }
    if (device != NULL) {
        (void)gravDestroyDevice(device);
    }
    if (instance != NULL) {
        (void)gravDestroyInstance(instance);
    }
    free(vertices);
    mesh_free(&mesh);
    return status;
}