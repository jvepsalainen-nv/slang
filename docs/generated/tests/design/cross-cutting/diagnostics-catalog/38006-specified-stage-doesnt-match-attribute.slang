//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38006 (specified-stage-doesnt-match-attribute) - entry point stage mismatch
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38006
//META: catalog_name=specified-stage-doesnt-match-attribute
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// -stage vertex on the command line but [shader("fragment")] on
// the entry point triggers E38006.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl -stage vertex -entry main -profile sm_5_0

[shader("fragment")]
float4 main() : SV_Target
{
    return float4(1.0f);
}

//CHECK: E38006