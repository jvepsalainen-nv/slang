//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: doc_section_digest=287321dc153823860396c030325e4ad4c0f6064005fa37b19c8ba53087dcd3e6
//META: purpose=Atomic<int>.load() lowers to the WGSL atomicLoad intrinsic on the i32 element
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The load row of the base Atomic<T> op family. CHECK pins atomicLoad,
// distinguishing the read cell from the read-modify-write ops; the
// emitted form takes a single pointer operand (no value argument).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<int>> ctr;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = ctr[0].load();
    outBuf[tid.x] = v;
}

// CHECK: array<atomic<i32>
// CHECK: atomicLoad(&(
