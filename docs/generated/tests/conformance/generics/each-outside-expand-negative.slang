//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-parameter-packs-type-param-packs
//META: purpose=An each-expression that is not enclosed in an expand-expression is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the enclosure rule for each-expressions. The call below uses `each
// args` as an ordinary argument with no surrounding `expand`, so there is no
// expansion context to iterate the pack. CHECK asserts E30104 fires on that
// each-expression, proving a bare `each` is diagnosed instead of being treated
// as a reference to the whole pack.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

void addHelper(inout int acc, int v)
{
    acc += v;
}

int sumInts<each T>(expand each T args) where T == int
{
    int acc = 0;
    addHelper(acc, each args);
    //CHECK: E30104
    return acc;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumInts(1, 2);
}
