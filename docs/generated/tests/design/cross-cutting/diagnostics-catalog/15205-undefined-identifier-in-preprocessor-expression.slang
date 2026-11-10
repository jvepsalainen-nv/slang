//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15205 (undefined-identifier-in-preprocessor-expression) - undefined identifier in preprocessor
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15205
//META: catalog_name=undefined-identifier-in-preprocessor-expression
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An identifier that is not a defined macro evaluates to 0 in a conditional,
// but the preprocessor still warns so typos in feature checks are visible. The
// CHECK pins that warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if UNDEFINED_IDENTIFIER_XYZ
#endif
void main() {}

//CHECK: E15205
