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
    float3 ray [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 relative_position;
};

half4 rayMarch (float3 direction, float3 camera) {
    float3 norm = normalize(direction - camera);
    float3 curpoint = camera;
    float3 pos = float3(0,0,0);
    float rad = 0.5;
//    half4 color = half4(1,1,1,1);
    float minDist = INFINITY;
    float surface = INFINITY;
    for (ushort step = 0; step < 75; step++) {
        minDist = distance(curpoint, pos) - rad;
        surface = curpoint.y + 1;
        if (minDist <= 0.001) {
            float3 l = normalize(camera - curpoint);
            float3 n = normalize(curpoint - pos);
//            return color * dot(l, n);
//            return half4(abs(n.y),0.5 + n.z,0.5 - n.z,1) * dot(l, n);
            return half4(0.5 + n.y,0,0.5 - n.x,1);
//            return half4(0,0,0,1);
        }
        if (surface <= 0.001)
            if (abs(curpoint.x) <= 2 && abs(curpoint.y) <= 2 && abs(curpoint.z) <= 2)
//            return half4(curpoint.z,curpoint.z,curpoint.z,1);
                return half4(abs(curpoint.x) / 4 + abs(curpoint.z) / 4,0,0,1);
        curpoint += norm * min(minDist,surface);
    }
    return half4(0.125,0.125,0.125,1);
}

vertex VertexOut vertex_shader(const VertexIn vertex_in [[stage_in]]) {
    VertexOut vertex_out;
    vertex_out.position = vertex_in.position;
    vertex_out.relative_position = vertex_in.ray;
    return vertex_out;
}

fragment half4 fragment_shader(VertexOut Vertex [[stage_in]],
                               constant packed_float3 &camera [[buffer(0)]]) {
    return rayMarch(float3(Vertex.relative_position), camera);
}


