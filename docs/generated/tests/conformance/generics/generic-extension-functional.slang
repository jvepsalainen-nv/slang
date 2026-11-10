//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#generic-extension-for-generic-types
//META: purpose=Two generic extensions on the same struct with different type constraints each contribute their method only for the matching specialization.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's "Generic extension for generic types" example: two
// `extension<T> GenericStruct<T>` blocks, one gated on `T : IFloat` and one on
// `T : IInteger`, each add an `isInt()` method returning 0 and 1 respectively.
// The float specialization dispatches to the IFloat extension and the uint
// specialization to the IInteger extension; CHECK asserts 0 then 1, proving
// constraint-selected extension resolution.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

struct GenericStruct<T>
{
}

extension<T> GenericStruct<T> where T : IFloat
{
    int isInt() { return 0; }
}

extension<T> GenericStruct<T> where T : IInteger
{
    int isInt() { return 1; }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    GenericStruct<float> floatObj = {};
    GenericStruct<uint> uintObj = {};
    outputBuffer[0] = floatObj.isInt();
    outputBuffer[1] = uintObj.isInt();
}
// CHECK: 0
// CHECK: 1
