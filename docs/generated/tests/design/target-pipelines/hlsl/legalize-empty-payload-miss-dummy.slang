//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizeemptyraypayloadsforhlsl
//META: purpose=A miss shader whose payload parameters are all empty is emitted with an inout parameter of the separate DummyRayPayload struct, not the empty source type.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the receiving-shader arm of the empty-payload handling for a
// `miss` entry point: the empty source struct is replaced at the native
// interface by the separate one-uint `DummyRayPayload`. CHECK captures the
// dummy struct and requires the miss signature to use it; CHECK-NOT keeps
// the empty source type out of the signature.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -profile lib_6_6 -stage miss -entry main

struct Empty
{
}

[shader("miss")]
void main(inout Empty p)
{
}

// CHECK: struct [[PAYLOAD:DummyRayPayload[A-Za-z0-9_]*]]
// CHECK-NEXT: {
// CHECK-NEXT: uint _slang_dummy{{[A-Za-z0-9_]*}};
// CHECK-NEXT: };
// CHECK: [shader("miss")]
// CHECK-NOT: Empty
// CHECK: void main(inout [[PAYLOAD]] {{[A-Za-z0-9_]+}})
