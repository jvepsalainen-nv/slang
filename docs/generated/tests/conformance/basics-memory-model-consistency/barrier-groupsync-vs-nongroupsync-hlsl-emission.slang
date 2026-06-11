//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#barriers
//META: doc_section_digest=28e72df67f1e8f2f68fd59f23431c2be534ec39fa4206bc57dd04922591e5594
//META: purpose=`*WithGroupSync` barrier variants emit `OpControlBarrier` (thread group execution sync + memory barrier), while their non-sync counterparts emit `OpMemoryBarrier` (memory-only, no execution sync).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans out the GroupSync-vs-non-sync barrier distinction to the HLSL text target
// (the SPIRV sibling pins OpMemoryBarrier vs OpControlBarrier). HLSL has no
// structural OpMemoryBarrier/OpControlBarrier split; instead each Slang barrier
// preserves its same-name HLSL intrinsic, so the non-sync entry emits
// AllMemoryBarrier and the GroupSync entry emits AllMemoryBarrierWithGroupSync.
// MEMCHECK confirms the non-sync entry does NOT pull in the WithGroupSync form.

//TEST:SIMPLE(filecheck=MEMCHECK):-target hlsl -entry computeMemMain -stage compute
//TEST:SIMPLE(filecheck=CTRLCHECK):-target hlsl -entry computeCtrlMain -stage compute

RWStructuredBuffer<uint> buf;

[numthreads(64,1,1)]
void computeMemMain(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = tid.x;
    AllMemoryBarrier();
    buf[tid.x + 64] = buf[0];
}

[numthreads(64,1,1)]
void computeCtrlMain(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = tid.x;
    AllMemoryBarrierWithGroupSync();
    buf[tid.x + 64] = buf[0];
}

// HLSL non-sync: emits AllMemoryBarrier() and not the WithGroupSync form.
// MEMCHECK: AllMemoryBarrier();
// MEMCHECK-NOT: WithGroupSync

// HLSL GroupSync: emits AllMemoryBarrierWithGroupSync().
// CTRLCHECK: AllMemoryBarrierWithGroupSync();
