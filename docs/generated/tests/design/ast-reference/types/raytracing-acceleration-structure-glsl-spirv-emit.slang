//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#resource--texture--sampler-types
//META: doc_section_digest=1fea6aaeec3d54a63a589bef03489a7dd7676c39ed93549751670b987cd46065
//META: purpose=A RaytracingAccelerationStructureType is the AST type for `RaytracingAccelerationStructure`; the HLSL backend renders it under its documented surface name in a raygeneration entry point.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the RaytracingAccelerationStructureType emission claim out to the
// GLSL and SPIR-V Vulkan ray-tracing targets the sibling
// raytracing-acceleration-structure-raygen.slang (HLSL) does not cover.
// At a raygeneration entry point the acceleration structure lowers to a
// target-specific RT handle: GLSL `accelerationStructureEXT`, SPIR-V the
// RayTracingKHR capability + `OpTypeAccelerationStructureKHR`. (Metal and
// WGSL have no ray-tracing pipeline; see Untested claims
// unsupported-on-target metal / wgsl.) Each CHECK pins the token that
// identifies the acceleration-structure handle, copied verbatim from
// slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage raygeneration -entry main
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage raygeneration -entry main

RaytracingAccelerationStructure scene;
RWStructuredBuffer<uint> outputBuffer;

struct RayPayload
{
    float4 color;
};

//GLSL: accelerationStructureEXT scene
//SPV-DAG: OpCapability RayTracingKHR
//SPV-DAG: OpTypeAccelerationStructureKHR
void main()
{
    RayDesc ray;
    ray.Origin = float3(0, 0, 0);
    ray.TMin = 0.0;
    ray.Direction = float3(0, 0, 1);
    ray.TMax = 1.0;

    RayPayload payload;
    payload.color = float4(0, 0, 0, 1);

    TraceRay(scene, 0, 0xff, 0, 0, 0, ray, payload);

    outputBuffer[0] = (uint)payload.color.x;
}
