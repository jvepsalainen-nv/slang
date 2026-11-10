//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#barriers
//META: purpose=`DeviceMemoryBarrierWithGroupSync()` emits `OpControlBarrier` with Workgroup execution scope plus Device memory scope and device-memory-only semantics in SPIRV.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc lists DeviceMemoryBarrierWithGroupSync() as covering "Device" scope
// with a thread-group synchronization point. SPIRV: OpControlBarrier with
// execution scope Workgroup (2), memory scope Device (1), semantics 2120
// (= SeqCst | UniformMemory | ImageMemory). WorkgroupMemory absent (device only).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSLCHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSLCHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METALCHECK):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSLCHECK):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDACHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> buf;

[numthreads(64,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = tid.x;
    DeviceMemoryBarrierWithGroupSync();
    buf[tid.x + 1] = buf[0];
}

// SPIRV: OpControlBarrier Workgroup(2) Device(1) device-memory-semantics(2120).
// CHECK: OpControlBarrier
// CHECK-SAME: %uint_2
// CHECK-SAME: %uint_1
// CHECK-SAME: %uint_2120

// HLSL: preserves DeviceMemoryBarrierWithGroupSync intrinsic name.
// HLSLCHECK: DeviceMemoryBarrierWithGroupSync()

// GLSL: emits controlBarrier with Workgroup execution scope, Device memory scope, image+buffer semantics.
// GLSLCHECK: controlBarrier
// GLSLCHECK-SAME: gl_ScopeWorkgroup
// GLSLCHECK-SAME: gl_ScopeDevice
// GLSLCHECK-SAME: gl_StorageSemanticsBuffer

// Metal: emits threadgroup_barrier with all-memory flags (device, threadgroup, texture, imageblock).
// METALCHECK: threadgroup_barrier
// METALCHECK-SAME: mem_device

// WGSL: emits storageBarrier, textureBarrier, and workgroupBarrier (WGSL has no device-only group-sync barrier).
// WGSLCHECK: storageBarrier
// WGSLCHECK: workgroupBarrier

// CUDA: emits __syncthreads() (thread-group execution barrier + full memory fence).
// CUDACHECK: __syncthreads()

// Targets not covered by emission directives:
//   cpp    - DeviceMemoryBarrierWithGroupSync is not available on cpp target (E36107 capability gate).
