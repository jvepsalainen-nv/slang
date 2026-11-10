//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=The `f` suffix on a floating-point literal types the token as `float` (single precision), distinguishing it from the unsuffixed form.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `3.5f` is typed as `float`. Sent through an overload
// set that distinguishes `float` from `double` — the suffix decides
// which overload is picked.

//TEST:INTERPRET(filecheck=CHECK):

int kind(float v) { return 1; }
int kind(double v) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", kind(3.5f));
}
