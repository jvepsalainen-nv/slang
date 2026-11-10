//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#option-set-toggles
//META: purpose=Verifies -fvk-invert-y inserts an OpFNegate on the SV_Position.y output that is absent without the flag.
//META: intent=characterization
//META: covers=source/slang/slang-options.cpp
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization of OptionKind::VulkanInvertY (-fvk-invert-y). The flag drives
// an IR pass that negates the Y component of SV_Position before stage output.
// The Y value is fed from a `uniform float` so the constant folder cannot
// precompute the negation. The INVERT directive pins the resulting `OpFNegate`;
// the PLAIN directive (no flag) uses CHECK-NOT to pin that no OpFNegate appears,
// isolating the option as the sole cause of the negate.

// Emission fan-out: the Y-flip is a Khronos-target legalization, so GLSL shows
// the same delta as SPIR-V, spelled as an explicit `.y = - <value>` store into
// the gl_Position temporary. The remaining shader text targets are recorded in
// the bundle README's Untested-claims table (`unsupported-on-target`): the
// option is Vulkan-cross-API only and produces byte-identical HLSL, Metal and
// WGSL with and without the flag, so there is no delta a CHECK could pin.

//TEST:SIMPLE(filecheck=INVERT):-target spirv-asm -fvk-invert-y -entry main -stage vertex
//TEST:SIMPLE(filecheck=PLAIN):-target spirv-asm -entry main -stage vertex
//TEST:SIMPLE(filecheck=GINV):-target glsl -fvk-invert-y -entry main -stage vertex
//TEST:SIMPLE(filecheck=GPLN):-target glsl -entry main -stage vertex

uniform float yval;

[shader("vertex")]
float4 main() : SV_Position
{
    return float4(0, yval, 0, 1);
}

//INVERT: OpFNegate
//PLAIN-NOT: OpFNegate

//GINV: .y = - globalParams_{{[0-9]+}}.yval_{{[0-9]+}}
//GPLN-NOT: .y = -
