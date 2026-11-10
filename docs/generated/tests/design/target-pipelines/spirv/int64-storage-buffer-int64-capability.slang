//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A 64-bit signed integer element triggers OpCapability Int64 and emits OpTypeInt 64 1.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: large integer width (64-bit). Using int64_t as a
// buffer element type pulls in the Int64 capability.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int64_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int64_t(tid.x);
}

// CHECK-DAG: OpCapability Int64
// CHECK-DAG: OpCapability Shader
// CHECK: OpTypeInt 64 1
