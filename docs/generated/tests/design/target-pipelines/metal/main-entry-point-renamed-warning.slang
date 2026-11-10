//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#entry-point-shape
//META: purpose=An entry point named exactly `main` is renamed on Metal and the rename is reported as warning E40100 rather than applied silently.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the Metal rename of a `main` entry point is a *reported*
// rewrite, not a silent one: a caller who looks up the kernel by name in the
// compiled library has to learn the name changed. The compile emits exactly
// one diagnostic, so pinning the stable code E40100 is sufficient and no
// other diagnostic is left unannotated.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: E40100
