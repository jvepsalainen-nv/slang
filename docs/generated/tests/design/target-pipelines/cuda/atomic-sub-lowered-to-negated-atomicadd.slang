//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=An Atomic<int>.sub on a UAV lowers to atomicAdd with a negated operand because CUDA has no atomicSub for the signed-int path.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDA provides no `atomicSub` for this path, so `kIROp_AtomicSub` is a
// distinct emitter branch from AtomicAdd: it writes `atomicAdd(ptr, -(v))`.
// The Slang surface is the `Atomic<T>.sub` method. CHECK pins the negated
// operand form `atomicAdd(..., -(` to fix this cell apart from plain add.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<Atomic<int> > outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0].sub(int(tid.x));
}

// CHECK: atomicAdd({{.*}}, -(
