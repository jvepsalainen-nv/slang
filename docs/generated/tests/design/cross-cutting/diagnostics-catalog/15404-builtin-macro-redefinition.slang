//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15404 (builtin-macro-redefinition) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15404
//META: catalog_name=builtin-macro-redefinition
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15404.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#define __FILE__ 5
void main() { __FILE__; }

//CHECK: E15404
