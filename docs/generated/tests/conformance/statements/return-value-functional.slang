//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#return-statement
//META: purpose=return expr supplies the return value to the caller; the returned value is visible at the call site.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `return expr` supplies the function result; the caller observes the returned value.
//TEST:INTERPRET(filecheck=CHECK):

int square(int x) { return x * x; }

void main()
{
    int r = square(7);
    // CHECK: 49
    printf("%d\n", r);
}
