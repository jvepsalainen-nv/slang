//META: generated=true
//META: doc_ref=docs/language-reference/basics-program-execution.md#wave-execution-model
//META: purpose=WaveActiveBallot is a wave-tangled ballot function available in compute entry points; it emits WaveActiveBallot in HLSL and OpGroupNonUniformBallot in SPIR-V.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `WaveActiveBallot` is available as a wave-tangled ballot intrinsic.
// The compute shader calls WaveActiveBallot(true) and writes the result; CHECK asserts
// HLSL emits `WaveActiveBallot` and SPIR-V emits `GroupNonUniformBallot`, proving
// the ballot operation lowers to the correct per-target subgroup instruction.

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
    uint4 ballot = WaveActiveBallot(true);
    output[tid.x] = ballot.x;
}

// HLSL emits WaveActiveBallot intrinsic.
// CHECK: WaveActiveBallot

// SPIR-V emits GroupNonUniformBallot (the Vulkan ballot extension opcode).
// CHECK-SPV: GroupNonUniformBallot

// GLSL emits subgroupBallot with the KHR_shader_subgroup_ballot extension.
// CHECK-GLSL: subgroupBallot

// Metal emits simd_ballot (Metal SIMD-group ballot intrinsic).
// CHECK-METAL: simd_ballot

// WGSL emits subgroupBallot with the subgroups enable directive.
// CHECK-WGSL: subgroupBallot

// CUDA emits __ballot_sync (CUDA warp ballot intrinsic).
// CHECK-CUDA: __ballot_sync
