//
//  SlimMPSCNNConvolution.m
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 6/9/18.
//  Copyright © 2018 Shuichi Tsutsumi, Inc. All rights reserved.
//

#import "SlimMPSCNNConvolution.h"
#include <sys/mman.h>

// https://forums.developer.apple.com/thread/99554
@interface MPSCNNConvolution (MPSCNNConvolution_iOS10)

-(nonnull instancetype) initWithDevice: (nonnull id <MTLDevice>) device
                 convolutionDescriptor: (const MPSCNNConvolutionDescriptor * __nonnull) convolutionDescriptor
                         kernelWeights: (const float * __nonnull) kernelWeights
                             biasTerms: (const float * __nullable) biasTerms
                                 flags: (MPSCNNConvolutionFlags) flags;
@end

@interface SlimMPSCNNConvolution ()
{
    BOOL bn;
}
@end


@implementation SlimMPSCNNConvolution

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:YES];
}

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
    destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:YES
                             strideX:1
                             strideY:1
     destinationFeatureChannelOffset:destinationFeatureChannelOffset];
}

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:willPad
                             strideX:1
                             strideY:1];
}

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
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:willPad
                             strideX:strideX
                             strideY:strideY
     destinationFeatureChannelOffset:0];
}

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
                            padding:(BOOL)willPad
    destinationFeatureChannelOffset:(NSUInteger)destinationFeatureChannelOffset
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:willPad
                             strideX:1
                             strideY:1
     destinationFeatureChannelOffset:destinationFeatureChannelOffset
                            groupNum:1];
}

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
{
    return [self initWithKernelWidth:kernelWidth
                        kernelHeight:kernelHeight
                inputFeatureChannels:inputFeatureChannels
               outputFeatureChannels:outputFeatureChannels
                        neuronFilter:neuronFilter
                              device:device
              kernelParamsBinaryName:kernelParamsBinaryName
                             padding:willPad
                             strideX:strideX
                             strideY:strideY
     destinationFeatureChannelOffset:destinationFeatureChannelOffset
                            groupNum:1];
}

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
{
    // calculate the size of weights and bias required to be memory mapped into memory
    NSUInteger sizeBias = outputFeatureChannels * sizeof(float);
    NSUInteger sizeWeights = inputFeatureChannels * kernelHeight * kernelWidth * outputFeatureChannels * sizeof(float);
    
    // get the url to this layer's weights and bias
    NSString *filenameW = [NSString stringWithFormat:@"weights_%@", kernelParamsBinaryName];
    NSString *filenameB = [NSString stringWithFormat:@"bias_%@", kernelParamsBinaryName];
    NSString *wtPath = [[NSBundle mainBundle] pathForResource:filenameW ofType:@"dat"];
    NSString *bsPath = [[NSBundle mainBundle] pathForResource:filenameB ofType:@"dat"];
    NSAssert1(wtPath, @"Error: failed to find file %@", filenameW);
    NSAssert1(bsPath, @"Error: failed to find file %@", filenameB);

    // open file descriptors in read-only mode to parameter files
    int fd_w = open([wtPath UTF8String], O_RDONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
    int fd_b = open([bsPath UTF8String], O_RDONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
    NSAssert1(fd_w != -1, @"Error: failed to open output file at %@", wtPath);
    NSAssert1(fd_b != -1, @"Error: failed to open output file at %@", bsPath);
    
    // memory map the parameters
    void *hdrW = mmap(nil, sizeWeights, PROT_READ, MAP_FILE | MAP_SHARED, fd_w, 0);
    void *hdrB = mmap(nil, sizeBias, PROT_READ, MAP_FILE | MAP_SHARED, fd_b, 0);
    
    // cast Void pointers to Float
    float *w = hdrW;
    float *b = hdrB;
    
    MPSCNNConvolutionDescriptor *convDesc;
    convDesc = [MPSCNNConvolutionDescriptor cnnConvolutionDescriptorWithKernelWidth:kernelWidth
                                                                       kernelHeight:kernelHeight
                                                               inputFeatureChannels:inputFeatureChannels
                                                              outputFeatureChannels:outputFeatureChannels
                                                                       neuronFilter:neuronFilter];
    convDesc.strideInPixelsX = strideX;
    convDesc.strideInPixelsY = strideY;
    convDesc.groups = groupNum;

    self = [super initWithDevice:device
           convolutionDescriptor:convDesc
                   kernelWeights:w
                       biasTerms:b
                           flags:MPSCNNConvolutionFlagsNone];
    
    self.destinationFeatureChannelOffset = destinationFeatureChannelOffset;
    
    // FIXME: -
//    self.padding = willPad;
    
    NSAssert1(munmap(hdrW, sizeWeights) == 0, @"error %s" ,"hdrW");
    NSAssert1(munmap(hdrB, sizeBias) == 0, @"error %s" ,"hdrB");
    
    close(fd_w);
    close(fd_b);
    return self;
}

- (void)encodeToCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                  sourceImage:(MPSImage *)sourceImage
             destinationImage:(MPSImage *)destinationImage
{
    // padding
    NSUInteger padAlongHeight = (destinationImage.height - 1) * self.strideInPixelsY + self.kernelHeight - sourceImage.height;
    NSUInteger padAlongWidth = (destinationImage.width - 1) *self.strideInPixelsX + self.kernelWidth - sourceImage.width;
    NSUInteger padTop = padAlongHeight / 2;
    NSUInteger padLeft = padAlongWidth / 2;
    MPSOffset offset;
    offset.x = self.kernelWidth/2 - padLeft;
    offset.y = self.kernelHeight/2 - padTop;
    offset.z = 0;
    self.offset = offset;

    [super encodeToCommandBuffer:commandBuffer
                     sourceImage:sourceImage
                destinationImage:destinationImage];

}

@end
