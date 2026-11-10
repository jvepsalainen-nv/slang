//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#texture-sampler-and-texture-intrinsic-spellings
//META: purpose=SampleCmp on a non-depth texture is rejected by the static_assert inside the WGSL intrinsic body
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target wgsl -entry main -stage compute

Texture2D<float> tex;
SamplerComparisonState cs;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleCmpLevelZero(cs, float2(0.5,0.5), 0.5f);
}

// CHECK: E41400
// CHECK: WGSL comparison sampling
