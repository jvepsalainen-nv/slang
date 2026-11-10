//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#reserved-identifier-prefixes
//META: purpose=`SV_`-prefixed identifiers are HLSL system-value semantics; `SV_Position` survives into HLSL emit as `SV_POSITION`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Tag a vertex-stage return with `SV_Position` semantic. The HLSL
// emit upper-cases the semantic to `SV_POSITION`, which is enough to
// confirm the `SV_` prefix was recognized.
//
// Recognition of the `SV_` prefix is observable on every shader text
// target, because each one has to map the system-value semantic onto
// its own position output: GLSL onto `gl_Position`, SPIR-V onto a
// `BuiltIn Position` variable, Metal onto a `[[position]]`-qualified
// struct field, and WGSL onto `@builtin(position)`. An unrecognized
// semantic would instead be diagnosed, so each per-target CHECK is a
// positive signal that the prefix was bound.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage vertex
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage vertex
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage vertex
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage vertex
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage vertex

float4 main(float3 pos : POSITION) : SV_Position
{
    //CHECK: SV_POSITION
    return float4(pos, 1.0);
}

//GLSL: gl_Position =
//SPIRV: OpDecorate %gl_Position BuiltIn Position
//METAL: float4 output{{.*}}{{\[\[}}position]]
//WGSL: @builtin(position) output{{.*}} : vec4<f32>
