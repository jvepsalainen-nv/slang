//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: doc_section_digest=0cb77e4bc46ab9a7f3eefef7b0e375bb9755811b790ee7577f7b13bbf467bf6b
//META: purpose=Two `RWStructuredBuffer<int>` resources emit as independent storage-buffer declarations on GLSL, Metal, CUDA, C++, and WGSL; the compiler assigns them distinct bindings so the client API can alias them at the storage layer.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the multi-target two-buffer claim
// (memory-aliasing-two-buffers-glsl-emission.slang) to HLSL and SPIR-V. HLSL emits each
// RWStructuredBuffer at a distinct `register(uN)`; SPIR-V decorates each with its own
// Binding. The two distinct bindings are the precondition the client API needs to alias
// them at the storage layer.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> bufA;
RWStructuredBuffer<int> bufB;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    bufA[0] = 42;
    int val = bufB[0];
    bufA[1] = val;
}

// HLSL: RWStructuredBuffer<int > bufA_{{[0-9]+}} : register(u0);
// HLSL: RWStructuredBuffer<int > bufB_{{[0-9]+}} : register(u1);

// SPV-DAG: OpDecorate %bufA{{.*}} Binding
// SPV-DAG: OpDecorate %bufB{{.*}} Binding
// SPV-DAG: OpVariable {{.*}} StorageBuffer
