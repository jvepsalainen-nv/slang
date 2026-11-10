//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A RWStructuredBuffer element access outBuf[idx] lowers to OpAccessChain that indexes through the runtime array inside the wrapping struct.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V buffer-element indexing uses logical addressing.
// outBuf[idx] becomes OpAccessChain into the StorageBuffer
// pointer, with the first index selecting the runtime-array
// member (struct field 0) and the second index selecting the
// element at idx.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x + 3] = 5;
}

// CHECK: OpAccessChain %_ptr_StorageBuffer_int %outBuf
