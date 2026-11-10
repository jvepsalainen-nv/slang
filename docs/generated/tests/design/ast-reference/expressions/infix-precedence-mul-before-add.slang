//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that the InfixExpr parser binds `*` tighter than `+`: `2 + 3 * 4` evaluates to 14, not 20.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Precedence corner: the InfixExpr tree for `a + b * c` must have
// `b * c` as the right operand of `+`. Compare with the paren-wrapped
// variant to verify both shapes evaluate as documented.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int r = 2 + 3 * 4;
    // CHECK: r=14
    printf("r=%d\n", r);
}
