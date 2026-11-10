//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=legalizeRayTracingPayloads gives an empty ray payload physical storage on D3D by substituting a nonempty dummy struct.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Legalize ray-tracing payloads row says an empty payload gets a
// nonempty dummy struct on D3D, GLSL and SPIR-V. The HLSL emit shows the
// user's empty `Payload` replaced by `DummyRayPayload_0` holding one uint.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -profile sm_6_5 -stage closesthit -entry chit

struct Payload {};

[shader("closesthit")]
void chit(inout Payload p, in BuiltInTriangleIntersectionAttributes attr) {}

// HLSL: struct DummyRayPayload_{{[0-9]+}}
// HLSL-NEXT: {
// HLSL-NEXT: uint _slang_dummy_{{[0-9]+}};
// HLSL: void chit(inout DummyRayPayload_{{[0-9]+}} p_{{[0-9]+}}
