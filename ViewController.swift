//
//  ViewController.swift
//  Metal RayMarching
//
//  Created by Maxim Yakhin on 31.07.2020.
//  Copyright © 2020 Max Yakhin. All rights reserved.
//

import MetalKit

class ViewController: NSViewController {

    var renderer: Renderer!
    var model: Model!
    var lastMouse: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = Model()
        
        renderer = Renderer(view: view as! MTKView)
        renderer.metalView.delegate = self
        
//        renderer.metalView.clearColor = MTLClearColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        lastMouse = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        let dx = event.locationInWindow.x - lastMouse.x
        let dy = event.locationInWindow.y - lastMouse.y
        model.orient(x: Float(dx / 360),y: Float(dy / 360))
        lastMouse = event.locationInWindow
    }
    
    override func scrollWheel(with event: NSEvent) {
        lastMouse = event.locationInWindow
    }
    
    override func magnify(with event: NSEvent) {
        model.magnify(scale: Float(1 + event.magnification))
    }
}
