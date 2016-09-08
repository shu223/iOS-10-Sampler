//
//  MNISTDeepCNN.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//
/*
    This is the deep layer network where we define and encode the correct layers on a command buffer as needed
    This is based on MNISTSingleLayer.swift and MNISTDeepCNN.swift provided by Apple
 */

import MetalPerformanceShaders
import Accelerate


class MNISTDeepCNN {
    // MPSImageDescriptors for different layers outputs to be put in
    let sid = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.unorm8, width: 28, height: 28, featureChannels: 1)
    let did = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 1, height: 1, featureChannels: 10)
    let c1id  = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 28, height: 28, featureChannels: 32)
    let p1id  = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 14, height: 14, featureChannels: 32)
    let c2id  = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 14, height: 14, featureChannels: 64)
    let p2id  = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 7 , height: 7 , featureChannels: 64)
    let fc1id = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width: 1 , height: 1 , featureChannels: 1024)
    
    // MPSImages and layers declared
    var srcImage, dstImage : MPSImage
    var c1Image, c2Image, p1Image, p2Image, fc1Image: MPSImage
    var conv1, conv2: MPSCNNConvolution
    var fc1, fc2: MPSCNNFullyConnected
    var pool: MPSCNNPoolingMax
    var relu: MPSCNNNeuronReLU

    //    var layer: MPSCNNFullyConnected
    var softmax : MPSCNNSoftMax
    var commandQueue : MTLCommandQueue
    var device : MTLDevice
    
    init(withCommandQueue commandQueueIn: MTLCommandQueue!) {
        commandQueue = commandQueueIn
        device = commandQueueIn.device
        
        pool = MPSCNNPoolingMax(device: device, kernelWidth: 2, kernelHeight: 2, strideInPixelsX: 2, strideInPixelsY: 2)
        pool.offset = MPSOffset(x: 1, y: 1, z: 0);
        pool.edgeMode = MPSImageEdgeMode.clamp
        relu = MPSCNNNeuronReLU(device: device, a: 0)
        
        
        // Initialize MPSImage from descriptors
        c1Image     = MPSImage(device: device, imageDescriptor: c1id)
        p1Image     = MPSImage(device: device, imageDescriptor: p1id)
        c2Image     = MPSImage(device: device, imageDescriptor: c2id)
        p2Image     = MPSImage(device: device, imageDescriptor: p2id)
        fc1Image    = MPSImage(device: device, imageDescriptor: fc1id)
        
        
        // setup convolution layers
        conv1 = SlimMPSCNNConvolution(kernelWidth: 5,
                                      kernelHeight: 5,
                                      inputFeatureChannels: 1,
                                      outputFeatureChannels: 32,
                                      neuronFilter: relu,
                                      device: device,
                                      kernelParamsBinaryName: "conv1")
        
        conv2 = SlimMPSCNNConvolution(kernelWidth: 5,
                                      kernelHeight: 5,
                                      inputFeatureChannels: 32,
                                      outputFeatureChannels: 64,
                                      neuronFilter: relu,
                                      device: device,
                                      kernelParamsBinaryName: "conv2")
        
        
        // same as a 1x1 convolution filter to produce 1x1x10 from 1x1x1024
        fc1 = SlimMPSCNNFullyConnected(kernelWidth: 7,
                                       kernelHeight: 7,
                                       inputFeatureChannels: 64,
                                       outputFeatureChannels: 1024,
                                       neuronFilter: nil,
                                       device: device,
                                       kernelParamsBinaryName: "fc1")
        
        fc2 = SlimMPSCNNFullyConnected(kernelWidth: 1,
                                       kernelHeight: 1,
                                       inputFeatureChannels: 1024,
                                       outputFeatureChannels: 10,
                                       neuronFilter: nil,
                                       device: device,
                                       kernelParamsBinaryName: "fc2")
        
        // Initialize MPSImage from descriptors
        srcImage = MPSImage(device: device, imageDescriptor: sid)
        dstImage = MPSImage(device: device, imageDescriptor: did)

        // prepare softmax layer to be applied at the end to get a clear label
        softmax = MPSCNNSoftMax(device: device)
    }
    
    
    /**
     This function encodes all the layers of the network into given commandBuffer, it calls subroutines for each piece of the network
     
     - Parameters:
     - inputImage: Image coming in on which the network will run
     - imageNum: If the test set is being used we will get a value between 0 and 9999 for which of the 10,000 images is being evaluated
     - correctLabel: The correct label for the inputImage while testing
     
     - Returns:
     Guess of the network as to what the digit is as UInt
     */
    func forward(inputImage: MPSImage? = nil, imageNum: Int = 9999, correctLabel: UInt = 10) -> UInt{
        var label = UInt(99)
        
        // to deliver optimal performance we leave some resources used in MPSCNN to be released at next call of autoreleasepool,
        // so the user can decide the appropriate time to release this
        autoreleasepool{
            // Get command buffer to use in MetalPerformanceShaders.
            let commandBuffer = commandQueue.makeCommandBuffer()
            
            // output will be stored in this image
            let finalLayer = MPSImage(device: commandBuffer.device, imageDescriptor: did)
            
            // encode layers to metal commandBuffer
            if inputImage == nil {
                conv1.encode(commandBuffer: commandBuffer, sourceImage: srcImage, destinationImage: c1Image)
            }
            else{
                conv1.encode(commandBuffer: commandBuffer, sourceImage: inputImage!, destinationImage: c1Image)
            }
            
            pool.encode   (commandBuffer: commandBuffer, sourceImage: c1Image   , destinationImage: p1Image)
            conv2.encode  (commandBuffer: commandBuffer, sourceImage: p1Image   , destinationImage: c2Image)
            pool.encode   (commandBuffer: commandBuffer, sourceImage: c2Image   , destinationImage: p2Image)
            fc1.encode    (commandBuffer: commandBuffer, sourceImage: p2Image   , destinationImage: fc1Image)
            fc2.encode    (commandBuffer: commandBuffer, sourceImage: fc1Image  , destinationImage: dstImage)
            softmax.encode(commandBuffer: commandBuffer, sourceImage: dstImage  , destinationImage: finalLayer)
            
            // add a completion handler to get the correct label the moment GPU is done and compare it to the correct output or return it
            commandBuffer.addCompletedHandler { commandBuffer in
                label = self.getLabel(finalLayer: finalLayer)
            }
            
            // commit commandbuffer to run on GPU and wait for completion
            commandBuffer.commit()
            if imageNum == 9999 {
                commandBuffer.waitUntilCompleted()
            }
            
        }
        return label
    }

    /**
     This function reads the output probabilities from finalLayer to CPU, sorts them and gets the label with heighest probability
     
     - Parameters:
     - finalLayer: output image of the network this has probabilities of each digit
     
     - Returns:
     Guess of the network as to what the digit is as UInt
     */
    func getLabel(finalLayer: MPSImage) -> UInt {
        // even though we have 10 labels outputed the MTLTexture format used is RGBAFloat16 thus 3 slices will have 3*4 = 12 outputs
        var result_half_array = [UInt16](repeating: 6, count: 12)
        var result_float_array = [Float](repeating: 0.3, count: 10)
        for i in 0...2 {
            finalLayer.texture.getBytes(&(result_half_array[4*i]),
                                        bytesPerRow: MemoryLayout<UInt16>.size*1*4,
                                        bytesPerImage: MemoryLayout<UInt16>.size*1*1*4,
                                        from: MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0),
                                                        size: MTLSize(width: 1, height: 1, depth: 1)),
                                        mipmapLevel: 0,
                                        slice: i)
        }
        
        // we use vImage to convert our data to float16, Metal GPUs use float16 and swift float is 32-bit
        var fullResultVImagebuf = vImage_Buffer(data: &result_float_array, height: 1, width: 10, rowBytes: 10*4)
        var halfResultVImagebuf = vImage_Buffer(data: &result_half_array , height: 1, width: 10, rowBytes: 10*2)
        
        if vImageConvert_Planar16FtoPlanarF(&halfResultVImagebuf, &fullResultVImagebuf, 0) != kvImageNoError {
            print("Error in vImage")
        }
        
        // poll all labels for probability and choose the one with max probability to return
        var max:Float = 0
        var mostProbableDigit = 10
        for i in 0...9 {
            if(max < result_float_array[i]){
                max = result_float_array[i]
                mostProbableDigit = i
            }
        }
        
        return UInt(mostProbableDigit)
    }
}
