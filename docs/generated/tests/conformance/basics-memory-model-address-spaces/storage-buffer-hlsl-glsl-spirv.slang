//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`StructuredBuffer<T>` (read-only) belongs to Storage buffer address space; HLSL emits it bound to a `t` register (SRV), while `RWStructuredBuffer<T>` binds to a `u` register (UAV).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, SPIRV) of storage-buffer-hlsl.slang. The read-only/read-write
// distinction HLSL shows via t-vs-u registers also appears on GLSL (a `readonly buffer` vs a
// plain shader-storage `buffer`) and SPIRV (both `StorageBuffer`, the read-only one carrying a
// `NonWritable` decoration); CHECK pins each target's read-only-vs-read-write marker.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

StructuredBuffer<float>   robuf;
RWStructuredBuffer<float> rwbuf;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    float v = robuf[0];
    rwbuf[0] = v + 1.0;
    output[0] = rwbuf[0];
}

// GLSL marks the read-only structured buffer with the `readonly` shader-storage qualifier.
// GLSL: readonly buffer
// SPIRV places both in StorageBuffer; the read-only one carries a NonWritable decoration.
// SPV-DAG: %robuf = OpVariable {{.*}} StorageBuffer
// SPV-DAG: OpDecorate %robuf NonWritable
