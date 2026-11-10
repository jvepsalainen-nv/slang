//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=Verifies an integer literal with an unrecognized suffix character is rejected with the invalid-suffix diagnostic.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the integer-literal parser recognizes only specific
// suffix characters (u/l etc.); a stray letter such as `q` drives the
// invalid-suffix branch. CHECK pins the diagnostic code and the observed
// message naming the rejected suffix.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

static const int x = 5q;
//CHECK: E39999
//CHECK: invalid suffix 'q' on integer literal

[numthreads(1, 1, 1)]
void main() {}
