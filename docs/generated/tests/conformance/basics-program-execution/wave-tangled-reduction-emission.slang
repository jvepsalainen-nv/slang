//META: generated=true
//META: doc_ref=docs/language-reference/basics-program-execution.md#wave-execution-model
//META: purpose=WaveActiveSum is a wave-tangled reduction function; it emits WaveActiveSum in HLSL and OpGroupNonUniformIAdd with Reduce in SPIR-V.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `WaveActiveSum` is available as a wave-tangled reduction intrinsic.
// The compute shader sums tid.x across the wave; CHECK asserts HLSL emits `WaveActiveSum`
// and SPIR-V emits `GroupNonUniformIAdd`, confirming the reduction maps to the correct
// subgroup arithmetic instruction on each target.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-CUDA):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(32, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    output[tid.x] = WaveActiveSum(tid.x);
}

// HLSL emits WaveActiveSum intrinsic.
// CHECK: WaveActiveSum

// SPIR-V emits OpGroupNonUniformIAdd with Reduce mode.
// CHECK-SPV: GroupNonUniformIAdd

// GLSL emits subgroupAdd with the KHR_shader_subgroup_arithmetic extension.
// CHECK-GLSL: subgroupAdd

// Metal emits simd_sum (Metal SIMD-group reduction intrinsic).
// CHECK-METAL: simd_sum

// WGSL emits subgroupAdd with the subgroups enable directive.
// CHECK-WGSL: subgroupAdd

// CUDA emits _waveSum (the Slang CUDA warp reduction helper).
// CHECK-CUDA: _waveSum
