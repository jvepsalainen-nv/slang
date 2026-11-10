//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=A RWTexture3D<float4> with no resolved Image Format (Unknown) requires both StorageImageReadWithoutFormat and StorageImageWriteWithoutFormat capabilities.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: resolveTextureFormat leaves the format as Unknown
// for a RWTexture<floatN> when no explicit [[vk::image_format(...)]]
// is given. SPIR-V then requires the two "without format"
// capabilities for reads and writes against the storage image.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWTexture3D<float4> img;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    img[uint3(0, 0, 0)] = float4(1, 0, 0, 1);
    outBuf[tid.x] = img[uint3(0, 0, 0)];
}

// CHECK-DAG: OpCapability StorageImageReadWithoutFormat
// CHECK-DAG: OpCapability StorageImageWriteWithoutFormat
