//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=A groupshared array becomes a __device__ __shared__ global in CUDA emit and GroupMemoryBarrierWithGroupSync lowers to __syncthreads.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CUDA's CPPSourceEmitter/CUDASourceEmitter writes `groupshared` as
// `__device__ __shared__` and the HLSL barrier intrinsic becomes
// the CUDA `__syncthreads()` builtin.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

groupshared float gs[64];
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 ltid : SV_GroupThreadID)
{
    gs[ltid.x] = float(tid.x);
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = gs[ltid.x];
}

// CHECK: __device__ __shared__
// CHECK: __syncthreads
