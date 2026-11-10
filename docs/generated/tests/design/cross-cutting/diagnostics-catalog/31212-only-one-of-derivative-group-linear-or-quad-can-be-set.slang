//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31212 (only-one-of-derivative-group-linear-or-quad-can-be-set) -- conflicting derivative group settings
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31212
//META: catalog_name=only-one-of-derivative-group-linear-or-quad-can-be-set
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[DerivativeGroupLinear][DerivativeGroupQuad][shader("compute")][numthreads(8,1,1)]
void main() {}


//CHECK: E31212
