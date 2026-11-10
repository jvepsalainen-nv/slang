//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#continue-statement
//META: purpose=continue in a while loop transfers to the condition check, not the start of the block.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that continue in a while-loop re-evaluates the condition.
// Counts n from 0 to 5, skipping the accumulator when n==2.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 0;
    int sum = 0;
    while (n < 5)
    {
        n++;
        if (n == 2)
            continue;
        sum += n;
    }
    // Sum = 1 + 3 + 4 + 5 = 13  (n==2 was skipped)
    // CHECK: 13
    printf("%d\n", sum);
}
