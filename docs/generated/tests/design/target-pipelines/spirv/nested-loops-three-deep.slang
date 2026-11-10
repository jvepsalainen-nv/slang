//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=Three nested data-dependent for loops emit exactly three OpLoopMerge instructions; structured control flow preserves the loop nesting.
//META: intent=stress
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: nested loop depth >= 3. Each loop must carry its own
// OpLoopMerge marker; simplifyIRForSpirvLegalization's
// removeTrivialSingleIterationLoops cannot collapse them because
// the bounds are data-dependent.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int x = int(tid.x);
    int sum = 0;
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < x; j++) {
            for (int k = 0; k < x; k++) {
                sum += i * j + k;
            }
        }
    }
    outBuf[tid.x] = sum;
}

// CHECK: OpLoopMerge
// CHECK: OpLoopMerge
// CHECK: OpLoopMerge
