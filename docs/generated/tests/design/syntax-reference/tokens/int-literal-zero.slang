//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - the integer literal `0` lexes as IntegerLiteral with int type at the lower edge of the int range.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the smallest non-negative integer literal `0` is
// still an `IntegerLiteral` token and types as `int` in the overload
// set below.

//TEST:INTERPRET(filecheck=CHECK):

int kind(int v) { return 1; }
int kind(uint v) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", kind(0));
}
