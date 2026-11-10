//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=The `u` suffix on an integer literal makes the token's type unsigned; the suffix is part of the literal token's raw text and is decoded by the parser/checker.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `42u` is typed as unsigned. We feed the literal into a
// function overload that accepts only `uint`; if the suffix were
// dropped or interpreted as a different type, overload resolution
// would fail to find a unique match and the test would not compile.

//TEST:INTERPRET(filecheck=CHECK):

int kind(int v) { return 1; }
int kind(uint v) { return 2; }

void main()
{
    // CHECK: kind=2
    printf("kind=%d\n", kind(42u));
}
