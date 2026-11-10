//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#block-statement
//META: purpose=A block statement provides local scoping; declarations in the block are not visible outside.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a block statement groups statements and scopes declarations locally.
// Inner `x` shadows the outer and is not visible outside the block.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 1;
    {
        int x = 99;
        // CHECK: 99
        printf("%d\n", x);
    }
    // After block, outer x is visible again
    // CHECK: 1
    printf("%d\n", x);
}
