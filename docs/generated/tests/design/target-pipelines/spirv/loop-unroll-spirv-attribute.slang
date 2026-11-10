//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A [unroll] attribute on a for-loop changes the OpLoopMerge attribute to "Unroll" — companion to the unattributed loop test that emits "None".
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: structured control flow preserves loop hints. The
// bundle pins OpLoopMerge for an unattributed loop; this pins the
// [unroll]-attributed shape — OpLoopMerge ... Unroll.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int sum = 0;
    [unroll]
    for (int i = 0; i < 4; ++i)
    {
        sum += i;
    }
    outBuf[tid.x] = sum;
}

// CHECK: OpLoopMerge %{{[A-Za-z_0-9]+}} %{{[A-Za-z_0-9]+}} Unroll
