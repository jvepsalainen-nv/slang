//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E40000 (ray-payload-field-missing-access-qualifiers) - ray payload field missing access qualifiers
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=40000
//META: catalog_name=ray-payload-field-missing-access-qualifiers
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A field in a `[raypayload]` struct without read/write access
// qualifiers triggers E40000.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage closesthit -entry main

struct [raypayload] Payload
{
    float c;
}

[shader("closesthit")]
void main(inout Payload p, in BuiltInTriangleIntersectionAttributes attrs)
{
    p.c = 0.0;
}

//CHECK: E40000
