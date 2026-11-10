//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`WhileStmt` parses as `'while' '(' Expr ')' Stmt`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the WhileStmt production.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 0;
    while (n < 3) ++n;
    // CHECK: n=3
    printf("n=%d\n", n);
}
