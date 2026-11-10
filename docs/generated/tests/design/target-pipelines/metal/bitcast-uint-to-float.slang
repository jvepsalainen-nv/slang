//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-c-metal-legalization-lowering-phi-elimination
//META: purpose=Boundary: the reverse bitcast direction `asfloat(uint)` also renders as `as_type<float>(...)` on Metal.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the other direction of the bitcast axis covered by
// `bitcast-emits-as-type.slang`: the emitter must pick the destination
// type for `as_type<T>` from the bitcast's result type, so an
// integer-to-float reinterpret has to render as `as_type<float>`. The
// source bits come from `SV_DispatchThreadID` so nothing is folded, and
// CHECK asserts the float-destination spelling.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = asfloat(tid.x);
}

// CHECK: as_type<float>
