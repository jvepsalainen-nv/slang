//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`ConstantBuffer<T>` belongs to the Uniform address space; SPIRV emits the variable with `Uniform` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of uniform-constant-buffer-spirv.slang. The `ConstantBuffer<T>`
// that SPIRV places in the `Uniform` storage class emits as a GLSL `uniform` block and an HLSL
// `cbuffer` on a `b` register; CHECK pins each target's uniform-buffer form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

struct Params {
    float scale;
    int   offset;
};

ConstantBuffer<Params> cb;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    output[0] = cb.scale + float(cb.offset);
}

// GLSL emits ConstantBuffer as a uniform block.
// GLSL: uniform block_
// HLSL emits ConstantBuffer as a cbuffer on a b register.
// HLSL: cbuffer cb{{.*}} : register(b
