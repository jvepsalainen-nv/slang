//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=A bare `0` followed by a decimal exponent (`0e10`) lexes as a single FloatingPointLiteral, not as an integer literal with a bogus suffix.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the leading-zero exponent continuation: `0e10` must be one
// floating-point token. An overload probe distinguishes the outcomes —
// if the literal is floating-point the float overload (kind=1) wins;
// if the exponent were instead swallowed as an integer suffix the file
// would not even compile, and an integer-typed decode would pick
// kind=2. The value probe confirms it decodes to zero.

//TEST:INTERPRET(filecheck=CHECK):

int probe(float x) { return 1; }
int probe(int x) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", probe(0e10));
    float v = 0e10;
    // CHECK: v=0
    printf("v=%d\n", int(v));
}
