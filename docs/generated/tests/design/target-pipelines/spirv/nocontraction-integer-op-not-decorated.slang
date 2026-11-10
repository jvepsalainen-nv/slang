//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#capabilities-and-extensions-decided-at-emit-time
//META: purpose=Integer arithmetic under -fp-mode precise is not NoContraction-decorated, because the decoration is chosen from the emitted opcode.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the NoContraction choice keys off the emitted SPIR-V opcode
// rather than the IR arithmetic instruction: integer multiply and add travel
// the same IR path as their float counterparts, but NoContraction is invalid
// on OpIMul / OpIAdd. The same buffer-fed multiply-add shape is compiled at
// -fp-mode precise with int operands; CHECK asserts the integer opcodes are
// emitted and CHECK-NOT asserts no NoContraction decoration is produced.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute -fp-mode precise

RWStructuredBuffer<int> outBuf;
StructuredBuffer<int> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = inBuf[tid.x];
    int b = inBuf[tid.x + 1];
    outBuf[tid.x] = a * b + a;
}

// CHECK-NOT: NoContraction
// CHECK: OpIMul %int
