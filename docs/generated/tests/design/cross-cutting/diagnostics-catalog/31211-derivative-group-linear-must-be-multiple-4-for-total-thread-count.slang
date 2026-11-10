//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31211 (derivative-group-linear-must-be-multiple-4-for-total-thread-count) -- derivative group linear thread count error
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31211
//META: catalog_name=derivative-group-linear-must-be-multiple-4-for-total-thread-count
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[DerivativeGroupLinear][shader("compute")][numthreads(3,1,1)]
void main() {}


//CHECK: E31211
