//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies the float positive-zero literal 0.0f survives CUDA emit as 0.0f when guarded behind a thread-id branch (constant-folding cannot remove it).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: float +0.0. Constant folding eliminates a pure
// 0.0 + 0.0 expression, so the value is gated by tid.x so the
// literal must reach emit.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float pz = (tid.x == 0U) ? 0.0f : float(tid.x);
    outBuf[tid.x] = pz;
}

// CHECK: 0.0f
