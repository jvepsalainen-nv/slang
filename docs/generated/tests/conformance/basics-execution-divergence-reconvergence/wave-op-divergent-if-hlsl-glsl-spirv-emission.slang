//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=Wave-tangled ops (WaveActiveMin/WaveActiveMax) inside a divergent `if` emit as HLSL wave intrinsics inside the respective if-arm, one per mutually-convergent thread set.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the HLSL wave-op-in-divergent-`if` claim: completes the
// GLSL and SPIR-V emission targets absent from wave-op-divergent-if-hlsl-emission.slang.
// GLSL lowers the source intrinsics to subgroupMin/subgroupMax inside the two
// if-arms (requiring GL_KHR_shader_subgroup_arithmetic); SPIR-V lowers each to
// OpGroupNonUniformUMin/UMax inside its per-arm block, confirming each wave op
// remains scoped to its mutually-convergent thread set.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_SPV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 0;
    if ((tid.x & 1) == 0)
    {
        result = WaveActiveMin(tid.x);
    }
    else
    {
        result = WaveActiveMax(tid.x);
    }
    output[tid.x] = result;
}

// GLSL: extension required; subgroupMin/Max are the lowered per-arm intrinsics.
// CHECK_GLSL: GL_KHR_shader_subgroup_arithmetic
// CHECK_GLSL: if(
// CHECK_GLSL: subgroupMin
// CHECK_GLSL: subgroupMax

// SPIRV: GroupNonUniformArithmetic capability; per-arm GroupNonUniform ops.
// CHECK_SPV: OpCapability GroupNonUniformArithmetic
// CHECK_SPV: OpSelectionMerge
// CHECK_SPV: OpGroupNonUniformUMin
// CHECK_SPV: OpGroupNonUniformUMax
