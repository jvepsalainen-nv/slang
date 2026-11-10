//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - the null escape `'\0'` lexes as a CharLiteral and decodes to integer 0.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the lowest-value CharLiteral (`'\0'`) is a valid
// single-character literal whose code point is 0.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: code=0
    printf("code=%d\n", int('\0'));
}
