//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15100 (expected-preprocessor-directive-name) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15100
//META: catalog_name=expected-preprocessor-directive-name
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15100.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#@
void main() {}

//CHECK: E15100
