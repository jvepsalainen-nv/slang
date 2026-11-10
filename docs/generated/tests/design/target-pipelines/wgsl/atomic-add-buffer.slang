//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Atomic<uint> emits as atomic<u32> in the storage buffer element and .add() lowers to atomicAdd
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL exposes atomic<T> as a typed element in a storage buffer;
// member calls like .add() map onto atomicAdd intrinsics.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<uint>> ctr;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint old = ctr[0].add(1);
    outBuf[tid.x] = old;
}

// CHECK: array<atomic<u32>
// CHECK: atomicAdd
