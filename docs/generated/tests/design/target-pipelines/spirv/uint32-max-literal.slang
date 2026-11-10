//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=The uint32 MAX literal (0xFFFFFFFFu) emits as OpConstant %uint 4294967295 (decimal in spirv-asm).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the upper edge of the uint32 range. The SPIR-V
// disassembler prints unsigned integer constants in decimal,
// so 0xFFFFFFFFu surfaces as 4294967295.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 0xFFFFFFFFu;
}

// CHECK: %uint_4294967295 = OpConstant %uint 4294967295
