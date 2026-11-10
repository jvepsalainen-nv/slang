//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=The `[format("...")]` attribute selects the image format recorded on the emitted SPIR-V image type.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the attribute's format argument is carried into layout and lands on
// the image type, not just parsed. The texture asks for `rgba32f` and CHECK
// asserts the emitted `OpTypeImage` names `Rgba32f`; without the attribute the
// image type would carry the unknown format instead.

// The other two back ends that carry a storage-image format spell it their own
// way: GLSL as a `layout(rgba32f)` qualifier on the image uniform and WGSL as
// the first type argument of `texture_storage_2d`, so each prefix asserts the
// requested format arrived there rather than the target's default.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

[format("rgba32f")]
RWTexture2D<float4> tex;

[numthreads(1,1,1)]
void main()
{
    tex[uint2(0, 0)] = float4(1, 0, 0, 1);
}

//CHECK: OpTypeImage {{.*}}Rgba32f

//GLSL: layout(rgba32f)
//WGSL: texture_storage_2d<rgba32float
