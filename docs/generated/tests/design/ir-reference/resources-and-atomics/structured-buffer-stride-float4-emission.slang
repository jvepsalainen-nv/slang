//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: doc_section_digest=a5cc503aaed86633e5970cfcf6ca63262c9a68fc95f6b94e9a9eaf7fe399c9fd
//META: purpose=A `StructuredBuffer<float4>` element backing array is decorated `ArrayStride 16` in SPIR-V (4x32-bit vector natural stride).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the vector-element stride cell of the buffer family
// (`ArrayStride 16` for `float4`). Distinct from the scalar cells because
// the natural stride of a 4-component 32-bit vector is 16 bytes; this is
// the token pinned.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

StructuredBuffer<float4> sbuf;
uniform RWStructuredBuffer<float4> obuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    obuf[tid.x] = sbuf[tid.x];
}

// SPV-DAG: OpDecorate %_runtimearr_v4float ArrayStride 16
