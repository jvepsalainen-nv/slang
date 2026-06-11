//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: doc_section_digest=287321dc153823860396c030325e4ad4c0f6064005fa37b19c8ba53087dcd3e6
//META: purpose=Atomic<int>.compareExchange() lowers to WGSL atomicCompareExchangeWeak with a .old_value projection
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The compare-exchange row of the base Atomic<T> op family. WGSL has
// no direct CAS returning the prior value; the emitter spells it as
// atomicCompareExchangeWeak(...) and projects .old_value. CHECK pins
// both tokens, which together identify this cell uniquely.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<int>> ctr;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int old = ctr[0].compareExchange(3, 7);
    outBuf[tid.x] = old;
}

// CHECK: array<atomic<i32>
// CHECK: atomicCompareExchangeWeak(&(
// CHECK-SAME: .old_value
