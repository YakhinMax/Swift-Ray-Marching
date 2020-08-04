//
//  Extension.swift
//  Metal RayMarching
//
//  Created by Maxim Yakhin on 31.07.2020.
//  Copyright © 2020 Max Yakhin. All rights reserved.
//

import MetalKit

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        let vertices = model.getVertices()
        renderer.buildVertexBuffer(array: vertices)
        renderer.setCamera(camera: model.getCamera())
        renderer.render(view: view)
    }
}
