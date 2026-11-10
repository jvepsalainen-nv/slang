//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `bit_cast<uint>(float)` reverse-direction reinterpret lowers to `bitCast(%fa)` with `UInt` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Counterpart to the existing `bit_cast<float>(uint)` test —
// reinterprets a `float`'s bits as a `uint`. Verifies that lowering keeps both
// directions under one `bitCast` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bit_cast<uint>(fa);
}

// IR-LABEL: func %main
// IR: bitCast(%fa)
