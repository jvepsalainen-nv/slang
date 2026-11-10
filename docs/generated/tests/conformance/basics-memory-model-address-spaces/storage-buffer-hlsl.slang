//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`StructuredBuffer<T>` (read-only) belongs to Storage buffer address space; HLSL emits it bound to a `t` register (SRV), while `RWStructuredBuffer<T>` binds to a `u` register (UAV).
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the HLSL register-binding distinction between read-only and read-write Storage
// buffer variants. `StructuredBuffer<T>` (read-only) and `RWStructuredBuffer<T>` (read-write)
// both occupy the Storage buffer address space; CHECK asserts the emitted HLSL binds the
// read-only form to a `t` register (SRV) and the read-write form to a `u` register (UAV).

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

StructuredBuffer<float>   robuf;
RWStructuredBuffer<float> rwbuf;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    float v = robuf[0];
    rwbuf[0] = v + 1.0;
    output[0] = rwbuf[0];
}

// Read-only StructuredBuffer -> t register (shader resource view).
// CHECK: StructuredBuffer<float{{.*}}> {{.*}} : register(t
// Read-write RWStructuredBuffer -> u register (unordered access view).
// CHECK-DAG: RWStructuredBuffer<float{{.*}}> {{.*}} : register(u
// Metal maps both structured buffers to device* (device address space).
// METAL: float device* robuf_
// METAL-DAG: float device* rwbuf_
// WGSL maps read-only to var<storage, read> and read-write to var<storage, read_write>.
// WGSL: var<storage, read> robuf_
// WGSL-DAG: var<storage, read_write> rwbuf_
// GLSL emits the read-only form as a `readonly buffer` block and the read-write form as a
// plain `buffer` block; both are the std430 Storage-buffer address space.
// GLSL: readonly buffer StructuredBuffer_float
// GLSL: } robuf_
// GLSL: layout(std430, binding = {{[0-9]+}}) buffer StructuredBuffer_float
// GLSL: } rwbuf_
// SPIRV puts both in StorageBuffer, distinguishing the read-only form with NonWritable.
// SPIRV-DAG: %robuf = OpVariable {{.*}} StorageBuffer {{.*}} NonWritable
// SPIRV-DAG: %rwbuf = OpVariable {{.*}} StorageBuffer
