//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[NumThreads(x,y,z)]` is an accepted alternate spelling of `[numthreads(x,y,z)]`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the capitalised spelling resolves to the same workgroup-size
// attribute. The extents are asymmetric so a silently-ignored attribute would
// leave the emitted entry point with the default 1,1,1; CHECK asserts the emitted
// HLSL carries the requested 8,2,1.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[NumThreads(8, 2, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: numthreads(8, 2, 1)
