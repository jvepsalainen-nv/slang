//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Boundary: an RWTexture1D bound `register(u63)` (high-index UAV) preserves its explicit `u63` annotation through HLSL emit.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: high-index `u` register on an RWTexture1D. The
// emit preserves multi-digit indices verbatim.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWTexture1D<float4> tex : register(u63);
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    tex[0] = float4(1.0);
    outBuf[tid.x] = float4(1.0);
}

// CHECK: RWTexture1D{{.*}} tex_{{[0-9]+}} : register(u63)
