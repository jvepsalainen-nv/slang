//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizebyteaddressbufferops-with-wgsl-options
//META: purpose=ByteAddressBuffer.Load<uint>(0) at offset zero still emits the array<u32>[...]/4 indexing expression
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower edge of the byte-address-buffer offset axis: even with an
// explicit zero offset the pass keeps the divide-by-4 indexing
// shape instead of constant-folding it away.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

ByteAddressBuffer ba;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = ba.Load<uint>(0);
}

// CHECK: var<storage, read>
// CHECK-SAME: array<u32>
// CHECK: ba_{{[0-9]+}}[
// CHECK-SAME: /4
