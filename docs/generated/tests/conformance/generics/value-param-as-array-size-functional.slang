//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-checking
//META: purpose=A generic value parameter is usable only as its declared compile-time constant (e.g. an array bound / loop bound); no other assumption is made about it.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Type-Checking claim that no assumptions are made about a generic
// value parameter beyond its declared type: `count<let N : uint>()` uses N only
// as an ordinary uint compile-time constant to size a loop and returns it.
// Specialized as `count<5>`; CHECK asserts 5, proving the value parameter
// behaves as its plain declared-type constant.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

uint count<let N : uint>()
{
    uint acc = 0;
    for (uint i = 0; i < N; ++i)
        acc += 1;
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<uint> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = count<5>();
}
// CHECK: 5
