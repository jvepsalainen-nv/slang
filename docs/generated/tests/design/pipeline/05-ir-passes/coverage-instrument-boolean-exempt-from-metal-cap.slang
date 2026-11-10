//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#instrumentation
//META: purpose=Boundary: boolean coverage mode is exempt from the Metal counter-width cap because it stores rather than accumulates, so an explicitly requested 64-bit width draws no warning there.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out attached to the Metal cap. This is the sibling of
// the counting-mode test: identical target and identical explicit 64-bit
// request, with boolean mode added. The row's reason for the exemption is
// that boolean mode never issues an atomic, so the MSL limitation does not
// apply and no cap warning should be reported. The CHECK asserts E45115 is
// absent from the output.

//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main -trace-coverage -trace-coverage-boolean -trace-coverage-counter-width 64

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid: SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// METAL: kernel
// METAL-NOT: E45115
