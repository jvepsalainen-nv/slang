//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=Sampler2DArray (combined image+sampler) lowers to OpTypeSampledImage backed by an OpTypeImage with dim=2D and Arrayed=1 — combining the Sampler2D combined-sampler claim with the array-image dim claim.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: corner of the combined-sampler family. The Sampler2D
// claim is pinned in the existing sampler2d-sampled-image test;
// this one adds the Arrayed axis. SPIR-V supports combined-
// sampler arrayed images natively (still no lowerCombinedTextureSamplers
// pass), so the emit stays as OpTypeSampledImage.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

Sampler2DArray tex;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(float3(0.5, 0.5, 0), 0.0);
}

// CHECK-DAG: OpTypeImage %float 2D 2 1
// CHECK-DAG: OpTypeSampledImage
