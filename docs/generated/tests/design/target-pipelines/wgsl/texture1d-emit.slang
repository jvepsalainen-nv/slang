//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Texture1D<float4> emits as a global var with WGSL texture_1d<f32> type with a @binding/@group annotation.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The WGSL emitter maps Texture1D<float4> to the WGSL
// `texture_1d<f32>` type (element scalar dropped to `f32`; the
// vec4 shape is implicit in the sampling-return type) with a
// per-resource binding pair.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture1D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float(tid.x), 0).x;
}

// CHECK: var tex_{{[0-9]+}} : texture_1d<f32>
// CHECK: sampler
