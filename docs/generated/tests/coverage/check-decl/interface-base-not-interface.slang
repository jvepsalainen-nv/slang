//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Verifies an interface inheriting from a non-interface struct type is rejected with E30810.
//META: intent=characterization
//META: covers=source/slang/slang-check-decl.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: an `interface I : Base` may only extend other
// interfaces. A struct base drives the interface-inheritance branch.
// CHECK pins E30810 and the `'NotIface'` substitution.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct NotIface {}
interface I : NotIface {}
//CHECK:      ^^^^^^^^ interface 'I' cannot inherit from non-interface type 'NotIface'

[numthreads(1, 1, 1)]
void main() {}
