//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Negative - an integer literal too wide for any built-in integer type triggers the documented "integer literal is too large" diagnostic.
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe: a 20-hex-digit literal exceeds the widest
// integer type. The lexer accepts the token shape but the checker
// reports the documented diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 0xFFFFFFFFFFFFFFFFFFFF;
//CHECK:    ^^^^^^^^^^^^^^^^^^^^^^ integer literal is too large to be represented in any integer type
// CHECK: E10012
}
