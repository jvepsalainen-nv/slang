//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies a float NaN (0.0/0.0) is emitted on CUDA as the (0.0 / 0.0) expression form so the value is well-defined under nvrtc.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: float NaN. CUDA emit writes the NaN-producing
// expression as `(0.0 / 0.0)` and the result is gated by tid.x to
// prevent constant folding from removing the value.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float nan = (tid.x == 0U) ? (0.0f / 0.0f) : float(tid.x);
    outBuf[tid.x] = nan;
}

// CHECK: (0.0 / 0.0)
