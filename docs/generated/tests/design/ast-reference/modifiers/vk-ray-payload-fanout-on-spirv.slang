//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#ray-tracing-attributes
//META: doc_section_digest=4a578d24f65dc29bcbb85085a150f642d821eab1012ac8a09ab76f12dff281fa
//META: purpose=`VulkanRayPayloadAttribute` (`[vk::ray_payload]`) on a closesthit payload propagates to emitted GLSL as a `rayPayloadInEXT`-class declaration.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out onto SPIR-V of the ray-payload lowering claim the sibling observes on
// GLSL. The `inout` payload of a closesthit entry point lowers to a SPIR-V
// variable in the `IncomingRayPayloadKHR` storage class (the SPIR-V form of
// GLSL's `rayPayloadInEXT`); CHECK pins `IncomingRayPayloadKHR`, proving the
// payload storage class reaches the emitted SPIR-V.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -stage closesthit -entry chitMain

struct ColorPayload
{
    float4 color;
};

[shader("closesthit")]
void chitMain(inout ColorPayload payload, BuiltInTriangleIntersectionAttributes attr)
{
    payload.color = float4(0.25f, 0.5f, 1.0f, 1.0f);
}

//CHECK: IncomingRayPayloadKHR
