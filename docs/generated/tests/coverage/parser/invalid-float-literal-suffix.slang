//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=Verifies a floating-point literal with an unrecognized suffix character is rejected with the invalid-suffix diagnostic.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the float-literal parser recognizes only `f`/`h`/`l`/`lf`
// suffixes; a stray letter such as `z` drives the invalid-float-suffix
// branch. The compiler emits this diagnostic twice for the single literal
// (a short form and a span form), so `non-exhaustive` lets the single CHECK
// consume one and leaves the duplicate. CHECK pins the code and message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

static const float x = 1.0z;
//CHECK: E39999
//CHECK: invalid suffix 'z' on floating-point literal

[numthreads(1, 1, 1)]
void main() {}
