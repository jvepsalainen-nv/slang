//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#attr-family
//META: purpose=The snorm modifier on a texture element type produces a no-operand snorm attribute inside an Attributed type wrapper.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the SNORM marker attribute, the mirror of `unorm`. Keeping it in a
// separate file makes a regression that only breaks one of the two normalized
// forms visible on its own. The CHECK captures the zero-operand attribute
// definition and requires the same id to be the attribute operand of an
// `Attributed` type.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -entry main -stage compute

RWTexture2D<snorm float4> tex;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    tex[tid.xy] = float4(-0.5);
}

// CHECK: %[[S:[0-9]+]]{{.*}}= snorm
// CHECK: Attributed({{.*}}, %[[S]])
