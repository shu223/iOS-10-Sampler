//
//  MetalImageRecognitionViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/9/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  This class is based on Apple's sample named "MetalImageRecognition"

import UIKit
import MetalKit
import MetalPerformanceShaders
import Accelerate
import AVFoundation

class MetalImageRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var Net: Inception3Net? = nil
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var imageNum = 0
    var total = 6
    var textureLoader : MTKTextureLoader!
    var ciContext : CIContext!
    var sourceTexture : MTLTexture? = nil
    var camRan = false
    
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var predictView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load default device.
        device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard MPSSupportsMTLDevice(device) else {
            print("Metal Performance Shaders not Supported on current Device")
            return
        }
        
        // Load any resources required for rendering.
        
        // Create new command queue.
        commandQueue = device!.makeCommandQueue()
        
        // make a textureLoader to get our input images as MTLTextures
        textureLoader = MTKTextureLoader(device: device!)
        
        // Load the appropriate Network
        Net = Inception3Net(withCommandQueue: commandQueue)
        
        // we use this CIContext as one of the steps to get a MTLTexture
        ciContext = CIContext.init(mtlDevice: device)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // get taken picture as UIImage
        let uiImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // display the image in UIImage View
        predictView.image = uiImg
        
        // use CGImage property of UIImage
        var cgImg = uiImg.cgImage
        
        // check to see if cgImg is valid if nil, UIImg is CIImage based and we need to go through that
        // this shouldn't be the case with our example
        if(cgImg == nil){
            // our underlying format was CIImage
            var ciImg = uiImg.ciImage
            if(ciImg == nil){
                // this should never be needed but if for some reason both formats fail, we create a CIImage
                // change UIImage to CIImage
                ciImg = CIImage(image: uiImg)
            }
            // use CIContext to get a CGImage
            cgImg = ciContext.createCGImage(ciImg!, from: ciImg!.extent)
        }
        
        // get a texture from this CGImage
        do {
            sourceTexture = try textureLoader.newTexture(with: cgImg!, options: [:])
        }
        catch let error as NSError {
            fatalError("Unexpected error ocurred: \(error.localizedDescription).")
        }
        
        // run inference neural network to get predictions and display them
        runNetwork()
        
        // to keep track of which image is being displayed
        camRan = true
        dismiss(animated: true, completion: nil)
    }
    
    /**
     This function is used to fetch the appropriate image and store it in a MTLTexture
     so we can run our inference network on it
     
     
     - Returns:
     Void
     */
    func fetchImage(){
        let URL = Bundle.main.url(forResource:"final0", withExtension: "jpg")
        do {
            sourceTexture = try textureLoader.newTexture(withContentsOf: URL!, options: [:])
        }
        catch let error as NSError {
            fatalError("Unexpected error ocurred: \(error.localizedDescription).")
        }
        
        // run the neural network to get outputs
        runNetwork()
        
    }
    
    /**
     This function gets a commanBuffer and encodes layers in it. It follows that by commiting the commandBuffer and getting labels
     
     
     - Returns:
     Void
     */
    func runNetwork(){
        
        // to deliver optimal performance we leave some resources used in MPSCNN to be released at next call of autoreleasepool,
        // so the user can decide the appropriate time to release this
        autoreleasepool{
            // encoding command buffer
            let commandBuffer = commandQueue.makeCommandBuffer()
            
            // encode all layers of network on present commandBuffer, pass in the input image MTLTexture
            Net!.forward(commandBuffer: commandBuffer, sourceTexture: sourceTexture)
            
            // commit the commandBuffer and wait for completion on CPU
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            // display top-5 predictions for what the object should be labelled
            let label = Net!.getLabel()
            predictLabel.text = label
            predictLabel.isHidden = false
        }
        
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func camera(sender: UIButton) {
        let picker = UIImagePickerController()
        
        // set the picker to camera so the user can take an image
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        // call the camera
        present(picker, animated: true, completion: nil)
    }
    
    // run the neural network to get predictions
    @IBAction func runTapped(sender: UIButton) {
        fetchImage()
    }

}
