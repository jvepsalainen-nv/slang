//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: purpose=Verifies InterlockedAdd with uint MAX (0xFFFFFFFF) operand still lowers to atomicAdd on CUDA emit with the value 4294967295U.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: atomic-add with unsigned MAX operand. The pass
// `validateAtomicOperations` does not change behavior at the
// numeric boundary; the lowering still produces `atomicAdd` and
// the literal still survives as `4294967295U`.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedAdd(outBuf[0], uint(0xFFFFFFFFu));
}

// CHECK: extern "C" __global__ void main_0()
// CHECK: atomicAdd(
// CHECK-SAME: 4294967295U
