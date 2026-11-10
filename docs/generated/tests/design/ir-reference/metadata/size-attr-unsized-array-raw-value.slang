//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#size-and-offset
//META: purpose=An unbounded resource array records a non-finite extent in the size attribute's raw LayoutSize operand rather than a finite count.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary of the size encoding: an unsized (infinite) extent.
// `Texture2D gTex[]` has no static bound, so its layout cannot report a finite
// count; the CHECK-DAG pins the raw sentinel that the encoding uses for that
// case alongside an ordinary finite size elsewhere in the same module, so a
// regression that collapsed the two forms would fail.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -entry main -stage compute

Texture2D gTex[] : register(t0);
SamplerState gSamp;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = gTex[tid.x].SampleLevel(gSamp, float2(0, 0), 0).x;
}

// The unbounded array's extent is the non-finite raw value.
// CHECK-DAG: = size({{[0-9]+}} : Int, -1 : Int)
// A finite size is still spelled as a plain count.
// CHECK-DAG: = size({{[0-9]+}} : Int, 1 : Int)
