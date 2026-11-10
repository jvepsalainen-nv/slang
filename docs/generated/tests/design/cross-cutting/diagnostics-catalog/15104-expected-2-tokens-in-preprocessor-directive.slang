//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15104 (expected-2-tokens-in-preprocessor-directive) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15104
//META: catalog_name=expected-2-tokens-in-preprocessor-directive
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15104.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#line abc
void main() {}

//CHECK: E15104
