//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15208 (unknown-language) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15208
//META: catalog_name=unknown-language
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15208.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#language cobol_xx
void main() {}

//CHECK: E15208
