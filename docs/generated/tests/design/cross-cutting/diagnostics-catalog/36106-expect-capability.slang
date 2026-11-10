//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36106 (expect-capability) - expect a capability name
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36106
//META: catalog_name=expect-capability
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `[require(...)]` whose argument is a number rather than a
// capability name triggers E36106.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[require(42)]
void helper() {}

//CHECK: E36106
