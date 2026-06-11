//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=The address space is determined by type, modifiers, and attributes simultaneously; a single shader mixing multiple address spaces emits each variable into its distinct SPIRV storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of the sibling spirv-asm/metal/wgsl test
// address-space-by-type-spirv.slang. Verifies that type/modifier/attribute jointly determine
// address space so a single shader holds three distinct address spaces at once. CHECK-DAG asserts
// each variable lands in its target-specific storage qualifier: GLSL uniform-block / shader-storage
// buffer / shared, and HLSL cbuffer / RWStructuredBuffer / groupshared.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

// Uniform address space (ConstantBuffer<T>).
ConstantBuffer<float> cbParam;

// Storage buffer address space (RWStructuredBuffer<T>).
RWStructuredBuffer<float> rwbuf;

// Group-shared address space (static groupshared).
static groupshared float lds[4];

[numthreads(4, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    lds[tid.x] = cbParam + float(tid.x);
    GroupMemoryBarrierWithGroupSync();
    rwbuf[tid.x] = lds[3u - tid.x];
}

// GLSL emits each address space with its own storage qualifier (order-independent).
// GLSL-DAG: uniform block_
// GLSL-DAG: buffer StructuredBuffer
// GLSL-DAG: shared float {{.*}}lds_
// HLSL emits each address space with its own storage class (order-independent).
// HLSL-DAG: cbuffer cbParam_
// HLSL-DAG: RWStructuredBuffer<float{{.*}}> rwbuf_
// HLSL-DAG: groupshared float {{.*}}lds_
