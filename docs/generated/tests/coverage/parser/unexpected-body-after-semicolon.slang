//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=Verifies a function signature terminated by `;` followed by a `{...}` body is rejected with E20102.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: after a function declaration terminated by `;` the
// parser does not expect a body block; seeing `{` next drives the
// unexpected-body-after-semicolon branch that suggests the `;` is a typo.
// CHECK pins E20102 and the observed message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

void foo(); {}
//CHECK: E20102
//CHECK: unexpected function body after signature declaration, is this ';' a typo?

[numthreads(1, 1, 1)]
void main() {}
