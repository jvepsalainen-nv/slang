//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: doc_section_digest=f394bf1461f5876676bdb5fa5c51feaa920cf5ef0986df9fe1bbf0db976d5a30
//META: purpose=Each `Atomic<int>` RMW / CAS / load / store method emits its own distinguishing SPIR-V atomic opcode (`OpAtomicIAdd` / `OpAtomicAnd` / `OpAtomicOr` / `OpAtomicXor` / `OpAtomicExchange` / `OpAtomicCompareExchange` / `OpAtomicLoad` / `OpAtomicStore`).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the atomic-operations table's per-op branch as it reaches the
// SPIR-V backend: the `-dump-ir` sibling tests collapse to opcode names
// (`atomicAdd`, `atomicAnd`, ...); this test follows the same op family
// through SPIR-V legalize/emit and pins each distinct `OpAtomic*` mnemonic
// the backend selects. Operands come from SV_DispatchThreadID so the
// constant folder cannot remove the ops. Incidental result ids / pointer
// ids are left wild; the OpAtomic* mnemonic is the cell-identifying token.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

RWStructuredBuffer<Atomic<int> > abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = (int)tid.y;
    int r = 0;
    r += abuf[idx].add(v);
    r += abuf[idx].and(v);
    r += abuf[idx].or(v);
    r += abuf[idx].xor(v);
    r += abuf[idx].exchange(v);
    r += abuf[idx].compareExchange(v, v + 1);
    r += abuf[idx].load();
    abuf[idx].store(v);
    rwbuf[idx] = r;
}

// SPV-DAG: OpAtomicIAdd %int
// SPV-DAG: OpAtomicAnd %int
// SPV-DAG: OpAtomicOr %int
// SPV-DAG: OpAtomicXor %int
// SPV-DAG: OpAtomicExchange %int
// SPV-DAG: OpAtomicCompareExchange %int
// SPV-DAG: OpAtomicLoad %int
// SPV-DAG: OpAtomicStore
