//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - `2147483647` (int32 MAX) is a valid IntegerLiteral that fits in `int` without overflow.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the literal that exactly matches `INT_MAX` for a
// 32-bit signed integer lexes as an `IntegerLiteral` and prints as
// the expected value via the byte-code interpreter.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = 2147483647;
    // CHECK: v=2147483647
    printf("v=%d\n", v);
}
