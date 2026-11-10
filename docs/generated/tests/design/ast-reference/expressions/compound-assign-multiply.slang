//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that the InfixExpr compound assignment `*=` updates the l-value in place, parallel to the documented `+=` case.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis for compound assignment: cover a second operator
// flavor (`*=`) beyond the smoke-test `+=`, to confirm the family
// is uniform.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 5;
    x *= 3;
    // CHECK: x=15
    printf("x=%d\n", x);
}
