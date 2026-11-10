//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-b-specialization-and-type-legalization
//META: purpose=A static array index past the upper edge of a fixed-size array is rejected by Phase B with E30029
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Above-the-upper-edge of a fixed-size array index: Phase B's
// checkForOutOfBoundAccess catches the constant index and emits
// E30029 before WGSL emit. The diagnostic is not attached to a
// specific source line, so we match by message text only.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int arr[4] = { 1, 2, 3, 4 };
    outBuf[tid.x] = arr[10];
}

//CHECK: array index out of bounds
// CHECK: E30029
