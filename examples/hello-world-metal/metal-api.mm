#include "metal-api.h"

#import <Metal/Metal.h>
#import <Foundation/Foundation.h>

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

MetalAPI::MetalAPI()
    : device(nullptr)
    , commandQueue(nullptr)
    , computePipeline(nullptr)
{
    for (int i = 0; i < 3; i++)
    {
        inOutBuffers[i] = nullptr;
    }
}

MetalAPI::~MetalAPI()
{
    // Release Metal objects manually (no ARC)
    if (computePipeline)
    {
        [(__bridge id<MTLComputePipelineState>)computePipeline release];
        computePipeline = nullptr;
    }
    
    for (int i = 0; i < 3; i++)
    {
        if (inOutBuffers[i])
        {
            [(__bridge id<MTLBuffer>)inOutBuffers[i] release];
            inOutBuffers[i] = nullptr;
        }
    }
    
    if (commandQueue)
    {
        [(__bridge id<MTLCommandQueue>)commandQueue release];
        commandQueue = nullptr;
    }
    
    if (device)
    {
        [(__bridge id<MTLDevice>)device release];
        device = nullptr;
    }
}

int MetalAPI::initDevice()
{
    // Get the default Metal device
    id<MTLDevice> mtlDevice = MTLCreateSystemDefaultDevice();
    if (!mtlDevice)
    {
        printf("Failed to create Metal device.\n");
        return -1;
    }
    
    // Create command queue
    id<MTLCommandQueue> queue = [mtlDevice newCommandQueue];
    if (!queue)
    {
        printf("Failed to create Metal command queue.\n");
        return -1;
    }
    
    // Store pointers (objects already have +1 retain count from Create/new methods)
    device = (__bridge void*)mtlDevice;
    commandQueue = (__bridge void*)queue;
    
    return 0;
}

int MetalAPI::createComputePipeline(const void* code, size_t codeSize)
{
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    
    // Create a string from the Metal shader code
    NSString* sourceCode = [[NSString alloc] initWithBytes:code 
                                                    length:codeSize 
                                                  encoding:NSUTF8StringEncoding];
    if (!sourceCode)
    {
        printf("Failed to create NSString from shader code.\n");
        return -1;
    }
    
    // Create library from source code
    NSError* error = nil;
    MTLCompileOptions* options = [[MTLCompileOptions alloc] init];
    id<MTLLibrary> library = [mtlDevice newLibraryWithSource:sourceCode 
                                                     options:options 
                                                       error:&error];
    
    // Release temporary objects
    [sourceCode release];
    [options release];
    
    if (!library)
    {
        printf("Failed to compile Metal library: %s\n", 
               [[error localizedDescription] UTF8String]);
        return -1;
    }
    
    // Get the compute function
    id<MTLFunction> computeFunction = [library newFunctionWithName:@"computeMain"];
    if (!computeFunction)
    {
        [library release];
        printf("Failed to find compute function 'computeMain' in Metal library.\n");
        return -1;
    }
    
    // Create compute pipeline state
    id<MTLComputePipelineState> pipeline = [mtlDevice newComputePipelineStateWithFunction:computeFunction 
                                                                                    error:&error];
    
    // Release temporary objects
    [library release];
    [computeFunction release];
    
    if (!pipeline)
    {
        printf("Failed to create compute pipeline state: %s\n", 
               [[error localizedDescription] UTF8String]);
        return -1;
    }
    
    // Store pointer (object already has +1 retain count from new method)
    computePipeline = (__bridge void*)pipeline;
    
    return 0;
}

int MetalAPI::createBuffers(size_t bufferSize)
{
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    
    // Create three buffers for input0, input1, and output
    for (int i = 0; i < 3; i++)
    {
        id<MTLBuffer> buffer = [mtlDevice newBufferWithLength:bufferSize 
                                                      options:MTLResourceStorageModeShared];
        if (!buffer)
        {
            printf("Failed to create Metal buffer %d.\n", i);
            return -1;
        }
        // Store pointer (object already has +1 retain count from new method)
        inOutBuffers[i] = (__bridge void*)buffer;
    }
    
    return 0;
}

int MetalAPI::uploadData(int bufferIndex, const void* data, size_t size)
{
    if (bufferIndex < 0 || bufferIndex >= 3)
    {
        printf("Invalid buffer index: %d\n", bufferIndex);
        return -1;
    }
    
    id<MTLBuffer> buffer = (__bridge id<MTLBuffer>)inOutBuffers[bufferIndex];
    if (!buffer)
    {
        printf("Buffer %d is not initialized.\n", bufferIndex);
        return -1;
    }
    
    // Copy data to buffer
    memcpy([buffer contents], data, size);
    
    return 0;
}

int MetalAPI::dispatchCompute(size_t threadCount)
{
    id<MTLCommandQueue> queue = (__bridge id<MTLCommandQueue>)commandQueue;
    id<MTLComputePipelineState> pipeline = (__bridge id<MTLComputePipelineState>)computePipeline;
    
    // Create command buffer
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    if (!commandBuffer)
    {
        printf("Failed to create command buffer.\n");
        return -1;
    }
    
    // Create compute command encoder
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
    if (!encoder)
    {
        printf("Failed to create compute command encoder.\n");
        return -1;
    }
    
    // Set compute pipeline state
    [encoder setComputePipelineState:pipeline];
    
    // Bind buffers
    for (int i = 0; i < 3; i++)
    {
        id<MTLBuffer> buffer = (__bridge id<MTLBuffer>)inOutBuffers[i];
        [encoder setBuffer:buffer offset:0 atIndex:i];
    }
    
    // Calculate thread group sizes
    MTLSize threadgroupSize = MTLSizeMake(1, 1, 1);
    MTLSize threadgroupCount = MTLSizeMake(threadCount, 1, 1);
    
    // Dispatch compute
    [encoder dispatchThreadgroups:threadgroupCount 
            threadsPerThreadgroup:threadgroupSize];
    
    // End encoding
    [encoder endEncoding];
    
    // Commit and wait
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    
    return 0;
}

int MetalAPI::downloadData(int bufferIndex, void* data, size_t size)
{
    if (bufferIndex < 0 || bufferIndex >= 3)
    {
        printf("Invalid buffer index: %d\n", bufferIndex);
        return -1;
    }
    
    id<MTLBuffer> buffer = (__bridge id<MTLBuffer>)inOutBuffers[bufferIndex];
    if (!buffer)
    {
        printf("Buffer %d is not initialized.\n", bufferIndex);
        return -1;
    }
    
    // Copy data from buffer
    memcpy(data, [buffer contents], size);
    
    return 0;
}

