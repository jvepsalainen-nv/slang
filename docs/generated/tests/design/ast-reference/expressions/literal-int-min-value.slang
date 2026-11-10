//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that an IntegerLiteralExpr at the documented int MIN (-2147483648) parses and round-trips through evaluation as that exact value.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for the int base type. The LiteralExpr family's
// `value: IntegerLiteralValue` must carry the full negative range.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = -2147483648;
    // CHECK: v=-2147483648
    printf("v=%d\n", v);
}
