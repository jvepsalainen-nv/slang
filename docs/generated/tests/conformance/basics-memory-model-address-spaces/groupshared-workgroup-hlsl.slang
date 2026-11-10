//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`static groupshared` at global scope belongs to the Group-shared address space; HLSL emits it with `groupshared` storage qualifier.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `static groupshared` at global scope maps to the Group-shared address space
// on HLSL. CHECK asserts the emitted HLSL retains the `groupshared` qualifier on the variable
// declaration, confirming all threads in the group share the same storage instance.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

static groupshared float sharedData[32];

[numthreads(32, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    sharedData[tid.x] = float(tid.x);
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedData[31u - tid.x];
}

// CHECK: groupshared {{.*}} sharedData{{.*}}
// Metal emits groupshared as threadgroup address space.
// METAL: threadgroup {{.*}} sharedData{{.*}}
// WGSL emits groupshared as var<workgroup>.
// WGSL: var<workgroup> sharedData{{.*}}
// GLSL emits the same Group-shared array with the `shared` storage qualifier.
// GLSL: shared float{{.*}} sharedData_
// SPIRV emits it with the Workgroup storage class.
// SPIRV: %sharedData = OpVariable {{.*}} Workgroup
