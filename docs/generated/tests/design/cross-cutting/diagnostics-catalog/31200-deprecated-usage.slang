//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31200 (deprecated-usage) -- use of deprecated declaration
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31200
//META: catalog_name=deprecated-usage
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[deprecated("use newF instead")] void oldF() {}
[shader("compute")][numthreads(1,1,1)]
void main() { oldF(); }


//CHECK: E31200
