//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15102 (expected-token-in-preprocessor-directive) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15102
//META: catalog_name=expected-token-in-preprocessor-directive
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15102.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#define
void main() {}

//CHECK: E15102
