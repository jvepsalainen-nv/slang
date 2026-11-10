//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion: lower-buffer-element-type renders an `RWStructuredBuffer<float>` element as `float _data[]` on GLSL — alternative element-type axis to the int case.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Element-type variation on lower-buffer-element-type. A
// `RWStructuredBuffer<float>` produces a `float _data[]` SSBO field
// on GLSL.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform float a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + float(tid.x);
}

// GLSL: float _data
