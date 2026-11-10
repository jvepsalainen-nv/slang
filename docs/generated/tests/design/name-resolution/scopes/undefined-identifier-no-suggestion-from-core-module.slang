//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-walking-order-during-lookup
//META: purpose=The close-spelling walk skips the core module, so a typo whose only near match is a builtin gets an undefined-identifier diagnostic with no "did you mean" suggestion.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core-module exclusion in the suggestion walk: `floot` is
// one edit from the builtin `float` and nothing user-declared is close,
// so only the two undefined-identifier forms may be emitted. The test
// runs exhaustively: a spurious suggestion sourced from the core module
// would surface as an unannotated diagnostic and fail.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void skipCore()
{
    float x = floot;
//CHECK:      ^^^^^ undefined identifier
//CHECK:      ^^^^^ undefined identifier 'floot'.
// CHECK: E30015
}
