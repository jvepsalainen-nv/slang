//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=A separate Texture2D and SamplerState pair both lower to UniformConstant-storage variables (the SPIR-V mapping for opaque texture and sampler handles).
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the UniformConstant storage class. Both a separate
// Texture2D and a SamplerState lower to UniformConstant pointers,
// distinct from Uniform (constant buffers) and StorageBuffer
// (read/write structured buffers).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

Texture2D tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float2(0.5, 0.5), 0.0);
}

// CHECK-DAG: %tex = OpVariable %{{[a-zA-Z_0-9]+}} UniformConstant
// CHECK-DAG: %samp = OpVariable %{{[a-zA-Z_0-9]+}} UniformConstant
