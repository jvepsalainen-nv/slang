//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#parameter-binding
//META: purpose=An explicit generic argument list with fewer arguments than the generic has parameters is rejected with E30441 naming both counts.
//META: intent=negative
//META: covers=source/slang/slang-check-overload.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Explicit generic arguments are bound positionally against the generic's
// parameter list, so supplying too few is caught at the argument list itself
// rather than deferred to the body. E30441 reports both the expected and the
// provided count, which distinguishes it from E30439 (a parameter that could
// not be *inferred*, where an argument list was not written out at all).

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

struct Pair<T, U>
{
    T first;
    U second;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Pair<int> p;
    //CHECK: E30441
    outputBuffer[0] = 0;
}
