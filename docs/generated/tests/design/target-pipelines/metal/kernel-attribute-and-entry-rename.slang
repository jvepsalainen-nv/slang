//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=A Metal compute entry point is emitted with the `[[kernel]]` attribute and the user's `main` is renamed to `main_0`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two things that together identify a Metal compute entry
// point in the emitted text. `kernel` is matched as a bare substring
// because FileCheck reads a literal `[[...]]` as a variable reference, and
// the `_0` suffix is asserted because Slang renames user entry points on
// this target -- a test that matched `void main(` would silently miss the
// signature entirely.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: kernel{{.*}} void main_0(
// CHECK-NOT: void main(
