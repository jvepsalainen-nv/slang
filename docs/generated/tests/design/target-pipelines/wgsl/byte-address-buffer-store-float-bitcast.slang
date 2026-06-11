//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizebyteaddressbufferops-with-wgsl-options
//META: doc_section_digest=678e8461e323191268a43189d73cdc9e17745b10b7056df81464b4ecab6262c7
//META: purpose=RWByteAddressBuffer.Store<float> reinterprets the value with bitcast<u32> before writing into array<u32>
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The float store branch of the byte-address Store family. A non-u32
// value must be reinterpreted as u32 before storing into the
// array<u32> backing store (useBitCastFromUInt). The value is read
// from a uniform to defeat the constant folder so the bitcast<u32>
// token survives; CHECK pins it as the float-cell distinguisher.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWByteAddressBuffer buf;
uniform float v;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf.Store<float>(tid.x * 4, v);
}

// CHECK: bitcast<u32>(
