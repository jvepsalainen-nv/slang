//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#buffer-types
//META: doc_section_digest=c25174867f65b28674f6e50925bd9f916f322862f95fe848ae8bb96cd35ce36b
//META: purpose=An HLSLByteAddressBufferType uniform reaches the HLSL backend as `ByteAddressBuffer` and `RWByteAddressBuffer`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the byte-address-buffer emission claim out to the four non-HLSL
// shader text targets. ByteAddressBuffer / RWByteAddressBuffer are
// UntypedBufferResourceType leaves; unlike HLSL (which keeps the
// surface spelling), every other target lowers them to a runtime array
// of `uint` and converts byte offsets to word indices. The CHECKs pin
// the per-target lowered form observed from slangc: GLSL emits a
// `readonly buffer` / `buffer` SSBO pair, Metal a `uint32_t device*`
// with `>>2` word addressing, SPIR-V a `NonWritable`-decorated
// StorageBuffer struct, and WGSL `var<storage,read>` /
// `var<storage,read_write>` with `/4` word addressing.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

ByteAddressBuffer g_in;
RWByteAddressBuffer g_out;

//GLSL-DAG: readonly buffer
//GLSL-DAG: }{{ ?}}g_in
//GLSL-DAG: }{{ ?}}g_out
//METAL-DAG: uint32_t device* g_in
//METAL-DAG: uint32_t device* g_out
//SPV-DAG: OpDecorate %g_in NonWritable
//SPV-DAG: %g_in = OpVariable %_ptr_StorageBuffer_StructuredBuffer StorageBuffer
//WGSL-DAG: var<storage, read> g_in
//WGSL-DAG: var<storage, read_write> g_out
[numthreads(1, 1, 1)]
void main()
{
    uint v = g_in.Load(0);
    g_out.Store(0, v);
}
