//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#flat-decoration-for-integral-fragment-inputs
//META: purpose=A wave built-in reaching the emitter as a spirv_asm builtin-var shape (SubgroupLocalInvocationId) still receives the Flat decoration in a fragment entry point.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second input shape the Flat rule has to accept: a wave built-in
// such as the lane index arrives at the emitter as a non-pointer builtin-var
// instruction rather than as an Input-storage global param, and its own data
// type is what must be inspected. The lane index is written to a buffer so it
// is not dead; CHECK asserts the SubgroupLocalInvocationId built-in carries
// both its BuiltIn decoration and Flat.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage fragment

RWStructuredBuffer<uint> outBuf;

[shader("fragment")]
float4 main() : SV_Target
{
    outBuf[0] = WaveGetLaneIndex();
    return float4(1.0, 0.0, 0.0, 1.0);
}

// CHECK-DAG: OpDecorate %{{[a-zA-Z_0-9]+}} BuiltIn SubgroupLocalInvocationId
// CHECK-DAG: OpDecorate %{{[a-zA-Z_0-9]+}} Flat
