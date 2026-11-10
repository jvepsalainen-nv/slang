//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=InterlockedAdd on a uint UAV lowers to OpAtomicIAdd; validateAtomicOperations inside legalizeIRForSPIRV accepts the operation.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Slang's InterlockedAdd lowers to the SPIR-V OpAtomicIAdd
// opcode. legalizeIRForSPIRV invokes validateAtomicOperations to
// confirm the operation is valid on a StorageBuffer-class pointer.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedAdd(outBuf[0], 1u);
}

// CHECK: OpAtomicIAdd
