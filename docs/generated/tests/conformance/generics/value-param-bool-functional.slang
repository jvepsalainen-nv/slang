//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#description
//META: purpose=A generic value parameter may be of Boolean type and drive compile-time branch selection.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the description claim that a generic value parameter's type may be
// Boolean. `sel<let flag : bool>()` branches on the compile-time flag. Two
// specializations `sel<true>` and `sel<false>` are called; CHECK asserts 100
// then 200, proving a bool value parameter is accepted and specialized to each
// literal.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

int sel<let flag : bool>()
{
    if (flag)
        return 100;
    else
        return 200;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sel<true>();
    outputBuffer[1] = sel<false>();
}
// CHECK: 100
// CHECK: 200
