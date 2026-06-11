//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: doc_section_digest=287321dc153823860396c030325e4ad4c0f6064005fa37b19c8ba53087dcd3e6
//META: purpose=Atomic<int>.max() lowers to the WGSL atomicMax intrinsic on the i32 element
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The maximum row of the Atomic<T> arithmetic op family. As with min,
// WGSL uses one `atomicMax` token for both signednesses; CHECK pins
// the op token and the i32 element to identify this cell.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<int>> ctr;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int old = ctr[0].max(7);
    outBuf[tid.x] = old;
}

// CHECK: array<atomic<i32>
// CHECK: atomicMax(&(
