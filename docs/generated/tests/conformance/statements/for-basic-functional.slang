//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: purpose=for(init;cond;incr) body iterates exactly the right number of times.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies basic for-loop: sums 0..4 = 10, confirming 5 iterations.
// Variable declared in init (`i`) is visible throughout the for-statement.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 0; i < 5; i++)
        sum = sum + i;
    // CHECK: 10
    printf("%d\n", sum);
}
