//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#if-statement
//META: purpose=if(cond) stmt else stmt executes the else-branch when cond is false.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the else clause: when condition is false, the else-branch executes.
// Tests both true (then) and false (else) paths of a single if-else.
//TEST:INTERPRET(filecheck=CHECK):

int classify(int n)
{
    if (n > 0)
        return 1;
    else
        return -1;
}

void main()
{
    // CHECK: 1
    printf("%d\n", classify(5));
    // CHECK: -1
    printf("%d\n", classify(-3));
}
