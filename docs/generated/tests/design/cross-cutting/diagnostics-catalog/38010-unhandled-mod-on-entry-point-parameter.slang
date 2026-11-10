//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38010 (unhandled-mod-on-entry-point-parameter) - modifier on entry point parameter is unsupported
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38010
//META: catalog_name=unhandled-mod-on-entry-point-parameter
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Applying `register(...)` to an entry-point parameter is
// unsupported and triggers E38010.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage vertex -entry main

float4 main(uniform float4 v : register(c0)) : SV_Position
{
    return v;
}

//CHECK: E38010