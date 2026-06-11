//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#buffer-types
//META: doc_section_digest=c25174867f65b28674f6e50925bd9f916f322862f95fe848ae8bb96cd35ce36b
//META: purpose=An HLSLStructuredBufferType (read-only) is distinct from its RW variant; the HLSL emit renders it as `StructuredBuffer<T>`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the read-only-StructuredBuffer emission claim out to the four
// non-HLSL shader text targets. The claim is that the read-only buffer
// is *distinct* from RWStructuredBuffer; that distinction surfaces
// differently per target. GLSL marks the read-only SSBO `readonly`,
// SPIR-V decorates its variable `NonWritable`, and WGSL gives it
// `var<storage, read>` vs the RW buffer's `var<storage, read_write>`.
// Metal lowers both to plain `int device*` pointers (no const-ness in
// the pointer type), so on Metal the read-only/RW distinction is not
// observable in the pointer declaration; the CHECK there pins only the
// element type and read-side access. Each CHECK is copied verbatim.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

StructuredBuffer<int> g_in;
RWStructuredBuffer<int> g_out;

//GLSL: readonly buffer StructuredBuffer_int_t
//METAL-DAG: int device* g_in
//METAL-DAG: int device* g_out
//SPV: OpDecorate %g_in NonWritable
//WGSL-DAG: var<storage, read> g_in
//WGSL-DAG: var<storage, read_write> g_out
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    g_out[tid.x] = g_in[tid.x] + 1;
}
