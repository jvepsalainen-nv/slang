//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#wrapstructuredbuffersofmatrices
//META: purpose=wrapStructuredBuffersOfMatrices does NOT wrap a non-matrix element type; a StructuredBuffer<int> stays as RWStructuredBuffer<int>.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// wrapStructuredBuffersOfMatrices is matrix-element-specific.
// A StructuredBuffer of scalar type emits its native element
// type, with no _S<N> wrapper struct.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) * 2;
}

// CHECK: RWStructuredBuffer<int{{.*}}> outBuf_{{[0-9]+}} : register(u{{[0-9]+}})
