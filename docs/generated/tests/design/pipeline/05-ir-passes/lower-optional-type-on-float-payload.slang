//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion: lower-optional-type renders `Optional<float>` into a struct with `value` and `hasValue` fields — alternative payload type axis to the existing `int` case.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Parameter-shape variation on lower-optional-type: a `float`
// payload instead of `int`. The legalizer should produce the same
// `value` / `hasValue` struct shape regardless of inner type.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform float a;
uniform RWStructuredBuffer<float> buf;

Optional<float> maybeF(float v) { if (v > 0.0f) return v; return none; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Optional<float> o = maybeF(a);
    buf[0] = o.hasValue ? o.value : -1.0f;
}

// HLSL: hasValue
// HLSL: value
