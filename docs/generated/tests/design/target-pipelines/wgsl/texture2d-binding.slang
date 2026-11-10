//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Texture2D<float4> emits as a global var with texture_2d<f32> type and a @binding/@group pair
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A Texture2D should map to WGSL's texture_2d<f32> type with a
// binding annotation.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float2(0, 0), 0).x;
}

// CHECK: @binding({{[0-9]+}}) @group(0) var tex_{{[0-9]+}} : texture_2d<f32>
// CHECK: sampler
