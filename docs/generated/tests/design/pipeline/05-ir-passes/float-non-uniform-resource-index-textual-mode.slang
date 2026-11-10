//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=In textual mode the float-non-uniform-resource-index pass only repositions the `NonUniformResourceIndex` wrapper onto the index expression and emits no decoration.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the non-SPIR-V half of the pass's documented two-mode
// behaviour, as the contrast case to the SPIR-V mode test. The same
// thread-varying resource-array index is compiled to HLSL and GLSL; the
// CHECKs assert the wrapper lands directly on the index expression
// (`NonUniformResourceIndex(tid_...)` on HLSL, `nonuniformEXT(...)` on
// GLSL) and that no SPIR-V-style `NonUniform` decoration token is
// produced on either target.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform RWStructuredBuffer<int> outBuf;
uniform StructuredBuffer<int> tables[8];

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = tables[NonUniformResourceIndex(tid.x)][0];
}

// HLSL keeps the intrinsic spelling around the index and emits no decoration.
// HLSL: NonUniformResourceIndex(tid_{{[0-9]+}}.x)
// HLSL-NOT: OpDecorate

// GLSL uses the nonuniformEXT qualifier on the index expression.
// GLSL: nonuniformEXT(
// GLSL-NOT: OpDecorate
