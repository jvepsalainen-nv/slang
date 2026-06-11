//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizebyteaddressbufferops-for-hlsl
//META: doc_section_digest=164828634e9baa99ca092b48a08857187612e7093b4737e812351988e3e9c2b7
//META: purpose=Per-element-type byte-address Load: ByteAddressBuffer.Load<float2> scalarizes into per-component templated Load<float> calls at successive 4-byte offsets.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-element-type depth on legalizeByteAddressBufferOps. A
// vector element type does not survive as a single Load<float2>;
// the legalizer scalarizes it into per-component scalar
// Load<float> reads at offsets 0 and +4. CHECK pins the
// per-component Load<float > form plus the +4U successive offset,
// the tokens that distinguish the scalarized vector cell from the
// scalar cells.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

ByteAddressBuffer inBuf;
RWStructuredBuffer<float2> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf.Load<float2>(tid.x * 4);
}

// CHECK-DAG: Load<float
// CHECK-DAG: + 4U
