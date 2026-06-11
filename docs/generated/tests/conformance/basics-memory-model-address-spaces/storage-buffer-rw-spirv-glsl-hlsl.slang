//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`RWStructuredBuffer<T>` and `StructuredBuffer<T>` belong to the Storage buffer address space; SPIRV emits both with `StorageBuffer` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of storage-buffer-rw-spirv.slang. Both structured-buffer forms
// that SPIRV places in `StorageBuffer` map to GLSL shader-storage `buffer` blocks and HLSL
// StructuredBuffer / RWStructuredBuffer declarations; CHECK pins each target's storage-buffer form
// for both read-only and read-write variants.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<float> rwbuf;
StructuredBuffer<float>   robuf;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    float v = robuf[0];
    rwbuf[0] = v + 1.0;
    output[0] = rwbuf[0];
}

// GLSL emits both as shader-storage buffer blocks; the read-only one is `readonly`.
// GLSL-DAG: readonly buffer
// GLSL-DAG: buffer StructuredBuffer
// HLSL emits the read-only and read-write structured buffers as their respective types.
// HLSL-DAG: StructuredBuffer<float{{.*}}> robuf
// HLSL-DAG: RWStructuredBuffer<float{{.*}}> rwbuf
