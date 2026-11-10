//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Boundary: precision-narrowing `float -> half` lowers to a single `floatCast(%fa)` opcode.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `floatCast` covers precision changes in both
// directions. This boundary probe isolates the narrowing edge:
// 32-bit `float` to 16-bit `half`. The widening case (float to
// double) lives in the smoke test.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<half> hbuf;

[numthreads(1, 1, 1)]
void main()
{
    hbuf[0] = half(fa);
}

// IR-LABEL: func %main
// IR: floatCast(%fa)
