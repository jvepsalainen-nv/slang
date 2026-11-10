//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#end-markers-and-special
//META: purpose=Negative - a character matching no lexer dispatch arm yields an `Invalid` token and the printable-character form of the illegal-character diagnostic (E10000).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fall-through arm of the per-character dispatch. A backtick is
// ASCII-printable and is not part of any Slang token spelling, so the lexer
// must select the printable spelling of the diagnostic (quoting the character)
// rather than the hex spelling. The CHECK pins the character inside the message
// so a switch to the hex form would be caught.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 1; `
//CHECK:       ^ error
// CHECK: E10000
    printf("%d\n", x);
}
