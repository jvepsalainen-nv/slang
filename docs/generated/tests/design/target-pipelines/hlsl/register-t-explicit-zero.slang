//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Lower-edge boundary: a Texture2D pinned to register(t0) emits exactly that binding.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: explicit register(t0) — the lowest legal SRV slot.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

Texture2D<float4> tex : register(t0);
SamplerState samp : register(s0);
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float2(0.0, 0.0), 0.0);
}

// CHECK: Texture2D<float4{{.*}}> tex_{{[0-9]+}} : register(t0)
