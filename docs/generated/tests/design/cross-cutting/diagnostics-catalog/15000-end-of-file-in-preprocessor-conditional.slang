//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15000 (end-of-file-in-preprocessor-conditional) - end of file encountered during preprocessor conditional
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15000
//META: catalog_name=end-of-file-in-preprocessor-conditional
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A conditional block that reaches end of file without `#endif` is unbalanced.
// The CHECK pins the end-of-file-in-conditional error, proving the preprocessor
// tracks conditional nesting to EOF rather than closing it implicitly.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#if 1
void main() {}

//CHECK: E15000
