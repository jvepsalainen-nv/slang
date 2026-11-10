//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#differentiability-as-interface-conformance
//META: purpose=The synthesized `fwd_diff` member is itself given the differentiable conformances, so `fwd_diff(fwd_diff(f))` resolves through ordinary lookup.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the recursive half of the conformance claim by nesting the lookup.
// The outer `fwd_diff` is applied to the *synthesized* inner member, so it can
// only resolve if that member carries the same conformance pair as the
// original function. CHECK asserts the second derivative of x*x, which is the
// constant 2 for the seed pair used here.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

[Differentiable]
float sq(float x)
{
    return x * x;
}

//TEST_INPUT:ubuffer(data=[0], stride=4):out,name=outputBuffer
RWStructuredBuffer<float> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    var seed = diffPair(diffPair(3.0, 1.0), diffPair(1.0, 0.0));
    var r = fwd_diff(fwd_diff(sq))(seed);
    outputBuffer[0] = r.d.d;
    // CHECK: 2.0
}
