//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - a leading-zero exponent with a `-` sign (`0e-3`) lexes as a single FloatingPointLiteral token.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative-exponent spelling of the leading-zero rule:
// in `probe(0e-3)` the `-` and digits are part of one float token. If
// the lexer split at the `-`, the expression would parse as `0e - 3`
// and fail on the invalid `e` suffix; the float overload firing
// (kind=1) proves the single-token reading.

//TEST:INTERPRET(filecheck=CHECK):

int probe(float x) { return 1; }
int probe(int x) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", probe(0e-3));
}
