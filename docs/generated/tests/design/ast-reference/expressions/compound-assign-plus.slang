//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A compound-assignment InfixExpr `a += b` updates `a` to `a + b`; the resulting value is the sum.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The InfixExpr Nodes row covers binary operators including the
// compound-assignment forms. `+=` updates the l-value in place; the
// read after the statement returns the updated value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 10;
    x += 5;
    // CHECK: x=15
    printf("x=%d\n", x);
}
