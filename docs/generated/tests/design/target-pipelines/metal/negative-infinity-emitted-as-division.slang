//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=Boundary: negative infinity is the third non-finite spelling and is emitted bare as the division `(-1.0 / 0.0)` with no `f` suffix.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the sign-carrying member of the non-finite literal carve-out. The
// suffix rule applies only to finite literals, so each non-finite value is
// instead written as a division that evaluates to it; negative infinity is
// the case where the numerator, not the operator, carries the information.
// The CHECK pins the exact division and asserts no suffixed form of the
// value appears.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = -1.0 / 0.0;
}

// CHECK: (-1.0 / 0.0)
// CHECK-NOT: -inf
