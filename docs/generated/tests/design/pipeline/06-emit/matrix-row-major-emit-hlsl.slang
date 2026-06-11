//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#shared-c-like-base
//META: doc_section_digest=9bd773e205e5aa520ee4875c2a6aebc4a9d9aabba8cfac9d3b66489e9488c043
//META: purpose=Boundary: an explicit `row_major float4x4` in a cbuffer changes the per-target emit marker — GLSL drops the `_ColMajor` wrapper-struct suffix; SPIR-V emits `ColMajor` member decoration (because SPIR-V matrix layouts are transposed relative to source); WGSL drops the `_ColMajor` infix.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the row_major matrix-layout claim onto HLSL — the existing
// sibling (matrix-row-major-emit-per-target.slang) pins GLSL/SPIR-V/WGSL.
// On HLSL the `row_major` qualifier produces a `_MatrixStorage_float4x4`
// wrapper struct with the `natural` suffix (the default column-major
// layout emits no such wrapper), so the wrapper-struct name is the
// distinguishing emit marker for the row-major shape on HLSL.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute

cbuffer C
{
    row_major float4x4 m;
}
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = m[0];
}

// HLSL: _MatrixStorage_float4x4natural
