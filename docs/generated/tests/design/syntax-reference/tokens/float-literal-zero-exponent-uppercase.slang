//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - an uppercase exponent marker after a bare zero (`0E5`) still lexes as a single FloatingPointLiteral.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the uppercase spelling of the leading-zero exponent rule:
// `0E5` must lex as one floating-point token exactly like `0e5`. The
// overload probe returns 1 only when the literal's type is a float;
// if `E5` were treated as an integer suffix the program would be
// rejected before the probe could run.

//TEST:INTERPRET(filecheck=CHECK):

int probe(float x) { return 1; }
int probe(int x) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", probe(0E5));
}
