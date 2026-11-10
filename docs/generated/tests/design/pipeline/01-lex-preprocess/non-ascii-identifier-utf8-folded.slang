//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#lexer-flags-and-special-case-rules
//META: purpose=A valid multi-byte UTF-8 sequence is folded into a single code point that the identifier rule accepts, so a non-ASCII name lexes as one identifier token.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the byte-level advance step decodes UTF-8 before the
// identifier rule sees the input. The name below contains the two-byte
// sequence for U+00E9; if the two bytes were offered to the identifier
// rule individually, neither would be an accepted identifier character
// and the declaration would not parse. Declaring and then reading the
// name proves the same single identifier token was produced at both
// sites, and the printed value pins the binding.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int café = 5;
    // CHECK: cafe=5
    printf("cafe=%d\n", café);
}
