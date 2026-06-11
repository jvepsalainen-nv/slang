//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#memory-aliasing-via-binding
//META: doc_section_digest=0cb77e4bc46ab9a7f3eefef7b0e375bb9755811b790ee7577f7b13bbf467bf6b
//META: purpose=`ConstantBuffer<T>` and `RWStructuredBuffer<T>` are independently bound resources that compile to distinct HLSL register declarations; the doc names them as resource types whose underlying memory may be aliased when bound to overlapping slots by the client API.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the HLSL resource-aliasing claim
// (memory-aliasing-resources-hlsl-emission.slang) to the remaining shader targets.
// GLSL emits a uniform block plus a std430 storage buffer; Metal emits a `constant*`
// and a `device*`; WGSL emits a `var<uniform>` and a `var<storage, read_write>`;
// SPIR-V decorates each with its own Binding. None of the backends merges the two.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
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

// GLSL-DAG: uniform block_{{.*}}
// GLSL-DAG: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_int_t_{{[0-9]+}}

// SPV-DAG: OpDecorate %cbuf{{.*}} Binding
// SPV-DAG: OpDecorate %rwbuf{{.*}} Binding

// MTL-DAG: int constant{{.*}} cbuf_{{[0-9]+}};
// MTL-DAG: int device{{.*}} rwbuf_{{[0-9]+}};

// WGSL-DAG: var<uniform> cbuf_{{[0-9]+}} : i32
// WGSL-DAG: var<storage, read_write> rwbuf_{{[0-9]+}} : array<i32>
