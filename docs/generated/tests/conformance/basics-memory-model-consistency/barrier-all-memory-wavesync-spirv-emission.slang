//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#barriers
//META: purpose=`AllMemoryBarrierWithWaveSync()` emits `OpControlBarrier` with Subgroup (wave) scope for execution and all-memory semantics in SPIRV.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc lists AllMemoryBarrierWithWaveSync() as a memory barrier primitive (with
// a TODO link). It synchronizes all threads in a wave and applies all-memory semantics.
// SPIRV: OpControlBarrier Subgroup(3) Subgroup(3) semantics 2376
// (= SeqCst | UniformMemory | WorkgroupMemory | ImageMemory).
// The Subgroup execution scope (3) distinguishes this from AllMemoryBarrierWithGroupSync
// which uses Workgroup (2).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSLCHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSLCHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METALCHECK):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDACHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> buf;

[numthreads(64,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = tid.x;
    AllMemoryBarrierWithWaveSync();
    buf[tid.x + 1] = buf[0];
}

// SPIRV: OpControlBarrier Subgroup(3) Subgroup(3) all-memory-semantics(2376).
// CHECK: OpControlBarrier
// CHECK-SAME: %uint_3
// CHECK-SAME: %uint_3
// CHECK-SAME: %uint_2376

// HLSL: AllMemoryBarrierWithWaveSync has no direct HLSL equivalent; falls back to AllMemoryBarrier.
// HLSLCHECK: AllMemoryBarrier

// GLSL: emits subgroupBarrier() (subgroup-scope barrier covering all memory, matching wave/subgroup sync).
// GLSLCHECK: subgroupBarrier

// Metal: emits simdgroup_barrier with device and threadgroup memory flags (SIMD-group scope).
// METALCHECK: simdgroup_barrier

// CUDA: emits __syncwarp() (warp-scope execution and memory fence).
// CUDACHECK: __syncwarp()

// Targets not covered by emission directives:
//   wgsl   - AllMemoryBarrierWithWaveSync is not available on wgsl target (E36107 capability gate; no wave-sync surface in WGSL).
//   cpp    - AllMemoryBarrierWithWaveSync is not available on cpp target (E36107 capability gate).
