//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that a FloatingPointLiteralExpr arithmetic chain that overflows to +inf compares greater than the largest finite literal.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// +inf boundary. Multiplying the largest representable finite float
// by 10 overflows to +inf; the resulting value must order strictly
// above the finite literal.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float big = 3.4e38f;
    float infv = big * 10.0f;
    // CHECK: gt-max=1
    printf("gt-max=%d\n", int(infv > big));
}
