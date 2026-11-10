//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-checking
//META: purpose=A type equality constraint `where T == int` causes T to be treated as int for all purposes inside the generic body.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Type-Checking rule that an equality constraint `T == U` makes T
// an alias for U: with `where T == int`, an int literal may be added to a value
// of type T and the result assigned to an int. The function is called at T=int;
// CHECK asserts 15, proving the body type-checked int operations on T solely
// because of the equality constraint.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

int addTen<T>(T x) where T == int
{
    int r = x + 10;
    return r;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = addTen(5);
}
// CHECK: 15
