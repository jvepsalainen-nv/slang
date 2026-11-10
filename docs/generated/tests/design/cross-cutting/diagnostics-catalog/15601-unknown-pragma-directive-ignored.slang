//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15601 (unknown-pragma-directive-ignored) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15601
//META: catalog_name=unknown-pragma-directive-ignored
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15601.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#pragma unknown_pragma_xyz
void main() {}

//CHECK: E15601
