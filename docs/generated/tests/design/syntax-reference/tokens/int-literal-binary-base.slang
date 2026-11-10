//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - a binary integer literal (`0b1111`) lexes as IntegerLiteral and decodes to its base-2 value.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: a leading `0b` followed by binary digits is part
// of the IntegerLiteral token; `0b1111` should decode to decimal 15.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = 0b1111;
    // CHECK: v=15
    printf("v=%d\n", v);
}
