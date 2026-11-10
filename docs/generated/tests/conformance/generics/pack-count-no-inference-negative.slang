//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#parameter-binding
//META: purpose=A `where countof(T) == N` constraint does not infer the value argument N from the number of pack arguments supplied.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the non-inference rule for pack-count constraints: the call supplies
// three pack arguments but leaves N unbound, and the constraint is not used
// backwards to deduce N = 3. CHECK asserts the call is rejected because the
// generic could not be specialized for the given arguments, proving N must be
// bound explicitly or inferred by ordinary generic-argument rules.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

void addHelper(inout int acc, int v)
{
    acc += v;
}

int sumExactly<let N : int, each T>(expand each T args)
    where countof(T) == N
    where T == int
{
    int acc = 0;
    expand addHelper(acc, each args);
    return acc;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = sumExactly(1, 2, 3);
    //CHECK: E39999
}
