//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-parameter-packs-type-param-packs
//META: purpose=A type parameter pack bound to zero arguments expands to no calls (empty pack, length 0).
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe of the empty-pack edge: `sumInts<each T>` is called with no
// arguments, so the pack has length 0 and `expand sumHelper(...)` produces no
// calls at all. The accumulator is pre-seeded with 7; CHECK asserts 7,
// confirming the expansion over an empty pack ran zero iterations.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void sumHelper(inout int acc, int term)
{
    acc += term;
}

int sumInts<each T>(expand each T terms) where T == int
{
    int acc = 7;
    expand sumHelper(acc, each terms);
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumInts();
}
// CHECK: 7
