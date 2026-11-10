//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=TextureCube<float4> emits as a global var with WGSL texture_cube<f32> type and a @binding/@group annotation.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The WGSL emitter maps TextureCube<float4> to the WGSL
// `texture_cube<f32>` type. A SampleLevel call with a `float3`
// direction lowers to `textureSampleLevel(...)`.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

TextureCube<float4> tex;
SamplerState samp;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float3(tid), 0).x;
}

// CHECK: var tex_{{[0-9]+}} : texture_cube<f32>
// CHECK: textureSampleLevel
