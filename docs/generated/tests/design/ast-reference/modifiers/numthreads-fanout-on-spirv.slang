//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T09:43:32Z
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#stage-specific-entry-point-attributes
//META: doc_section_digest=5332741d22bd1f66cc006924c76c4414130d880c08abe1915fb243255799a71b
//META: purpose=`[numthreads(x,y,z)]` workgroup dimensions appear in emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `[numthreads]` workgroup-dimensions claim onto SPIR-V. The
// attribute lowers to an `OpExecutionMode ... LocalSize x y z` line; CHECK
// pins `LocalSize 8 4 2`, proving the chosen dimensions reach the SPIR-V
// execution mode.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(8, 4, 2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: OpExecutionMode %main LocalSize 8 4 2
