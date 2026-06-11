//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: doc_section_digest=0cb77e4bc46ab9a7f3eefef7b0e375bb9755811b790ee7577f7b13bbf467bf6b
//META: purpose=`ConstantBuffer<T>` and `RWStructuredBuffer<T>` emit as independently-decorated SPIRV variables (distinct Binding decorations, Uniform vs StorageBuffer storage classes); they are never merged even when the client API could bind them to overlapping memory.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the SPIR-V resource-aliasing claim
// (memory-aliasing-resources-spirv-emission.slang) to the remaining shader targets.
// HLSL emits a `cbuffer` block and a distinct RWStructuredBuffer UAV; GLSL a uniform
// block and a std430 buffer; Metal a `constant*` and a `device*`; WGSL a `var<uniform>`
// and a `var<storage, read_write>`. No backend merges the two resources.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

ConstantBuffer<int> cbuf;
RWStructuredBuffer<int> rwbuf;

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int val = cbuf;
    rwbuf[0] = val;
}

// HLSL-DAG: cbuffer cbuf_{{[0-9]+}}
// HLSL-DAG: RWStructuredBuffer<int > rwbuf_{{[0-9]+}}

// GLSL-DAG: uniform block_{{.*}}
// GLSL-DAG: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_int_t_{{[0-9]+}}

// MTL-DAG: int constant{{.*}} cbuf_{{[0-9]+}};
// MTL-DAG: int device{{.*}} rwbuf_{{[0-9]+}};

// WGSL-DAG: var<uniform> cbuf_{{[0-9]+}} : i32
// WGSL-DAG: var<storage, read_write> rwbuf_{{[0-9]+}} : array<i32>
