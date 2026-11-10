//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An AssignExpr `a = b` updates the l-value `a` to the value of `b`; reading `a` afterward yields the new value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that assignment stores into its left operand. The variable is
// initialised, assigned a new value, and then read; the CHECK asserts the
// second value, so a dropped or reversed assignment is visible.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    x = 42;
    // CHECK: x=42
    printf("x=%d\n", x);
}
