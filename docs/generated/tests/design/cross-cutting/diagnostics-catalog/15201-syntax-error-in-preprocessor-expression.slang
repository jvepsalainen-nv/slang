//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15201 (syntax-error-in-preprocessor-expression) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15201
//META: catalog_name=syntax-error-in-preprocessor-expression
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15201.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if @
#endif
void main() {}

//CHECK: E15201
