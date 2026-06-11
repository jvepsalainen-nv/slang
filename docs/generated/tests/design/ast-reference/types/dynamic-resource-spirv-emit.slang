//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#resource--texture--sampler-types
//META: doc_section_digest=1fea6aaeec3d54a63a589bef03489a7dd7676c39ed93549751670b987cd46065
//META: purpose=A DynamicResourceType is the AST type for the bindless `__DynamicResource` handle; the GLSL backend lowers the surface spelling to a binding declaration in a fragment entry point.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the DynamicResourceType emission claim out to the SPIR-V text
// target the sibling dynamic-resource-fragment.slang (GLSL) does not
// cover. The `__DynamicResource` handle resolved via
// `.as<Texture2D<float4>>()` lowers to a `UniformConstant` image
// variable in SPIR-V. (HLSL, Metal, and WGSL abort on this surface with
// an internal error; see Untested claims + finding
// types-dynamic-resource-hlsl-metal-wgsl-emit-abort.) The CHECK pins
// the UniformConstant image variable, copied verbatim from slangc output.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage fragment -entry main

[vk::binding(0, 0)]
__DynamicResource handle;

//SPV: %handle = OpVariable %_ptr_UniformConstant_6 UniformConstant
float4 main() : SV_Target
{
    let tex = handle.as<Texture2D<float4>>();
    return tex.Load(int3(0, 0, 0));
}
