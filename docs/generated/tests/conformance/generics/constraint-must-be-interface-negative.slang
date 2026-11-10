//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#description
//META: purpose=A conformance constraint's constraining type must be an interface; a struct is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the remark that a conformance requirement `T : C` requires C to be
// an interface that T has as a base. The where-clause below names a struct as
// the constraining type. CHECK asserts E30401 fires on the declaration, proving
// the constraining position rejects a non-interface type rather than treating
// it as a base-class requirement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl

struct Base
{
    int v;
}

int useBase<T>(T x) where T : Base { return 1; }
//CHECK: E30401

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 0;
}
