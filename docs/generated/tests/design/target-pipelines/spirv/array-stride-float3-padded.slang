//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: doc_section_digest=701541a00a1b084515168e6adaa766b069355955c8c77e0f8307c0318b34f251
//META: purpose=A float3 element StructuredBuffer carries ArrayStride 16 on the %v3float runtime array — the vec3 element is padded up to a 16-byte stride.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the vec3-padding branch of the stride rule. A float3 is 12
// bytes of data but is laid out at a 16-byte stride (rounded up to
// the vec4 alignment), so the %v3float runtime array gets ArrayStride
// 16, not 12. The CHECK pins the padded stride that distinguishes
// vec3 from the unpadded vec2 (stride 8).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float3> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = outBuf[0];
}

// CHECK: OpDecorate %_runtimearr_v3float ArrayStride 16
