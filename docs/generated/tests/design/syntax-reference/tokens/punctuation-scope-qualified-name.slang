//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#punctuation-and-structural-symbols
//META: purpose=The two-character spelling `::` lexes as a single `Scope` token that separates a namespace from the name it qualifies.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `::` is one token rather than two adjacent `Colon` tokens. A pair of
// colons would parse as an empty label / type-annotation and the call would not
// resolve, so successfully calling through the qualified name and printing the
// callee's return value is what proves the single-token lexing.

//TEST:INTERPRET(filecheck=CHECK):

namespace Outer
{
    int seven() { return 7; }
}

void main()
{
    // CHECK: scope=7
    printf("scope=%d\n", Outer::seven());
}
