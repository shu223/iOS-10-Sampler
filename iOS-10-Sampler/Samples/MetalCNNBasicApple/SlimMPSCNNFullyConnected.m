//
//  SlimMPSCNNFullyConnected.m
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 6/9/18.
//  Copyright © 2018 Shuichi Tsutsumi, Inc. All rights reserved.
//

#import "SlimMPSCNNFullyConnected.h"
#include <sys/mman.h>

@interface SlimMPSCNNFullyConnected ()
{
    BOOL bn;
}
@end


@implementation SlimMPSCNNFullyConnected

- (instancetype)initWithKernelWidth:(NSUInteger)kernelWidth
                       kernelHeight:(NSUInteger)kernelHeight
               inputFeatureChannels:(NSUInteger)inputFeatureChannels
              outputFeatureChannels:(NSUInteger)outputFeatureChannels
                       neuronFilter:(MPSCNNNeuron *)neuronFilter
                             device:(id<MTLDevice>)device
             kernelParamsBinaryName:(NSString *)kernelParamsBinaryName
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
    self = [super initWithDevice:device
           convolutionDescriptor:convDesc
                   kernelWeights:w
                       biasTerms:b
                           flags:MPSCNNConvolutionFlagsNone];
    if (self) {
        self.destinationFeatureChannelOffset = 0;
    }
    
    NSAssert1(munmap(hdrW, sizeWeights) == 0, @"error %s" ,"hdrW");
    NSAssert1(munmap(hdrB, sizeBias) == 0, @"error %s" ,"hdrB");
    
    close(fd_w);
    close(fd_b);
    return self;
}

@end
