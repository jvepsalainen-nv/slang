//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#discard-statement
//META: purpose=discard used outside a fragment shader context (e.g. compute) is a compile error (E36107).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `discard` in a compute entry point is rejected with E36107.
// The test compiles a compute kernel containing `discard`; CHECK asserts
// E36107 fires, proving the compiler enforces the fragment-only restriction.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
//CHECK: E36107
{
    discard;
    outputBuffer[0] = 1;
}
