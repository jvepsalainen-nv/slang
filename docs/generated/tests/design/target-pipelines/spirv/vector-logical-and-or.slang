//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=A vector && (legalizeLogicalAndOr's Khronos arm) lowers to OpLogicalAnd on bool3 operands.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that Phase C's legalizeLogicalAndOr takes its Khronos arm for
// SPIR-V and rewrites a vector-typed short-circuit && into an element-wise
// logical operation rather than into control flow. The comparison operands
// come from a buffer load so nothing folds; CHECK asserts a single
// OpLogicalAnd on %v3bool, which only appears if the vector && survived as
// an element-wise logical op. The bool3 result is converted to int3 before
// it is stored, because OpTypeBool has no defined size in a StorageBuffer.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int3> outBuf;
StructuredBuffer<int3> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int3 v = inBuf[tid.x];
    bool3 a = v > 0;
    bool3 b = v < 10;
    outBuf[tid.x] = int3(a && b);
}

// CHECK: OpLogicalAnd %v3bool
