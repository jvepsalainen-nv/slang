//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#description
//META: purpose=A generic value parameter that is not a pack cannot carry a type constraint.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the restriction that non-pack value parameters cannot be
// constrained. The where-clause names the value parameter `N` on the left of a
// conformance constraint, a position that requires a type. CHECK asserts the
// compiler rejects it -- E30060 for the value-where-a-type-was-expected, and
// E30402 for the resulting invalid left-hand side -- proving the constraint is
// diagnosed at the declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

int constrainedValue<let N : int>() where N : IInteger { return N; }
//CHECK: E30060
//CHECK: E30402

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 0;
}
