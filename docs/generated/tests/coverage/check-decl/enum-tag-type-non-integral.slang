//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Verifies an enum declared with a non-integer, non-interface tag type (`float`) is rejected with E32000.
//META: intent=characterization
//META: covers=source/slang/slang-check-decl.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the enum-decl check validates the explicit tag type
// listed in the base list. A `float` tag drives the invalid-tag-type
// branch. CHECK pins the observed E32000 and the `'float'` substitution.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

enum E : float { A, B }
//CHECK: ^^^^^ invalid enum tag type
//CHECK: ^^^^^ invalid tag type for 'enum': 'float'

[numthreads(1, 1, 1)]
void main() {}
