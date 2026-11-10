//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31148 (cannot-resolve-derivative-function) -- cannot resolve derivative function
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31148
//META: catalog_name=cannot-resolve-derivative-function
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[Differentiable]
[BackwardDerivative(unknownDeriv)]
float f(float x) { return x; }


//CHECK: E31148
