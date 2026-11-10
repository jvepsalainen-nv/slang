//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-a-link-and-entry-point-prep
//META: purpose=`lowerEnumType` collapses an enum to its underlying integer, so the emitted Metal text carries the literal `int(1)` and no `Green` enumerator name.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that Phase A's `lowerEnumType` erases the enumerator name and
// replaces the enum value with its underlying integer before Metal emit.
// The kernel stores `Color.Green` (declared value 1) into a buffer so the
// value escapes DCE; CHECK asserts the literal `int(1)` appears and that
// no `Green` identifier survives anywhere in the emitted MSL, which is
// only true if the enum type itself was lowered away.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

enum Color
{
    Red,
    Green = 1,
    Blue = 2
}

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(Color.Green);
}

// CHECK: int(1)
// CHECK-NOT: Green
