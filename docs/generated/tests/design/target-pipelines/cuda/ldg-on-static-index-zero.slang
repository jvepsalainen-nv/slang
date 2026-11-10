//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerimmutablebufferloadforcuda
//META: purpose=Verifies lowerImmutableBufferLoadForCUDA emits __ldg for a static index 0 (lower-edge) load of a StructuredBuffer.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: scalar immutable-buffer load at the lower edge
// (index 0). The pass still fires and the read goes through `__ldg`.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

StructuredBuffer<float> roBuf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = roBuf[0];
}

// CHECK: extern "C" __global__ void main_0()
// CHECK: __ldg(
// CHECK-SAME: int(0)
