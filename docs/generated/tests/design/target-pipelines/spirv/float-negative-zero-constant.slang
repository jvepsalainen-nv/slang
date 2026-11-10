//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A -0.0 float literal is preserved as a distinct OpConstant %float -0 in SPIR-V emit (not folded to +0).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: IEEE 754 distinguishes -0.0 from +0.0 by sign bit.
// SPIR-V emit preserves the sign bit; the disassembler shows
// the constant as -0.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = -0.0f;
}

// CHECK: %float_n0 = OpConstant %float -0
