//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#break-statement
//META: purpose=break in nested loops exits only the closest enclosing loop, not the outer loop.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that break exits only the innermost loop.
// Outer loop runs 3 times; inner loop breaks at j==1 each time, so inner count = 3.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int innerCount = 0;
    int outerCount = 0;
    for (int i = 0; i < 3; i++)
    {
        outerCount++;
        for (int j = 0; j < 10; j++)
        {
            if (j == 1)
                break;
            innerCount++;
        }
    }
    // Outer loop ran 3 times
    // CHECK: 3
    printf("%d\n", outerCount);
    // Inner loop ran once per outer iteration (j==0 only, then break at j==1)
    // CHECK: 3
    printf("%d\n", innerCount);
}
