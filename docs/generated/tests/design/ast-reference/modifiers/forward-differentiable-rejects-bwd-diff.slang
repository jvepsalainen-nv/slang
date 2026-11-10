//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#differentiable-attribute-family
//META: purpose=`[ForwardDifferentiable]` marks only forward mode, so `bwd_diff` on such a function is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The negative counterpart that pins the mapping down: `[ForwardDifferentiable]`
// is the one spelling that does not imply backward mode, so asking for
// `bwd_diff` must fail. CHECK pins the member-not-found error code raised for
// the unavailable `bwd_diff` on that function.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<float> outBuf;

[ForwardDifferentiable]
float square(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void computeMain()
{
    DifferentialPair<float> p = diffPair(3.0, 0.0);
    bwd_diff(square)(p, 1.0);
    //CHECK: E30027
    outBuf[0] = p.d;
}
