//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A 16-bit array index is widened to a 32-bit integer (OpUConvert to uint) before it is used as an OpAccessChain index (widenNarrowAccessChainIndices).
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies widenNarrowAccessChainIndices: a uint16_t index into a local array must not
// reach OpAccessChain as a 16-bit value. CHECK asserts a convert to 32-bit `uint`
// is followed by an access chain into the Function-storage array.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint16_t i = uint16_t(tid.x);
    int a[4] = { outBuf[0], outBuf[1], outBuf[2], outBuf[3] };
    outBuf[0] = a[i];
}

// CHECK: OpUConvert %uint %{{[A-Za-z0-9_]+}}
// CHECK: OpAccessChain %_ptr_Function_int %{{[A-Za-z0-9_]+}} %{{[A-Za-z0-9_]+}}
