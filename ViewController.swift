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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = Model()
        
        renderer = Renderer(view: view as! MTKView)
        renderer.setCamera(camera: model.getCamera())
        renderer.metalView.delegate = self
        
//        renderer.metalView.clearColor = MTLClearColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
