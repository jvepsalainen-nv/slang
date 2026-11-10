//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Atomic<int> emits as atomic<i32> and .add() lowers to atomicAdd on the i32 element
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The signed-int side of the atomic<T> axis: the element type
// switches from u32 to i32 while the atomicAdd intrinsic shape is
// preserved.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<int>> ctr;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int old = ctr[0].add(1);
    outBuf[tid.x] = old;
}

// CHECK: array<atomic<i32>
// CHECK: atomicAdd
