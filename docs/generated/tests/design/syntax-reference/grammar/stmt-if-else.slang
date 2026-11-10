//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`IfStmt` parses as `'if' '(' Expr ')' Stmt ('else' Stmt)?`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the IfStmt production including the optional `else` arm.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 5;
    int y;
    if (x > 0)
        y = 1;
    else
        y = -1;
    // CHECK: y=1
    printf("y=%d\n", y);
}
