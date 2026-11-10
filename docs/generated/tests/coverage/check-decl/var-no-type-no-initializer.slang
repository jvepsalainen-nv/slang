//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Verifies a `var` declaration with neither an explicit type nor an initializer is rejected with E30620.
//META: intent=characterization
//META: covers=source/slang/slang-check-decl.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: type inference for a `var` needs either an explicit
// type annotation or an initializer to infer from. With neither present,
// the decl checker cannot assign a type. CHECK pins the observed E30620.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

[numthreads(1, 1, 1)]
void main()
{
    var y;
//CHECK:^ a variable declaration without an initial-value expression must be given an explicit type
}
