//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/overview.md#ast--ir-lowering
//META: purpose=A for-loop statement in the AST becomes a back-edged block structure whose loop header, exit test, and body all reach the emitted target text.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the loop case of statement lowering, which needs a back edge
// rather than the straight-line join an if/else produces. The trip count
// comes from the dispatch id so the loop cannot be unrolled or folded away.
// The source back-ends emit an unconditional loop with an early exit
// `break`: WGSL spells the header `loop`, while the other targets use
// `for(;;)`. On SPIR-V, `OpLoopMerge` names the loop's merge and continue
// targets.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int sum = 0;
    for (uint i = 0u; i < tid.x; ++i)
        sum = sum + int(i);
    gOut[0] = sum;
}

// HLSL-DAG: for(;;)
// HLSL-DAG: break;

// GLSL-DAG: for(;;)
// GLSL-DAG: break;

// SPIRV-DAG: OpLoopMerge
// SPIRV-DAG: OpBranchConditional

// METAL-DAG: for(;;)
// METAL-DAG: break;

// WGSL: loop
// WGSL-NEXT: {
// WGSL: break;

// CUDA-DAG: for(;;)
// CUDA-DAG: break;

// CPP-DAG: for(;;)
// CPP-DAG: break;
