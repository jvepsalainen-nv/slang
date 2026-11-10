//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#parameters
//META: purpose=An `out` parameter uses copy-out semantics: the callee writes to it and the value is copied to the caller's argument on return.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies copy-out semantics: the callee writes to `out` parameters and values appear in the caller.
// `getValues` assigns 10 and 20 to uninitialized locals via `out`; `10 20`
// confirms both values were copied back to the call site correctly.

//TEST:INTERPRET(filecheck=CHECK):

void getValues(out int a, out int b)
{
    a = 10;
    b = 20;
}

void main()
{
    int x, y;
    getValues(x, y);
    // CHECK: 10 20
    printf("%d %d\n", x, y);
}
