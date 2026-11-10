//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31102 (non-positive-num-threads) - invalid 'numthreads' value
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31102
//META: catalog_name=non-positive-num-threads
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A thread-group extent must be positive, since a zero extent would launch no
// threads. The CHECK pins the non-positive-numthreads error for an X extent of
// 0.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute
[numthreads(0,1,1)]
void main() {}

//CHECK: E31102
