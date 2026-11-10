//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: purpose=CUDA uses the default legalizeByteAddressBufferOps options so ByteAddressBuffer.Load<T> survives as a templated method call.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `legalizeByteAddressBufferOps` runs with default options for CUDA
// (CUDA is in the `default` arm of both byte-address-buffer
// switches). The result is a templated `(buf).Load<T>(offset)`
// call in the emitted CUDA C++ source.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

ByteAddressBuffer bab;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint v = bab.Load<uint>(tid.x * 4);
    outBuf[tid.x] = v;
}

// CHECK: Load<uint
