//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#syntax
//META: purpose=A generic parameter list may be empty (`<>`), and the declaration is still usable with an empty argument list.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe of the generic-params-decl production, which admits zero
// parameters between the angle brackets. `struct Wrap<>` declares an empty
// parameter list and `Wrap<>` at the use site supplies an empty argument list.
// CHECK asserts the stored field value (7) round-trips, proving the empty
// parameter list parsed and specialized rather than being rejected.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

struct Wrap<>
{
    int v;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Wrap<> w;
    w.v = 7;
    outputBuffer[0] = w.v;
}
// CHECK: 7
