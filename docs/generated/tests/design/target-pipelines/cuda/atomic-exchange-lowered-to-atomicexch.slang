//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=InterlockedExchange on a UAV lowers to the CUDA atomicExch intrinsic in the emitted CUDA C++ text.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `InterlockedExchange` lowers to `kIROp_AtomicExchange`, a distinct CUDA
// emitter branch that writes `atomicExch(...)`. CHECK pins `atomicExch` to
// distinguish the exchange cell from the read-modify-write cells.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int orig;
    InterlockedExchange(outBuf[0], int(tid.x), orig);
}

// CHECK: atomicExch(
