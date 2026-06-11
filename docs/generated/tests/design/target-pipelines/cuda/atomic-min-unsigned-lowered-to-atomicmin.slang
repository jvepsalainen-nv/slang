//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=InterlockedMin on an unsigned uint UAV lowers to atomicMin with a uint-typed result, dispatching to the unsigned CUDA overload.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The signed/unsigned atomic-min distinction does not change the emitted op
// token (both emit `atomicMin`); it is realized by C++ overload resolution on
// the operand type. The uint cell is identified by the `uint` result decl and
// the absence of an `int(...)` cast on the operand. CHECK pins the `uint`
// result-typed `atomicMin` call to fix the unsigned branch as distinct from
// the signed sibling.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedMin(outBuf[0], tid.x);
}

// CHECK: uint {{[A-Za-z_0-9]+}} = atomicMin(
