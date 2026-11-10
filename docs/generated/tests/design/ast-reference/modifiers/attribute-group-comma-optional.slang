//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#modifiers-vs-attributes
//META: purpose=Several attributes may share one bracket group and the comma between them is optional.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both halves of the shared-group rule: two attributes live in one
// `[...]` group, and they are separated by whitespace with no comma. If the
// parser required a separator, or bound only the first entry in the group, the
// stage marker or the workgroup size would be missing; the CHECK-DAG lines
// assert the emitted HLSL carries both.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl

RWStructuredBuffer<int> outBuf;

[shader("compute") numthreads(4, 1, 1)]
void csMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK-DAG: numthreads(4, 1, 1)
//CHECK-DAG: csMain
