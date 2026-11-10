//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15203 (expected-token-in-defined-expression) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15203
//META: catalog_name=expected-token-in-defined-expression
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15203.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if defined(
#endif
void main() {}

//CHECK: E15203
