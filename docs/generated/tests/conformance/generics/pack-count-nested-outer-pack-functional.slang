//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#pack-count-constraints
//META: purpose=The right side of a pack-count constraint may itself be `countof(...)` of an outer generic's pack, tying an inner pack's length to the outer one.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the nested form of the pack-count constraint: `Outer<let each D>`
// declares an outer value pack, and its member `inner<each TIndex>` requires
// `countof(TIndex) == countof(D)`. Specializing `Outer<1, 2, 3>` and calling
// `inner(10, 20, 30)` supplies a three-element inner pack, matching the outer
// pack's count. The body sums both packs; CHECK asserts 66 (= 10+20+30 plus
// 1+2+3), proving the constraint was proved from the outer pack's count and
// both expansions ran over three elements.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void addHelper(inout int acc, int v)
{
    acc += v;
}

struct Outer<let each D : int>
{
    int inner<each TIndex>(expand each TIndex indices)
        where TIndex == int
        where countof(TIndex) == countof(D)
    {
        int acc = 0;
        expand addHelper(acc, each indices);
        expand acc += each D;
        return acc;
    }
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Outer<1, 2, 3> o;
    outputBuffer[0] = o.inner(10, 20, 30);
}
// CHECK: 66
