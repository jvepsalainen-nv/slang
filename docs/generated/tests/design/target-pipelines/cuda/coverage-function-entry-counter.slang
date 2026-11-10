//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-a-link-and-entry-point-prep
//META: purpose=slangc -trace-function-coverage is one of the three options that set reqSet.coverageTracing, and it instruments per function entry rather than per statement, so a two-branch shader gets a single counter at the top of the kernel.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the function-entry member of the documented trio of
// coverage options, distinguished from -trace-coverage by counter
// placement rather than by whether instrumentation runs at all. The
// shader has two branch arms; with per-function counting only the
// kernel entry is counted, so the CHECK asserts the coverage buffer
// exists and that slot 0 is bumped, while CHECK-NOT rules out the
// per-branch slots 1 and 2 that the branch-coverage sibling emits.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute -trace-function-coverage

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0)
        outputBuffer[0] = 1;
    else
        outputBuffer[0] = 2;
}

// CHECK: RWStructuredBuffer<ulonglong> _slang_coverage_{{[0-9]+}};
// CHECK: atomicAdd((&(globalParams_{{[0-9]+}}->_slang_coverage_{{[0-9]+}})[int(0)]), 1ULL)
// CHECK-NOT: _slang_coverage_{{[0-9]+}})[int(1)]
