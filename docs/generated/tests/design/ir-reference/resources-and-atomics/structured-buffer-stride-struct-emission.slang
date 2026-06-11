//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:26:59Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: doc_section_digest=a5cc503aaed86633e5970cfcf6ca63262c9a68fc95f6b94e9a9eaf7fe399c9fd
//META: purpose=A `StructuredBuffer<S>` for a 3-`float` struct is decorated `ArrayStride 12` with member offsets 0/4/8 in SPIR-V (std430-packed aggregate stride).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the aggregate-element stride cell of the buffer family: a struct
// of three `float`s packs to `ArrayStride 12` with member `Offset` 0/4/8,
// distinct from any scalar/vector cell. The doc describes the structured
// buffer load family generically without giving aggregate layout; this pins
// the observed std430 packing for the struct element.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

struct S { float a; float b; float c; }
StructuredBuffer<S> sbuf;
uniform RWStructuredBuffer<float> obuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    obuf[tid.x] = sbuf[tid.x].a;
}

// SPV-DAG: OpMemberDecorate %S_std430 0 Offset 0
// SPV-DAG: OpMemberDecorate %S_std430 1 Offset 4
// SPV-DAG: OpMemberDecorate %S_std430 2 Offset 8
// SPV-DAG: OpDecorate %_runtimearr_S_std430 ArrayStride 12
