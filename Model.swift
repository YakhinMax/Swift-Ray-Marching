//
//  Model.swift
//  Metal RayMarching
//
//  Created by Maxim Yakhin on 31.07.2020.
//  Copyright © 2020 Max Yakhin. All rights reserved.
//

import simd

struct Vertex {
    var position: SIMD3<Float>
    var ray: SIMD3<Float>
}

class Model {
    
    var camera : [Float] = [0,0,2]
    
    var vertices : [Vertex] = [
        Vertex(position: SIMD3<Float>(-1,-1,0),
               ray: SIMD3<Float>(-1,-1,0)),
        Vertex(position: SIMD3<Float>(-1,1,0),
               ray: SIMD3<Float>(-1,1,0)),
        Vertex(position: SIMD3<Float>(1,-1,0),
               ray: SIMD3<Float>(1,-1,0)),
        Vertex(position: SIMD3<Float>(1,1,0),
               ray: SIMD3<Float>(1,1,0))
    ]
    
    func magnify(scale: Float) {
        camera[0] *= scale
        camera[1] *= scale
        camera[2] *= scale
        for i in 0..<vertices.count {
            vertices[i].ray *= scale
        }
    }
    
    func orient(x: Float, y: Float) {
        let radx = x * sign(camera[2])
        let rady = -y * sign(camera[2])
        let ax1 = SIMD3<Float>(0, camera[2], 0)
        let ax2 = SIMD3<Float>(camera[2], 0, -camera[0])
        let matrx = matrix3x3_rotation(radians: radx, axis: ax1)
        let matry = matrix3x3_rotation(radians: rady, axis: ax2)
        let matr = simd_mul(matrx, matry)
        let pack = simd_mul(SIMD3<Float>(camera), matr)
        camera = [pack.x, pack.y, pack.z]
        for i in 0..<vertices.count {
            vertices[i].ray = simd_mul(vertices[i].ray, matr)
        }
    }
    
    func matrix3x3_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float3x3 {
        let unitAxis = normalize(axis)
        let ct = cosf(radians)
        let st = sinf(radians)
        let ci = 1 - ct
        let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
        return matrix_float3x3.init(columns:(vector_float3(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st),
                                             vector_float3(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st),
                                             vector_float3(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci)
                                             ))
    }
    
    func getCamera() -> [Float] {
        return camera
    }
    func getVertices() -> [Vertex] {
        return vertices
    }
}
