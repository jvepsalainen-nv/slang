//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: purpose=`ConstantBuffer<T>` and `RWStructuredBuffer<T>` emit as distinct, independently-bound resource declarations on GLSL, Metal, CUDA, C++, and WGSL; neither backend merges them.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `ConstantBuffer<T>` and `RWStructuredBuffer<T>` emit as
// independent resource declarations on every text-emit backend other than
// HLSL (memory-aliasing-resources-hlsl-emission.slang) and SPIRV
// (memory-aliasing-resources-spirv-emission.slang).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

ConstantBuffer<int> cbuf;
RWStructuredBuffer<int> rwbuf;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int val = cbuf;
    rwbuf[0] = val;
}

// GLSL: layout({{.*}}) uniform block_{{.*}}
// GLSL: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_int_t_{{[0-9]+}}

// MTL: int constant{{.*}} cbuf_{{[0-9]+}};
// MTL: int device{{.*}} rwbuf_{{[0-9]+}};

// CUDA: int{{.*}} cbuf_{{[0-9]+}};
// CUDA: RWStructuredBuffer<int> rwbuf_{{[0-9]+}};

// CPP: int32_t{{.*}} cbuf_{{[0-9]+}};
// CPP: RWStructuredBuffer<int32_t> rwbuf_{{[0-9]+}};

// WGSL: var<uniform> cbuf_{{[0-9]+}} : i32
// WGSL: var<storage, read_write> rwbuf_{{[0-9]+}} : array<i32>

// HLSL: cbuffer cbuf_{{[0-9]+}} : register(b{{[0-9]+}})
// HLSL: RWStructuredBuffer<int > rwbuf_{{[0-9]+}} : register(u{{[0-9]+}})

// SPIRV-DAG: OpDecorate %cbuf{{.*}} Binding
// SPIRV-DAG: OpDecorate %cbuf{{.*}} DescriptorSet
// SPIRV-DAG: OpDecorate %rwbuf{{.*}} Binding
// SPIRV-DAG: OpDecorate %rwbuf{{.*}} DescriptorSet
// SPIRV-DAG: %cbuf = OpVariable %_ptr_Uniform_{{.*}} Uniform
// SPIRV-DAG: %rwbuf = OpVariable %_ptr_StorageBuffer_{{.*}} StorageBuffer
