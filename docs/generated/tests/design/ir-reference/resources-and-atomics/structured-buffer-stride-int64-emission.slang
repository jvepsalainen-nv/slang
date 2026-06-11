//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: doc_section_digest=a5cc503aaed86633e5970cfcf6ca63262c9a68fc95f6b94e9a9eaf7fe399c9fd
//META: purpose=A `StructuredBuffer<int64_t>` element backing array is decorated `ArrayStride 8` in SPIR-V (64-bit scalar natural stride).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the 64-bit-scalar element-stride cell of the buffer family
// (`ArrayStride 8`). Same shape as the int32 companion but with an
// `int64_t` element; the only thing that changes is the stride decoration,
// which is the distinguishing token pinned here.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

StructuredBuffer<int64_t> sbuf;
uniform RWStructuredBuffer<int64_t> obuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    obuf[tid.x] = sbuf[tid.x];
}

// SPV-DAG: OpDecorate %_runtimearr_long ArrayStride 8
