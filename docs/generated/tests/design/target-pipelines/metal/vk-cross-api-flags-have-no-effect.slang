//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-c-metal-legalization-lowering-phi-elimination
//META: purpose=Negative: Vulkan cross-API options are filtered out of the Metal pipeline, so `-fvk-invert-y` and `-fvk-use-dx-position-w` leave the emitted MSL unchanged.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the filtered-out half of the Metal predicate table by asking
// for two Khronos-only rewrites and showing neither happens: the
// Y-inversion pass would negate the position's y component and the
// position-w pass would introduce a reciprocal. The vertex position is
// derived from a `uniform` so a rewrite could not be constant-folded away;
// CHECK asserts the emitted position assignment carries neither a negation
// of the uniform nor a `1.0f /` reciprocal.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage vertex -fvk-invert-y -fvk-use-dx-position-w

uniform float yScale;

struct VOut
{
    float4 pos : SV_Position;
}

[shader("vertex")]
VOut main(uint vid : SV_VertexID)
{
    VOut o;
    o.pos = float4(float(vid), yScale, 0.0, 1.0);
    return o;
}

// CHECK: vertex
// CHECK-SAME: main_0
// CHECK-NOT: 1.0f /
// CHECK-NOT: - yScale
