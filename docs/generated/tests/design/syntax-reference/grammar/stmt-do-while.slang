//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`DoWhileStmt` parses as `'do' Stmt 'while' '(' Expr ')' ';'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the DoWhileStmt production with the body executing at least
// once before the condition is checked.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 5;
    int count = 0;
    do { ++count; --n; } while (n > 0);
    // CHECK: count=5
    printf("count=%d\n", count);
}
