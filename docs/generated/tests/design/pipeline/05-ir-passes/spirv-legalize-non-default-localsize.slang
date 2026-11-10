//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=Expansion: spirv-legalize emits an `OpEntryPoint` and `OpExecutionMode LocalSize` for an alternative numthreads shape (8,4,1) — non-default localsize axis.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Numthreads axis on spirv-legalize: an explicit (8, 4, 1) layout
// surfaces in the `OpExecutionMode LocalSize` line. The pass must
// route the per-axis numthreads through to the SPIR-V emit.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(8, 4, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// SPIRV: OpCapability Shader
// SPIRV: OpEntryPoint
// SPIRV: OpExecutionMode {{.*}} LocalSize 8 4 1
