//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#parameter-binding
//META: purpose=A generic function with two independent type parameters infers each one separately from its own argument.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that implicit binding infers multiple distinct type parameters
// independently. `firstAsInt<T : IInteger, U : IFloat>(T a, U b)` is called
// with an int and a float, inferring T=int and U=float separately, and returns
// `a.toInt()` using only T's IInteger requirement. CHECK asserts 13, proving
// each parameter bound from its own argument with the correct constraint.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

int firstAsInt<T : IInteger, U : IFloat>(T a, U b)
{
    return a.toInt();
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = firstAsInt(13, 3.5f);
}
// CHECK: 13
