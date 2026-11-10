//META: generated=true
//META: doc_ref=docs/language-reference/basics-program-execution.md#thread-group-execution-model
//META: purpose=GroupMemoryBarrier() and GroupMemoryBarrierWithGroupSync() are thread-group barriers that emit the corresponding HLSL intrinsics and SPIR-V OpControlBarrier/OpMemoryBarrier ops.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `GroupMemoryBarrier` and `GroupMemoryBarrierWithGroupSync` are
// available in a compute entry point and lower to the correct backend ops.
// CHECK asserts the HLSL output contains both function names; CHECK-SPV asserts
// SPIR-V emits OpControlBarrier, proving the barrier instructions survive emit.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK-CUDA):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> outputBuffer;

groupshared uint shared[2];

[numthreads(2, 1, 1)]
void computeMain(uint3 tid : SV_GroupThreadID)
{
    shared[tid.x] = tid.x;
    GroupMemoryBarrier();
    GroupMemoryBarrierWithGroupSync();
    outputBuffer[tid.x] = shared[1u - tid.x];
}

// HLSL: both barriers appear by name.
// CHECK-DAG: GroupMemoryBarrier
// CHECK-DAG: GroupMemoryBarrierWithGroupSync

// SPIR-V: barriers lower to OpControlBarrier or OpMemoryBarrier.
// CHECK-SPV: OpControlBarrier

// GLSL: GroupMemoryBarrier → memoryBarrier (shared scope); GroupMemoryBarrierWithGroupSync → controlBarrier.
// CHECK-GLSL: memoryBarrier
// CHECK-GLSL: controlBarrier

// Metal: both barriers lower to threadgroup_barrier.
// CHECK-METAL: threadgroup_barrier

// WGSL: both barriers lower to workgroupBarrier.
// CHECK-WGSL: workgroupBarrier

// CUDA: GroupMemoryBarrier → __threadfence_block; GroupMemoryBarrierWithGroupSync → __syncthreads.
// CHECK-CUDA: __threadfence_block
// CHECK-CUDA: __syncthreads
