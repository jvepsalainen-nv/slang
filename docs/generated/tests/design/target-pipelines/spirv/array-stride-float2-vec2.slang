//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=A float2 element StructuredBuffer carries ArrayStride 8 on the %v2float runtime array (two 4-byte floats, no padding).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the vector-element branch of the stride rule. A float2
// element is two contiguous 4-byte floats, so the %v2float runtime
// array gets ArrayStride 8 (no vec2 padding). The CHECK pins the
// stride-8 vec2 branch.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float2> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK: OpDecorate %_runtimearr_v2float ArrayStride 8
