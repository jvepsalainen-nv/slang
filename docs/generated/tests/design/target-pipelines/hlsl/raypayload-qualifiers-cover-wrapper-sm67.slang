//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizeraypayloadaccessqualifiersforhlsl
//META: purpose=At shader model 6.7 the qualifier fill also covers the physical wrapper struct created for a non-struct payload, so its data field carries both read and write sides.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the qualifier fill runs after the payload adaptation: the
// generated `RayPayload_t` wrapper (made for an inout `float4` payload,
// which has no user-written qualifiers) is a `[raypayload]` struct at
// sm_6_7 and its `data` field gets the full read and write stage lists. The
// sm_6_6 run asserts no qualifiers are added there.

//TEST:SIMPLE(filecheck=CHECK67):-target hlsl -profile sm_6_7 -stage anyhit -entry main
//TEST:SIMPLE(filecheck=CHECK66):-target hlsl -profile sm_6_6 -stage anyhit -entry main

[shader("anyhit")]
void main(
    inout float4 payload,
    BuiltInTriangleIntersectionAttributes attrs)
{
    payload.x = payload.x + 1.0;
}

// CHECK67: struct [raypayload] RayPayload_t{{[A-Za-z0-9_]*}}
// CHECK67-NEXT: {
// CHECK67-NEXT: float4 data{{[A-Za-z0-9_]*}} : read(caller, anyhit, closesthit, miss) : write(caller, anyhit, closesthit, miss);

// CHECK66: struct RayPayload_t{{[A-Za-z0-9_]*}}
// CHECK66-NEXT: {
// CHECK66-NEXT: float4 data{{[A-Za-z0-9_]*}};
