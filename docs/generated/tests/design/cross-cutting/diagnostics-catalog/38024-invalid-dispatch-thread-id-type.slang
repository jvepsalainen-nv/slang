//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38024 (invalid-dispatch-thread-id-type) - invalid SV_DispatchThreadID type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38024
//META: catalog_name=invalid-dispatch-thread-id-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Using a float vector type for SV_DispatchThreadID instead of
// uint/int vector triggers E38024.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main

[numthreads(1,1,1)]
void main(float3 tid : SV_DispatchThreadID) {}

//CHECK: E38024
