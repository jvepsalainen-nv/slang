//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=Verifies a generic value parameter typed `float` is rejected with E30624 (only integer/enum types allowed).
//META: intent=characterization
//META: covers=source/slang/slang-check-decl.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the generic-parameter decl check restricts value
// (`let`) parameters to integer and enum types. A `float`-typed value
// parameter drives the unsupported-type branch. CHECK pins E30624.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct S<let N : float> {}
//CHECK:     ^ generic value parameter type 'float' is not supported; only integer and enum types are allowed

[numthreads(1, 1, 1)]
void main() {}
