//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizebyteaddressbufferops-with-wgsl-options
//META: doc_section_digest=678e8461e323191268a43189d73cdc9e17745b10b7056df81464b4ecab6262c7
//META: purpose=RWByteAddressBuffer.Store<uint> writes directly into array<u32>[offset/4] with no bitcast
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The u32 store branch of the byte-address Store family. A uint
// element matches the underlying array<u32> element, so no bitcast is
// needed; the offset is divided by 4. CHECK pins the `[(...)/4]`
// index shape with a u32 store value, the representative no-bitcast
// cell that contrasts with the float store below.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWByteAddressBuffer buf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf.Store<uint>(tid.x * 4, 7u);
}

// CHECK: buf_{{[0-9]+}}[{{.*}}/4] = u32(7)
