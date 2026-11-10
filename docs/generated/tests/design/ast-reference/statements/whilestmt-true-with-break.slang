//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A WhileStmt with a constant-true predicate iterates indefinitely; a body-internal BreakStmt terminates the LoopStmt at the documented iteration.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: a `while` whose predicate is literally `true`. Verifies the
// loop is still breakable, so a `break` in the body terminates it at
// the expected iteration. The CHECK asserts exactly four iterations
// ran.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 0;
    while (true)
    {
        n = n + 1;
        if (n == 4) { break; }
    }
    // CHECK: n=4
    printf("n=%d\n", n);
}
