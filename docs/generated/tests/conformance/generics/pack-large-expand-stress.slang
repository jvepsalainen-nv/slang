//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-parameter-packs-type-param-packs
//META: purpose=A type parameter pack bound to many arguments (length 10) expands to one call per element with correct ordering.
//META: intent=stress
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress probe of the pack length axis: `sumInts<each T>` is called with ten
// arguments, binding the pack to length 10. CHECK asserts the sum 1..10 == 55,
// proving the expand/each construct scales past small packs and generates a
// call per element.

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
    outputBuffer[0] = sumInts(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
}
// CHECK: 55
