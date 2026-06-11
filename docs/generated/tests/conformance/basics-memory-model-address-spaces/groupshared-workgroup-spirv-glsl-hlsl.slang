//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`static groupshared` at global scope belongs to the Group-shared address space; SPIRV emits it with `Workgroup` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of groupshared-workgroup-spirv.slang. The same shader that maps
// `static groupshared` to SPIRV `Workgroup` also maps it to GLSL `shared` and HLSL
// `groupshared`; CHECK pins each target's group-shared storage qualifier on the array.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

static groupshared float sharedData[32];

[numthreads(32, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    sharedData[tid.x] = float(tid.x);
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedData[31u - tid.x];
}

// GLSL emits group-shared memory with the `shared` storage qualifier.
// GLSL: shared float {{.*}}sharedData
// HLSL retains the `groupshared` qualifier.
// HLSL: groupshared float {{.*}}sharedData
