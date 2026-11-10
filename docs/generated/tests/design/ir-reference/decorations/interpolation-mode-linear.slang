//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=Boundary - a `linear` modifier produces interpolationMode with mode operand 0, the lowest interpolation-mode value observed in the dump.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `modeOperand` of `interpolationMode` really encodes
// which modifier was written. `linear` pins the literal 0 here, while the
// `nointerpolation` and `sample` siblings pin 2 and 4, so the three tests
// together show the operand is a per-modifier tag rather than a constant.
// The doc does not publish the encoding; that is recorded as a doc gap.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

struct V
{
    linear float u : TEXCOORD0;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, V v)
{
    buf[0] = v.u + float(tid.x);
}

// CHECK: [interpolationMode(0 : Int)]
