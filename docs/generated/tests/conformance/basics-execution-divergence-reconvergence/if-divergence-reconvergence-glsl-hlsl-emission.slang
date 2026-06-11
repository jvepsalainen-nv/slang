//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=`if` statement: SPIRV emits OpSelectionMerge/OpBranchConditional marking divergence point and a single merge block for reconvergence.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the `if`/`else` divergence claim: completes the GLSL and
// HLSL emission targets absent from if-divergence-reconvergence-emission.slang.
// Both targets preserve the if/else divergence point and the two arms as a
// structured conditional; CHECK pins the `if(` and the two distinct arm writes.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 0;
    bool cond = (tid.x & 1) == 0;
    if (cond)
    {
        result = 1;
    }
    else
    {
        result = 2;
    }
    output[tid.x] = result;
}

// GLSL: if/else preserved; both arms visible.
// CHECK_GLSL: if(
// CHECK_GLSL: result_{{[0-9]+}} = 1U
// CHECK_GLSL: result_{{[0-9]+}} = 2U

// HLSL: if/else preserved; both arms visible.
// CHECK_HLSL: if(
// CHECK_HLSL: result_{{[0-9]+}} = 1U
// CHECK_HLSL: result_{{[0-9]+}} = 2U
