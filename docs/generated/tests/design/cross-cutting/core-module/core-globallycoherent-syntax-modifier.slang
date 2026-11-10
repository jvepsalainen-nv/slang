//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#what-the-core-module-provides
//META: purpose=The globallycoherent modifier declared by the core module's syntax declarations reaches emit as HLSL globallycoherent, GLSL coherent and the SPIR-V Coherent decoration.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the modifier keywords the core module introduces through
// `syntax` declarations are real modifiers with target-visible effect,
// not just accepted spellings. A buffer is declared globallycoherent
// and written; each prefix CHECKs the coherence marker that back end
// emits, so a modifier that parsed but was dropped during lowering
// would fail here.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

globallycoherent RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// HLSL: globallycoherent
// GLSL: coherent
// SPIRV: OpDecorate %{{[A-Za-z0-9_]+}} Coherent
