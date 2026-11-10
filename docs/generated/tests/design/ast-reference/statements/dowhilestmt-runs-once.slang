//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A DoWhileStmt tests its predicate after each iteration; the body executes at least once even when the predicate is false at entry.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `do ... while (cond);` tests its predicate after the body,
// so the body runs at least once even when the predicate is false from
// the start. The CHECK asserts the counter reads 1; a head-tested loop
// would leave it at 0.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 0;
    do
    {
        n = n + 1;
    } while (n < 0);
    // CHECK: n=1
    printf("n=%d\n", n);
}
