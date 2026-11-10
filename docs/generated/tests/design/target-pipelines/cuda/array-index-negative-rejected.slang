//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=A negative static index into a fixed-size array is rejected by checkForOutOfBoundAccess with E30029, covering the underflow edge of the same bound check.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower boundary of the Phase B out-of-bound validation.
// Index -1 underflows the array rather than overflowing it, so this is
// the mirror case of the one-past-the-end test and confirms the check is
// a range test, not just an upper-limit test. The caret-anchored CHECK
// pins the reported column on the subscript expression.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<int> outBuf;
static const int arr[4] = { 1, 2, 3, 4 };

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = arr[-1];
//CHECK:               ^ array index '-1' is out of bounds for array of size '4'.
}
