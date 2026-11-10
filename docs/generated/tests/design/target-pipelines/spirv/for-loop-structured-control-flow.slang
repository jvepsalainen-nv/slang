//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A for loop with a data-dependent bound survives as SPIR-V structured control flow (OpLoopMerge / OpBranchConditional).
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V requires structured control flow. A for loop whose bound
// is data-dependent (not a compile-time constant the simplifier
// can unroll) emits OpLoopMerge plus OpBranchConditional.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;
StructuredBuffer<int> bounds;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int sum = 0;
    for (int i = 0; i < bounds[tid.x]; i++)
        sum += i;
    outBuf[tid.x] = sum;
}

// CHECK: OpLoopMerge
// CHECK: OpBranchConditional
