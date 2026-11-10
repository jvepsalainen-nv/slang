//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#constant-buffers-and-texture-buffers
//META: purpose=A `cbuffer` declaration expands to an anonymous struct in a `ConstantBuffer<>`, and fields are accessible directly by name in emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `cbuffer` block is emitted as a uniform/constant-buffer binding across every
// text-emit backend. HLSL uses the `cbuffer` keyword; SPIR-V emits a Uniform block named MyParams;
// GLSL/Metal/WGSL/CUDA/CPP each emit a struct wrapping the fields. Each prefix CHECK asserts
// the struct name and the `count` field appear in the target output.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

cbuffer MyParams : register(b0)
{
    float4 color;
    int count;
}
RWStructuredBuffer<int> output;
[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    output[0] = count;
}

// HLSL: cbuffer
// HLSL: MyParams
// HLSL: count

// SPV-DAG: OpName %MyParams
// SPV-DAG: count

// GLSL: SLANG_ParameterGroup_MyParams
// GLSL: count

// METAL: SLANG_ParameterGroup_MyParams
// METAL: count

// WGSL: var<uniform> MyParams
// WGSL: count

// CUDA: SLANG_ParameterGroup_MyParams
// CUDA: count

// CPP: SLANG_ParameterGroup_MyParams
// CPP: count
