//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=A struct field declared with a TEXCOORD semantic emits a semantic decoration on the field's key with the semantic name and default -1 index.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that struct fields are one of the surfaces that produce
// `semantic`, not just entry-point parameters. The CHECK pins the
// `("TEXCOORD0", -1 : Int)` operand pair on a field of a plain struct used
// as a local value.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

struct V
{
    float pos : SV_Position;
    float u : TEXCOORD0;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    V v;
    v.pos = 0.0;
    v.u = float(tid.x);
    buf[0] = v.u;
}

// CHECK: [semantic("TEXCOORD0", -1 : Int)]
