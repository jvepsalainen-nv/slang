//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#reserved-identifier-prefixes
//META: doc_section_digest=3f95ec9865b25008e28f60ca66efd13758cbf3599f18b4c7e50e7d0178187f2f
//META: purpose=`gl_`-prefixed identifiers stand for shader-stage built-ins supplied by `glsl.meta.slang`; the GLSL emit uses the gl_-prefixed spelling.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Emission fan-out for the `gl_`-prefixed builtin claim onto SPIR-V. The
// sibling `reserved-gl-prefix-glsl.slang` pins the GLSL emit
// (`gl_Position`). SPIR-V keeps the same Khronos `gl_`-prefixed spelling
// for the position builtin: the CHECK pins the `%gl_Position` id named
// after the vertex position output, decorated `BuiltIn Position`. (The
// HLSL, Metal, and WGSL emits do NOT use the `gl_` spelling — they use
// `SV_POSITION`, `[[position]]`, and `@builtin(position)` respectively —
// so those targets are recorded unsupported-on-target in the README.)

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage vertex

float4 main(float3 pos) : SV_Position
{
    return float4(pos, 1.0);
}

//SPV-DAG: %gl_Position = OpVariable
//SPV-DAG: OpDecorate %gl_Position BuiltIn Position
