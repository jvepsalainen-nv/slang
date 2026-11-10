//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - a CharLiteral whose content is an escape sequence (`'\\'`, `'\n'`) lexes as one token and decodes to the escaped code point.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: an escape sequence inside single quotes is a
// single CharLiteral. `'\\'` is backslash (ASCII 92); `'\n'` is
// newline (ASCII 10).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: bs=92
    printf("bs=%d\n", int('\\'));
    // CHECK: nl=10
    printf("nl=%d\n", int('\n'));
}
