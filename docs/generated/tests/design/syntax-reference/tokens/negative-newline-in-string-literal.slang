//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Negative - an unescaped newline inside a double-quoted literal body is one of the two failures the string-literal helper reports itself, as `newline in literal` (E10005).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the string-literal body helper refuses to run past a raw newline.
// The helper steps over escaped quotes but has no way to find a closing quote
// once a physical line ends, so it must stop and diagnose rather than swallow
// the rest of the file. The CHECK pins the message text; the count of
// diagnostics is left open because recovery re-enters the literal on the
// following line.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    printf("abc
");
// CHECK: E10005
}
