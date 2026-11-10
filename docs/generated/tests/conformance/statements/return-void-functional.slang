//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#return-statement
//META: purpose=return; (with no value) is valid in a void function and immediately exits it.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `return;` in a void function exits it immediately.
// Code after the return is not executed; observable via a counter.
//TEST:INTERPRET(filecheck=CHECK):

void earlyExit(int x, inout int counter)
{
    counter++;
    if (x == 0)
        return;
    counter++; // only reached when x != 0
}

void main()
{
    int c1 = 0;
    earlyExit(0, c1);
    // returned early: counter is 1 (incremented once before return)
    // CHECK: 1
    printf("%d\n", c1);

    int c2 = 0;
    earlyExit(1, c2);
    // did not return early: counter is 2
    // CHECK: 2
    printf("%d\n", c2);
}
