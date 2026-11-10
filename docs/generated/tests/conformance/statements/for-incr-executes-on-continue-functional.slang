//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: purpose=In a for-loop with a side-effect expression, the increment runs even when continue is used.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the for-loop increment expression executes after a continue statement.
// Doc: "the side effect expression is evaluated when continue is used".
// Loop runs i=0..4, skipping the accumulator on even i; increment still fires each time.
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
    // odd values 1 + 3 = 4, and i reaches 5 confirming increment ran on continue
    // CHECK: 4
    printf("%d\n", sum);
}
