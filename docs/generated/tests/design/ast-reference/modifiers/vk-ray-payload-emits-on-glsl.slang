//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=A ray payload passed `inout` to a closesthit entry point lowers to a GLSL `rayPayloadInEXT` variable.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ray-payload attribute family's user-visible consequence on the
// GLSL back end: the payload parameter becomes a module-scope `rayPayloadInEXT`
// variable rather than an ordinary function argument, which is how Vulkan ray
// tracing passes payloads. CHECK asserts that storage qualifier appears in the
// emitted GLSL.

// The direct SPIR-V path performs the same rewrite under the Khronos name for
// that storage class, so the SPIRV prefix asserts the payload became a module
// -scope `IncomingRayPayloadKHR` variable there rather than staying a function
// parameter.

//TEST:SIMPLE(filecheck=CHECK): -target glsl -profile glsl_460+GL_EXT_ray_tracing -stage closesthit -entry chitMain
//TEST:SIMPLE(filecheck=SPIRV): -target spirv-asm -stage closesthit -entry chitMain

struct ColorPayload
{
    float4 color;
};

[shader("closesthit")]
void chitMain(inout ColorPayload payload, BuiltInTriangleIntersectionAttributes attr)
{
    payload.color = float4(0.25f, 0.5f, 1.0f, 1.0f);
}

//CHECK: rayPayloadInEXT

//SPIRV: %payload = OpVariable %{{[A-Za-z0-9_]+}} IncomingRayPayloadKHR
