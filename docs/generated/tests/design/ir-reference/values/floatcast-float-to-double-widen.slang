//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: middle-of-ladder float widening `float -> double` lowers to `floatCast(%fa)` with `Double` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Middle rung of the float ladder, reversed: 32-bit to 64-bit
// widening. Verifies that lowering keeps both narrowing and widening under one
// `floatCast` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = double(fa);
}

// IR-LABEL: func %main
// IR: floatCast(%fa)
