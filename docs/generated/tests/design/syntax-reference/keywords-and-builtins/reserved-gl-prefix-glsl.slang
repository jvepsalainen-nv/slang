//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#reserved-identifier-prefixes
//META: purpose=`gl_`-prefixed identifiers stand for shader-stage built-ins supplied by `glsl.meta.slang`; the GLSL emit uses the gl_-prefixed spelling.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Write to the vertex-stage position output and verify the GLSL emit
// names it `gl_Position` (the GLSL spelling for `SV_Position`).
//
// SPIR-V is the one other target that carries the `gl_`-prefixed
// spelling: the position built-in is emitted as an `OpVariable` named
// `%gl_Position` and decorated `BuiltIn Position`, so the reserved
// prefix is observable in the SPIR-V annotation section as well. The
// HLSL, Metal, and WGSL emits spell the same output `SV_POSITION`,
// `[[position]]`, and `@builtin(position)`, i.e. they never use a
// `gl_` name; those three are recorded as `unsupported-on-target` in
// the bundle README rather than pinned with a weakened CHECK.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage vertex
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage vertex

float4 main(float3 pos) : SV_Position
{
    //CHECK: gl_Position
    return float4(pos, 1.0);
}

//SPIRV: OpDecorate %gl_Position BuiltIn Position
