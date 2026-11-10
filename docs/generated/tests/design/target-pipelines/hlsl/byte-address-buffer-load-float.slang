//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizebyteaddressbufferops-for-hlsl
//META: purpose=Boundary: ByteAddressBuffer.Load<float>(offset) keeps the float template parameter on HLSL emit.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: float template parameter on a byte-address-
// buffer Load. The HLSL options leave `useBitCastFromUInt=false`
// for modern profiles, so the template survives as `Load<float>`.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

ByteAddressBuffer inBuf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf.Load<float>(tid.x * 4);
}

// CHECK: Load<float{{.*}}>(
