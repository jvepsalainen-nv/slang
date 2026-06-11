//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=An int16_t element StructuredBuffer carries ArrayStride 2 on the %short runtime array and pulls in the Int16 / 16BitStorage capabilities.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the 2-byte width branch of the ArrayStride rule. An int16_t
// element yields ArrayStride 2 on the %short runtime array, gated by
// the 16-bit storage capability. The CHECKs pin the stride-2 branch
// and its capability.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int16_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK-DAG: OpCapability UniformAndStorageBuffer16BitAccess
// CHECK-DAG: OpDecorate %_runtimearr_short ArrayStride 2
