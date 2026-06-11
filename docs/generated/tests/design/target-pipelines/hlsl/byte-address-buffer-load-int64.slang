//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizebyteaddressbufferops-for-hlsl
//META: doc_section_digest=164828634e9baa99ca092b48a08857187612e7093b4737e812351988e3e9c2b7
//META: purpose=Per-element-type byte-address Load: ByteAddressBuffer.Load<int64_t> keeps the templated Load<int64_t> form, exercising the 64-bit width branch of the byte-address legalizer.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-element-type depth on legalizeByteAddressBufferOps. The
// default HLSL options leave useBitCastFromUInt=false, so a 64-bit
// element type survives as a single templated Load<int64_t> rather
// than being scalarized into 32-bit reads. CHECK pins the
// Load<int64_t form, the token distinguishing this width cell.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

ByteAddressBuffer inBuf;
RWStructuredBuffer<int64_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf.Load<int64_t>(tid.x * 8);
}

// CHECK: Load<int64_t
