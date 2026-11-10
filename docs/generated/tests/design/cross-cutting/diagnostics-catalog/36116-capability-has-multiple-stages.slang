//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36116 (capability-has-multiple-stages) - capability targets multiple stages
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36116
//META: catalog_name=capability-has-multiple-stages
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Using a `[shader("...")]` value that resolves to a multi-stage
// capability triggers E36116.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl -entry main -allow-glsl -profile sm_5_0

[shader("compute_fragment")]
void main()
{
}

//CHECK: E36116
