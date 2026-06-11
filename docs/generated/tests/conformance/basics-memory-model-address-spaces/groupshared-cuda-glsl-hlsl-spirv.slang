//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`static groupshared` belongs to the Group-shared address space; CUDA emits it as `__device__ __shared__`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL, SPIRV) of groupshared-cuda.slang. The `sharedArr` array that
// CUDA emits as `__shared__` also maps to GLSL `shared`, HLSL `groupshared`, and SPIRV
// `Workgroup`; CHECK pins each target's group-shared storage on the array.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

static groupshared float sharedArr[8];

[numthreads(8, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    sharedArr[tid.x] = float(tid.x) * 3.0;
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedArr[7u - tid.x];
}

// GLSL emits group-shared memory with the `shared` storage qualifier.
// GLSL: shared float {{.*}}sharedArr
// HLSL retains the `groupshared` qualifier.
// HLSL: groupshared float {{.*}}sharedArr
// SPIRV emits the array as an OpVariable in the Workgroup storage class.
// SPV: %sharedArr = OpVariable {{.*}} Workgroup
