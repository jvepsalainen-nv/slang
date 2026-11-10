//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=Under slangc -minimum-slang-optimization the minimal-optimization arm runs applySparseConditionalConstantPropagation plus eliminateDeadCode in place of simplifyIR, cleaning up the dead branch a force-inlined call reveals so a static_assert in that branch does not falsely fire.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the stated reason the minimal-optimization arm pairs
// SCCP with DCE rather than just dropping simplifyIR. A ForceInline
// generic carries a static_assert in each arm of a branch on its
// value parameter; only one arm can hold for a given instantiation.
// Instantiated at N == 0, the N != 0 assertion sits in dead code.
// If the dead branch survived to checkStaticAssert the compile would
// fail, so a clean CUDA kernel emitting the live arm's value is the
// observation that SCCP+DCE removed it. The CHECK pins the live
// value reaching the buffer.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute -minimum-slang-optimization

RWStructuredBuffer<int> outputBuffer;

[ForceInline]
int pick<let N : int>()
{
    if (N == 0)
    {
        static_assert(N == 0, "live arm: N is zero");
        return 10;
    }
    else
    {
        static_assert(N != 0, "dead arm: must not fire for N == 0");
        return 20;
    }
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = pick<0>();
}

// CHECK: extern "C" __global__ void main{{.*}}()
// CHECK: = int(10);
