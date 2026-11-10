//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#legalizeentrypointvaryingparamsforcuda
//META: purpose=legalizeEntryPointVaryingParamsForCUDA rewrites SV_DispatchThreadID into the CUDA builtin expression blockIdx * blockDim + threadIdx.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The CUDA-only Phase-C pass `legalizeEntryPointVaryingParamsForCUDA`
// turns the `SV_DispatchThreadID` varying parameter into a derived
// expression over CUDA builtins. The semantic does not survive as
// a literal token.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: blockIdx
// CHECK-SAME: blockDim
// CHECK-SAME: threadIdx
