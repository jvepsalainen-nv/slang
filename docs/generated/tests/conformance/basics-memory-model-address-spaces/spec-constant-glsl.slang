//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`[vk::specialization_constant]`-annotated variables belong to the Specialization constant address space; SPIRV emits them as `OpSpecConstant` with a `SpecId` decoration.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL) of spec-constant-spirv.slang. The specialization constants that SPIRV
// emits as `OpSpecConstant` + `SpecId` map to GLSL `layout(constant_id = N) const` declarations;
// CHECK pins the `constant_id` layout qualifier carrying the SpecId on both spellings.
// HLSL has no specialization-constant surface; see README ## Untested claims (unsupported-on-target).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute

[[vk::specialization_constant]]
const int WORK_SIZE = 4;

[[SpecializationConstant]]
const float SCALE_FACTOR = 1.5;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    output[0] = float(WORK_SIZE) * SCALE_FACTOR;
}

// GLSL emits both specialization constants with `constant_id` layout qualifiers (order-independent).
// GLSL-DAG: layout(constant_id = 0)
// GLSL-DAG: layout(constant_id = 1)
// GLSL-DAG: const int WORK_SIZE
// GLSL-DAG: const float SCALE_FACTOR
