//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=RWStructuredBuffer<T> lowers to a Block-decorated struct in StorageBuffer storage class with Binding 0 / DescriptorSet 0 decorations.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V structured-buffer lowering wraps the element type in a
// struct decorated with Block, places the struct in the
// StorageBuffer storage class, and assigns default Binding 0 /
// DescriptorSet 0 decorations to the variable.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) - 1;
}

// CHECK-DAG: OpDecorate %RWStructuredBuffer Block
// CHECK-DAG: OpMemberDecorate %RWStructuredBuffer 0 Offset 0
// CHECK-DAG: OpDecorate %outBuf Binding 0
// CHECK-DAG: OpDecorate %outBuf DescriptorSet 0
// CHECK: %outBuf = OpVariable %{{[a-zA-Z_0-9]+}} StorageBuffer
