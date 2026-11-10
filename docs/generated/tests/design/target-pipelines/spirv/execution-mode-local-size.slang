//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=[numthreads(8,4,2)] lowers to OpExecutionMode %main LocalSize 8 4 2 in SPIR-V.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The HLSL [numthreads(X,Y,Z)] attribute survives Phase A/B/C and
// lowers in Phase D's word emission to OpExecutionMode LocalSize
// X Y Z attached to the entry-point function.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 4, 2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: OpExecutionMode %{{[a-zA-Z_0-9]+}} LocalSize 8 4 2
