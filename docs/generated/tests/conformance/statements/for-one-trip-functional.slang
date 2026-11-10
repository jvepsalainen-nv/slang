//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: purpose=A for-loop with range [0,1) executes the body exactly once.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies single-trip for-loop: condition is true exactly once, body executes once.
// Counter is 1, confirming exactly one iteration.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    for (int i = 0; i < 1; i++)
        count++;
    // CHECK: 1
    printf("%d\n", count);
}
