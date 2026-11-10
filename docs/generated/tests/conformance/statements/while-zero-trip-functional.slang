//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#while-statement
//META: purpose=while(false) body executes the body zero times.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the zero-trip while loop: condition is false from the start.
// Counter stays 0, confirming the body is never entered.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    while (false)
        count++;
    // CHECK: 0
    printf("%d\n", count);
}
