//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=An `inout` parameter both reads the caller's value and writes back to it.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `inout` is both directions at once: the callee sees the
// caller's value and its assignment propagates back. `doubleIt` computes
// `x * 2`, so the printed 42 proves both halves -- the callee read 21 (in) and
// the caller saw the product (out). Either half missing gives a different number.

//TEST:INTERPRET(filecheck=CHECK):

void doubleIt(inout int x)
{
    x = x * 2;
}

void main()
{
    int v = 21;
    doubleIt(v);
    //CHECK: v=42
    printf("v=%d\n", v);
}
