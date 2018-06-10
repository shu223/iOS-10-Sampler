//
//  SlimMPSCNNConvolution.h
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 6/9/18.
//  Copyright © 2018 Shuichi Tsutsumi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MetalPerformanceShaders;

@interface SlimMPSCNNConvolution : MPSCNNConvolution

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
                            strideX:(NSUInteger)strideX
                            strideY:(NSUInteger)strideY;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
    destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
                            strideX:(NSUInteger)strideX
                            strideY:(NSUInteger)strideY
    destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset;

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
                            strideX:(NSUInteger)strideX
                            strideY:(NSUInteger)strideY
    destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset
                           groupNum:(NSUInteger)groupNum;

@end
