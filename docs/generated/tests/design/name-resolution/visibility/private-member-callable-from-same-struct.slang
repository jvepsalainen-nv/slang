//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=A `private` member is visible from another method of the same aggregate; access through `this` succeeds.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-keyword semantics: `private` is visible only inside the same
// aggregate. A public method on the same struct can still call a
// private one and read a private field.

//TEST:INTERPRET(filecheck=CHECK):

struct S
{
    private int secret;
    private int doubleSecret() { return secret * 2; }
    int observe() { return doubleSecret(); }

    __init(int x) { secret = x; }
}

void main()
{
    S s = S(7);
    // CHECK: observe=14
    printf("observe=%d\n", s.observe());
}
