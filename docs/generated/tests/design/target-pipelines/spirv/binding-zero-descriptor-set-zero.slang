//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=The first declared resource defaults to Binding 0 on DescriptorSet 0 (lower edge of both indices).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: lower edge of the (binding, descriptor-set) index
// space. With no explicit binding annotation the first
// module-scope resource takes index 0 in set 0.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float(tid.x);
}

// CHECK-DAG: OpDecorate %outBuf Binding 0
// CHECK-DAG: OpDecorate %outBuf DescriptorSet 0
