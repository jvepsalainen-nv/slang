//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15002 (directive-after-else) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15002
//META: catalog_name=directive-after-else
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15002.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if 1
#else
#elif 0
#endif
void main() {}

//CHECK: E15002
