//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#break-statement
//META: purpose=break transfers control to after the end of the immediately enclosing loop.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that break exits the innermost loop and resumes after it.
// Loop would run to 10 but break fires at i==3; result is 3.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i = 0;
    for (i = 0; i < 10; i++)
    {
        if (i == 3)
            break;
    }
    // CHECK: 3
    printf("%d\n", i);
}
