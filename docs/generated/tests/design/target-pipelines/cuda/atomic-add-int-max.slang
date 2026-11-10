//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: purpose=Verifies an atomic operation at int MAX 2147483647 still lowers to atomicAdd on CUDA emit and the constant is wrapped in int(...).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: atomic-add operand at signed-int MAX. The lowering
// to `atomicAdd` is unaffected by the operand boundary value.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedAdd(outBuf[0], int(2147483647));
}

// CHECK: extern "C" __global__ void main_0()
// CHECK: atomicAdd(
// CHECK-SAME: int(2147483647)
