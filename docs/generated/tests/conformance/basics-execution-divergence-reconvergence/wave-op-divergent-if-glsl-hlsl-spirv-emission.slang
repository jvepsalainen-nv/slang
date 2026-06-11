//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=Wave-tangled ops (WaveActiveMin/WaveActiveMax) inside a divergent `if` emit as GLSL subgroup ops (subgroupMin/subgroupMax) inside their respective if-arms, requiring the GL_KHR_shader_subgroup_arithmetic extension.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the GLSL wave-op-in-divergent-`if` claim: completes the
// HLSL and SPIR-V emission targets absent from wave-op-divergent-if-glsl-emission.slang.
// HLSL keeps the source intrinsics WaveActiveMin/WaveActiveMax inside the two
// if-arms; SPIR-V declares the GroupNonUniformArithmetic capability and lowers
// each op to OpGroupNonUniformUMin/UMax inside its per-arm block, confirming the
// wave op stays scoped to its mutually-convergent thread set.

//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute
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

// HLSL: if-conditional preserved; WaveActiveMin/Max in their respective arms.
// CHECK_HLSL: if(
// CHECK_HLSL: WaveActiveMin
// CHECK_HLSL: WaveActiveMax

// SPIRV: GroupNonUniformArithmetic capability; per-arm GroupNonUniform ops.
// CHECK_SPV: OpCapability GroupNonUniformArithmetic
// CHECK_SPV: OpSelectionMerge
// CHECK_SPV: OpGroupNonUniformUMin
// CHECK_SPV: OpGroupNonUniformUMax
