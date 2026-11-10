//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#pack-count-constraints
//META: purpose=A `where countof(T) == N` constraint accepts a specialization whose pack argument list has exactly N elements.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pack-count constraint's accepting side: `sumExactly<let N : int,
// each T>` declares `where countof(T) == N`, and the call binds N explicitly to
// 3 while supplying a three-element pack. The body seeds the accumulator with
// N * 100 so the value proves N was bound to 3, then expands over the pack.
// CHECK asserts 306 (= 300 + 1 + 2 + 3), which is only reachable if the
// constraint admitted the specialization and the pack expanded over all three
// elements.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void addHelper(inout int acc, int v)
{
    acc += v;
}

int sumExactly<let N : int, each T>(expand each T args)
    where countof(T) == N
    where T == int
{
    int acc = N * 100;
    expand addHelper(acc, each args);
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumExactly<3>(1, 2, 3);
}
// CHECK: 306
