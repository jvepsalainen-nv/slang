//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#compile-time-for-statement
//META: purpose=$for(i in Range(0, 4)) body instantiates the body with i bound to 0, 1, 2, 3.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that $for unrolls the body once per value in Range(initial, upper).
// Sum of 0+1+2+3 = 6 confirms all 4 instantiations ran.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    $for(i in Range(0, 4))
    {
        sum += i;
    }
    // CHECK: 6
    printf("%d\n", sum);
}
