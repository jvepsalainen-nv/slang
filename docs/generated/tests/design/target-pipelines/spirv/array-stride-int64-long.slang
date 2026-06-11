//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=An int64_t element StructuredBuffer carries ArrayStride 8 on the %long runtime array and pulls in the Int64 capability.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the 8-byte width branch of the ArrayStride rule. An int64_t
// element yields ArrayStride 8 on the %long runtime array, gated by
// the Int64 capability. The CHECKs pin the stride-8 branch.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int64_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK-DAG: OpCapability Int64
// CHECK-DAG: OpDecorate %_runtimearr_long ArrayStride 8
