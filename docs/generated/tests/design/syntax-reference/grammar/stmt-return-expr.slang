//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`ReturnStmt` parses as `'return' Expr? ';'` and yields the expression value.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ReturnStmt production with an Expr operand.

//TEST:INTERPRET(filecheck=CHECK):

int answer() { return 42; }

void main()
{
    // CHECK: r=42
    printf("r=%d\n", answer());
}
