//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=An RWTexture2D subscript at the (0,0) origin still lowers to OpImageWrite / OpImageRead - the legalization is shape-driven, not value-driven.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: lower edge of the 2D image coordinate space. The
// legalizeImageSubscript pass converts img[uint2(0,0)] = v into
// OpImageWrite at the origin; the read back lowers to
// OpImageRead. Out-of-bounds behavior is GPU-defined and
// not asserted here.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWTexture2D<float4> img;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    img[uint2(0, 0)] = float4(1, 0, 0, 1);
    outBuf[tid.x] = img[uint2(0, 0)];
}

// CHECK-DAG: OpImageWrite
// CHECK-DAG: OpImageRead
