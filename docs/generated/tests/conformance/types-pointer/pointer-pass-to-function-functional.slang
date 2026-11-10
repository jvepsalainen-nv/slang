//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=A pointer can be passed as a function argument; mutations through the pointer parameter are visible at the call site.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a pointer passed to a function lets the callee mutate the caller's variable.
// Calls `addDelta(&x, 5)` which writes through `*p`; CHECK asserts `x` at the call site
// reflects the mutation, proving pointer parameters convey write access.
//TEST:INTERPRET(filecheck=CHECK):

void addDelta(int* p, int delta)
{
    *p = *p + delta;
}

void main()
{
    int x = 10;
    addDelta(&x, 5);
    //CHECK: 15
    printf("%d\n", x);
}
