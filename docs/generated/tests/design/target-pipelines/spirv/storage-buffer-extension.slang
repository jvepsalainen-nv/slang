//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A StructuredBuffer triggers the SPV_KHR_storage_buffer_storage_class OpExtension declaration.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The SPIR-V StorageBuffer storage class lives in an extension;
// Slang emits OpExtension "SPV_KHR_storage_buffer_storage_class"
// whenever a StructuredBuffer / RWStructuredBuffer is used.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x * 2u;
}

// CHECK: OpExtension "SPV_KHR_storage_buffer_storage_class"
