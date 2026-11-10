//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies the half largest-finite value 65504 round-trips through CUDA emit as the __half(...) cast so the value reaches nvrtc as a CUDA half.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: half (fp16) largest finite. CUDA emit wraps half
// values in the prelude `__half(...)` constructor and the literal
// value 65504 is the documented half max.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<half> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    half h = half((tid.x == 0U) ? 65504.0f : float(tid.x));
    outBuf[tid.x] = h;
}

// CHECK: 65504.0f
// CHECK: __half(
