//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#if-statement
//META: purpose=if(cond) stmt executes the then-branch when cond is true, skips it when false.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `if(cond) stmt` executes the body when the condition is true.
// Also verifies that when the condition is false, the body is not executed.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    if (true)
        x = 1;
    // CHECK: 1
    printf("%d\n", x);

    int y = 0;
    if (false)
        y = 1;
    // CHECK: 0
    printf("%d\n", y);
}
