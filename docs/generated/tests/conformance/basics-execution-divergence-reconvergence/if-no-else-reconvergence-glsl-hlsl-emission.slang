//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=`if` without `else`: reconvergence still occurs at the if-exit point; SPIRV emits OpSelectionMerge pointing to the single merge block after the then-arm.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the else-less `if` reconvergence claim: completes the GLSL
// and HLSL emission targets absent from if-no-else-reconvergence-emission.slang.
// Both targets emit a structured conditional; the then-arm assigns 1U and the
// implicit-skip path retains the initializer 5U, so CHECK pins `if(` plus both
// values, confirming the post-if reconvergence point is materialized.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint result = 5;
    bool cond = (tid.x & 1) == 0;
    if (cond)
    {
        result = 1; // only even threads reach here
    }
    // reconvergence: all threads continue here
    output[tid.x] = result;
}

// GLSL: single conditional; then-arm value and the retained initializer both present.
// CHECK_GLSL: if(
// CHECK_GLSL: result_{{[0-9]+}} = 1U
// CHECK_GLSL: result_{{[0-9]+}} = 5U

// HLSL: single conditional; then-arm value and the retained initializer both present.
// CHECK_HLSL: if(
// CHECK_HLSL: result_{{[0-9]+}} = 1U
// CHECK_HLSL: result_{{[0-9]+}} = 5U
