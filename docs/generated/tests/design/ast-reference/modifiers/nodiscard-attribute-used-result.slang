//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[NoDiscard]` is accepted on a value-returning function, and a call whose result is consumed checks and runs normally.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the permitted half of the result-use rule: consuming the returned
// value is exactly what the attribute asks for, so the call must check and
// evaluate unchanged. CHECK asserts the computed 42, showing the attribute does
// not perturb an ordinary call.

//TEST:INTERPRET(filecheck=CHECK):

[NoDiscard]
int triple(int x)
{
    return x * 3;
}

void main()
{
    int r = triple(14);
    //CHECK: r=42
    printf("r=%d\n", r);
}
