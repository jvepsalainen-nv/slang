//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#buffer-types
//META: doc_section_digest=c25174867f65b28674f6e50925bd9f916f322862f95fe848ae8bb96cd35ce36b
//META: purpose=An HLSLRWStructuredBufferType uniform reaches every text-emit backend; HLSL renders it as `RWStructuredBuffer`, GLSL as a `buffer` block, and CUDA emits a global of the buffer name.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Completes the RWStructuredBuffer<T> emission fan-out: the sibling
// rwstructuredbuffertype-multi-target.slang covers HLSL/GLSL/CUDA, and
// this file adds the remaining three shader text targets. The emitted
// shape differs per target: Metal lowers the buffer to an
// `int device*` kernel parameter, SPIR-V to an `OpVariable ...
// StorageBuffer` (a `Block`-decorated runtime-array struct), and WGSL
// to `var<storage, read_write> ... : array<i32>`. Each CHECK pins the
// per-target form copied verbatim from slangc.

//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> g_buf;

//METAL: int device* g_buf
//SPV: %g_buf = OpVariable %_ptr_StorageBuffer_RWStructuredBuffer StorageBuffer
//WGSL: var<storage, read_write> g_buf_0 : array<i32>
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    g_buf[tid.x] = int(tid.x);
}
