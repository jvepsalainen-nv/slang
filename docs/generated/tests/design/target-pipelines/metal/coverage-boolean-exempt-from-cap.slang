//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#metal-caps-coverage-counters-to-32-bits
//META: purpose=Boundary: boolean coverage mode is exempt from the Metal 32-bit cap, so an explicitly requested 64-bit width keeps a `ulong` counter written with a plain non-atomic store.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the documented carve-out at the other edge of the width axis:
// boolean mode writes plain stores rather than atomics, so MSL's missing
// 64-bit atomic fetch-add does not apply and the requested width is
// honored. Compiling with `-trace-coverage-boolean` plus an explicit
// 64-bit width and CHECKing for `ulong device*` and a `1ULL` store (with
// no `atomic_fetch_add_explicit` on the coverage slot) shows the cap did
// not fire here, in contrast to the counting-mode companion test.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute -trace-coverage -trace-coverage-boolean -trace-coverage-counter-width 64

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float(tid.x);
}

// CHECK: ulong device* _slang_coverage_{{[0-9]+}}
// CHECK: 1ULL
// CHECK-NOT: atomic_fetch_add_explicit
