//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`[SpecializationConstant]` (non-vk form) also belongs to the Specialization constant address space; SPIRV emits it as `OpSpecConstant` with `SpecId` decoration.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL) of spec-constant-attr-spirv.slang. The non-vk `[[SpecializationConstant]]`
// spelling routes the constant to the same Specialization constant address space: GLSL emits a
// `layout(constant_id = N) const` declaration carrying the SpecId. CHECK pins the `constant_id`
// layout qualifier. HLSL has no specialization-constant surface; see README ## Untested claims
// (unsupported-on-target).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute

[[SpecializationConstant]]
const int TILE_SIZE = 8;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<int> output)
{
    output[0] = TILE_SIZE * TILE_SIZE;
}

// GLSL emits the specialization constant with a `constant_id` layout qualifier.
// GLSL: layout(constant_id = 0)
// GLSL-DAG: const int TILE_SIZE
