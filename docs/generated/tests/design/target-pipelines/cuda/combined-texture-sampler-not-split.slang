//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=lowerCombinedTextureSamplers is skipped for CUDA, so a Sampler2D stays a single global that maps to one CUtexObject instead of being split into a separate texture and sampler pair.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that CUDA never enters the combined-texture-sampler
// lowering arm. That switch names HLSL / Metal / WGSL explicitly and its
// default arm only falls through for CPU-like artifacts; a CUDA source
// artifact is not CPU-like, so the pass never runs even though the
// module contains a combined sampler. The observable consequence is that
// `Sampler2D` reaches the emitter intact and is written as one
// `CUtexObject` field of `GlobalParams`; had the pass run, the parameter
// block would carry two separate members. CHECK-NOT rules out a split
// `SamplerState`-derived member.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry computeMain -stage compute

Sampler2D tex;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(float2(0.5f, 0.5f), 0.0f);
}

// CHECK: struct GlobalParams
// CHECK: CUtexObject tex
// CHECK-NOT: SamplerState
// CHECK: tex2DLod
