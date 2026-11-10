//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A ForStmt iterated 100 times accumulates the documented count; the loop variable advances monotonically and the side-effect expression runs once per iteration.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: 100-iteration ForStmt. Sum of 0..99 is 4950. A bug that
// dropped, doubled, or skipped iterations would mis-sum.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 0; i < 100; i = i + 1)
    {
        sum = sum + i;
    }
    // CHECK: sum=4950
    printf("sum=%d\n", sum);
}
