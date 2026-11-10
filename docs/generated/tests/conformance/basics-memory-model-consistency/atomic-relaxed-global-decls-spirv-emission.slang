//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#atomics
//META: purpose=Slang standard library relaxed atomic operations (InterlockedMin, InterlockedMax, InterlockedAnd, InterlockedOr, InterlockedXor, InterlockedExchange) compile to corresponding `OpAtomicS*/OpAtomicU*/OpAtomicOr/OpAtomicAnd/OpAtomicXor/OpAtomicExchange` SPIRV ops with relaxed (0) memory semantics.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that all six global-decl relaxed atomics (InterlockedMin/Max/And/Or/Xor/Exchange)
// each compile to their corresponding SPIRV OpAtomic* opcode. CHECK-DAG pins all six
// opcodes regardless of emission order; the HLSL CHECKs confirm each intrinsic name
// survives lowering, proving the global-decl atomic surface maps one-to-one.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSLCHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSLCHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METALCHECK):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDACHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<uint> buf;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint old;
    InterlockedMin(buf[0], tid.x, old);
    InterlockedMax(buf[1], tid.x, old);
    InterlockedAnd(buf[2], tid.x, old);
    InterlockedOr(buf[3], tid.x, old);
    InterlockedXor(buf[4], tid.x, old);
    InterlockedExchange(buf[5], tid.x, old);
}

// All relaxed global-decl atomics emit with None (0) semantics in SPIRV.
// CHECK-DAG: OpAtomicUMin
// CHECK-DAG: OpAtomicUMax
// CHECK-DAG: OpAtomicAnd
// CHECK-DAG: OpAtomicOr
// CHECK-DAG: OpAtomicXor
// CHECK-DAG: OpAtomicExchange

// HLSL: each maps to corresponding Interlocked intrinsic.
// HLSLCHECK: InterlockedMin
// HLSLCHECK: InterlockedMax
// HLSLCHECK: InterlockedAnd
// HLSLCHECK: InterlockedOr
// HLSLCHECK: InterlockedXor
// HLSLCHECK: InterlockedExchange

// GLSL: each maps to corresponding atomic built-in (atomicMin/Max/And/Or/Xor/Exchange).
// GLSLCHECK-DAG: atomicMin
// GLSLCHECK-DAG: atomicMax
// GLSLCHECK-DAG: atomicAnd
// GLSLCHECK-DAG: atomicOr
// GLSLCHECK-DAG: atomicXor
// GLSLCHECK-DAG: atomicExchange

// Metal: each maps to metal atomic_fetch_*_explicit with memory_order_relaxed.
// METALCHECK-DAG: atomic_fetch_min_explicit
// METALCHECK-DAG: atomic_fetch_max_explicit
// METALCHECK-DAG: atomic_fetch_and_explicit
// METALCHECK-DAG: atomic_fetch_or_explicit
// METALCHECK-DAG: atomic_fetch_xor_explicit
// METALCHECK-DAG: atomic_exchange_explicit

// CUDA: each maps to CUDA atomicMin/Max/And/Or/Xor/Exch.
// CUDACHECK-DAG: atomicMin
// CUDACHECK-DAG: atomicMax
// CUDACHECK-DAG: atomicAnd
// CUDACHECK-DAG: atomicOr
// CUDACHECK-DAG: atomicXor
// CUDACHECK-DAG: atomicExch

// Targets not covered by emission directives:
//   wgsl   - Interlocked* intrinsics are not available on wgsl target (E36107 capability gate).
//   cpp    - Interlocked* intrinsics are not available on cpp target (E36107 capability gate).
