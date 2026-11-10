//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#parameters
//META: purpose=An `inout` parameter uses copy-in-copy-out semantics: caller's value is copied in, callee may modify it, and the final value is copied back.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies copy-in-copy-out semantics for `inout` parameters.
// `accumulate` is called twice on `total`; the caller's variable must reflect each
// accumulated increment, and 8 confirms the final value was written back.

//TEST:INTERPRET(filecheck=CHECK):

void accumulate(inout int sum, int val) { sum += val; }

void main()
{
    int total = 0;
    accumulate(total, 5);
    accumulate(total, 3);
    // CHECK: 8
    printf("%d\n", total);
}
