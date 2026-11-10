//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E58001 (entry-point-must-return-void-when-global-output-present) - entry point must return void with global outputs
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=58001
//META: catalog_name=entry-point-must-return-void-when-global-output-present
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// GLSL requires entry points to return void when a global output
// variable exists. A non-void return on the same entry triggers
// the error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target glsl -entry main -stage fragment

layout(location=0) out float4 oColor;

float4 main() : SV_TARGET {
    oColor = float4(1);
    return float4(1);
}

//CHECK: E58001
