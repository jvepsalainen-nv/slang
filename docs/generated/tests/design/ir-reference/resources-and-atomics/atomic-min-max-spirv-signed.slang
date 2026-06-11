//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: doc_section_digest=f394bf1461f5876676bdb5fa5c51feaa920cf5ef0986df9fe1bbf0db976d5a30
//META: purpose=`Atomic<int>::min(v)` / `::max(v)` (signed element type) select the signed SPIR-V atomic opcodes `OpAtomicSMin` / `OpAtomicSMax`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the signed branch of the atomicMin/atomicMax cell. The
// `-dump-ir` sibling (`atomic-min-max.slang`) shows only the type-neutral
// `atomicMin`/`atomicMax` opcode names; the signed-vs-unsigned distinction
// is made by SPIR-V legalization from the element type. With a signed
// `Atomic<int>` element the backend must pick `OpAtomicSMin`/`OpAtomicSMax`.
// Companion: `atomic-min-max-spirv-unsigned.slang`.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

RWStructuredBuffer<Atomic<int> > abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = (int)tid.y;
    int pmin = abuf[idx].min(v);
    int pmax = abuf[idx].max(v);
    rwbuf[idx] = pmin + pmax;
}

// SPV-DAG: OpAtomicSMin %int
// SPV-DAG: OpAtomicSMax %int
