//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizebyteaddressbufferops-for-hlsl
//META: doc_section_digest=164828634e9baa99ca092b48a08857187612e7093b4737e812351988e3e9c2b7
//META: purpose=Per-element-type byte-address Load: ByteAddressBuffer.Load<uint> emits as a bare untemplated .Load(...) because uint is the buffer's native word type.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-element-type depth on legalizeByteAddressBufferOps. The
// signed-int and float cells survive as templated Load<T>; the
// uint cell branches differently because uint is the native word
// of a byte-address buffer, so the legalizer lowers it to the
// bare .Load(offset) form with no template parameter. CHECK pins
// the bare `.Load(` token that distinguishes this cell.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

ByteAddressBuffer inBuf;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf.Load<uint>(tid.x * 4);
}

// CHECK: .Load(
