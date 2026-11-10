//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=Verifies an empty parenthesized expression `()` in value position is rejected with E20005.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the primary-expression parser handles `(` by parsing a
// sub-expression; an immediately-closing `)` leaves no expression, driving
// the invalid-empty-parentheses branch. CHECK pins E20005 and the observed
// message text.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

[numthreads(1, 1, 1)]
void main()
{
    int x = ();
//CHECK: E20005
//CHECK: empty parenthesis '()' is not a valid expression.
}
