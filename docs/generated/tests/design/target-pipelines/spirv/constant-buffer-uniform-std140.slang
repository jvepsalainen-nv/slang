//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=ConstantBuffer<T> lowers identically to cbuffer { T fields } - a *_std140 Block struct in Uniform storage class.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ConstantBuffer<T> is HLSL surface syntax for the same lowering
// produced by cbuffer. Both reach Phase C's
// legalizeConstantBufferLoadForGLSL and emit a *_std140 Block
// struct in Uniform storage class.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

struct Params { float4 g; }
ConstantBuffer<Params> cb;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = cb.g;
}

// CHECK-DAG: OpDecorate %Params_std140 Block
// CHECK: OpVariable %_ptr_Uniform_Params_std140 Uniform
