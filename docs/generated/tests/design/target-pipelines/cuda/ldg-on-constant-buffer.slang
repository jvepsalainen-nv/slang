//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerimmutablebufferloadforcuda
//META: purpose=The backing pointer for a top-level ConstantBuffer<T> is loaded from SLANG_globalParams, after which reading its contents is eligible for __ldg global-memory lowering.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDA stores the ConstantBuffer backing pointer in its synthesized
// `__constant__` parameter group. The pointer load stays plain, but
// dereferencing the pointed-to global memory is eligible for `__ldg`.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

ConstantBuffer<uint> inBuf;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf;
}

// CHECK: __ldg(globalParams_{{[0-9]+}}->inBuf_{{[0-9]+}})
