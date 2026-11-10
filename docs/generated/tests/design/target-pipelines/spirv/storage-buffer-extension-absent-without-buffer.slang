//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=Negative: `SPV_KHR_storage_buffer_storage_class` is requested on demand by the type that needs it, so a shader with no storage-buffer pointer declares no such extension while still emitting the unconditional front matter.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the storage-buffer extension is not part of the front matter
// every SPIR-V compile emits, but a consequence of declaring a StorageBuffer
// pointer. The shader uses only a storage image, so no such pointer type is
// ever created. The leading CHECK-NOT covers the whole prologue up to the
// memory model -- extensions are emitted before OpMemoryModel in the
// physical layout -- while the two positive CHECKs assert the two
// instructions that genuinely are unconditional.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWTexture2D<float4> outTex;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outTex[tid.xy] = float4(1, 0, 0, 1);
}

// CHECK-NOT: SPV_KHR_storage_buffer_storage_class
// CHECK: OpCapability Shader
// CHECK: OpMemoryModel Logical GLSL450
