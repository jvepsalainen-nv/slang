//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Texture2D<float4>.Sample(samp, uv) lowers to WGSL textureSample(tex, samp, uv) without an explicit LOD argument.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `Texture2D.Sample(samp, uv)` uses pixel-shader derivatives.
// In compute it still lowers to WGSL's `textureSample(...)`
// without an explicit LOD argument (contrast with SampleLevel
// which lowers to textureSampleLevel and an explicit LOD).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.Sample(samp, float2(tid.xy));
}

// CHECK: texture_2d<f32>
// CHECK: textureSample
