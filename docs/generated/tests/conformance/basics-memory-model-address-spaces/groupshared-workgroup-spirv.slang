//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`static groupshared` at global scope belongs to the Group-shared address space; SPIRV emits it with `Workgroup` storage class.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `static groupshared` at global scope maps to the Workgroup storage class in
// SPIRV. The kernel reverses values through `sharedData`; CHECK asserts the SPIRV assembly
// declares the array as `OpVariable ... Workgroup`, confirming the thread-group address space.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
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

// CHECK: %sharedData = OpVariable {{.*}} Workgroup
// Metal maps Workgroup storage class to threadgroup address space.
// METAL: threadgroup {{.*}} sharedData{{.*}}
// WGSL maps Workgroup to var<workgroup>.
// WGSL: var<workgroup> sharedData{{.*}}
// GLSL emits the same Workgroup-class array with the `shared` storage qualifier.
// GLSL: shared float{{.*}} sharedData_
// HLSL emits it with the `groupshared` qualifier.
// HLSL: static groupshared float{{.*}} sharedData_
