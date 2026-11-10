//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=Vector || (the OR companion to && in legalizeLogicalAndOr's Khronos arm) lowers to OpLogicalOr on bool3.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the OR half of the same legalizeLogicalAndOr claim: on a Khronos
// target a vector-typed || becomes an element-wise logical operation. The
// operands are runtime comparisons on a buffer-loaded int3 so the optimizer
// cannot fold them; CHECK asserts OpLogicalOr on %v3bool. Storing through an
// int3 buffer keeps OpTypeBool out of the StorageBuffer block.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int3> outBuf;
StructuredBuffer<int3> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int3 v = inBuf[tid.x];
    bool3 lo = v < 0;
    bool3 hi = v > 100;
    outBuf[tid.x] = int3(lo || hi);
}

// CHECK: OpLogicalOr %v3bool
