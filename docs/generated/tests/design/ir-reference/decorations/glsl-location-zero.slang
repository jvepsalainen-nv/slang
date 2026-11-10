//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#layout-and-binding
//META: purpose=Boundary - vk::location(0) at the lower edge produces glslLocation(0 : Int).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower edge of the location range. Zero is the value most
// likely to be confused with "absent", so the CHECK pins
// `[glslLocation(0 : Int)]` to show the decoration is emitted with an
// explicit zero operand rather than omitted.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

struct V
{
    [vk::location(0)] float u : TEXCOORD0;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, V v)
{
    buf[0] = v.u + float(tid.x);
}

// CHECK: [glslLocation(0 : Int)]
