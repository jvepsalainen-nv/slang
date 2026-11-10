//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`static groupshared` at global scope belongs to the Group-shared address space; GLSL emits it with the `shared` storage qualifier.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `static groupshared` at global scope maps to the Group-shared address space
// on GLSL. CHECK asserts the emitted GLSL uses the `shared` storage qualifier on the array,
// confirming the thread-group-visible memory mapping.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

static groupshared int sharedCounter[16];

[numthreads(16, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<int> output)
{
    sharedCounter[tid.x] = int(tid.x) * 2;
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedCounter[15u - tid.x];
}

// CHECK: shared {{.*}} sharedCounter{{.*}}
// Metal maps groupshared to threadgroup address space.
// METAL: threadgroup {{.*}} sharedCounter{{.*}}
// WGSL maps groupshared to var<workgroup>.
// WGSL: var<workgroup> sharedCounter{{.*}}
// HLSL emits the same Group-shared array with the `groupshared` qualifier.
// HLSL: static groupshared int{{.*}} sharedCounter_
// SPIRV emits it with the Workgroup storage class.
// SPIRV: %sharedCounter = OpVariable {{.*}} Workgroup
