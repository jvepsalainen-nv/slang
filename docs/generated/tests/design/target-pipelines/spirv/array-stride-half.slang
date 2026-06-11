//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=A half (float16) element StructuredBuffer carries ArrayStride 2 on the %half runtime array and pulls in the Float16 capability.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the half (16-bit float) element of the stride rule. It
// yields ArrayStride 2 on the %half runtime array and requires the
// Float16 capability — the floating-point counterpart of the int16
// 2-byte width branch. The CHECKs pin the stride and capability.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<half> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK-DAG: OpCapability Float16
// CHECK-DAG: OpDecorate %_runtimearr_half ArrayStride 2
