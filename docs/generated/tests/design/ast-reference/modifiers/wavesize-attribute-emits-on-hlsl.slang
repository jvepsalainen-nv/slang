//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[WaveSize(N)]` on a compute entry point carries the lane count into emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the requested wave width is retained on the entry point rather than
// discarded once checking accepts it. CHECK asserts the emitted HLSL reproduces
// `[WaveSize(32)]`, which is what pins the lane count for the downstream
// compiler.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute -profile sm_6_6

RWStructuredBuffer<int> outBuf;

[WaveSize(32)]
[numthreads(32, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: WaveSize(32)
