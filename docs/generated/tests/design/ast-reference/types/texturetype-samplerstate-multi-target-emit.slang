//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#resource-and-texture-type-families
//META: doc_section_digest=0197e5bf25e2070b22239561996c86e1062d87133cd63b800da272aedb76f2aa
//META: purpose=A TextureType and SamplerStateType uniform are first-class types; the HLSL backend renders them as `Texture2D<T>` and `SamplerState`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the Texture2D + SamplerState emission claim out to the four
// non-HLSL shader text targets. TextureType and SamplerStateType are
// distinct first-class types, and each target spells the pair its own
// way: GLSL emits a `uniform texture2D` and a separate `uniform
// sampler`, Metal a `texture2d<float, access::sample>` plus a `sampler`
// with `[[texture]]`/`[[sampler]]` attributes, SPIR-V an `OpTypeImage`
// plus `OpTypeSampler`, and WGSL `texture_2d<f32>` plus `sampler`. Each
// CHECK pins the per-target type spelling copied verbatim from slangc.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

Texture2D<float4> g_tex;
SamplerState g_samp;
RWStructuredBuffer<float4> g_out;

//GLSL-DAG: uniform texture2D g_tex
//GLSL-DAG: uniform sampler g_samp
//METAL-DAG: texture2d<float, access::sample> g_tex
//METAL-DAG: sampler g_samp
//SPV-DAG: OpTypeImage %float 2D
//SPV-DAG: OpTypeSampler
//WGSL-DAG: texture_2d<f32>
//WGSL-DAG: g_samp_0 : sampler
[numthreads(1, 1, 1)]
void main()
{
    g_out[0] = g_tex.SampleLevel(g_samp, float2(0.0, 0.0), 0.0);
}
