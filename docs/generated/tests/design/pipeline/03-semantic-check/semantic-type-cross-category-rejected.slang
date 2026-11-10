//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=A system-value semantic rejects a declared type whose scalar element is in a different category, so `float` is not valid for a `uint` semantic (E30701).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the category half of the compatibility rule with the doc's own
// counter-example. `SV_GroupIndex` is a scalar `uint` semantic and the
// parameter is declared `float`: same shape, different category, so the
// coercion is refused. CHECK pins E30701, whose message names the expected
// type.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK): -target hlsl

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(float gi: SV_GroupIndex)
//CHECK: E30701
{
    outputBuffer[0] = int(gi);
}
