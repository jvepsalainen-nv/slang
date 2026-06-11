//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#simple-modifiers
//META: doc_section_digest=f4322db59ceb8b8af42c196b566ca82e3f4804c47a61babf133a4e241eddf511
//META: purpose=`groupshared` is a simple HLSL-flavored storage modifier; it lowers to `groupshared` in HLSL emit and to `shared` in GLSL emit.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission fan-out for the `groupshared` storage modifier onto the
// remaining shader text targets. The sibling
// `modifier-groupshared-multitarget.slang` pins HLSL (`groupshared`) and
// GLSL (`shared`). The value must escape (be read back after a barrier
// into an output buffer) or DCE removes the shared array before emit on
// Metal/SPIR-V; this shader therefore writes through the shared array,
// barriers, and reads a neighbouring slot into `outBuf`. Each CHECK pins
// the target's own group-shared storage class (Metal `threadgroup`,
// SPIR-V `Workgroup` storage class, WGSL `var<workgroup>`).

//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

groupshared int sharedBuf[4];
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 gid : SV_GroupThreadID)
{
    sharedBuf[gid.x] = int(tid.x);
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = sharedBuf[(gid.x + 1) % 4];
}

//METAL: threadgroup array<int
//SPV-DAG: %sharedBuf = OpVariable %{{[A-Za-z0-9_]+}} Workgroup
//WGSL: var<workgroup> sharedBuf
