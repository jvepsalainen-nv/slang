//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=A static index of N-1 into a fixed-size array passes checkForOutOfBoundAccess, and the global constant is inlined at the use site so the CUDA text carries the element value directly.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the last in-bounds index of a four-element array is accepted
// by the Phase B out-of-bound validation, and pairs that with the CUDA
// forcing of `inlineGlobalConstantsForLegalization`: because nvrtc
// rejects dynamic `__device__` initialization, the array constant is
// inlined at every use, so index 3 emits as the literal element value
// rather than a subscript on a global. The CHECK asserts the folded
// literal reaches the buffer store.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<int> outBuf;
static const int arr[4] = { 1, 2, 3, 4 };

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = arr[3];
}

// CHECK: outBuf{{[A-Za-z0-9_]*}}){{.*}} = int(4);
