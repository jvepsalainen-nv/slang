//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#modifiers-vs-attributes
//META: purpose=An attribute group may be written with double brackets (`[[a]]`) and means the same as the single-bracket form.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the double-bracket spelling of an attribute group is accepted and
// resolves to the same attribute as `[a]`. The workgroup size is written
// `[[numthreads(4,1,1)]]` and CHECK asserts the emitted HLSL carries
// `[numthreads(4, 1, 1)]`, which only happens if the group parsed and the
// checker bound it to the same attribute the single-bracket form produces.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[[numthreads(4, 1, 1)]]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: numthreads(4, 1, 1)
