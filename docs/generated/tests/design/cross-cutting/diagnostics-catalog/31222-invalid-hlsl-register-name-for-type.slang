//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31222 (invalid-hlsl-register-name-for-type) -- invalid HLSL register name for type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31222
//META: catalog_name=invalid-hlsl-register-name-for-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

Texture2D tex : register(t0, space0);
RWTexture2D<float4> rwtex : register(t0);
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E31222
