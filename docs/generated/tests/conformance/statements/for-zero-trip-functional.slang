//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: purpose=A for-loop with a false initial condition executes the body zero times.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies zero-trip for-loop: condition is false from the start, body never executes.
// Counter stays 0, confirming the body executed 0 times.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    for (int i = 0; i < 0; i++)
        count++;
    // CHECK: 0
    printf("%d\n", count);
}
