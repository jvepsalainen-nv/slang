//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#continue-statement
//META: purpose=continue transfers control to the start of the next loop iteration, skipping remaining body.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that continue skips the rest of the loop body and starts the next iteration.
// Sum only accumulates for odd i (0..4); even i are skipped via continue.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 0; i < 5; i++)
    {
        if (i % 2 == 0)
            continue;
        sum += i;
    }
    // Odd values: 1 + 3 = 4
    // CHECK: 4
    printf("%d\n", sum);
}
