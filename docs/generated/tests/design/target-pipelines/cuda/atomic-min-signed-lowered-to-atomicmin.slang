//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=InterlockedMin on a signed int UAV lowers to the CUDA atomicMin intrinsic with an int-typed result.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `InterlockedMin` lowers to `kIROp_AtomicMin`, emitted as `atomicMin(...)`.
// Signed vs unsigned dispatch is on the CUDA C++ overload of `atomicMin`, so
// the op token is shared; the signed cell is identified by the `int`-typed
// result decl. CHECK pins both `int` result and `atomicMin` to fix the cell.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedMin(outBuf[0], int(tid.x));
}

// CHECK: int {{[A-Za-z_0-9]+}} = atomicMin(
