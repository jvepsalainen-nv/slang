//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#layout-and-binding
//META: purpose=Boundary - a `: packoffset(c2.y)` modifier lowers to a packoffset decoration with (registerOffset, componentOffset) = (2, 1).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `packoffset` splits the HLSL `cN.component` spelling into
// two separate integer operands. Two fields are declared, one at `c0`
// (both operands zero) and one at `c2.y`, so the CHECK-DAG lines pin both
// the all-zero corner and a case where the component letter must map to a
// non-zero index.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

cbuffer MyCB
{
    float4 a : packoffset(c0);
    float4 b : packoffset(c2.y);
};

uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a.x + b.y + float(tid.x);
}

// CHECK-DAG: [packoffset(0 : Int, 0 : Int)]
// CHECK-DAG: [packoffset(2 : Int, 1 : Int)]
