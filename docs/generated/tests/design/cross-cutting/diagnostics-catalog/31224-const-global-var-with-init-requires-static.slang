//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31224 (const-global-var-with-init-requires-static) -- global const requires static
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31224
//META: catalog_name=const-global-var-with-init-requires-static
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

const int x = 5;
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E31224
