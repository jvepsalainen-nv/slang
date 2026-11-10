//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=A `\'` inside a character literal is stepped over while lexing, so `'\''` is one CharLiteral that decodes to the apostrophe code point 39.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the closing-quote search skips an escaped quote instead of ending
// the token at it. If the escape were not stepped over, `'\''` would close
// after the backslash and the trailing quote would start a new, unterminated
// literal. Printing the decoded value proves both that one token was produced
// and that it decoded to the apostrophe.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: quote=39
    printf("quote=%d\n", int('\''));
}
