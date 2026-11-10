//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A double element in a StructuredBuffer triggers OpCapability Float64 and emits OpTypeFloat 64.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: large float width (64-bit). Using double pulls in
// the Float64 capability declaration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<double> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = double(tid.x);
}

// CHECK-DAG: OpCapability Float64
// CHECK-DAG: OpCapability Shader
// CHECK: OpTypeFloat 64
