//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=Two resources receive sequential Binding 0 and Binding 1 decorations on the default DescriptorSet.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Slang's layout phase assigns sequential binding indices to
// resources declared at module scope. The first resource gets
// Binding 0, the second Binding 1, all under DescriptorSet 0.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

StructuredBuffer<int> inBuf;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf[tid.x];
}

// CHECK-DAG: OpDecorate %inBuf Binding 0
// CHECK-DAG: OpDecorate %outBuf Binding 1
// CHECK-DAG: OpDecorate %inBuf DescriptorSet 0
// CHECK-DAG: OpDecorate %outBuf DescriptorSet 0
