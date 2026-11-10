//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `int8_t -> int16_t` one-step signed widening lowers to a single `intCast(%i8a)` with `Int16` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Smallest documented signed widening step: 8-bit to 16-bit. The
// doc places this under the same `intCast` opcode that handles all
// other int-int reshapes.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int8_t i8a;
uniform RWStructuredBuffer<int16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int16_t(i8a);
}

// IR-LABEL: func %main
// IR: intCast(%i8a)
