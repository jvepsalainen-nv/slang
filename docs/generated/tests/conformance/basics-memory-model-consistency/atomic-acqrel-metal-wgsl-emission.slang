//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#memory-order
//META: doc_section_digest=f82c5b23c187c6975c3756a23c69a4c91ddfdef1ddfe031714a5cf40822c89c8
//META: purpose=`Atomic<T>.load` with `MemoryOrder.AcquireRelease` emits `OpAtomicLoad` with AcquireRelease semantics in SPIRV, confirming memory accesses cannot cross the operation.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans out the AcquireRelease `Atomic<T>.load` claim to the Metal and WGSL text
// targets (the SPIRV sibling pins the AcquireRelease semantics operand). Metal has
// no separate acquire-release load ordering, so the load lowers to
// atomic_load_explicit with memory_order_seq_cst — the strongest available ordering;
// WGSL atomics are unconditionally sequentially consistent and lower to atomicLoad.
// Each CHECK pins the per-target atomic load form observed from slangc.

//TEST:SIMPLE(filecheck=METALCHECK):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSLCHECK):-target wgsl -entry computeMain -stage compute

RWStructuredBuffer<Atomic<uint>> atomicBuf;
RWStructuredBuffer<uint> outBuf;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = atomicBuf[0].load(MemoryOrder.AcquireRelease);
}

// Metal: AcquireRelease load maps to memory_order_seq_cst (no separate acq-rel load).
// METALCHECK: atomic_load_explicit
// METALCHECK-SAME: memory_order_seq_cst

// WGSL: atomicLoad (WGSL atomics are sequentially consistent; no ordering operand).
// WGSLCHECK: atomicLoad
