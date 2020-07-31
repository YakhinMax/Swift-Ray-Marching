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
}

class Model {
    
    var camera : [Float] = [0,0,1]
    
    var vertices : [Vertex] = [
        Vertex(position: SIMD3<Float>(-1,-1,0)),
        Vertex(position: SIMD3<Float>(-1,1,0)),
        Vertex(position: SIMD3<Float>(1,-1,0)),
        Vertex(position: SIMD3<Float>(1,1,0))
    ]
    
    func getCamera() -> [Float] {
        return camera
    }
    func getVertices() -> [Vertex] {
        return vertices
    }
}
