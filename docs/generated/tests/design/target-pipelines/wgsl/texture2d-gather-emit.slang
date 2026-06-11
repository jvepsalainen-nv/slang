//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: doc_section_digest=287321dc153823860396c030325e4ad4c0f6064005fa37b19c8ba53087dcd3e6
//META: purpose=Texture2D<float4>.Gather(samp, uv) lowers to the WGSL textureGather builtin returning the four-texel footprint
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The gather row of the texture-access intrinsic family. Gather reads
// the four-texel footprint and lowers to the distinct textureGather
// builtin (vs the single-sample textureSample family). CHECK pins
// textureGather, the token that distinguishes this cell.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.Gather(samp, float2(tid.xy));
}

// CHECK: texture_2d<f32>
// CHECK: textureGather(
