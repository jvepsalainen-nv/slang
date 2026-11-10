//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`nointerpolation` on a fragment varying input survives into emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `nointerpolation` interpolation mode reaches codegen rather
// than being erased with the rest of the varying plumbing. The annotated field
// is returned from the fragment shader so it stays live, and CHECK asserts the
// emitted HLSL parameter still carries the qualifier.

// Each back end spells "do not interpolate" differently -- GLSL `flat`, Metal
// `[[flat]]`, WGSL `@interpolate(flat)`, SPIR-V a `Flat` decoration on the
// input variable -- so every prefix asserts that back end's own form of the
// mode rather than a generic marker.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage fragment
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage fragment
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage fragment
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage fragment
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage fragment

struct VsOut
{
    float4 pos     : SV_Position;
    nointerpolation float4 flat : COLOR0;
};

float4 main(VsOut v) : SV_Target
{
    return v.flat;
}

//CHECK: nointerpolation

//GLSL: flat layout(location = 0)
//METAL: {{\[\[}}flat{{\]\]}} float4 flat_
//WGSL: @interpolate(flat) @location(0) flat_
//SPIRV: OpDecorate %v_flat Flat
