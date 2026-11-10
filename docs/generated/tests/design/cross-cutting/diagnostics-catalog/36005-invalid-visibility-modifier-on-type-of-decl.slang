//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36005 (invalid-visibility-modifier-on-type-of-decl) - visibility modifier not allowed
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36005
//META: catalog_name=invalid-visibility-modifier-on-type-of-decl
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Applying `internal` to a namespace declaration triggers E36005.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

internal namespace N { int x; }

//CHECK: E36005
