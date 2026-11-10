//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#capabilities-and-extensions-decided-at-emit-time
//META: purpose=Under -fp-mode precise the emitted float multiply and add carry the NoContraction decoration.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that precise floating-point mode decorates the emitted arithmetic
// so a driver may not fuse the multiply and the add into an FMA. Both operands
// are buffer loads, so the expression reaches emit as a real OpFMul feeding an
// OpFAdd; CHECK asserts NoContraction decorations exist and that both
// float-arithmetic opcodes were emitted.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute -fp-mode precise

RWStructuredBuffer<float> outBuf;
StructuredBuffer<float> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float a = inBuf[tid.x];
    float b = inBuf[tid.x + 1];
    outBuf[tid.x] = a * b + a;
}

// CHECK-DAG: OpDecorate %{{[a-zA-Z_0-9]+}} NoContraction
// CHECK-DAG: OpFMul %float
// CHECK-DAG: OpFAdd %float
