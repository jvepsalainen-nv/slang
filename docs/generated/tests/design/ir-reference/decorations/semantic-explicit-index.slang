//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=Boundary - a TEXCOORD with a trailing digit (TEXCOORD3) lowers to semantic("TEXCOORD3", -1 : Int); the digit stays fused with the name operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies which of the two `semantic` operands carries an index written in
// the source. Writing `TEXCOORD3` keeps the digit inside the name string
// and leaves the index operand at -1, so the CHECK pins both operands
// together - asserting only the name would not distinguish this encoding
// from a split `("TEXCOORD", 3)` form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

struct V
{
    float u : TEXCOORD3;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, V v)
{
    buf[0] = v.u + float(tid.x);
}

// CHECK: [semantic("TEXCOORD3", -1 : Int)]
