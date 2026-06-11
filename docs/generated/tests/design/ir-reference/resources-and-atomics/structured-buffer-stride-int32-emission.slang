//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: doc_section_digest=a5cc503aaed86633e5970cfcf6ca63262c9a68fc95f6b94e9a9eaf7fe399c9fd
//META: purpose=A `StructuredBuffer<int>` element backing array is decorated `ArrayStride 4` in SPIR-V (32-bit scalar natural stride).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-element-type stride branch the buffer family implies
// (`getNaturalStride` returns the element's natural stride). The doc names
// the structured-buffer load opcodes generically and never enumerates the
// stride each element type produces; this test pins the 32-bit-scalar cell
// (`ArrayStride 4`). Companions cover int64 (8), uint16 (2), float4 (16),
// and a 3-float struct (12).

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<int> obuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    obuf[tid.x] = sbuf[tid.x];
}

// SPV-DAG: OpDecorate %_runtimearr_int ArrayStride 4
