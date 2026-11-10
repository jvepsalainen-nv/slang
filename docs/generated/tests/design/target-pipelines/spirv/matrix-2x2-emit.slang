//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A 2x2 float matrix emits OpTypeMatrix %v2float 2 — the smallest documented matrix shape on the matrix-dim boundary axis (lower edge companion to 4x4).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the smallest matrix dimension. The bundle pins the
// 4x4 case; this test pins the lower 2x2 edge — emits
// OpTypeMatrix %v2float 2 with a matching MatrixStride of 8.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float2x2> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float2x2 m = float2x2(float(tid.x), 1, 0, float(tid.x));
    outBuf[tid.x] = m;
}

// CHECK-DAG: OpTypeMatrix %v2float 2
// CHECK-DAG: MatrixStride 8
