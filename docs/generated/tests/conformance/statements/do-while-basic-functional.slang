//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#do-while-statement
//META: purpose=do body while(cond) executes the body at least once before checking the condition.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that do-while executes the body before testing the condition.
// Even with an initially-false condition, the body executes once.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // Body always executes at least once
    int count = 0;
    do {
        count++;
    } while (false);
    // CHECK: 1
    printf("%d\n", count);

    // Normal multi-trip do-while
    int n = 0;
    do {
        n++;
    } while (n < 3);
    // CHECK: 3
    printf("%d\n", n);
}
