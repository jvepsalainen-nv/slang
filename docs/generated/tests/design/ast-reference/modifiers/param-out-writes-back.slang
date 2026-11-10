//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=An `out` parameter writes a value back to the caller's variable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `out` names the copy-out direction. `produce` never reads its
// parameter, only assigns 42 to it; CHECK asserts the caller's `x`, initialised
// to 0, reads back as 42 after the call, which can only happen if the assignment
// propagated out.

//TEST:INTERPRET(filecheck=CHECK):

void produce(out int dst)
{
    dst = 42;
}

void main()
{
    int x = 0;
    produce(x);
    //CHECK: x=42
    printf("x=%d\n", x);
}
