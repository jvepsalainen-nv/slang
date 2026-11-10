//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-parameter-packs-type-param-packs
//META: purpose=A type parameter pack bound to exactly one argument expands to a single call (pack length 1).
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe of the pack length axis: the same `sumInts<each T>` expansion
// is called with a single argument, binding the pack to length 1. CHECK asserts
// 99, proving the expand/each construct produces exactly one call for a
// one-element pack.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void sumHelper(inout int acc, int term)
{
    acc += term;
}

int sumInts<each T>(expand each T terms) where T == int
{
    int acc = 0;
    expand sumHelper(acc, each terms);
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumInts(99);
}
// CHECK: 99
