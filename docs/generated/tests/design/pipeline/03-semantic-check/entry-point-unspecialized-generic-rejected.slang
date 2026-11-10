//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=A generic entry point left genuinely unspecialized is diagnosed (E38014) rather than compiled into an unusable generic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the unspecialized-generic-entry-point check. No specialization
// arguments are supplied on the command line, so the entry point has no
// concrete type to lower to; the check turns that into a diagnostic at the
// entry-point declaration. CHECK pins E38014 on the entry-point name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void main<T : IArithmetic>(uniform T v)
{
    outputBuffer[0] = 1;
}
//CHECK: E38014
