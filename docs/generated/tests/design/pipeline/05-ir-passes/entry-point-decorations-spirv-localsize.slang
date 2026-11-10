//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#entry-point-and-parameter-handling
//META: purpose=Boundary: `[numthreads(8, 4, 2)]` (mixed non-trivial dimensions) is surfaced verbatim as `OpExecutionMode %main LocalSize 8 4 2` on SPIR-V by the entry-point-decorations pass.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary input for the entry-point-decorations pass: a numthreads
// triple with distinct non-trivial dimensions. The pass routes
// the values into `OpExecutionMode LocalSize` on SPIR-V.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(8, 4, 2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// SPIRV: OpEntryPoint
// SPIRV: OpExecutionMode %main LocalSize 8 4 2
