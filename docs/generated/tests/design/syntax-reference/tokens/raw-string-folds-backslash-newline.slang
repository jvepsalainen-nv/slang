//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - inside a raw string literal a backslash immediately followed by a newline is still folded out of the token text, so R"x(a\<newline>b)x" holds the two bytes ab.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one escape-like sequence a raw string does not preserve: the
// shared character reader folds a backslash-newline out of the stored text.
// We compile to C++ text and FileCheck the emitted literal "ab"; a lexer that
// kept the backslash and newline literally would emit a longer string.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", R"x(ab)x");
    //CHECK: "ab"
}
