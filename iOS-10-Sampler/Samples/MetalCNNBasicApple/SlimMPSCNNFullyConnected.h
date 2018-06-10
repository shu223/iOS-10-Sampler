//
//  SlimMPSCNNFullyConnected.h
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 6/9/18.
//  Copyright © 2018 Shuichi Tsutsumi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MetalPerformanceShaders;

@interface SlimMPSCNNFullyConnected : MPSCNNFullyConnected

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName;

@end
