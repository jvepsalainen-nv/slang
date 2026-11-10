//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=SPIR-V direct emit declares the Logical addressing model and the GLSL450 memory model.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// emitPhysicalLayout writes the OpMemoryModel instruction after
// OpCapability / OpExtension. SPIR-V direct-emit uses Logical
// addressing (no raw pointer arithmetic) with the GLSL450
// memory model.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float4(float(tid.x), 0.0, 0.0, 1.0);
}

// CHECK: OpMemoryModel Logical GLSL450
