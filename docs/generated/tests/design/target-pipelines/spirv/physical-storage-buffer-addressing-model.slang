//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=The addressing model in the emitted `OpMemoryModel` is `Logical` unless `requirePhysicalStorageAddressing` moved it, which a buffer-pointer parameter does.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one documented escape from the default addressing model. The
// front matter emits OpMemoryModel with whatever addressing model the module
// ended up in, so a shader that dereferences a uniform pointer -- which needs
// real device addresses -- must shift the whole module to the 64-bit physical
// storage-buffer model. The CHECKs pin that model plus the capability that
// accompanies it, in contrast to the Logical model the sibling tests assert.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

struct Data { float4 v; };
uniform Data* dataPtr;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = dataPtr[tid.x].v;
}

// CHECK-DAG: OpCapability PhysicalStorageBufferAddresses
// CHECK-DAG: OpExtension "SPV_KHR_physical_storage_buffer"
// CHECK: OpMemoryModel PhysicalStorageBuffer64 GLSL450
