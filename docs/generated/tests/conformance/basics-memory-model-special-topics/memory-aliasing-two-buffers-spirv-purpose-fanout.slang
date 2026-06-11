//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: doc_section_digest=0cb77e4bc46ab9a7f3eefef7b0e375bb9755811b790ee7577f7b13bbf467bf6b
//META: purpose=Two `RWStructuredBuffer<int>` resources emit as independent StorageBuffer variables with distinct SPIRV Binding decorations; if the client API binds them to the same memory, concurrent non-atomic access is a data race.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the SPIR-V two-buffer claim
// (memory-aliasing-two-buffers-spirv-emission.slang) to the remaining shader targets.
// HLSL emits each RWStructuredBuffer at a distinct `register(uN)`; GLSL at a distinct
// std430 binding; Metal as a separate `device*`; WGSL as a separate
// `var<storage, read_write>`. The distinct bindings let the client API alias them.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

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

// GLSL: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_int_t_{{[0-9]+}}
// GLSL: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_int_t_{{[0-9]+}}

// MTL-DAG: int device{{.*}} bufA_{{[0-9]+}};
// MTL-DAG: int device{{.*}} bufB_{{[0-9]+}};

// WGSL-DAG: var<storage, read_write> bufA_{{[0-9]+}} : array<i32>
// WGSL-DAG: var<storage, read_write> bufB_{{[0-9]+}} : array<i32>
