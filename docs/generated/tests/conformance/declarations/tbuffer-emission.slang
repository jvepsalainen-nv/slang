//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#constant-buffers-and-texture-buffers
//META: purpose=A `tbuffer` declaration uses the same expansion as `cbuffer` but with `TextureBuffer<T>`, producing a `tbuffer` keyword in emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `tbuffer` block emits correctly on every feasible text-emit backend.
// HLSL uses the `tbuffer` keyword; GLSL emits a std140 uniform block; Metal emits a
// texture_buffer<> parameter; WGSL emits a var<uniform> binding. SPIR-V, CUDA, and CPP
// fail with an internal compiler error (compiler bug — see Untested claims in README).

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

tbuffer MyTex : register(t0)
{
    float4 texData;
}
RWStructuredBuffer<float> output;
[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    output[0] = texData.x;
}

// HLSL: tbuffer
// HLSL: MyTex

// GLSL: MyTex{{[_0-9]*}}
// GLSL: texData

// METAL: texture_buffer
// METAL: texData

// WGSL: var<uniform> MyTex{{[_0-9]*}}
// WGSL: texData
