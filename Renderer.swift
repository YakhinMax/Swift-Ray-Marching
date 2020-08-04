//
//  Renderer.swift
//  Metal RayMarching
//
//  Created by Maxim Yakhin on 31.07.2020.
//  Copyright © 2020 Max Yakhin. All rights reserved.
//

import MetalKit

class Renderer {
    
    var device: MTLDevice!
    var metalView: MTKView
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    
    init(view: MTKView) {
        metalView = view
        buildCommandQueue()
        buildPipeline()
    }
    
    func buildCommandQueue() {
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        commandQueue = device.makeCommandQueue()
    }
    
    func buildPipeline() {
        let lib = device.makeDefaultLibrary()
        let vf = lib?.makeFunction(name: "vertex_shader")
        let ff = lib?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vf
        pipelineDescriptor.fragmentFunction = ff
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        catch _ as NSError {}
    }
    
    func buildVertexBuffer (array: [Float]) {
        vertexBuffer = device.makeBuffer(bytes: array, length: array.count * MemoryLayout<Float>.size, options: [])
    }
    
    func buildVertexBuffer (array: [Vertex]) {
        vertexBuffer = device.makeBuffer(bytes: array, length: array.count * MemoryLayout<Vertex>.size, options: [])
    }
    
    var camera : [Float] = []
    func setCamera (camera: [Float]) {
        self.camera = camera
    }
    
    func render (view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let state = pipelineState
        else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        encoder?.setRenderPipelineState(state)
        encoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder?.setFragmentBytes(camera, length: camera.count * MemoryLayout<Float>.stride, index: 0)
        encoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        encoder?.endEncoding()
        
        commandBuffer!.present(drawable)
        commandBuffer!.commit()
    }
}
