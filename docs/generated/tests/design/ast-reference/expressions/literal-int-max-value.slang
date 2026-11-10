//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that an IntegerLiteralExpr at the documented int MAX (2147483647) parses and round-trips through evaluation as that exact value.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper-edge boundary for the signed int base type. The LiteralExpr
// must preserve the value all the way through to the runtime print.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = 2147483647;
    // CHECK: v=2147483647
    printf("v=%d\n", v);
}
