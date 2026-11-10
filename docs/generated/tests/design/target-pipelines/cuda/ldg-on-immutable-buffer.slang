//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerimmutablebufferloadforcuda
//META: purpose=lowerImmutableBufferLoadForCUDA translates a StructuredBuffer<T> load into a __ldg intrinsic call so the read-only cache path is used.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `lowerImmutableBufferLoadForCUDA` fires for `isCUDATarget` in
// Phase C. Loads of a read-only (StructuredBuffer) element become
// `__ldg(...)` calls in the emitted CUDA C++ text.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

StructuredBuffer<float> roBuf;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(roBuf[tid.x]);
}

// CHECK: __ldg
