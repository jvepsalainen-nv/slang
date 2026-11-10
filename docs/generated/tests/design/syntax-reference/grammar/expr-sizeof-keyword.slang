//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=`KeywordExpr` accepts `'sizeof' '(' ArgExpr ')'`, where a type name parses as the operand expression.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `sizeof(Type)` keyword-expression production. The
// surface accepts a parenthesized type. The numeric value is not
// the production claim; the production claim is that the syntax
// parses and yields a usable integer.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int s = int(sizeof(int));
    // CHECK: nonzero=1
    printf("nonzero=%d\n", s > 0 ? 1 : 0);
}
