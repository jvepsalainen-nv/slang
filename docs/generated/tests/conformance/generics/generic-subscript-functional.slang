//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#generic-subscript
//META: purpose=A generic subscript operator `__subscript<T>(T i) where T : IInteger` accepts any IInteger index type for get and set.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's "Generic subscript" example: a struct declares
// `__subscript<T>(T i) -> float where T : IInteger` that indexes its float
// array via `i.toInt()`. The kernel writes through the set accessor with a
// uint index and reads back through get with an int index; CHECK asserts the
// stored value (99.0) is retrieved, proving both accessors specialized for the
// integer index types.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

struct TestStruct
{
    float arr[10];
    __subscript<T>(T i) -> float where T : IInteger
    {
        get { return arr[i.toInt()]; }
        set { arr[i.toInt()] = newValue; }
    }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    TestStruct obj;
    uint uidx = 3;
    obj[uidx] = 99.0;
    int iidx = 3;
    outputBuffer[0] = obj[iidx];
}
// CHECK: 99.0
