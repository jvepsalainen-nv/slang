//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`Texture1D<T>` also belongs to the Image address space (not just Texture2D); SPIRV emits it with `UniformConstant` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of image-texture1d-spirv.slang. The Image→UniformConstant
// mapping that SPIRV gives `Texture1D<float>` also holds on GLSL (`uniform texture1D`) and HLSL
// (`Texture1D<float>` bound to a `t` register), confirming it across texture dimensionalities.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

Texture1D<float>   tex1d;
SamplerState       samp;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    output[0] = tex1d.SampleLevel(samp, 0.5, 0.0);
}

// GLSL emits the image as a `uniform texture1D` (separate-image model).
// GLSL: uniform texture1D tex1d
// HLSL emits Texture1D bound to a t register (shader resource view).
// HLSL: Texture1D<float{{.*}}> tex1d{{.*}} : register(t
