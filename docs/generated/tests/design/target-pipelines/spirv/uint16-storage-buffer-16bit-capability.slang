//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A 16-bit integer element in a StructuredBuffer triggers the UniformAndStorageBuffer16BitAccess and Int16 capability declarations alongside Shader.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: small integer width (16-bit). Using uint16_t as a
// buffer element type pulls in both Int16 and the buffer-side
// 16-bit-access capability declaration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint16_t> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = uint16_t(tid.x);
}

// CHECK-DAG: OpCapability Int16
// CHECK-DAG: OpCapability UniformAndStorageBuffer16BitAccess
// CHECK-DAG: OpCapability Shader
// CHECK: OpTypeInt 16 0
