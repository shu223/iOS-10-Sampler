//
//  Inception3Net+label.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
import MetalKit
import Accelerate

extension Inception3Net {
    
    /**
     This function reads the output probabilities from sftImage to CPU, sorts them and gets the label of top 5 probabilities
     
     - Returns:
     A string with top-5 valid labels ready to be put in predictLabel
     */
    func getResults() -> [(String, Float)] {
        
        // gather measurements of MPSImage to use to get out probabilities
        let width = sftImage.width
        let height = sftImage.height
        let numSlices = (sftImage.featureChannels + 3)/4;
        let count = sftImage.texture.width*sftImage.texture.height*sftImage.featureChannels
        let channelsPerSlice = 4 // textures are in RGBA format
        
        var output = [UInt16](repeating: 3 , count: count)
        var outputF = [Float](repeating: 0.6 , count: count)
        
        // get probabilities of each label in UIn16 array we use this to contain float16s
        for i in 0..<numSlices {
            sftImage.texture.getBytes(&(output[height*width*channelsPerSlice*i]),
                                      bytesPerRow: MemoryLayout<UInt16>.size*width*channelsPerSlice,
                                      bytesPerImage: 0,
                                      from: MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0),
                                                      size: MTLSize(width: width, height: height, depth: 1)),
                                      mipmapLevel: 0,
                                      slice: i)
        }
        
        // use VImage to convert Float16 to Float32 so we can use them
        var fullResultVImagebuf = vImage_Buffer(data: &outputF, height: 1, width: UInt(count), rowBytes: count*4)
        var halfResultVImagebuf = vImage_Buffer(data: &output, height: 1, width: UInt(count), rowBytes: count*2)
        
        if(vImageConvert_Planar16FtoPlanarF(&halfResultVImagebuf, &fullResultVImagebuf, 0) != kvImageNoError){
            print("Error in vImage")
        }
        
        // copy output probabilities into an array of touples of (probability, index)
        var indexedProbabilities = [(Float, Int)]()
        for i in 0..<outputF.count{
            indexedProbabilities.append((outputF[i], i))
        }
        
        // sort the touple array to have top5 guesses in the front
        indexedProbabilities.sort { (a: (prob: Float, _: Int), b: (prob: Float, _: Int)) -> Bool in
            return a.prob > b.prob
        }
        
        // get top 5 valid guesses and add them to return string with top 5 guesses
        var results: [(String, Float)] = []
        var j = 0
        var i = 0
        while( j < 5){
            let (prob, index) = indexedProbabilities[i]
            // labels at 0 and 1001 to 1008 are invalid (no labels were provided for these indices) so we ignore these
            if((index < 1001) && (index > 0)){
                results.append((labels[index], prob))
                j = j + 1
            }
            i = i + 1
        }
        return results
    }
}
