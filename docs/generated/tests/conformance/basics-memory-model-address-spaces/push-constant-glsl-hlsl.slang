//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`[vk::push_constant]`-annotated struct belongs to the Push constant address space; SPIRV emits it with `PushConstant` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of push-constant-spirv.slang. The `[[vk::push_constant]]` struct
// that SPIRV places in `PushConstant` emits as a GLSL `layout(push_constant)` uniform block; HLSL
// (which has no push-constant concept) lowers it to a `cbuffer` bound to a `b` register. CHECK
// pins each target's emitted form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

struct PushData {
    float scale;
    int   count;
};

[[vk::push_constant]]
PushData pushConst;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    output[0] = pushConst.scale * float(pushConst.count);
}

// GLSL emits the push-constant struct with the `push_constant` layout qualifier.
// GLSL: layout(push_constant)
// HLSL has no push-constant concept; the struct lowers to a cbuffer on a b register.
// HLSL: cbuffer pushConst{{.*}} : register(b
