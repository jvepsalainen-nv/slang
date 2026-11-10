//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38052 (vertex-shader-missing-sv-position) - vertex shader has no output with the 'SV_Position' system value semantic
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38052
//META: catalog_name=vertex-shader-missing-sv-position
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A vertex shader with no SV_Position output triggers E38052.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-Wpedantic -target hlsl -entry main -stage vertex -profile sm_5_0

[shader("vertex")]
float4 main() : COLOR
{
    return float4(0);
}

//CHECK: E38052