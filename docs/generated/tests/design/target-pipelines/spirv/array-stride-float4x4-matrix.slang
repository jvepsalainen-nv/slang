//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=A float4x4 element StructuredBuffer carries ArrayStride 64 on the %mat4v4float runtime array — the matrix element is four 16-byte columns.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the matrix-element branch of the stride rule. A float4x4 is
// four 16-byte columns = 64 bytes, so the %mat4v4float runtime array
// gets ArrayStride 64. The CHECK pins the matrix stride.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float4x4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK: OpDecorate %_runtimearr_mat4v4float ArrayStride 64
