//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=InterlockedOr on a UAV lowers to the CUDA atomicOr intrinsic in the emitted CUDA C++ text.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `InterlockedOr` lowers to `kIROp_AtomicOr`; the CUDA emitter writes the
// per-op branch as `atomicOr(...)`. CHECK pins `atomicOr` to distinguish it
// from the sibling and/xor/add cells which each emit their own intrinsic.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedOr(outBuf[0], int(tid.x));
}

// CHECK: atomicOr(
