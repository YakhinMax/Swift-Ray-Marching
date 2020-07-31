//
//  Shader.metal
//  Metal RayMarching
//
//  Created by Maxim Yakhin on 31.07.2020.
//  Copyright © 2020 Max Yakhin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 relative_position;
};

vertex VertexOut vertex_shader(const VertexIn vertex_in [[stage_in]]) {
    VertexOut vertex_out;
    vertex_out.position = vertex_in.position;
    vertex_out.relative_position = float3(vertex_in.position);
    return vertex_out;
}

half4 rayMarch (float3 direction, float3 camera) {
    float3 norm = normalize(direction - camera);
    float3 curpoint = camera;
    float3 pos = float3(0,0,0);
    float rad = 0.5;
    half4 color = half4(1,1,1,1);
    for (ushort step = 0; step < 20; step++) {
//        float minDist = INFINITY;
        float minDist = distance(curpoint, pos) - rad;
        if (minDist <= 0.001) {
            float3 l = normalize(camera - curpoint);
            float3 n = normalize(curpoint - pos);
            return color * dot(l, n);
        }
        curpoint += norm * minDist;
    }
    return half4(0,0,0,1);
}

fragment half4 fragment_shader(VertexOut Vertex [[stage_in]],
                               constant packed_float3 &camera [[buffer(0)]]) {

    return rayMarch(float3(Vertex.relative_position), camera);
}


