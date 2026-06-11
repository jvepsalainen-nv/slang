//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=`static groupshared` at global scope belongs to the Group-shared address space; GLSL emits it with the `shared` storage qualifier.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (HLSL, SPIRV) of groupshared-workgroup-glsl.slang. The `int sharedCounter`
// group-shared array that GLSL emits with `shared` also lands in HLSL `groupshared` and SPIRV
// `Workgroup`; CHECK pins the group-shared storage on each.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

static groupshared int sharedCounter[16];

[numthreads(16, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<int> output)
{
    sharedCounter[tid.x] = int(tid.x) * 2;
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedCounter[15u - tid.x];
}

// HLSL retains the `groupshared` qualifier.
// HLSL: groupshared int {{.*}}sharedCounter
// SPIRV emits the array as an OpVariable in the Workgroup storage class.
// SPV: %sharedCounter = OpVariable {{.*}} Workgroup
