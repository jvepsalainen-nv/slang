//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=The `unorm` and `snorm` resource-element format modifiers survive into the emitted HLSL resource type.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two resource-element format modifiers wrap the element type of
// a resource and are carried into codegen, not stripped once the type is checked.
// Both textures are read into the output buffer so neither declaration is
// eliminated, and the CHECK-DAG lines assert each emitted HLSL resource type
// still spells its normalisation modifier.

// SPIR-V records the same distinction in the image type's format operand: the
// `unorm` texture becomes `Rgba8` and the `snorm` one `Rgba8Snorm`, so the
// SPIRV prefix shows the two modifiers stay apart after legalization instead of
// collapsing onto one format.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute

RWTexture2D<unorm float4> uTex;
RWTexture2D<snorm float4> sTex;
RWStructuredBuffer<float> outBuf;

[numthreads(1,1,1)]
void main()
{
    outBuf[0] = uTex[uint2(0, 0)].x + sTex[uint2(0, 0)].y;
}

//CHECK-DAG: RWTexture2D<unorm float4
//CHECK-DAG: RWTexture2D<snorm float4

//SPIRV-DAG: OpTypeImage %float 2D 2 0 0 2 Rgba8Snorm
//SPIRV-DAG: OpTypeImage %float 2D 2 0 0 2 Rgba8{{$}}
