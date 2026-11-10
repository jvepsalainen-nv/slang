//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`SwitchStmt` parses with `SwitchCase` arms — `'case' Expr ':'` and `'default' ':'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the SwitchStmt production and the SwitchCase variants.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 2;
    int y = 0;
    switch (x)
    {
    case 1: y = 100; break;
    case 2: y = 200; break;
    default: y = 999; break;
    }
    // CHECK: y=200
    printf("y=%d\n", y);
}
