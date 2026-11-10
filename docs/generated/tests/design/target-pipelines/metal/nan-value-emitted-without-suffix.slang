//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=Boundary: a NaN value is emitted bare as `(0.0 / 0.0)` with no `f` suffix, the same carve-out the emitter applies to infinity.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the second non-finite case of the literal-suffix carve-out. Like
// infinity, NaN has no suffixed decimal spelling, so the emitter renders a
// division that evaluates to it instead of a literal. CHECK asserts the
// `(0.0 / 0.0)` form with unsuffixed operands appears while the finite
// value added to it on the same statement still carries `f` elsewhere in
// the kernel.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = float(tid.x) + (0.0f / 0.0f);
    outBuf[1] = float(tid.x) * 1.25f;
}

// CHECK-DAG: (0.0 / 0.0)
// CHECK-DAG: 1.25f
