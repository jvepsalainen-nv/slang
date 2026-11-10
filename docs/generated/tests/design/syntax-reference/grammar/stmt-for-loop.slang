//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`ForStmt` parses with `DeclStmt` init, `Expr` condition, and `Expr` increment.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ForStmt production: `'for' '(' DeclStmt Expr ';' Expr ')' Stmt`.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 1; i <= 4; ++i) sum += i;
    // CHECK: sum=10
    printf("sum=%d\n", sum);
}
