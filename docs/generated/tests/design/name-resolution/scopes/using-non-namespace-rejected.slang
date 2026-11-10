//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=When a `using` argument does not resolve to a namespace-like entity, no sibling scope is added and the checker diagnoses expected-a-namespace (E30061).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the failure path of using-decl scope wiring: naming a plain
// global variable in `using` cannot yield a namespace-like target, so no
// sibling is spliced and the E30061 expected-a-namespace diagnostic must
// fire at the argument.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int notANamespace = 3;

namespace N
{
    using notANamespace;
//CHECK:  ^^^^^^^^^^^^^ expected a namespace
//CHECK:  ^^^^^^^^^^^^^ expected a namespace, got a 'int'
// CHECK: E30061
}
