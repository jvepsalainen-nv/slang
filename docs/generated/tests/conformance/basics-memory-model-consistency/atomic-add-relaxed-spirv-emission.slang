//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#atomics
//META: purpose=Relaxed atomic `InterlockedAdd` emits `OpAtomicIAdd` with None (0) memory semantics in SPIRV, confirming atomicity without ordering constraints.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `InterlockedAdd` (a relaxed global-decl atomic) emits `OpAtomicIAdd`
// with memory semantics operand 0 (None) in SPIRV, confirming atomicity with no
// ordering constraint beyond the atomic operation itself. CHECK pins %uint_0 on
// OpAtomicIAdd; the HLSL CHECK confirms the intrinsic name is preserved.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSLCHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSLCHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METALCHECK):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDACHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> buf;

[numthreads(64,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint old;
    InterlockedAdd(buf[0], tid.x, old);
}

// SPIRV: relaxed atomic (None=0 semantics) opcode.
// CHECK: OpAtomicIAdd
// CHECK-SAME: %uint_0

// HLSL: emits InterlockedAdd intrinsic preserving the relaxed semantics.
// HLSLCHECK: InterlockedAdd

// GLSL: emits atomicAdd (no ordering parameter; GLSL does not surface per-op ordering here).
// GLSLCHECK: atomicAdd

// Metal: emits atomic_fetch_add_explicit with memory_order_relaxed.
// METALCHECK: atomic_fetch_add_explicit
// METALCHECK-SAME: memory_order_relaxed

// CUDA: emits atomicAdd (no ordering parameter; CUDA PTX default is relaxed for atomicAdd).
// CUDACHECK: atomicAdd

// Targets not covered by emission directives:
//   wgsl   - InterlockedAdd is not available on wgsl target (E36107 capability gate).
//   cpp    - InterlockedAdd is not available on cpp target (E36107 capability gate).
