//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=RWTexture2DArray lowers to OpTypeImage with dim 2D, Arrayed=1, and storage-image sampled-bit 2; writes/reads go through OpImageWrite / OpImageRead.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: arrayed + storage corner — combines Arrayed=1 with
// sampled=2 on a 2D image. Index is uint3 (xy + layer).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWTexture2DArray<float4> img;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    img[uint3(0, 0, 0)] = float4(1, 0, 0, 1);
    outBuf[tid.x] = img[uint3(0, 0, 0)];
}

// CHECK-DAG: OpTypeImage %float 2D 2 1 0 2
// CHECK-DAG: OpImageWrite
// CHECK-DAG: OpImageRead
