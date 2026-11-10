//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15407 (expected-macro-parameter-after-stringize) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15407
//META: catalog_name=expected-macro-parameter-after-stringize
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15407.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#define M(a) # b
void main() { M(1); }

//CHECK: E15407
