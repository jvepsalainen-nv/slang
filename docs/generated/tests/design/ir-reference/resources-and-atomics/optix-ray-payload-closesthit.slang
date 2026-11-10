//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#raytracing-payload
//META: purpose=A `closesthit` entry point on `-target cuda` with a `[raypayload]` struct emits `optixGetPayload_N` and `optixGetAttribute_N`, the user-visible artifact of the `getOptiXRayPayloadPtr` / `getOptiXHitAttribute` opcodes synthesized during target legalization.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The OptiX payload and hit-attribute accessors are synthesized during
// target legalization, after the `-dump-ir` snapshot, so this test
// observes the emitted CUDA instead. A `closesthit` entry point with a
// `[raypayload]` struct and a built-in attribute struct makes the
// legalizer produce both accessors, and the order-independent CHECKs
// pin the payload read and the attribute read.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -stage closesthit -entry main

struct LargePayload
{
    float4 a;
    float4 b;
    float4 c;
    float4 d;
    float4 e;
    float4 f;
};

[shader("closesthit")]
void main(inout LargePayload payload, BuiltInTriangleIntersectionAttributes attribs)
{
    float3 bary = float3(
        1.0 - attribs.barycentrics.x - attribs.barycentrics.y,
        attribs.barycentrics.x,
        attribs.barycentrics.y);
    payload.a = float4(bary, RayTCurrent());
}

// CHECK-DAG: optixGetPayload_
// CHECK-DAG: optixGetAttribute_
