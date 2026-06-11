//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=Switch fall-through: threads in the first case group reconverge with threads in the second case group at the fall-through label (common body), visible as adjacent SPIRV blocks without OpSelectionMerge between them.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the switch fall-through reconvergence claim: completes the
// GLSL and HLSL emission targets absent from switch-fallthrough-reconvergence-emission.slang.
// Case 0 falls through into case 1. GLSL emits case 0 with no `break`, leaving
// the fall-through into the case-1 body intact. HLSL does not support
// fall-through and restructures it (warning E41026) by duplicating the shared
// case body; both still emit the switch with the two case-label groups, so CHECK
// pins `switch(`, `case 0U`, `case 1U`.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 0;
    uint v = tid.x & 1; // 0 or 1
    switch (v)
    {
    case 0:
        result += 10;
        // fall-through — threads from case 0 reconverge with case 1 threads here
    case 1:
        result += 20;
        break;
    }
    output[tid.x] = result;
}

// GLSL: fall-through preserved — case 0 has no break before case 1.
// CHECK_GLSL: switch(
// CHECK_GLSL: case 0U
// CHECK_GLSL: case 1U

// HLSL: fall-through restructured (warning E41026) by duplicating the shared
// body; the switch and both case-label groups remain present.
// CHECK_HLSL: switch(
// CHECK_HLSL: case 0U
// CHECK_HLSL: case 1U
