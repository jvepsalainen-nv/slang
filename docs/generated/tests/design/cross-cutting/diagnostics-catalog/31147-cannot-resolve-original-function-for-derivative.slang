//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31147 (cannot-resolve-original-function-for-derivative) -- cannot resolve original function for derivative
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31147
//META: catalog_name=cannot-resolve-original-function-for-derivative
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[BackwardDerivativeOf(unknownFunc)]
void derivFunc(inout DifferentialPair<float> p, float dOut) {}


//CHECK: E31147
