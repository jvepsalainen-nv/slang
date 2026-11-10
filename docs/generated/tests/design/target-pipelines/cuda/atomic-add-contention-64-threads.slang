//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: purpose=Verifies an atomic operation under a 64-thread block (contention stress) still emits as a single atomicAdd call on the same buffer slot.
//META: intent=stress
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress axis: 64 threads all writing the same slot through
// `InterlockedAdd`. The emit shape is unchanged from the smoke
// test, but exercises a high-contention dispatch envelope.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedAdd(outBuf[0], 1);
}

// CHECK: atomicAdd
