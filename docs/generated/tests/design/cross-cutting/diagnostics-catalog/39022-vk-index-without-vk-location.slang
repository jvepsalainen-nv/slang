//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39022 (vk-index-without-vk-location) - vk::index without vk::location
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39022
//META: catalog_name=vk-index-without-vk-location
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[[vk::index(N)]]` without a corresponding `[[vk::location(N)]]`
// is ignored and triggers E39022.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage fragment -entry main

[shader("fragment")]
float4 main([[vk::index(1)]] float4 col : COLOR) : SV_Target
{
    return col;
}

//CHECK: E39022