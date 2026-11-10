//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`static groupshared` belongs to the Group-shared address space; CUDA emits it as `__device__ __shared__`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `static groupshared` at global scope maps to the Group-shared address space
// on CUDA. The compute kernel writes to `sharedArr` and reads back in reverse; CHECK asserts
// the emitted CUDA text carries the `__shared__` qualifier, confirming the thread-group scope.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

static groupshared float sharedArr[8];

[numthreads(8, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    sharedArr[tid.x] = float(tid.x) * 3.0;
    GroupMemoryBarrierWithGroupSync();
    output[tid.x] = sharedArr[7u - tid.x];
}

// CUDA group-shared maps to __shared__ device memory.
// CHECK: __shared__
// CHECK-DAG: sharedArr{{.*}}
// Metal maps groupshared to threadgroup address space.
// METAL: threadgroup {{.*}} sharedArr{{.*}}
// WGSL maps groupshared to var<workgroup>.
// WGSL: var<workgroup> sharedArr{{.*}}
// GLSL maps the same Group-shared array to the `shared` storage qualifier.
// GLSL: shared float{{.*}} sharedArr_
// HLSL maps it back to `groupshared`.
// HLSL: static groupshared float{{.*}} sharedArr_
// SPIRV maps it to the Workgroup storage class.
// SPIRV: %sharedArr = OpVariable {{.*}} Workgroup
