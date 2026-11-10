//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizeemptyraypayloadsforhlsl
//META: purpose=An empty logical ray payload is represented by a separate one-uint physical payload in the emitted HLSL closesthit entry-point signature.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An empty source payload still needs physical storage at the HLSL
// closest-hit interface. Capture the separate dummy struct, require its
// single uint field, and check that main uses that type for its inout
// payload. This ties the nonempty storage to the receiving entry point.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -profile lib_6_6 -stage closesthit -entry main

// Keep the logical source type empty; only its native interface needs
// the separate physical representation.
[raypayload]
struct EmptyPayload
{
}

[shader("closesthit")]
void main(
    inout EmptyPayload payload,
    BuiltInTriangleIntersectionAttributes attrs)
{
}

// CHECK: struct [[PAYLOAD:DummyRayPayload[A-Za-z0-9_]*]]
// CHECK-NEXT: {
// CHECK-NEXT: uint _slang_dummy{{[A-Za-z0-9_]*}};
// CHECK-NEXT: };
// CHECK: [shader("closesthit")]
// CHECK: void main(inout [[PAYLOAD]] {{[A-Za-z0-9_]+}},
