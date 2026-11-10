//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38011 (entry-point-cannot-return-resource-type) - entry point cannot return type that contains resource types
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38011
//META: catalog_name=entry-point-cannot-return-resource-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An entry point that returns a Texture2D triggers E38011.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage vertex -entry main -profile sm_5_0

Texture2D<float> g;
Texture2D<float> main() : COLOR
{
    return g;
}

//CHECK: E38011
