//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#differentiability-as-interface-conformance
//META: purpose=Asking for `fwd_diff` of a function with no differentiable conformance fails as a member lookup (E30027), which is how the subtype query surfaces to the user.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative consequence of modelling differentiability as a
// conformance: with no attribute and no explicit extension, nothing installs
// the interface, so `fwd_diff` is simply not a member of the function. CHECK
// pins E30027 naming `fwd_diff` and the callee.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl

float plain(float x)
{
    return x * x;
}

RWStructuredBuffer<float> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    var r = fwd_diff(plain)(diffPair(2.0, 1.0));
//CHECK: E30027
    outputBuffer[0] = r.d;
}
