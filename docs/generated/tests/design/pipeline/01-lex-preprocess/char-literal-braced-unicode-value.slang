//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=Boundary probe of the braced `\u{...}` escape: a code point above the BMP (`'\u{1F600}'`) decodes to 128512 as a 32-bit value.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the braced Unicode escape form with a supplementary-plane
// code point: U+1F600 = 128512 does not fit in 16 bits, so the
// printed value is only correct if the braced form really carries
// up to 32 bits through the char value-extraction helper.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: braced=128512
    printf("braced=%d\n", int('\u{1F600}'));
}
