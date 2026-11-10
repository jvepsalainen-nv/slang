//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15901 (user-defined-warning) - preprocessor warning
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15901
//META: catalog_name=user-defined-warning
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#warning` reports its message without failing the compile. The CHECK pins
// the user-defined-warning code, which distinguishes it from `#error`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#warning deliberate user-defined preprocessor warning
void main() {}

//CHECK: E15901
