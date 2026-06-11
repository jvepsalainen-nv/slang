//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: doc_section_digest=287321dc153823860396c030325e4ad4c0f6064005fa37b19c8ba53087dcd3e6
//META: purpose=Texture2D<float4>.SampleGrad(samp, uv, ddx, ddy) lowers to WGSL textureSampleGrad with explicit gradient arguments
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The explicit-gradient row of the texture-access intrinsic family.
// SampleGrad passes ddx/ddy derivatives and lowers to the distinct
// textureSampleGrad builtin (vs textureSample / textureSampleLevel).
// CHECK pins textureSampleGrad, the token that distinguishes this cell.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleGrad(samp, float2(tid.xy), float2(0.1, 0.1), float2(0.2, 0.2));
}

// CHECK: texture_2d<f32>
// CHECK: textureSampleGrad(
