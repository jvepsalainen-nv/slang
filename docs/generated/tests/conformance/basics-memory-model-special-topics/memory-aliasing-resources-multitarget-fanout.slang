//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: doc_section_digest=0cb77e4bc46ab9a7f3eefef7b0e375bb9755811b790ee7577f7b13bbf467bf6b
//META: purpose=`ConstantBuffer<T>` and `RWStructuredBuffer<T>` emit as distinct, independently-bound resource declarations on GLSL, Metal, CUDA, C++, and WGSL; neither backend merges them.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the multi-target resource-aliasing claim
// (memory-aliasing-resources-glsl-emission.slang) to HLSL and SPIR-V. HLSL emits the
// constant buffer as a `cbuffer` block and the structured buffer as a distinct
// RWStructuredBuffer UAV declaration; SPIR-V decorates each with its own Binding and
// places them in separate storage classes, so neither is merged.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

ConstantBuffer<int> cbuf;
RWStructuredBuffer<int> rwbuf;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int val = cbuf;
    rwbuf[0] = val;
}

// HLSL: cbuffer cbuf_{{[0-9]+}}
// HLSL: RWStructuredBuffer<int > rwbuf_{{[0-9]+}}

// SPV-DAG: OpDecorate %cbuf{{.*}} Binding
// SPV-DAG: OpDecorate %rwbuf{{.*}} Binding
// SPV-DAG: OpVariable %_ptr_StorageBuffer_{{.*}} StorageBuffer
