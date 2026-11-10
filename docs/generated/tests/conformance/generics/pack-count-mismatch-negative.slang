//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-checking
//META: purpose=A specialization whose pack argument count differs from the declared `countof(...)` value is rejected with E30433.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a pack-count constraint is enforced as an exact shape
// requirement at specialization time. `sumExactly` declares `countof(T) == N`;
// the call binds N explicitly to 2 but supplies three pack arguments. CHECK
// asserts E30433 fires at the call, naming the expected and actual element
// counts, so the mismatch is rejected rather than silently accepted.

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
    outputBuffer[0] = sumExactly<2>(1, 2, 3);
    //CHECK: E30433
}
