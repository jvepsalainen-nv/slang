//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Inside a raw string literal `R"d(...)d"`, backslashes are taken literally — no escape processing is performed by the lexer.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a raw string preserves a literal backslash-n sequence
// rather than converting it to a newline. We compile to CPP text and
// FileCheck for the C++ rendition of the four-byte sequence
// {a, '\\', 'n', 'b'} — in C++ source that prints as `"a\\nb"`. If
// the lexer were performing escape processing on the raw string, the
// emitted C++ would be `"a\nb"` (three bytes including a real
// newline) and the CHECK would not match.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", R"x(a\nb)x");
    //CHECK: "a\\nb"
}
