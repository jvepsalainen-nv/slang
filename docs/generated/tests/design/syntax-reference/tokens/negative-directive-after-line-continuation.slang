//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#token-flags
//META: purpose=Negative - a folded backslash-newline emits no NewLine token, so a # on the continued physical line does not carry AtStartOfLine and is not recognised as a directive.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies directive recognition depends on AtStartOfLine: after a trailing
// backslash the next physical line is part of the same logical line, so its
// leading  is an ordinary Pound token and the parser rejects it. CHECK
// asserts the unexpected-token code E20001 rather than a macro expansion.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target cpp -entry main -stage compute

int a = 1; #define FOO 2
//CHECK: E20001

[shader("compute")]
[numthreads(1, 1, 1)]
void main() {}
