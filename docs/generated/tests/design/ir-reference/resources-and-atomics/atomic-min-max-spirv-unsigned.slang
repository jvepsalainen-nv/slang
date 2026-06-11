//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: doc_section_digest=f394bf1461f5876676bdb5fa5c51feaa920cf5ef0986df9fe1bbf0db976d5a30
//META: purpose=`Atomic<uint>::min(v)` / `::max(v)` (unsigned element type) select the unsigned SPIR-V atomic opcodes `OpAtomicUMin` / `OpAtomicUMax`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the unsigned branch of the atomicMin/atomicMax cell — the
// sibling of `atomic-min-max-spirv-signed.slang`. The two differ only in
// element-type signedness, and that single axis flips the emitted opcode
// from `OpAtomicSMin/SMax` to `OpAtomicUMin/UMax`. This is the branch the
// type-neutral `-dump-ir` opcode name hides.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

RWStructuredBuffer<Atomic<uint> > abuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint v = tid.y;
    uint pmin = abuf[idx].min(v);
    uint pmax = abuf[idx].max(v);
    rwbuf[idx] = pmin + pmax;
}

// SPV-DAG: OpAtomicUMin %uint
// SPV-DAG: OpAtomicUMax %uint
