//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizebyteaddressbufferops-for-hlsl
//META: doc_section_digest=164828634e9baa99ca092b48a08857187612e7093b4737e812351988e3e9c2b7
//META: purpose=Per-element-type byte-address Store: RWByteAddressBuffer.Store<float4> scalarizes into per-component .Store(...) calls at successive 4-byte offsets.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-element-type depth on the Store side of
// legalizeByteAddressBufferOps. A vector store does not survive as
// a single Store<float4>; the legalizer scalarizes it into
// per-component .Store(offset, comp) calls at offsets 0, +4, +8,
// +12. CHECK pins the successive-offset Store form, the token
// distinguishing the scalarized vector store cell from the scalar
// store cell.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWByteAddressBuffer outBuf;
StructuredBuffer<float4> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf.Store<float4>(tid.x * 16, inBuf[tid.x]);
}

// CHECK-DAG: .Store(
// CHECK-DAG: + 12U
