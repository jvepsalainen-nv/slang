//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A fragment entry point emits OpEntryPoint Fragment and an OpExecutionMode %main OriginUpperLeft (the SPIR-V default coordinate origin Slang requests).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: a different execution model than the bundle's
// compute-stage default. Fragment entry points emit
// "Fragment" rather than "GLCompute" and add the
// OriginUpperLeft execution mode (HLSL/D3D convention that
// Slang preserves for Vulkan).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage fragment

RWStructuredBuffer<float4> outBuf;

[shader("fragment")]
float4 main() : SV_Target
{
    outBuf[0] = float4(0, 0, 0, 1);
    return float4(0.5, 0.5, 0.5, 1.0);
}

// CHECK: OpEntryPoint Fragment %main
// CHECK: OpExecutionMode %main OriginUpperLeft
