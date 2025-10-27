#pragma once

#include <cstddef>

#ifdef __OBJC__
#import <Metal/Metal.h>
#else
// Forward declarations for C++ files
typedef struct objc_object* id;
#endif

// This file provides basic helper functions for using the Metal API.

struct MetalAPI
{
    void* device;              // MTLDevice*
    void* commandQueue;        // MTLCommandQueue*
    void* computePipeline;     // MTLComputePipelineState*
    
    // Input and output buffers
    void* inOutBuffers[3];     // MTLBuffer* array
    
    MetalAPI();
    ~MetalAPI();
    
    // Initialize Metal device and command queue
    int initDevice();
    
    // Create a compute pipeline from compiled Metal shader code
    int createComputePipeline(const void* code, size_t codeSize);
    
    // Create buffers for input and output data
    int createBuffers(size_t bufferSize);
    
    // Upload data to a buffer
    int uploadData(int bufferIndex, const void* data, size_t size);
    
    // Dispatch compute shader
    int dispatchCompute(size_t threadCount);
    
    // Download data from a buffer
    int downloadData(int bufferIndex, void* data, size_t size);
};

#define RETURN_ON_FAIL(x) \
    {                     \
        auto _res = x;    \
        if (_res != 0)    \
        {                 \
            return -1;    \
        }                 \
    }

