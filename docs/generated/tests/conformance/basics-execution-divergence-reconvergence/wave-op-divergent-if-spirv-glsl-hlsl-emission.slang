//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=Wave-tangled ops (WaveActiveMin/WaveActiveMax) inside a divergent `if` emit as GroupNonUniform ops inside separate SPIRV branch arms, applying only to mutually-convergent threads in each arm.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the SPIR-V per-arm wave-op claim: completes the GLSL and
// HLSL emission targets absent from wave-op-divergent-if-spirv-emission.slang.
// Both targets keep each wave op inside its if-arm: HLSL preserves the source
// WaveActiveMin/WaveActiveMax intrinsics; GLSL lowers them to subgroupMin/Max
// (under GL_KHR_shader_subgroup_arithmetic). CHECK confirms the `if(` structure
// and the two per-arm ops, matching the SPIR-V per-arm GroupNonUniform shape.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 0;
    if ((tid.x & 1) == 0)
    {
        // mutually-convergent set: even threads only
        result = WaveActiveMin(tid.x);
    }
    else
    {
        // mutually-convergent set: odd threads only
        result = WaveActiveMax(tid.x);
    }
    output[tid.x] = result;
}

// GLSL: if preserved; subgroupMin in the then-arm, subgroupMax in the else-arm.
// CHECK_GLSL: if(
// CHECK_GLSL: subgroupMin
// CHECK_GLSL: subgroupMax

// HLSL: if preserved; WaveActiveMin in the then-arm, WaveActiveMax in the else-arm.
// CHECK_HLSL: if(
// CHECK_HLSL: WaveActiveMin
// CHECK_HLSL: WaveActiveMax
