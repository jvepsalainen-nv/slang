//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=A function parameter declared with the precise modifier carries a precise decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `precise` row: a nullary decoration produced by the
// `precise` modifier. The modifier is written on a function parameter and
// the CHECK pins the bare `[precise]` line, showing the request is recorded
// on the declaration rather than folded into the arithmetic.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

float bumpy(precise float x) { return x * x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = bumpy(float(tid.x));
}

// CHECK: [precise]
