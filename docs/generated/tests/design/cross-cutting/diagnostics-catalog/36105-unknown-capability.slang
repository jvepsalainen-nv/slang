//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36105 (unknown-capability) - unknown capability
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36105
//META: catalog_name=unknown-capability
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `[require(...)]` listing a name that is not a known
// capability triggers E36105.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[require(bogus_capability_name)]
void helper() {}

//CHECK: E36105
