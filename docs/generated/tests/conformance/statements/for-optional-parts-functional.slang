//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#for-statement
//META: purpose=The for-loop init, condition, and increment parts are all optional; omitting cond makes it loop forever (exited by break).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that all three parts of for(;;) can be omitted.
// A for(;;) loops indefinitely; a break exits it after 3 iterations.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int count = 0;
    int i = 0;
    for (;;)
    {
        if (i >= 3)
            break;
        count++;
        i++;
    }
    // CHECK: 3
    printf("%d\n", count);
}
