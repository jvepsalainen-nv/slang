//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#while-statement
//META: purpose=while(cond) body executes the body repeatedly while the condition is true.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that while iterates exactly the right number of times.
// Counts down from 5 to 0; executes 5 iterations (5,4,3,2,1 are all > 0).
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 5;
    int count = 0;
    while (n > 0)
    {
        count++;
        n--;
    }
    // CHECK: 5
    printf("%d\n", count);
}
