//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A `__require_capability` naming a capability that does not exist is diagnosed at the name.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the capability names in a requirement declaration are resolved
// rather than stored verbatim. An invented name is used; the CHECKs pin the
// unknown-capability diagnostic spanning the name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

__require_capability ThisIsANonExistingCapability;
//CHECK:             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ unknown capability
//CHECK:             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ unknown capability name 'ThisIsANonExistingCapability'.

void main() {}
