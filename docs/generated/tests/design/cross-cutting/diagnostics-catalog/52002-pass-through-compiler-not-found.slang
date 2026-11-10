//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E52002 (pass-through-compiler-not-found) - pass-through compiler not found
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=52002
//META: catalog_name=pass-through-compiler-not-found
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Requesting -pass-through with a downstream tool (fxc) that is
// not installed produces the pass-through-not-found error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target dxil -entry main -profile cs_6_0 -pass-through fxc

[numthreads(1,1,1)]
void main() {}

//CHECK: E52002
