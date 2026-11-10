//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15206 (expected-integral-version-number) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15206
//META: catalog_name=expected-integral-version-number
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15206.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#version not_an_int
void main() {}

//CHECK: E15206
