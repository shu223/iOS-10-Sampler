//
//  MetalCNNBasicViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import MetalPerformanceShaders

class MetalCNNBasicViewController: UIViewController {

    var commandQueue: MTLCommandQueue!
    var device: MTLDevice!
    
    // Networks we have
    var network: MNIST_Deep_ConvNN!
//    var runningNet: MNIST_Full_LayerNN? = nil
    
    // MNIST dataset image parameters
    let mnistInputWidth  = 28
    let mnistInputHeight = 28
    let mnistInputNumPixels = 784
    
    @IBOutlet weak var digitView: DrawView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load default device.
        device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard MPSSupportsMTLDevice(device) else {
            print("Metal Performance Shaders not Supported on current Device")
            return
        }
        
        // Create new command queue.
        commandQueue = device!.newCommandQueue()
        
        // initialize the networks we shall use to detect digits
        network  = MNIST_Deep_ConvNN(withCommandQueue: commandQueue)
    }
    
    @IBAction func clearBtnTapped(sender: UIButton) {
        // clear the digitview
        digitView.lines = []
        digitView.setNeedsDisplay()
        predictionLabel.isHidden = true
        
    }
    
    @IBAction func detectBtnTapped(sender: UIButton) {
        // get the digitView context so we can get the pixel values from it to intput to network
        let context = digitView.getViewContext()
        
        // validate NeuralNetwork was initialized properly
        assert(network != nil)
        
        // putting input into MTLTexture in the MPSImage
        network.srcImage.texture.replace(MTLRegion( origin: MTLOrigin(x: 0, y: 0, z: 0),
                                                        size: MTLSize(width: mnistInputWidth, height: mnistInputHeight, depth: 1)),
                                             mipmapLevel: 0,
                                             slice: 0,
                                             withBytes: context!.data!,
                                             bytesPerRow: mnistInputWidth,
                                             bytesPerImage: 0)
        // run the network forward pass
        let label = network.forward()
        
        // show the prediction
        predictionLabel.text = "\(label)"
        predictionLabel.isHidden = false
    }

}
