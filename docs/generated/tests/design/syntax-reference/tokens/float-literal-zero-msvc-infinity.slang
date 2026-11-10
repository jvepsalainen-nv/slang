//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=The legacy MSVC infinity form with a leading zero (`0#INF`) lexes as a single FloatingPointLiteral rather than an integer followed by `#INF`.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `0#INF` is consumed as one floating-point token: the
// `#` never reaches the preprocessor as a Pound token and `INF` is not
// a stray identifier, either of which would fail compilation. The
// overload probe returning kind=1 proves the token both lexes as a
// unit and decodes as a floating-point value. (The doc does not state
// the decoded numeric value, so this test deliberately asserts only
// the token classification, not infinity-ness.)

//TEST:INTERPRET(filecheck=CHECK):

int probe(float x) { return 1; }
int probe(int x) { return 2; }

void main()
{
    // CHECK: kind=1
    printf("kind=%d\n", probe(0#INF));
}
