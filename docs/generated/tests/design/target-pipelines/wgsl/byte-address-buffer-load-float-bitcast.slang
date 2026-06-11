//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizebyteaddressbufferops-with-wgsl-options
//META: doc_section_digest=678e8461e323191268a43189d73cdc9e17745b10b7056df81464b4ecab6262c7
//META: purpose=ByteAddressBuffer.Load<float> inserts a bitcast<f32> after the array<u32> load because useBitCastFromUInt is set for WGSL
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The float element-type branch of the byte-address Load family. The
// WGSL legalize options set useBitCastFromUInt=true, so a non-u32
// element type is read as u32 from the array<u32> and reinterpreted.
// CHECK pins bitcast<f32>, the token that distinguishes the float cell
// from the uint cell (which loads directly with no bitcast).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

ByteAddressBuffer buf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = buf.Load<float>(tid.x * 4);
}

// CHECK: bitcast<f32>(
