//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-c-hlsl-legalization-lowering-phi-elimination
//META: doc_section_digest=e8f525c4f3b39107c481bf03414c7c2ad6a1c96a430e84aae54c4f8e6a580692
//META: purpose=An atomic InterlockedCompareExchange on a UAV survives Phase C and emits as the four-argument HLSL InterlockedCompareExchange intrinsic.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-op atomic-family depth: compare-exchange has a distinct
// four-argument shape (dest, compare, value, original) from the
// add/and/or/min family. HLSL accepts the validated IR and emits
// InterlockedCompareExchange. CHECK pins that intrinsic name, the
// token distinguishing this cell from the other interlocked ops.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int orig;
    InterlockedCompareExchange(outBuf[0], 0, int(tid.x), orig);
    outBuf[1] = orig;
}

// CHECK: InterlockedCompareExchange(
