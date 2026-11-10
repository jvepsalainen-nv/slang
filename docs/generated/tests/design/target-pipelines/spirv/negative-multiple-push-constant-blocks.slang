//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=An entry point that uses two push-constant blocks is rejected by checkForMultiplePushConstantBlocksPerEntryPoint with E39033 and no SPIR-V is produced.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative: legalizeIRForSPIRV counts, per entry point, the globals legalized into a
// PushConstant variable and diagnoses more than one. The CHECK pins the error code
// E39033 so an unrelated failure cannot satisfy the test.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target spirv-asm -entry main -stage compute

struct P { float4 a; };
[[vk::push_constant]] ConstantBuffer<P> p1;
[[vk::push_constant]] ConstantBuffer<P> p2;
RWStructuredBuffer<float> o;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    o[0] = p1.a.x + p2.a.y;
}

// CHECK: E39033
