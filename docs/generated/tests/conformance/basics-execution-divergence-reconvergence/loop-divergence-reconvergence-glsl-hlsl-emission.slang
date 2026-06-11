//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=9c1a6a00ef413932805da5b813465a7a9d517fb9
//META: doc_ref=docs/language-reference/basics-execution-divergence-reconvergence.md#divergence
//META: doc_section_digest=7748f330eccf2fb718b5ba2c0f9aff0035f24f4197647463775fd43f1b5ebbb9
//META: purpose=Loop statement: SPIRV emits OpLoopMerge marking the loop merge block where all threads reconverge after the loop exits.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the loop divergence/reconvergence claim: completes the
// GLSL and HLSL emission targets absent from loop-divergence-reconvergence-emission.slang.
// Threads loop 2 or 3 times; both targets lower the bounded `for` to a top-test
// infinite loop with an explicit `break` for the exit, so CHECK pins `for(;;)`
// plus `break`, the construct at whose exit all threads reconverge.

//TEST:SIMPLE(filecheck=CHECK_GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CHECK_HLSL):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<uint> output;

[numthreads(4,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    // Different threads loop different numbers of times: divergence
    uint numLoops = 2 + (tid.x & 1);
    uint sum = 0;
    for (uint i = 0; i < numLoops; ++i)
    {
        sum += i;
    }
    // All threads exit the loop: reconvergence at the merge block
    output[tid.x] = sum;
}

// GLSL: for-loop lowered to a top-test infinite loop with a break.
// CHECK_GLSL: for(;;)
// CHECK_GLSL: break

// HLSL: for-loop lowered to a top-test infinite loop with a break.
// CHECK_HLSL: for(;;)
// CHECK_HLSL: break
