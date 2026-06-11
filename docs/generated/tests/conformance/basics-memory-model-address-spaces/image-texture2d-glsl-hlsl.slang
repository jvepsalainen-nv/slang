//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`Texture2D<T>` belongs to the Image address space; SPIRV emits the variable with `UniformConstant` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of image-texture2d-spirv.slang. The same `Texture2D<float4>`
// that SPIRV places in `UniformConstant` emits as a GLSL `uniform texture2D` and an HLSL
// `Texture2D<float4>` bound to a `t` register; CHECK pins each target's image-resource form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

Texture2D<float4>  myTexture;
SamplerState       mySampler;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float4> output)
{
    output[0] = myTexture.SampleLevel(mySampler, float2(0.5, 0.5), 0.0);
}

// GLSL emits the image as a `uniform texture2D` (separate-image model).
// GLSL: uniform texture2D myTexture
// HLSL emits Texture2D bound to a t register (shader resource view).
// HLSL: Texture2D<float4{{.*}}> myTexture{{.*}} : register(t
