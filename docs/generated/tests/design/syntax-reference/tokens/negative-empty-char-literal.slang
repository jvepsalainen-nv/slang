//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Negative - an empty character literal (`''`) is rejected eagerly with the "illegal character literal" diagnostic (E10001).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lexer's eager one-character rule for char literals from
// the empty side: a ''-quoted body with zero characters must fire the
// illegal-character-literal diagnostic at lex time. The CHECK pins the
// diagnostic code E10001 so a silent acceptance or a different error
// both fail the test. (The multi-character side of the same rule is
// probed by negative-multi-char-literal.slang.)

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = int('');
//CHECK:        ^^ illegal character literal
// CHECK: E10001
}
