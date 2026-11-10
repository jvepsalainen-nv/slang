//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#compile-time-for-statement
//META: purpose=$for(i in Range(N, N)) produces zero instantiations; body never executes.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies zero-trip compile-time for: Range(3, 3) is empty so body never executes.
// Counter stays 0.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    $for(i in Range(3, 3))
    {
        count++;
    }
    // CHECK: 0
    printf("%d\n", count);
}
