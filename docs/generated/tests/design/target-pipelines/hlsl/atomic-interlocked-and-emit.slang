//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-c-hlsl-legalization-lowering-phi-elimination
//META: doc_section_digest=e8f525c4f3b39107c481bf03414c7c2ad6a1c96a430e84aae54c4f8e6a580692
//META: purpose=An atomic InterlockedAnd on a UAV survives Phase C and emits as the matching HLSL InterlockedAnd intrinsic, distinct from InterlockedAdd.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-op atomic-family depth: the Phase C table lists
// validateAtomicOperations for non-SPIRV targets. HLSL accepts the
// validated IR and the emitter selects the op-specific interlocked
// intrinsic. CHECK pins InterlockedAnd (not InterlockedAdd), the
// token that distinguishes this cell from the sibling add test.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int orig;
    InterlockedAnd(outBuf[0], int(tid.x), orig);
    outBuf[1] = orig;
}

// CHECK: InterlockedAnd(
