//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#pack-queries
//META: purpose=A `where nonempty(T)` constraint is accepted and a function using it compiles and runs when called with a non-empty pack.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the non-emptiness guard: `sumNonempty<each T>(...) where nonempty(T)`
// declares that the pack must be non-empty at specialization time. Called with
// three arguments, the constraint is satisfied and the expansion runs. CHECK
// asserts 60, proving the constraint admitted a non-empty specialization and
// the pack expanded over all elements. (The empty-pack rejection of the same
// constraint is covered by pack-nonempty-empty-negative.slang.)

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

void addHelper(inout int acc, int v)
{
    acc += v;
}

int sumNonempty<each T>(expand each T args) where nonempty(T) where T == int
{
    int acc = 0;
    expand addHelper(acc, each args);
    return acc;
}

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumNonempty(10, 20, 30);
}
// CHECK: 60
