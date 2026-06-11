//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=`switch` statement: SPIRV emits OpSelectionMerge + OpSwitch encoding divergence into distinct case-label groups and reconvergence at the merge block.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the `switch` divergence claim: completes the GLSL and HLSL
// emission targets absent from switch-divergence-reconvergence-emission.slang.
// Threads fan out to case 0, 1, or default by tid.x % 3; both targets emit a
// switch statement with the three case-label groups, so CHECK pins `switch(`
// plus the three case/default labels that encode the divergence groups.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 0;
    uint v = tid.x % 3;
    switch (v)
    {
    case 0:
        result = 10;
        break;
    case 1:
        result = 20;
        break;
    default:
        result = 30;
        break;
    }
    output[tid.x] = result;
}

// GLSL: switch statement preserved with three case arms.
// CHECK_GLSL: switch(
// CHECK_GLSL: case 0U
// CHECK_GLSL: case 1U
// CHECK_GLSL: default

// HLSL: switch statement preserved with three case arms.
// CHECK_HLSL: switch(
// CHECK_HLSL: case 0U
// CHECK_HLSL: case 1U
// CHECK_HLSL: default
