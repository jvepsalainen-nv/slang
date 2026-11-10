//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#compile-time-for-statement
//META: purpose=$for(i in Range(0, 1)) produces exactly one instantiation with i bound to 0.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies single-trip compile-time for: Range(0, 1) instantiates body once with i=0.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    $for(i in Range(0, 1))
    {
        sum += i;
    }
    // i was 0; sum == 0
    // CHECK: 0
    printf("%d\n", sum);
    // Confirm exactly one iteration
    int count = 0;
    $for(j in Range(5, 6))
    {
        count++;
    }
    // CHECK: 1
    printf("%d\n", count);
}
