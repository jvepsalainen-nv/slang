//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#pack-queries
//META: purpose=`__trimFirst(P)` applied to an empty pack is total and yields an empty pack rather than an error.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe of the totality claim for `__trimFirst`: the pack is bound to
// zero arguments, so `__trimFirst(args)` is applied to an empty pack. Totality
// means this is well-formed and yields another empty pack, so the surrounding
// expansion produces no calls at all. The accumulator is pre-seeded with 7;
// CHECK asserts 7, proving the query neither errored nor produced elements.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void addHelper(inout int acc, int v)
{
    acc += v;
}

int sumTrimFirst<each T>(expand each T args) where T == int
{
    int acc = 7;
    expand addHelper(acc, each __trimFirst(args));
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumTrimFirst();
}
// CHECK: 7
