//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - a hexadecimal integer literal (`0xFF`) is a valid IntegerLiteral and decodes to its base-16 value.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: integer literals carry a base prefix (`0x`) that
// the lexer accepts as part of the IntegerLiteral token. `0xFF`
// should decode to decimal 255.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = 0xFF;
    // CHECK: v=255
    printf("v=%d\n", v);
}
