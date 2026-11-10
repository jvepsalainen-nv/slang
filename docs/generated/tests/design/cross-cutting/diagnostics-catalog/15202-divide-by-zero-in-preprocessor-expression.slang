//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15202 (divide-by-zero-in-preprocessor-expression) - division by zero
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15202
//META: catalog_name=divide-by-zero-in-preprocessor-expression
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Preprocessor conditional expressions are evaluated with integer arithmetic,
// and division by zero there is a diagnosed error rather than undefined
// behaviour. The CHECK pins the divide-by-zero code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if 1/0
#endif
void main() {}

//CHECK: E15202
