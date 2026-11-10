//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=Verifies a struct-typed groupshared declaration is lowered to __device__ __shared__ with field accesses preserved on CUDA emit.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: groupshared of an aggregate (struct) type. The
// `__device__ __shared__` lowering still applies and field
// accesses survive as `(&gs_0)->field_N` reads.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

struct Pair { int a; int b; }
groupshared Pair gs;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 ltid : SV_GroupThreadID)
{
    if (ltid.x == 0U) { gs.a = int(tid.x); gs.b = int(tid.y); }
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = gs.a + gs.b;
}

// CHECK: __device__ __shared__
// CHECK: __syncthreads
