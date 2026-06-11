//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=The `uniform` keyword on entry-point parameters also belongs to the Uniform address space; SPIRV emits it in a PushConstant block (single-element uniform parameters collapse to push-constant blocks on SPIRV).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of uniform-keyword-spirv.slang. The `uniform float scale`
// entry-point parameter that SPIRV packs into a PushConstant block emits as a GLSL
// `layout(push_constant)` uniform block and an HLSL `cbuffer` on a `b` register; CHECK pins each
// target's collapsed-uniform-parameter form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

[numthreads(4, 1, 1)]
void computeMain(uint3           tid    : SV_DispatchThreadID,
                 uniform float   scale,
                 RWStructuredBuffer<float> output)
{
    output[tid.x] = float(tid.x) * scale;
}

// GLSL packs the single uniform parameter into a push-constant uniform block.
// GLSL-DAG: layout(push_constant)
// GLSL-DAG: float scale_
// HLSL packs the single uniform parameter into a cbuffer on a b register.
// HLSL-DAG: cbuffer entryPointParams{{.*}} : register(b
// HLSL-DAG: float scale_
