//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `bit_cast<float>(int)` signed-int-to-float reinterpret lowers to `bitCast(%a)` with `Float` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Counterpart to the existing `bit_cast<float>(uint)` test: same
// width but signed source. Verifies that lowering keeps signed and unsigned
// int-to-float bit-reinterprets under one `bitCast` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bit_cast<float>(a);
}

// IR-LABEL: func %main
// IR: bitCast(%a)
