//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=Entry-point output parameters and return values belong to the Output address space; SPIRV emits vertex shader outputs with `Output` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of output-address-space-spirv.slang. A vertex shader returns a
// struct carrying SV_Position and TEXCOORD0; the Output address space that SPIRV emits as
// `Output` storage class maps to GLSL `gl_Position` + an `out` varying, and on HLSL stays the
// SV_Position / TEXCOORD0 return-struct semantics. CHECK pins each target's output form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry vsMain -stage vertex
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry vsMain -stage vertex

struct VSOutput {
    float4 pos : SV_Position;
    float2 uv  : TEXCOORD0;
};

VSOutput vsMain(float3 pos : POSITION, float2 uv : TEXCOORD0)
{
    VSOutput o;
    o.pos = float4(pos, 1.0);
    o.uv  = uv;
    return o;
}

// GLSL emits the position output as gl_Position and the TEXCOORD0 output as an `out` varying.
// GLSL-DAG: gl_Position
// GLSL-DAG: out vec2
// HLSL emits the return struct fields with their SV_Position / TEXCOORD0 semantics.
// HLSL-DAG: SV_Position
// HLSL-DAG: TEXCOORD0
