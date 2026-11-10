//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15503 (invalid-token-paste-result) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15503
//META: catalog_name=invalid-token-paste-result
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15503.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#define C 1 ## $$
void main() { C; }

//CHECK: E15503
