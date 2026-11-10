//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=An IntegerLiteralExpr carries a parsed integer value that survives to runtime as that integer.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `12345` is parsed as IntegerLiteralExpr with value 12345. The
// LiteralExpr family stores the parsed value; printing it back proves
// the value made it through to evaluation unchanged.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: v=12345
    printf("v=%d\n", 12345);
}
