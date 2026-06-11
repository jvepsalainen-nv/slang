//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T12:18:57Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-c-metal-legalization-lowering-phi-elimination
//META: doc_section_digest=de6a2b24718ef9344624fa3cfc660b5e13c913b28787d2b06b2db1085587ae5e
//META: purpose=InterlockedMax on a signed int buffer keeps atomic_fetch_max_explicit but casts through (atomic_int device*) rather than atomic_uint.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Atomic op-family depth — signed/unsigned branch for Max. With an
// `int` element the cast is `atomic_int device*`; the op name stays
// `atomic_fetch_max_explicit` (Metal has no SMax/UMax distinction).

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<int> counter;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int prev;
    InterlockedMax(counter[0], 1, prev);
}

// CHECK: atomic_fetch_max_explicit
// CHECK-SAME: atomic_int device*
// CHECK-SAME: memory_order_relaxed
