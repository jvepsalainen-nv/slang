//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=Boundary - a `sample` modifier produces interpolationMode with mode operand 4, the upper edge of the mode range observed in the dump.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the top of the interpolation-mode encoding. Together with the
// `linear` (0) and `nointerpolation` (2) siblings this pins the endpoints
// of the range the dump exposes, so a renumbering of the mode enum fails
// here instead of silently changing emitted interpolation qualifiers.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

struct V
{
    sample float u : TEXCOORD0;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, V v)
{
    buf[0] = v.u + float(tid.x);
}

// CHECK: [interpolationMode(4 : Int)]
