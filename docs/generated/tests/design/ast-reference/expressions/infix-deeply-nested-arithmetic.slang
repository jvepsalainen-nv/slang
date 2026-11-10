//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Stresses InfixExpr parsing with a five-deep paren-nested arithmetic chain: ((((1+2)*3)-4)/5) must evaluate to 1.
//META: intent=stress
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Deep nesting stress for InfixExpr / ParenExpr interaction. Five
// levels of parentheses force the parser through repeated descent;
// the result must still equal the documented arithmetic value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int r = ((((1 + 2) * 3) - 4) / 5);
    // CHECK: r=1
    printf("r=%d\n", r);
}
