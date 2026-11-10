//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39020 (too-many-shader-record-constant-buffers) - too many shader record constant buffers
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39020
//META: catalog_name=too-many-shader-record-constant-buffers
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// At most one constant buffer may be tagged
// `[[vk::shader_record]]`; declaring two triggers E39020.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage closesthit -entry main

[[vk::shader_record]]
cbuffer SR1 { int a; }

[[vk::shader_record]]
cbuffer SR2 { int b; }

struct Payload { float4 c; }

[shader("closesthit")]
void main(inout Payload p, in BuiltInTriangleIntersectionAttributes attrs)
{
    p.c = float4(0);
}

//CHECK: E39020
