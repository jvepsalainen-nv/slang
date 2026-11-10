//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: `bitfieldExtract(a, 0, 0)` lowers to `bitfieldExtract(%a, 0 : UInt, 0 : UInt)` — the count=0 edge of the bitfield-width range.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `bitfieldExtract` opcode keeps its `offset` and
// `count` operands intact at the degenerate width. This boundary probe takes the zero-width extract — count = 0 —
// as the lower edge of the bit-field width range.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bitfieldExtract(a, 0, 0);
}

// IR-LABEL: func %main
// IR: bitfieldExtract(%a, 0 : UInt, 0 : UInt)
