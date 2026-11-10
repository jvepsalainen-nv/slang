//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=A ConstantBuffer<float4> (scalar payload of one vector) lowers to a Uniform-storage OpVariable; the address-space mapping does not change with payload shape.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: smallest ConstantBuffer payload shape (a single
// float4). The storage class mapping (Uniform) should not
// depend on whether the payload is a struct or a vector.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

ConstantBuffer<float4> globals;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = globals;
}

// CHECK: %globals = OpVariable %{{[a-zA-Z_0-9]+}} Uniform
