//META: generated=true
//META: doc_ref=docs/language-reference/basics-program-execution.md#program-execution
//META: purpose=Total invocations equal grid_dim.x*group_dim.x (for 1D case); each thread receives a unique SV_DispatchThreadID with 0 <= tid.x < group_dim.x.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a 1x1x1 dispatch of numthreads(4,1,1) produces exactly 4 invocations,
// each receiving a unique SV_DispatchThreadID.x in [0, 4).
// Each thread writes tid.x to its output slot; CHECK-buffer asserts values 0–3 appear,
// confirming total invocation count and unique ID assignment.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0 0 0], stride=4)
RWStructuredBuffer<uint> outputBuffer;

[numthreads(4, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outputBuffer[tid.x] = tid.x;
}

// Thread IDs 0 through 3 are assigned, verifying the range [0, group_dim.x).
// CHECK: 0
// CHECK: 1
// CHECK: 2
// CHECK: 3
