//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#deferstmt
//META: purpose=A DeferStmt's inner statement runs when the enclosing scope exits rather than at the position the `defer` is written.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a deferred statement does not run where it is written but at
// the exit of the block containing it. The CHECK asserts the ordering
// body -> deferred -> after-block, which is what distinguishes
// scope-exit execution from in-place execution.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    {
        defer printf("deferred\n");
        printf("body\n");
    }
    printf("after-block\n");
    // CHECK: body
    // CHECK-NEXT: deferred
    // CHECK-NEXT: after-block
}
