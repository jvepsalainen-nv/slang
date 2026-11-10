//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#optional-type-constraint
//META: purpose=An `optional` conformance constraint enables `if (T is IInteger)` to select behavior at specialization time, using T as IInteger in the then-branch.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's "Optional type constraint" example: `where optional T :
// IInteger` makes `T is IInteger` a compile-time-resolvable test. For int the
// then-branch (a + b) is chosen; for float the else-branch (a - a = 0). CHECK
// asserts 3 for the int call and 0 for the float call, proving the optional
// constraint drove specialization-time branch selection.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

func addTwoIfInts<T>(T a, T b) -> T
    where T : IArithmetic
    where optional T : IInteger
{
    if (T is IInteger)
        return a + b;
    else
        return a - a;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = float(addTwoIfInts(1, 2));
    outputBuffer[1] = addTwoIfInts(1.5f, 2.5f);
}
// CHECK: 3.0
// CHECK: 0.0
