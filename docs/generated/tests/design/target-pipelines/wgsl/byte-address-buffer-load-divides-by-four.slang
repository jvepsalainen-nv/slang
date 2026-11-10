//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizebyteaddressbufferops-with-wgsl-options
//META: purpose=legalizeByteAddressBufferOps with WGSL options lowers a ByteAddressBuffer.Load<uint> to an array<u32>[offset/4] indexing expression
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL has no native byte-address buffer; the pass lowers
// ByteAddressBuffer to array<u32> and divides the offset by 4.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

ByteAddressBuffer ba;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = ba.Load<uint>(16);
}

// CHECK: var<storage, read>
// CHECK-SAME: array<u32>
// CHECK: ba_{{[0-9]+}}[
// CHECK-SAME: /4
