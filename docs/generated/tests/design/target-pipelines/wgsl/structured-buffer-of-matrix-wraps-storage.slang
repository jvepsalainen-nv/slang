//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-c-wgsl-legalization-lowering-phi-elimination
//META: purpose=lowerBufferElementTypeToStorageType wraps a structured buffer's matrix element in a _MatrixStorage_ struct on WGSL
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// On WGSL the lowering policy wraps RWStructuredBuffer<float4x4>
// in a generated struct '_MatrixStorage_float4x4_ColMajorstd430_*'
// whose 'data_*' field is the matrix stored as an array<vec4<f32>>.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float> outBuf;
RWStructuredBuffer<float4x4> matBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = matBuf[tid.x][0][0];
}

// CHECK: struct _MatrixStorage_float4x4
// CHECK: array<vec4<f32>
