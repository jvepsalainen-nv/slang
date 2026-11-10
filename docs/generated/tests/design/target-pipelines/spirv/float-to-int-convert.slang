//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=Converting float to int emits OpConvertFToS — the reverse direction of int->float, also distinct from OpBitcast.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: companion to int->float. float -> int conversion
// emits OpConvertFToS (signed) rather than reinterpreting bits.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;
RWStructuredBuffer<float> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float f = inBuf[tid.x];
    outBuf[tid.x] = int(f);
}

// CHECK: OpConvertFToS
