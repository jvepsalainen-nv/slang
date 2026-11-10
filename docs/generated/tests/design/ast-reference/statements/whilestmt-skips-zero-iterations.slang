//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A WhileStmt tests its predicate before each iteration; when the predicate is false at entry the body does not execute at all.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `while (cond)` tests its predicate before each iteration, so
// a predicate that is false on entry skips the body entirely. The CHECK
// asserts the counter reads 0; a tail-tested loop would have decremented
// it once.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    while (count > 0)
    {
        count = count - 1;
    }
    // CHECK: count=0
    printf("count=%d\n", count);
}
