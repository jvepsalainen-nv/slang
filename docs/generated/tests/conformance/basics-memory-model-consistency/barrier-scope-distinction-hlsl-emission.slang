//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#barriers
//META: doc_section_digest=28e72df67f1e8f2f68fd59f23431c2be534ec39fa4206bc57dd04922591e5594
//META: purpose=The three address-space scopes (All, Device, ThreadGroup) for memory barriers produce distinct SPIRV memory semantics operands: All=2376, Device=2120, ThreadGroup=264.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans out the three-scope barrier distinction to the HLSL text target (the SPIRV
// sibling pins the distinct semantics operands 2376/2120/264). HLSL has no numeric
// memory-semantics operand; instead each scope maps to its own same-name HLSL
// barrier intrinsic. The three CHECKs pin AllMemoryBarrier / DeviceMemoryBarrier /
// GroupMemoryBarrier respectively, confirming the scope distinction survives to HLSL.

//TEST:SIMPLE(filecheck=ALLCHECK):-target hlsl -entry computeAllMain -stage compute
//TEST:SIMPLE(filecheck=DEVCHECK):-target hlsl -entry computeDevMain -stage compute
//TEST:SIMPLE(filecheck=GRPCHECK):-target hlsl -entry computeGrpMain -stage compute

RWStructuredBuffer<uint> buf;
groupshared uint shared1[64];

[numthreads(64,1,1)]
void computeAllMain(uint3 tid : SV_DispatchThreadID, uint3 gid : SV_GroupThreadID)
{
    buf[tid.x] = tid.x;
    AllMemoryBarrier();
    buf[tid.x + 1] = buf[0];
}

[numthreads(64,1,1)]
void computeDevMain(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = tid.x;
    DeviceMemoryBarrier();
    buf[tid.x + 1] = buf[0];
}

[numthreads(64,1,1)]
void computeGrpMain(uint3 tid : SV_DispatchThreadID, uint3 gid : SV_GroupThreadID)
{
    shared1[gid.x] = tid.x;
    GroupMemoryBarrier();
    buf[tid.x] = shared1[63 - gid.x];
}

// HLSL All scope: AllMemoryBarrier() and not the Device/Group-scoped form.
// ALLCHECK: AllMemoryBarrier();
// ALLCHECK-NOT: DeviceMemoryBarrier
// ALLCHECK-NOT: GroupMemoryBarrier

// HLSL Device scope: DeviceMemoryBarrier().
// DEVCHECK: DeviceMemoryBarrier();

// HLSL ThreadGroup scope: GroupMemoryBarrier().
// GRPCHECK: GroupMemoryBarrier();
