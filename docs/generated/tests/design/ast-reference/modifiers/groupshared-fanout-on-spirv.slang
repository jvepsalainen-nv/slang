//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T09:43:32Z
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#compatibility-and-hlsl-storage-class-modifiers
//META: doc_section_digest=0b146a7577c216d587114be607b7bee424fa867d45b9300854bbc44543473939
//META: purpose=The `groupshared` storage modifier survives lowering to emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `groupshared` storage-modifier claim onto SPIR-V. The
// modifier lowers to the `Workgroup` storage class; CHECK pins the
// `OpVariable ... Workgroup` line for the shared array, proving the storage
// class survives codegen on this target.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

groupshared int gShared[4];

RWStructuredBuffer<int> outBuf;

[numthreads(4,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    gShared[tid.x] = int(tid.x);
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = gShared[tid.x];
}

//CHECK: %gShared = OpVariable %{{[A-Za-z0-9_]+}} Workgroup
